//
//  ViewController.m
//  ImageScale
//
//  Created by 王俊钢 on 2018/11/8.
//  Copyright © 2018 wangjungang. All rights reserved.
//

#import "ViewController.h"
#import "ImageScale.h"

@interface ViewController ()<UIScrollViewDelegate>//签代理

/** 图片数组  */
@property (nonatomic, strong) NSArray *picArr;

/** bigImage  */
@property (nonatomic, strong) UIImageView *bigImage;

/** ImageScale  */
@property (nonatomic, strong) ImageScale *imageScale;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.picArr = [NSArray arrayWithObjects:@"tutu.jpg",@"fengjing1.jpg",@"meimei1.jpg",@"meimei2.jpg",@"qiu.jpg", nil];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 100, 80, 80)];
    [self.view addSubview:imageView];
    imageView.image = [UIImage imageNamed:self.picArr[0]];
    self.imageScale= [ImageScale new];
    [self.imageScale scaleImageView:imageView];
    self.bigImage = imageView;
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setTitle:@"下一张" forState:UIControlStateNormal];
    nextBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 40, 300, 80, 40);
    [nextBtn addTarget:self action:@selector(nextPic) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.backgroundColor = [UIColor blackColor];
    [self.view addSubview:nextBtn];
}


- (void)nextPic {
    int x = arc4random() % 4;
    self.bigImage.image = [UIImage imageNamed:self.picArr[x]];
}



@end
