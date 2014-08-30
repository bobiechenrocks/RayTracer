//
//  UtilityHelper.h
//  RayTracer
//
//  Created by Bobie Chen on 8/27/14.
//  Copyright (c) 2014 Bobie Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicObjects.h"

@interface UtilityHelper : NSObject

+ (float)vectorDotProductOfVector:(Vector3D)vA andVector:(Vector3D)vB;
+ (Vector3D)vectorFromPointA:(Point3D)pA toPointB:(Point3D)pB;
+ (Vector3D)unitVectorOfVector:(Vector3D)vector;
+ (Vector3D)vectorScale:(Vector3D)vector scale:(float)fScale;
+ (Point3D)addToPoint:(Point3D)point withVector:(Vector3D)vector;
+ (UIColor*)hexToColor:(NSUInteger)hexValue withAlpha:(NSNumber*)alpha;

@end
