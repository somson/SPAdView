//
//  SPAdView.m
//  SPAdView
//
//  Created by qianfeng on 15/10/30.
//  Copyright © 2015年 qianfeng. All rights reserved.
//

#import "SPAdView.h"
@interface SPAdView ()<UIScrollViewDelegate>


@property (nonatomic) UIPageControl *pageControl;

@property (nonatomic) UIScrollView *scrollView;

@property (nonatomic) NSTimer *timer;

@end

@implementation SPAdView

+(id)adViewWithFrame:(CGRect)frame
{
    return [[self alloc]initWithFrame:frame];
}

-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        //初始化scrollView pageControl
        self.frame = frame;
        [self createUI];
        
        [self startTimer];
    }
    return self;
}
-(void)pageControlPosition:(CGPoint)point
{
    CGRect rect = self.pageControl.frame;
    rect.origin = point;
    self.pageControl.frame = rect;
}

-(void)createUI
{
    self.backgroundColor = [UIColor blueColor];
   
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.backgroundColor = [UIColor redColor];
    self.scrollView.contentSize = CGSizeMake(0, 0);
    
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, 100, 10)];
    self.pageControl.center = CGPointMake(self.scrollView.center.x, self.frame.size.height-self.pageControl.frame.size.height);
    
    self.pageControl.numberOfPages = 5;
    self.pageControl.currentPage = 0;
    
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
}
-(void)timer:(NSTimer*)timer
{
    CGPoint currentOffset = self.scrollView.contentOffset;
    
    CGRect rect = CGRectMake(currentOffset.x+self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    
    [self.scrollView scrollRectToVisible:rect animated:YES];
}
-(void)setImageNames:(NSArray *)imageNames
{
    if(self.imageUrls != nil)
    {
        return;
    }
    _imageNames = imageNames;
    self.pageControl.numberOfPages = imageNames.count;
    
    [self createImages:imageNames tag:0];
}


-(void)createImages:(NSArray *)images tag:(int) tag
{
    float x = 0;
    float y = 0;
    float width = self.frame.size.width;
    float heigt = self.frame.size.height;
    UIImageView *firstImage = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, width, heigt)];
    if(tag == 0)
    {
        firstImage.image = [UIImage imageNamed:[images lastObject]];
    }
    [self.scrollView addSubview:firstImage];
    x = self.frame.size.width;
    
    for(int i = 0; i < images.count; i++)
    {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, width, heigt)];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dealTap:)];
        [imageView addGestureRecognizer:tapGes];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i+1;
        
        if(tag == 0)
        {
            imageView.image = [UIImage imageNamed:images[i]];
        }
        [self.scrollView addSubview:imageView];
        x += width;
    }
    
    UIImageView *lastImage = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, width, heigt)];
    if(tag == 0)
    {
        lastImage.image = [UIImage imageNamed:[images firstObject]];
    }
    [self.scrollView addSubview:lastImage];
    
    self.scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    
    self.scrollView.contentSize = CGSizeMake((images.count+2)*width, heigt);
}

-(void)dealTap:(UITapGestureRecognizer *)tap
{
    UIImageView *imageView = (UIImageView *)tap.view;
    
    if(self.imageTap)
    {
        self.imageTap(imageView, imageView.tag);
    }
}

-(void)startTimer
{
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timer:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
-(void)stopTimer
{
    [_timer invalidate];
    _timer = nil;
}


#pragma mark scrollView的代理
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    float width = self.frame.size.width;
    int page = offsetX/width-1;
    self.pageControl.currentPage = page;
    
    if(page >= self.pageControl.numberOfPages)
    {
        self.pageControl.currentPage = 0;
        
        CGRect rect = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        [self.scrollView scrollRectToVisible:rect animated:NO];
    }
    
    if(page < 0)
    {
        self.pageControl.currentPage = self.pageControl.numberOfPages-1;
        CGRect rect = CGRectMake(self.frame.size.width*self.pageControl.numberOfPages+1, 0, self.frame.size.width, self.frame.size.height);
        [self.scrollView scrollRectToVisible:rect animated:NO];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.timer.fireDate = [NSDate distantPast];
    [self startTimer];
    
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    float width = self.frame.size.width;
    int page = offsetX/width-1;
    self.pageControl.currentPage = page;
    
    if(page >= self.pageControl.numberOfPages)
    {
        self.pageControl.currentPage = 0;
        
        CGRect rect = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        [self.scrollView scrollRectToVisible:rect animated:NO];
    }
    
    if(page < 0)
    {
        self.pageControl.currentPage = self.pageControl.numberOfPages-1;
        
        
        CGRect rect = CGRectMake(self.frame.size.width*self.pageControl.numberOfPages+1, 0, self.frame.size.width, self.frame.size.height);
        [self.scrollView scrollRectToVisible:rect animated:NO];
    }
}



@end
