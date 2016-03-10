//
//  ViewController.m
//  CustomScrollview
//
//  Created by 楚晨晨 on 16/3/10.
//  Copyright © 2016年 楚晨晨. All rights reserved.
//

#import "ViewController.h"
#import "BannerView.h"


#define SCREEN_WIDTH        [[UIScreen mainScreen]bounds].size.width
#define SCREEN_HEIGHT       [[UIScreen mainScreen]bounds].size.height
#define TOPBARHEIGHT        64
#define STATUSBARHEIGHT     20
#define TABBARHEIGHT        49
@interface ViewController ()<BannerViewDelegate>{

    BannerView *bannerview;


}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    bannerview = [[BannerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*0.5)];
    bannerview.backgroundColor = [UIColor clearColor];
    bannerview.delegate = self;
    NSArray *arr = @[@"APP1.jpg",@"APP2.jpg",@"APP3.jpg"];
    [bannerview setBannerImage:arr];

    [self.view addSubview:bannerview];

}
#pragma mark - BannerView Delegate

- (void)bannerView:(id)view clickedAtIndex:(NSInteger)index
{
    NSLog(@"您点击了第%ld张图片",index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
