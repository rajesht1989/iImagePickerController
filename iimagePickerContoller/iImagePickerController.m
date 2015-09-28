//
//  iImagePickerController.m
//  iimagePickerContoller
//
//  Created by Rajesh on 9/11/15.
//  Copyright (c) 2015 Org. All rights reserved.
//

#import "iImagePickerController.h"
#import <AVFoundation/AVFoundation.h>

typedef struct
{
    BOOL isSecondaryCamAvail;
    BOOL isSecondaryCam;
}ImagePickerConfig;

@interface iImagePickerController ()
{
    AVCaptureSession *captureSession;
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
    AVCaptureDeviceInput *captureDeviceInput;
    ImagePickerConfig config;
    AVCaptureStillImageOutput *stillImageOutput;
    NSMutableArray *arrImages;
    UIButton *btnPreview;
}
@end

@implementation iImagePickerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    arrImages = [NSMutableArray new];
    captureSession = [[AVCaptureSession alloc]init];
    captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
    
    captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:captureSession];
    captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    captureVideoPreviewLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:captureVideoPreviewLayer];
    
    NSArray *arrVideoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    config.isSecondaryCamAvail = arrVideoDevices.count > 1;
    config.isSecondaryCam = NO;
    if (arrVideoDevices.count)
    {
        captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:arrVideoDevices[0] error:nil];
        [captureSession addInput:captureDeviceInput];
        [captureSession startRunning];
    }
    {
        stillImageOutput = [[AVCaptureStillImageOutput alloc]init];
        NSDictionary * outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
        [stillImageOutput setOutputSettings:outputSettings];
        [captureSession addOutput:stillImageOutput];
    }
    {
        UIView *vwOverlayTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
        [vwOverlayTop setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [vwOverlayTop setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.3]];
        [self.view addSubview:vwOverlayTop];
        
        UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(10, 5, 60, 30)];
        [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(btnCancelTapped:) forControlEvents:UIControlEventTouchUpInside];
        [vwOverlayTop addSubview:btnCancel];
        
        if (config.isSecondaryCamAvail)
        {
            UIButton *btnRotate = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - 40, 5, 40, 30)];
            [btnRotate setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
            [btnRotate setTitle:@"R" forState:UIControlStateNormal];
            [btnRotate addTarget:self action:@selector(btnRotateTapped:) forControlEvents:UIControlEventTouchUpInside];
            [vwOverlayTop addSubview:btnRotate];
        }
    }
    
    {
        UIView *vwOverlay = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 90, self.view.bounds.size.width, 90)];
        [vwOverlay setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
        [vwOverlay setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.3]];
        [self.view addSubview:vwOverlay];
        
         btnPreview = [[UIButton alloc] initWithFrame:CGRectMake(10, (vwOverlay.bounds.size.height - 60)/2, 60, 60)];
        [btnPreview setBackgroundColor:[UIColor whiteColor]];
        [btnPreview setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnPreview addTarget:self action:@selector(btnPreviewTapped:) forControlEvents:UIControlEventTouchUpInside];
        [vwOverlay addSubview:btnPreview];
        [btnPreview setHidden:YES];
        
        UIView *vwCapture = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.bounds)-30, 10, 65, 65)];
        [vwCapture setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
        [vwCapture.layer setBorderColor:[UIColor whiteColor].CGColor];
        [vwCapture.layer setBorderWidth:3.];
        [vwCapture.layer setCornerRadius:vwCapture.bounds.size.width/2];
        [vwOverlay addSubview:vwCapture];
        
        UIButton *btnCapture = [[UIButton alloc] initWithFrame:CGRectInset(vwCapture.bounds, 5, 5)];
        [btnCapture setBackgroundColor:[UIColor whiteColor]];
        [btnCapture setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnCapture.layer setCornerRadius:btnCapture.bounds.size.width/2];
        [btnCapture addTarget:self action:@selector(btnCapturedTapped:) forControlEvents:UIControlEventTouchUpInside];
        [vwCapture addSubview:btnCapture];
        
        UIButton *btnDone = [[UIButton alloc] initWithFrame:CGRectMake(vwOverlay.bounds.size.width - 60, (vwOverlay.bounds.size.height - 30)/2, 60, 30)];
        [btnDone setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
        [btnDone setTitle:@"Done" forState:UIControlStateNormal];
        [btnDone addTarget:self action:@selector(btnDoneTapped:) forControlEvents:UIControlEventTouchUpInside];
        [vwOverlay addSubview:btnDone];
        
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)btnCancelTapped:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)btnRotateTapped:(UIButton *)button
{
    NSArray *arrVideoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    [captureSession beginConfiguration];
    [captureSession removeInput:captureDeviceInput];
    if (config.isSecondaryCam) captureDeviceInput  = [AVCaptureDeviceInput deviceInputWithDevice:arrVideoDevices[0] error:nil];
    else captureDeviceInput  = [AVCaptureDeviceInput deviceInputWithDevice:arrVideoDevices[1] error:nil];
    [captureSession addInput:captureDeviceInput];
    [captureSession commitConfiguration];
    config.isSecondaryCam = !config.isSecondaryCam;
}

- (void)btnCapturedTapped:(UIButton *)button
{
    [stillImageOutput captureStillImageAsynchronouslyFromConnection:[stillImageOutput connectionWithMediaType:AVMediaTypeVideo] completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        if (error)
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertController animated:YES completion:nil];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }]];
        }
        else if (imageSampleBuffer)
        {
            UIView *viewCapture = [[UIView alloc] initWithFrame:self.view.bounds];
            [viewCapture setBackgroundColor:[UIColor colorWithWhite:0 alpha:.3]];
            [viewCapture setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
            [self.view addSubview:viewCapture];
            
            [UIView animateWithDuration:.2 animations:^{
                [viewCapture setTransform:CGAffineTransformMakeScale(.01, .01)];
            } completion:^(BOOL finished) {
                [viewCapture removeFromSuperview];
            }];
            UIImage *capturedImage = [[UIImage alloc]initWithData:[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer] scale:1];
            if (capturedImage)
            {
                [arrImages addObject:capturedImage];
                [button setTitle:[NSString stringWithFormat:@"%d",[button.titleLabel.text intValue] + 1] forState:UIControlStateNormal];
                [btnPreview setHidden:NO];
                [btnPreview setImage:capturedImage forState:UIControlStateNormal];
            }
        }
    }];
}

- (void)btnDoneTapped:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:^{
        [_viewController previewImages:arrImages];
    }];
}

- (void)btnPreviewTapped:(UIButton *)button
{
    [_viewController previewImagesFromTopController:arrImages];
}

- (void)dealloc
{
    [captureSession stopRunning];
}

@end
