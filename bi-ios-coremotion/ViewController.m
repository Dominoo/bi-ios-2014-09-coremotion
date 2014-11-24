//
//  ViewController.m
//  bi-ios-coremotion
//
//  Created by Dominik Vesely on 24/11/14.
//  Copyright (c) 2014 Ackee s.r.o. All rights reserved.
//

#import "ViewController.h"
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))


@import AVFoundation;
@import CoreMotion;
@import CoreLocation;

@interface ViewController ()
@property (nonatomic,weak) UIView* cameraPreview;
@property (nonatomic,strong) AVCaptureSession* session;
@property (nonatomic,strong) AVCaptureDevice* inputDevice;
@property (nonatomic,strong) CMMotionManager* manager;
@property (nonatomic,weak) UILabel* label;
@property (nonatomic,strong) UIImageView* imageView;
@property (nonatomic,strong) CLLocationManager *locationManager;


@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView* v = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:v];
    self.cameraPreview = v;
    
    UILabel * l = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    l.backgroundColor = [UIColor whiteColor];
    l.textColor = [UIColor blackColor];
    [self.view addSubview:l];
    _label = l;
    
    UIImageView* imgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dominik"]];
    imgV.center = self.view.center;
    [self.view addSubview:imgV];
    self.imageView = imgV;
    
    
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];

    _inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_inputDevice error:nil];
    if ( [_session canAddInput:deviceInput] )
        [_session addInput:deviceInput];
    
    AVCaptureVideoPreviewLayer *previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    CALayer *rootLayer = [[self cameraPreview] layer];
    [rootLayer setMasksToBounds:YES];
    [previewLayer setFrame:CGRectMake(-70, 0, rootLayer.bounds.size.height, rootLayer.bounds.size.height)];
    [rootLayer insertSublayer:previewLayer atIndex:0];
    
    [_session startRunning];
    
    //Camera stuff end
    
    self.manager = [[CMMotionManager alloc ] init];
    self.manager.gyroUpdateInterval = 0.1;
    [self.manager startGyroUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMGyroData *gyroData, NSError *error) {
        
     //   double rotation = atan2(gyroData.rotationRate.x, gyroData.rotationRate.y) - M_PI;
     //   self.imageView.transform = CGAffineTransformMakeRotation(rotation);
        
    }];
    
    self.manager.accelerometerUpdateInterval = 0.01;
    [self.manager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
      //  double rotation = atan2(accelerometerData.acceleration.x, accelerometerData.acceleration.y) - M_PI;
      //  self.imageView.transform = CGAffineTransformMakeRotation(rotation);
    }];
    //CM Motion stuff
    
    
    self.manager.deviceMotionUpdateInterval = 0.01;
    [self.manager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
        
      //  double rotation = atan2(motion.gravity.x, motion.gravity.y) - M_PI;
      //  self.imageView.transform = CGAffineTransformMakeRotation(rotation);
    }];
    
    
    
  /*  [self.manager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical toQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
        double x = motion.magneticField.field.x;
        double y = motion.magneticField.field.y;
        double z = motion.magneticField.field.z;
        
        
          double rotation = motion.attitude.yaw;
            double angle = RADIANS_TO_DEGREES(rotation);
          self.imageView.transform = CGAffineTransformMakeRotation(rotation);
        NSLog(@"%f",angle);
        
        
        
        self.label.text = [NSString stringWithFormat:@"{%8.4f, %8.4f, %8.4f}", x, y, z];
    }]; */
    
    
    
  /*  _locationManager= [[CLLocationManager alloc] init];
    [_locationManager requestWhenInUseAuthorization];
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.headingFilter = 1;
    _locationManager.delegate= self;
    [_locationManager startUpdatingHeading];
   */
    
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    float oldRad =  -manager.heading.trueHeading * M_PI / 180.0f;
    float newRad =  -newHeading.trueHeading * M_PI / 180.0f;
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    theAnimation.fromValue = [NSNumber numberWithFloat:oldRad];
    theAnimation.toValue=[NSNumber numberWithFloat:newRad];
    theAnimation.duration = 0.5f;
    [_imageView.layer addAnimation:theAnimation forKey:@"animateMyRotation"];
    _imageView.transform = CGAffineTransformMakeRotation(newRad);
    NSLog(@"%f (%f) => %f (%f)", manager.heading.trueHeading, oldRad, newHeading.trueHeading, newRad);
}


- (CAAnimation *)animationForRotationX:(float)x Y:(float)y andZ:(float)z
{
    CATransform3D transform;
    transform = CATransform3DMakeRotation(M_PI, x, y, z);
    
    CABasicAnimation* animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:transform];
    animation.duration = 2;
    animation.cumulative = YES;
    animation.repeatCount = 10000;
    return animation;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
