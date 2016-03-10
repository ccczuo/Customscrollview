//
//  BannerView.h
//  CustomScrollview
//
//  Created by 楚晨晨 on 16/3/10.
//  Copyright © 2016年 楚晨晨. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol BannerViewDelegate <NSObject>

- (void)bannerView:(id)view clickedAtIndex:(NSInteger)index;

@end
@interface BannerView : UIView
@property (nonatomic,weak)id<BannerViewDelegate> delegate;
- (void)setBannerImage:(NSArray *)array;


@end
