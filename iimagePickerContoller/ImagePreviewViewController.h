//
//  ImagePreviewViewController.h
//
//  Created by Rajesh on 2/23/15.
//  Copyright (c) 2015 Org. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface ImagePreviewContainerController : UIViewController<UIPageViewControllerDataSource> {
    UIPageViewController *pageViewController;
}
@property(nonatomic, strong)NSMutableArray *arrImages;
- (void)setTitleWithImage:(UIImage *)image;

@end

@interface ImagePreviewViewController : UIViewController<UIScrollViewDelegate>

- (instancetype)initWithImage:(UIImage *)image andContainer:(ImagePreviewContainerController *)container;

@property(nonatomic, strong)UIImage *image;
@property(nonatomic, weak)ImagePreviewContainerController *container;;

@end


