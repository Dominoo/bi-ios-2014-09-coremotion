//
//  ViewController.m
//  bi-ios-coremotion
//
//  Created by Dominik Vesely on 24/11/14.
//  Copyright (c) 2014 Ackee s.r.o. All rights reserved.
//

#import "ViewController.h"

@import AVFoundation;

@interface ViewController ()
@property (nonatomic,weak) UIView* cameraPreview;
@property (nonatomic,weak) AVCaptureSession* session;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView* v = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:v];
    self.cameraPreview = v;
    
    
    _session = [[AVCaptureSession alloc] init];

    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
