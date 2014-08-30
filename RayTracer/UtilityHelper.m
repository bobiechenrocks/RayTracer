//
//  UtilityHelper.m
//  RayTracer
//
//  Created by Bobie Chen on 8/27/14.
//  Copyright (c) 2014 Bobie Chen. All rights reserved.
//

#import "UtilityHelper.h"

@implementation UtilityHelper

+ (float)vectorDotProductOfVector:(Vector3D)vA andVector:(Vector3D)vB
{
    return (vA.fVX * vB.fVX + vA.fVY * vB.fVY + vA.fVZ * vB.fVZ);
}

+ (Vector3D)vectorFromPointA:(Point3D)pA toPointB:(Point3D)pB
{
    Vector3D v = {pB.fX - pA.fX, pB.fY - pA.fY, pB.fZ - pA.fZ};
    
    return v;
}

+ (Vector3D)unitVectorOfVector:(Vector3D)vector
{
    float fVectorLength = vector.fVX*vector.fVX + vector.fVY*vector.fVY + vector.fVZ*vector.fVZ;
    fVectorLength = sqrtf(fVectorLength);
    
    Vector3D unitV = {vector.fVX/fVectorLength, vector.fVY/fVectorLength, vector.fVZ/fVectorLength};
    
    return unitV;
}

+ (Vector3D)vectorScale:(Vector3D)vector scale:(float)fScale
{
    Vector3D v = {vector.fVX*fScale, vector.fVY*fScale, vector.fVZ*fScale};
    
    return v;
}

+ (Point3D)addToPoint:(Point3D)point withVector:(Vector3D)vector
{
    Point3D p = {point.fX+vector.fVX, point.fY+vector.fVY, point.fZ+vector.fVZ};
    
    return p;
}

+ (UIColor*)hexToColor:(NSUInteger)hexValue withAlpha:(NSNumber*)alpha
{
    NSNumber* red = [NSNumber numberWithInt:(hexValue>>16)];
    NSNumber* green = [NSNumber numberWithInt:((hexValue >> 8) & 0xFF)];
    NSNumber* blue = [NSNumber numberWithInt:(hexValue & 0xFF)];
    
    float fAlpha = (alpha)? [alpha floatValue] : 1.0f;
    UIColor* color = [UIColor colorWithRed:[red floatValue]/255.0f green:[green floatValue]/255.0f blue:[blue floatValue]/255.0f alpha:fAlpha];
    
    return color;
}

@end
