//
//  SPAdView.h
//  SPAdView
//
//  Created by qianfeng on 15/10/30.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPAdView : UIView
@property (nonatomic, strong) NSArray *imageUrls;
@property (nonatomic, strong) NSArray *imageNames;
@property (nonatomic,strong) void (^imageTap)(UIImageView *imageView, NSInteger index);

+(id)adViewWithFrame:(CGRect)frame;

-(void)pageControlPosition:(CGPoint)point;

@end
