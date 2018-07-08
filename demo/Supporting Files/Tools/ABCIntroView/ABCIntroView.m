//
//  IntroView.m
//  DrawPad
//
//  Created by Adam Cooper on 2/4/15.
//  Copyright (c) 2015 Adam Cooper. All rights reserved.
//

#import "ABCIntroView.h"

@interface ABCIntroView ()

@property (strong, nonatomic)  UIScrollView *scrollView;
@property (strong, nonatomic)  UIPageControl *pageControl;

@end

@implementation ABCIntroView
{
    BOOL flag;
}

#pragma mark - tool
//移除动画
- (void)removeAnimation
{
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

//结束操作
- (void)endAction
{
    //移除动画
    [self removeAnimation];
    
    // 显示状态栏
    [k_UIApplication setStatusBarHidden:NO];
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        
        // 初始化scrollView
        [self initScrollView];
        
        // 初始化skip按钮
        [self initSkipBtn];
        
        // 初始化4个页面 + 1个空白页面
        [self createViewOne];
        [self createViewTwo];
        [self createViewThree];
        [self createViewFour];
        [self createViewFive];
    }
    return self;
}


#pragma mark - private
// 初始化scrollView
- (void)initScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width*4, self.scrollView.frame.size.height);
    [self addSubview:self.scrollView];
    

    
    
    // 初始化pageControl
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height*0.95, self.frame.size.width, 10)];
    self.pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"#ededed"];
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#ffcb13"];
    self.pageControl.numberOfPages = 4;
    [self addSubview:self.pageControl];
    
    

    
    
    //This is the starting point of the ScrollView
    CGPoint scrollPoint = CGPointMake(0, 0);
    [self.scrollView setContentOffset:scrollPoint animated:YES];
    
}

// 初始化skip按钮
- (void)initSkipBtn
{
     UIButton *skipBtn = [UIButton buttonWithType:0];
     skipBtn.frame = CGRectMake(SCREEN_WIDTH - 60 - 10, SCREEN_HEIGHT - 30 - 10, 60, 30);
     [skipBtn setBackgroundImage:[UIImage imageNamed:@"skip"] forState:0];
     [skipBtn setBackgroundImage:[UIImage imageNamed:@"skip"] forState:1];
     [skipBtn addTarget:self action:@selector(skipBtnClick) forControlEvents:UIControlEventTouchUpInside];
     [self addSubview:skipBtn];
    
    skipBtn.backgroundColor = [UIColor redColor];
     
     // 扩大点击区域
     [skipBtn setEnlargeEdge:40];
}

// 初始化4个页面 + 1个空白页面
-(void)createViewOne
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.scrollView.delegate = self;
    [self.scrollView addSubview:view];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:view.bounds];
    imageView.image = [UIImage imageNamed:@"引导页1"];
    [view addSubview:imageView];
}

-(void)createViewTwo
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*1, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.scrollView.delegate = self;
    [self.scrollView addSubview:view];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:view.bounds];
    imageView.image = [UIImage imageNamed:@"引导页2"];
    [view addSubview:imageView];
}

-(void)createViewThree
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.scrollView.delegate = self;
    [self.scrollView addSubview:view];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:view.bounds];
    imageView.image = [UIImage imageNamed:@"引导页3"];
    [view addSubview:imageView];
}

-(void)createViewFour
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*3, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.scrollView.delegate = self;
    [self.scrollView addSubview:view];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:view.bounds];
    imageView.image = [UIImage imageNamed:@"引导页4"];
    imageView.userInteractionEnabled = YES;
    [view addSubview:imageView];
    
    // "立即体验"按钮
    UIButton *tasteBtn = [UIButton buttonWithType:0];
    tasteBtn.frame = CGRectMake(0, 420, 100, 40);
    tasteBtn.centerX = imageView.centerX;
    tasteBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [tasteBtn addTarget:self action:@selector(tasteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:tasteBtn];
    
    if (IS_IPHONE_6) {
        tasteBtn.top = 490;
        tasteBtn.width = 120;
        tasteBtn.height = 44;
        tasteBtn.centerX = imageView.centerX;
    }
    if (IS_IPHONE_6P) {
        tasteBtn.top = 540;
        tasteBtn.width = 120;
        tasteBtn.height = 44;
        tasteBtn.centerX = imageView.centerX;
    }
}

-(void)createViewFive
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*4, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.scrollView.delegate = self;
    [self.scrollView addSubview:view];
    
    // 设置为白色 李满
    view.backgroundColor = [UIColor whiteColor];
}
 

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = CGRectGetWidth(self.bounds);
    CGFloat pageFraction = self.scrollView.contentOffset.x / pageWidth;
    self.pageControl.currentPage = roundf(pageFraction);
    
    NSLog(@"===%f===%f===%ld", pageWidth, pageFraction, (long)self.pageControl.currentPage);
    
    // 李满
    if (self.pageControl.currentPage == 3 && pageFraction > 3.0f) {
        
        if (!flag) {
            flag = YES;
            
            [self endAction];
        }
    }
    
    if (self.pageControl.currentPage == 0) {
        _scrollView.bounces = NO;
    } else {
        _scrollView.bounces = YES;
    }
}

#pragma mark - target action
//skip按钮
- (void)skipBtnClick
{
    [self endAction];
}

// "立即体验"按钮
- (void)tasteBtnClick
{
    [self endAction];
}

@end