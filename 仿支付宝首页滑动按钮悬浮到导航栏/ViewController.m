//
//  ViewController.m
//  仿支付宝首页滑动按钮悬浮到导航栏
//
//  Created by 宗炳林 on 2018/4/20.
//  Copyright © 2018年 宗炳林. All rights reserved.
//

#define SCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGTH   [[UIScreen mainScreen] bounds].size.height
#define BTN_HEIGHT      100

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>

/** 导航栏 **/
@property (nonatomic,strong)UIView      *navBgView;         // 导航栏背景图
@property (nonatomic,strong)UILabel     *navTitleLabel;     // nav标题Label
@property (nonatomic,strong)UIView      *navBtnBgView;      // nav按钮背景图


/** 视图 **/
@property (nonatomic,strong)UIScrollView *myScrollView;     // 大ScrollView
@property (nonatomic,strong)UIView       *btnBgView;        // 按钮背景图

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initNavigationBar];
    
    [self initView];
}

#pragma mark - 导航栏定制
- (void)initNavigationBar
{
    _navBgView                  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    _navBgView.backgroundColor  = [UIColor blackColor];
    [self.view addSubview:_navBgView];
    
    
    _navTitleLabel                  = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - 100) / 2, 20, 100, 44)];
    _navTitleLabel.textAlignment    = NSTextAlignmentCenter;
    _navTitleLabel.text             = @"导航栏标题";
    _navTitleLabel.font             = [UIFont systemFontOfSize:16];
    _navTitleLabel.textColor        = [UIColor whiteColor];
    [_navBgView addSubview:_navTitleLabel];
    
    
    _navBtnBgView                   = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 176, 44)];
    _navBtnBgView.backgroundColor   = [UIColor clearColor];
    _navBtnBgView.alpha             = 0;
    [_navBgView addSubview:_navBtnBgView];
    
    
    NSArray *navBtnNameArray = @[@"Home_QRCode_Small", @"Home_MyCode_Small", @"Home_Search_Small", @"Home_Integral_Small"];
    for (int i = 0 ; i < navBtnNameArray.count; i ++)
    {
        UIButton *navBtn = [[UIButton alloc] initWithFrame:CGRectMake(i * 44, 0, 44, 44)];
        [navBtn setImage:[UIImage imageNamed:navBtnNameArray[i]] forState:UIControlStateNormal];
        navBtn.tag = i;
        [navBtn addTarget:self action:@selector(navBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_navBtnBgView addSubview:navBtn];
    }
    
}

#pragma mark - 视图定制
- (void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    _myScrollView                   = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGTH - 64)];
    _myScrollView.backgroundColor   = [UIColor whiteColor];
    _myScrollView.delegate          = self;
    [self.view addSubview:_myScrollView];
    _myScrollView.contentSize       = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGTH * 2);
    
    
    _btnBgView                      = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, BTN_HEIGHT)];
    _btnBgView.backgroundColor      = [UIColor blackColor];
    [_myScrollView addSubview:_btnBgView];
    
    NSArray *btnNameArray = @[@"Home_QRCode", @"Home_MyCode", @"Home_Search", @"Home_Integral"];
    for (int i = 0 ; i < btnNameArray.count; i ++)
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i * (SCREEN_WIDTH / btnNameArray.count), 0, SCREEN_WIDTH / 4, 100)];
        [btn setImage:[UIImage imageNamed:btnNameArray[i]] forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(navBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btnBgView addSubview:btn];
    }
    
}


#pragma mark - 导航栏按钮事件
- (void)navBtnClick:(UIButton *)button
{
    
}

#pragma mark - UIScrollViewDelegate
// 正在滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _myScrollView)
    {
        // 计算滑动的位置
        CGFloat alpha = _myScrollView.contentOffset.y / BTN_HEIGHT;
        NSLog(@"滚动距离比例 ======= %f",alpha);
        
//        alpha = MAX(alpha, 0.0);
//        NSLog(@"滚动距离比例取大 ======= %f",alpha);
        
        alpha = MIN(alpha, 1.0);
        NSLog(@"滚动距离比例取小 ======= %f",alpha);

        _navTitleLabel.alpha    = 1.0 - alpha;
        _navBtnBgView.alpha     = alpha;
        
        // 当ScrollView下滑
//        if (_myScrollView.contentOffset.y <= 0)
//        {
//            alpha = ABS(_myScrollView.contentOffset.y / BTN_HEIGHT);
//            alpha = MIN(alpha, 1.0);
//
//            _navBtnBgView.alpha = 1.0 - alpha;
//        }
    }
}

// 用户拖动结束被调用,decelerate为YES时，结束拖动后会有减速过程
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == _myScrollView)
    {
        // 如果不是在减速
        if (!decelerate)
        {
            // 处于上拉但是小于100的一半
            if (_myScrollView.contentOffset.y < BTN_HEIGHT/2 && _myScrollView.contentOffset.y > 0)
            {
                [_myScrollView setContentOffset:CGPointZero animated:YES];
            }
            // 处于上拉但是大于100的一半
            else if (_myScrollView.contentOffset.y < BTN_HEIGHT && _myScrollView.contentOffset.y > BTN_HEIGHT/2)
            {
                [_myScrollView setContentOffset:CGPointMake(0, BTN_HEIGHT) animated:YES];
            }
        }
    }
}

//停止滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _myScrollView)
    {
        if (_myScrollView.contentOffset.y < BTN_HEIGHT / 2 && _myScrollView.contentOffset.y > 0)
        {
            [_myScrollView setContentOffset:CGPointZero animated:YES];
        }
        else if (_myScrollView.contentOffset.y < BTN_HEIGHT && _myScrollView.contentOffset.y > BTN_HEIGHT / 2)
        {
            [_myScrollView setContentOffset:CGPointMake(0, BTN_HEIGHT) animated:YES];;
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}


@end
