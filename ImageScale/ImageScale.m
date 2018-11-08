//
//  ImageScale.m
//  ImageScale
//
//  Created by 王俊钢 on 2018/11/8.
//  Copyright © 2018 wangjungang. All rights reserved.
//

#import "ImageScale.h"

#define ScreenBounds [UIScreen mainScreen].bounds

@interface ImageScale() <UIScrollViewDelegate>

/** 全屏窗口  */
@property (nonatomic, strong) UIWindow  *screenWindow;

/** 覆盖视图，用于动画展示  */
@property (nonatomic, strong) UIImageView  *coverImageView;

/** 放大画布  */
@property (nonatomic, strong) UIScrollView *scrollView;

/** 原始图片视图  */
@property (nonatomic, strong) UIImageView *originalImageView;

/** 当前视图的放大比例  */
@property (nonatomic, assign) CGFloat currentScale;

/** 需要放大的图片  */
@property (nonatomic, strong) UIImageView *bigImage;

/** 原始位置大小  */
@property (nonatomic, assign) CGRect originRect;

@end

@implementation ImageScale


- (void)scaleImageView:(UIImageView *)imageView {
    self.originalImageView  = imageView;
    imageView.userInteractionEnabled  = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [imageView addGestureRecognizer:tap];
}

- (void)tapAction:(UITapGestureRecognizer *)gesture {
    //底层视图
    UIWindow *screenWindow = [[UIWindow alloc] initWithFrame:ScreenBounds];
    screenWindow.backgroundColor = [UIColor blackColor];
    self.screenWindow = screenWindow;
    
    //放大图片
    UIImageView *bigImage = [[UIImageView alloc] init];
    self.bigImage = bigImage;
    bigImage.userInteractionEnabled = YES;
    bigImage.image = self.originalImageView.image;
    CGRect viewFrame = [self.originalImageView.superview convertRect:self.originalImageView.frame toView:screenWindow];
    self.originRect = viewFrame;
    bigImage.frame = viewFrame;
    
    UITapGestureRecognizer *tapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(smallAction:)];
    tapOne.numberOfTapsRequired = 1;
    tapOne.numberOfTouchesRequired = 1;
    [bigImage addGestureRecognizer:tapOne];
    
    UITapGestureRecognizer *tapTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTwoAction:)];
    tapTwo.numberOfTapsRequired = 2;
    tapTwo.numberOfTouchesRequired = 1;
    [bigImage addGestureRecognizer:tapTwo];
    [tapOne requireGestureRecognizerToFail:tapTwo];
    
    //放大视图
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:ScreenBounds];
    scrollView.delegate = self;
    [scrollView addSubview:bigImage];
    scrollView.maximumZoomScale = 2;
    scrollView.minimumZoomScale = 1;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    //设置UIScrollView的滚动范围和图片的真实尺寸一致
    scrollView.contentSize = self.originalImageView.image.size;
    self.scrollView = scrollView;
    
    [self.screenWindow addSubview:scrollView];
    self.screenWindow.hidden = NO;
    viewFrame = [self getRectWithSize:[[UIScreen mainScreen] bounds].size];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bigImage.frame = viewFrame;
    }];
}



- (void)smallAction:(UITapGestureRecognizer *)gesture {
    UIView *targetView = gesture.view;
    UIImageView *coverImageView = [[UIImageView alloc] init];
    coverImageView.image = self.originalImageView.image;
    coverImageView.frame = [targetView convertRect:targetView.frame toView:self.screenWindow];
    [_screenWindow addSubview:coverImageView];
    coverImageView.center = self.screenWindow.center;
    [self.scrollView removeFromSuperview];
    [UIView animateWithDuration:0.3 animations:^{
        coverImageView.frame = self.originRect;
        self.screenWindow.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [coverImageView removeFromSuperview];
        [self.screenWindow.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.screenWindow removeFromSuperview];
        self.screenWindow.hidden = YES;
        self.screenWindow = nil;
    }];
}

- (void)tapTwoAction:(UITapGestureRecognizer *)gesture {
    if (self.currentScale > 1.0) {
        self.currentScale = 1;
        [self.scrollView setZoomScale:_currentScale animated:YES];
    }else {
        self.currentScale = 2;
        [self.scrollView setZoomScale:_currentScale animated:YES];
    }
}


#pragma mark -- scrollViewDelegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.bigImage;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    self.currentScale = scale;
}

- (void) scrollViewDidZoom:(UIScrollView *)scrollView {
    self.bigImage.center = [self centerOfScrollViewContent:scrollView];
}


- (CGRect)getRectWithSize:(CGSize)size {
    UIImage *originalImage = self.originalImageView.image;
    CGFloat widthRatio = size.width / originalImage.size.width;
    CGFloat heightRatio = size.height / originalImage.size.height;
    CGFloat scale = MIN(widthRatio, heightRatio);
    CGFloat width = scale * originalImage.size.width;
    CGFloat height = scale * originalImage.size.height;
    return CGRectMake((size.width - width) / 2, (size.height - height) / 2, width, height);
}

- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                       scrollView.contentSize.height * 0.5 + offsetY);
    return actualCenter;
}




@end
