//
//  BasicObjects.m
//  RayTracer
//
//  Created by Bobie Chen on 8/27/14.
//  Copyright (c) 2014 Bobie Chen. All rights reserved.
//

#import "BasicObjects.h"

@implementation BasicObjects

+ (LightSource3D*)createLightSourceWithCenter:(Point3D)center andIntensity:(float)fIntensity
{
    LightSource3D* lightSource = (LightSource3D*)malloc(sizeof(LightSource3D));
    
    lightSource->basicObject.objectType = OBJECTTYPE_LIGHTSOURCE;
    lightSource->basicObject.center = center;
    lightSource->fLightIntensity = fIntensity;
    
    return lightSource;
}

+ (Sphere3D*)createSphereWithCenter:(Point3D)center andRadius:(float)fRadius materialAttribute:(MaterialAttribute)materialAttribute
{
    Sphere3D* sphere = (Sphere3D*)malloc(sizeof(Sphere3D));
    
    sphere->basicObject.objectType = OBJECTTYPE_SPHERE;
    sphere->basicObject.center = center;
    sphere->basicObject.materialAttribute = materialAttribute;
    sphere->fRadius = fRadius;
    
    return sphere;
}

@end
