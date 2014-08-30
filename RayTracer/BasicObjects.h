//
//  BasicObjects.h
//  RayTracer
//
//  Created by Bobie Chen on 8/27/14.
//  Copyright (c) 2014 Bobie Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BasicObjects : NSObject

/* basic 3D world data structures */
typedef struct point3D {
    float fX;
    float fY;
    float fZ;
}Point3D;

typedef struct vector3D {
    float fVX;
    float fVY;
    float fVZ;
}Vector3D;

typedef struct ray3D {
    Point3D source;
    Vector3D direction;
}Ray3D;


/* basic objects */
typedef enum enumObjectTypes {
    OBJECTTYPE_LIGHTSOURCE = 1,
    OBJECTTYPE_SPHERE = 1 << 1
}enumObjectTypes;

typedef struct materialAttribute {
    NSInteger nColor;
    float fReflectionIntensity;
    float fRefractionIntensity;
    float fRefractionAngleRate;
}MaterialAttribute;

typedef struct basicPointObject {
    enumObjectTypes objectType;
    Point3D center;
    MaterialAttribute materialAttribute;
}basicPointObject;

typedef struct lightSource {
    basicPointObject basicObject;
    float fLightIntensity;
}LightSource3D;

typedef struct sphere {
    basicPointObject basicObject;
    float fRadius;
}Sphere3D;

/* class methods to create basic objects */
+ (LightSource3D*)createLightSourceWithCenter:(Point3D)center andIntensity:(float)fIntensity;
+ (Sphere3D*)createSphereWithCenter:(Point3D)center andRadius:(float)fRadius materialAttribute:(MaterialAttribute)materialAttribute;

@end
