//
//  ImagePreviewViewController.m
//
//  Created by Rajesh on 2/23/15.
//  Copyright (c) 2015 Org. All rights reserved.
//

#import "ImagePreviewViewController.h"

#define TITLE @"%ld of %ld"

@interface ImagePreviewContainerController ()

@end

@implementation ImagePreviewContainerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(btnCancelTapped:)];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];

    pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    pageViewController.dataSource = self;
    [pageViewController.view setClipsToBounds:YES];
    [self.view addSubview:pageViewController.view];
    [self addChildViewController:pageViewController];
    [pageViewController setViewControllers:@[[[ImagePreviewViewController alloc] initWithImage:[_arrImages firstObject] andContainer:self]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (void)setTitleWithImage:(UIImage *)image
{
    [self setTitle:[NSString stringWithFormat:TITLE,[_arrImages indexOfObject:image] + 1,[_arrImages count]]];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(ImagePreviewViewController *)viewController
{
    NSInteger iCurrentIndex = [_arrImages indexOfObject:viewController.image];
    if(iCurrentIndex <= 0)
    {
        return nil;
    }
    return [[ImagePreviewViewController alloc] initWithImage:[_arrImages objectAtIndex:iCurrentIndex - 1] andContainer:self];
}
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(ImagePreviewViewController *)viewController
{
    NSInteger iCurrentIndex = [_arrImages indexOfObject:viewController.image];
    if(iCurrentIndex + 1 >= [_arrImages count])
    {
        return nil;
    }
    return [[ImagePreviewViewController alloc] initWithImage:[_arrImages objectAtIndex:iCurrentIndex + 1] andContainer:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)btnCancelTapped:(UIBarButtonItem *)barButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

@implementation ImagePreviewViewController
- (instancetype)initWithImage:(UIImage *)image andContainer:(ImagePreviewContainerController *)container;
{
    if (self = [super init])
    {
        self.image = image;
        _container = container;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor clearColor]];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [scrollView setDelegate:self];
    [scrollView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    scrollView.minimumZoomScale=1;
    scrollView.maximumZoomScale=4;
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:scrollView];
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [scrollView addGestureRecognizer:doubleTapRecognizer];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectInset(scrollView.bounds, 5., 5.)];
    [imageView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [imageView setCenter:self.view.center];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [scrollView addSubview:imageView];
    [imageView setImage:_image];
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [[scrollView subviews] firstObject];
}

- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
    CGPoint pointInView = [recognizer locationInView:[[recognizer.view subviews] firstObject]];
    CGFloat fZoomScale = ((UIScrollView *)recognizer.view).zoomScale * 2.f;
    fZoomScale = fZoomScale > ((UIScrollView *)recognizer.view).maximumZoomScale ?((UIScrollView *)recognizer.view).minimumZoomScale :fZoomScale;
    CGSize scrollViewSize = self.view.frame.size;
    CGFloat w = scrollViewSize.width / fZoomScale;
    CGFloat h = scrollViewSize.height / fZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);    
    [((UIScrollView *)recognizer.view) zoomToRect:rectToZoomTo animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_container setTitleWithImage:self.image];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

