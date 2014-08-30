//
//  RayTracer.m
//  RayTracer
//
//  Created by Bobie Chen on 8/27/14.
//  Copyright (c) 2014 Bobie Chen. All rights reserved.
//

#import "RayTracer.h"
#import "UtilityHelper.h"

static RayTracer* m_rayTracer;

static const float kfMinimumLightIntensity = 0.05;
static const float kfLightDecayRate = 0.8;

@interface RayTracer ()

@property (nonatomic, strong)NSMutableArray* array3DObjects;

@end

@implementation RayTracer

+ (RayTracer*)sharedRayTracer
{
    if (!m_rayTracer) {
        m_rayTracer = [[RayTracer alloc] init];
    }
    
    return m_rayTracer;
}

- (id)init
{
    if (self = [super init]) {
        self.array3DObjects = [NSMutableArray arrayWithCapacity:0];
    }
    
    return self;
}

- (void)dealloc
{
    for (id object in self.array3DObjects) {
        free((__bridge void *)(object));
    }
}

- (void)add3DObject:(id)object
{
    if (!self.array3DObjects) {
        self.array3DObjects = [NSMutableArray arrayWithCapacity:0];
    }
    
    [self.array3DObjects addObject:object];
}

- (NSInteger)mainColorTracerWithLightDirection:(Ray3D)ray andLightIntensity:(float)fIntensity
{
    NSInteger nPixelColor = 0;
    
    /* find first intersected object */
    NSValue* firstObjectValue = [self findFirstIntersectedObject:ray];
    if (firstObjectValue) {

        NSInteger nSurfaceColor = [self calculateSurfaceColor:firstObjectValue andLightIntensity:fIntensity];
        Sphere3D* sphere;
        [firstObjectValue getValue:&sphere];
        Point3D pIntersectedPoint = [self getIntersectedPointWithSphere:sphere ray:ray];
        
        while (fIntensity > kfMinimumLightIntensity)
        {
            nPixelColor = nSurfaceColor;
                            /* + reflection
                               + refraction
                               + shadow */
            
            /*  A shadow ray is traced toward each light. If any opaque object is found between the surface and
                the light, the surface is in shadow and the light does not illuminate it. */
            
            fIntensity = fIntensity*kfLightDecayRate;
        }
    }
    
    return nPixelColor;
}

- (NSValue*)findFirstIntersectedObject:(Ray3D)ray
{
    NSValue* intersectedObjectValue = nil;
    basicPointObject* object = malloc(sizeof(basicPointObject));
    for (id objectValue in self.array3DObjects) {
        
        /* objects in were wrapped with NSValue */
        [objectValue getValue:&object];
        
        BOOL bIntersectionFound = NO;
        enumObjectTypes type = ((basicPointObject*)object)->objectType;
        switch (type) {
            case OBJECTTYPE_SPHERE:
            {
                bIntersectionFound = [self checkIfRayIntersectsSphere:(Sphere3D*)object ray:ray];
            }
                break;
                
            default:
                break;
        }
        
        if (bIntersectionFound) {
            intersectedObjectValue = objectValue;
            break;
        }
    }
    
    return intersectedObjectValue;
}

- (NSInteger)calculateSurfaceColor:(NSValue*)objectValue andLightIntensity:(float)fIntensity
{
    basicPointObject* object = malloc(sizeof(basicPointObject));
    [objectValue getValue:&object];
    NSInteger nColor = object->materialAttribute.nColor;
    NSInteger nRed = (nColor >> 16) & 0xFF;
    NSInteger nGreen = (nColor >> 8) & 0xFF;
    NSInteger nBlue = nColor & 0xFF;
    
    nColor = ((int)(((float)nRed)*fIntensity) << 16) + ((int)(((float)nGreen)*fIntensity) << 8) + (int)(((float)nBlue)*fIntensity);
    
    return nColor;
}


#pragma mark - sphere intersection
- (BOOL)checkIfRayIntersectsSphere:(Sphere3D*)sphere ray:(Ray3D)ray
{
    /*  wiki: http://en.wikipedia.org/wiki/Ray_tracing_(graphics)
        sphere: (x - c)^2 = r^2, ray: x = s + td
        assume they intersect, then they have common x, replace x with s + td
        
        sphere: (s + td - c)^2 = r^2, let v = s - c
        (v + td)^2 = r^2, ... => t = -vd +- sqrt( (vd)^2 - (v^2 - r^2) )
     
        t won't be valid unless things in sqrt() are >= 0 */
    
    Vector3D v = [UtilityHelper vectorFromPointA:sphere->basicObject.center toPointB:ray.source];
    Vector3D d = [UtilityHelper unitVectorOfVector:ray.direction];
    
    float vd2 = [UtilityHelper vectorDotProductOfVector:v andVector:d] * [UtilityHelper vectorDotProductOfVector:v andVector:d];
    float v2r2 = [UtilityHelper vectorDotProductOfVector:v andVector:v] - (sphere->fRadius * sphere->fRadius);
    
    return (vd2 - v2r2 >= 0);
}

- (Point3D)getIntersectedPointWithSphere:(Sphere3D*)sphere ray:(Ray3D)ray
{
    /*  x = s + td
        t = -vd +- sqrt( (vd)^2 - (v^2 - r^2) ) */
    
    Vector3D v = [UtilityHelper vectorFromPointA:sphere->basicObject.center toPointB:ray.source];
    Vector3D d = [UtilityHelper unitVectorOfVector:ray.direction];
    
    float vd2 = [UtilityHelper vectorDotProductOfVector:v andVector:d] * [UtilityHelper vectorDotProductOfVector:v andVector:d];
    float v2r2 = [UtilityHelper vectorDotProductOfVector:v andVector:v] * [UtilityHelper vectorDotProductOfVector:v andVector:v] - (sphere->fRadius * sphere->fRadius);
    
    Point3D p;
    if (vd2 - v2r2 >= 0) {
        float fRoot = sqrtf(vd2 - v2r2);
        float fMinusVd = - [UtilityHelper vectorDotProductOfVector:v andVector:d];
        
        /* solution of t */
        float fSolution = fminf(fMinusVd + fRoot, fMinusVd - fRoot);
        
        p = [UtilityHelper addToPoint:ray.source withVector:[UtilityHelper vectorScale:d scale:fSolution]];
    }
    
    return p;
}

@end
