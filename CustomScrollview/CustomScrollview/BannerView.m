//
//  BannerView.m
//  CustomScrollview
//
//  Created by 楚晨晨 on 16/3/10.
//  Copyright © 2016年 楚晨晨. All rights reserved.
//

#import "BannerView.h"
#import "UIView+Rect.h"
@interface BannerView ()<UIScrollViewDelegate>

@property (nonatomic,assign) NSInteger offset;
@property (nonatomic,strong) NSMutableArray *imageViews;
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) NSArray *imageNames;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIActivityIndicatorView *activityView;


@end
@implementation BannerView
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        //数据初始化
        self.imageNames = [NSMutableArray array];
        self.imageViews = [NSMutableArray array];
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.scrollView.backgroundColor  = [UIColor cyanColor];
        self.scrollView.delegate = self;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.bounces  = NO;
        self.scrollView.scrollsToTop = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:self.scrollView];
        
        
        
        // 添加点击事件
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        [self.scrollView addGestureRecognizer:recognizer];
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 20, self.frame.size.width, 20)];
        self.pageControl.backgroundColor = [UIColor clearColor];
        self.pageControl.enabled = NO;
        self.pageControl.numberOfPages = self.imageNames.count;
        self.pageControl.currentPage = 0;
        self.pageControl.hidesForSinglePage = YES;
        [self addSubview:self.pageControl];
        
        // loading
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        self.activityView.frame = CGRectMake((frame.size.width - 20 )/ 2,(frame.size.height - 20 )/ 2, 20.0f, 20.0f);
        self.activityView.hidesWhenStopped = YES;
        [self addSubview:self.activityView];
    }


    return self;
}
-(void)setBannerImage:(NSArray *)array{
   

    self.imageNames = array;
    [self.imageViews removeAllObjects];
    [self.scrollView  removeAllSubviews];

    self.offset = 0;
    if(array.count==0){
        NSLog(@"没有图片");
        return;
    }
    
    if (array.count==1) {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
        imageview.backgroundColor = [UIColor colorWithRed:250/255.0  green:250/255.0 blue:250/255.0 alpha:1];
        imageview.contentMode = UIViewContentModeScaleAspectFill;
        [imageview setImage:[UIImage imageNamed:self.imageNames[0]]];
        [self.imageViews addObject:imageview];
        [self.scrollView addSubview:imageview];
        [self.scrollView setContentOffset:CGPointMake(0, 0)];
        self.pageControl.numberOfPages = 1;
        self.pageControl.currentPage = 0;
        
    }else {
        if (array.count == 2) {
            NSMutableArray *urlArray = [NSMutableArray arrayWithArray:array];
            [urlArray addObjectsFromArray:array];
            self.imageNames = urlArray;
            
            self.pageControl.numberOfPages = 2;
            self.pageControl.currentPage = 0;
        } else {
            self.pageControl.numberOfPages = self.imageNames.count;
            self.pageControl.currentPage = 0;
        }
        
        for (int i=0; i<3; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*self.width, 0, self.width, self.height)];
            [self.imageViews addObject:imageView];
            [self.scrollView addSubview:imageView];
        }
        [self.scrollView setContentSize:CGSizeMake(3*self.width, self.height)];
        [self.scrollView setContentOffset:CGPointMake(self.width, 0)];
        
        for (int i=0; i<3; i++) {
            UIImageView *imageView = self.imageViews[i];
            NSInteger index = (i == 0) ? (self.imageNames.count-1) : (i-1);
            [imageView setImage:[UIImage imageNamed:self.imageNames[index ]]];
        }
        
        // 开始图片轮播
        [self performSelector:@selector(switchBannerItem) withObject:nil afterDelay:2];
    
    }


}
- (void)switchBannerItem{

    CGFloat targetX = self.scrollView.contentOffset.x + self.bounds.size.width;
    [self.scrollView setContentOffset:CGPointMake(targetX, 0) animated:YES];

}


#pragma mark - scrollView

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(switchBannerItem) object:nil];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{


    if (self.imageViews.count<3 ||self.imageNames.count<2) {
        return;
    }
    if (scrollView.contentOffset.x==0) {
        //左滑对齐
        self.offset = (self.offset==0)?(self.imageNames.count-1):(self.offset-1);
        for (UIImageView *imageView in self.imageViews) {
            imageView.left += scrollView.frame.size.width;
            if (imageView.left == scrollView.frame.size.width*3) {
                imageView.left = 0;
                NSInteger index = (self.offset == 0) ? (self.imageNames.count-1) : (self.offset - 1);
                [imageView setImage:[UIImage imageNamed:self.imageNames[index]]];
            }
        }
        if (self.imageViews.count > 2) {
            [self.imageViews exchangeObjectAtIndex:0 withObjectAtIndex:2];
            [self.imageViews exchangeObjectAtIndex:1 withObjectAtIndex:2];
        }

    }

    else if (scrollView.contentOffset.x == scrollView.frame.size.width*2) {
        //右滑对齐
        self.offset = (self.offset == (self.imageNames.count -1)) ? 0 : (self.offset + 1);
        for (UIImageView *imageView in self.imageViews) {
            imageView.left -= scrollView.frame.size.width;
            if (imageView.left == -scrollView.frame.size.width) {
                imageView.left = scrollView.frame.size.width*2;
                NSInteger index = (self.offset == (self.imageNames.count - 1)) ? 0 : (self.offset + 1);
                 [imageView setImage:[UIImage imageNamed:self.imageNames[index]]];
            }
        }
        if (self.imageViews.count > 2) {
            [self.imageViews exchangeObjectAtIndex:0 withObjectAtIndex:2];
            [self.imageViews exchangeObjectAtIndex:0 withObjectAtIndex:1];
        }
    }
    [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width, 0)];
    self.pageControl.currentPage = self.offset % self.pageControl.numberOfPages;
    
    [self performSelector:@selector(switchBannerItem) withObject:nil afterDelay:4];

}


#pragma mark - tap

- (void)tap:(UIGestureRecognizer *)recognizer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bannerView:clickedAtIndex:)]) {
        [self.delegate bannerView:self clickedAtIndex:self.pageControl.currentPage];
    }
}


@end
