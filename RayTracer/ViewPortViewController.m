//
//  ViewPortViewController.m
//  RayTracer
//
//  Created by Bobie Chen on 8/28/14.
//  Copyright (c) 2014 Bobie Chen. All rights reserved.
//

#import "ViewPortViewController.h"
#import "BasicObjects.h"
#import "RayTracer.h"
#import "UtilityHelper.h"

@interface ViewPortViewController ()

@property (nonatomic, strong)RayTracer* rayTracer;

@end

@implementation ViewPortViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self prepare3DWorld];
    [self.view setBackgroundColor:[UIColor grayColor]];
    [self performSelectorInBackground:@selector(runRayTracing) withObject:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepare3DWorld
{
    if (!self.rayTracer) {
        self.rayTracer = [RayTracer sharedRayTracer];
    }
    
    Point3D pSphereCenter = {160.0f, 300.0f, 200.0f};
    MaterialAttribute material = {0x74A091, 1.0f, 1.0f, 1.0f};
    Sphere3D* sphere1 = [BasicObjects createSphereWithCenter:pSphereCenter andRadius:100.0f materialAttribute:material];
    
    NSValue* objectValue = [NSValue valueWithPointer:sphere1];
    [self.rayTracer add3DObject:objectValue];
    
    
    Point3D pSphereCenter2 = {60.0f, 200.0f, 300.0f};
    MaterialAttribute material2 = {0x5A7491, 1.0f, 1.0f, 1.0f};
    Sphere3D* sphere2 = [BasicObjects createSphereWithCenter:pSphereCenter2 andRadius:80.0f materialAttribute:material2];
    
    NSValue* objectValue2 = [NSValue valueWithPointer:sphere2];
    [self.rayTracer add3DObject:objectValue2];
}

- (void)runRayTracing
{
    NSLog(@"start rendering");
    
    Point3D pRaySource = {self.view.frame.size.width/2.0f, self.view.frame.size.height/2.0f, -200.0f};
    
    UIGraphicsBeginImageContext(CGSizeMake(self.view.frame.size.width, self.view.frame.size.height));
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(contextRef, 1.0f);
    
    for (int i = 0; i < self.view.frame.size.width; ++i) {
        for (int j = 0; j < self.view.frame.size.height; ++j) {
            
            Point3D pViewPort = {i, j ,0.0f};
            Vector3D rayDir = [UtilityHelper vectorFromPointA:pRaySource toPointB:pViewPort];
            Ray3D ray = {pRaySource, rayDir};
            NSInteger nColor = [self.rayTracer mainColorTracerWithLightDirection:ray andLightIntensity:1.0f];
            
            CGContextSetStrokeColorWithColor(contextRef, [UtilityHelper hexToColor:nColor withAlpha:@1.0f].CGColor);
            CGRect circlePoint = (CGRectMake(i, j, 1.0f, 1.0f));
            CGContextStrokeRect(contextRef, circlePoint);
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:imageView];
        imageView.image = image;
    });
    
    NSLog(@"end rendering");
}

@end
