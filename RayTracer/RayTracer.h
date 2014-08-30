//
//  RayTracer.h
//  RayTracer
//
//  Created by Bobie Chen on 8/27/14.
//  Copyright (c) 2014 Bobie Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicObjects.h"

@interface RayTracer : NSObject

+ (RayTracer*)sharedRayTracer;
- (void)add3DObject:(id)object;
- (NSInteger)mainColorTracerWithLightDirection:(Ray3D)ray andLightIntensity:(float)fIntensity;

@end
