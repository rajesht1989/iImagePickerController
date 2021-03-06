//
//  ViewController.m
//  iimagePickerContoller
//
//  Created by Rajesh on 9/11/15.
//  Copyright (c) 2015 Org. All rights reserved.
//

#import "ViewController.h"
#import "iImagePickerController.h"
#import "ImagePreviewViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)previewImages:(NSMutableArray*)arrImages {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%lu  Image(s) captured",(unsigned long)arrImages.count] preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:YES completion:nil];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
}

- (void)previewImagesFromTopController:(NSMutableArray*)arrImages {
    UIViewController *topController = self;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    ImagePreviewContainerController *container = [[ImagePreviewContainerController alloc] init];
    [container setArrImages:arrImages];
    [topController presentViewController:[[UINavigationController alloc] initWithRootViewController:container] animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    iImagePickerController *controller = segue.destinationViewController;
    if ([controller isKindOfClass:[iImagePickerController class]]) {
        [controller setViewController:self];
    }
}

@end
