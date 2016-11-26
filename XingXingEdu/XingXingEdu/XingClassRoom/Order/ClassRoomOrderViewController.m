//
//  ClassRoomOrderViewController.m
//  XingXingEdu
//
//  Created by codeDing on 16/3/31.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "ClassRoomOrderViewController.h"

#import <Foundation/Foundation.h>
#import "ClassRoomOrderNoPayTableViewController.h"
#import "ClassRoomOrderDidPayTableViewController.h"
#import "ClassRoomOrderNoAppraiseTableViewController.h"
#import "ClassRoomOrderDidAppraiseTableViewController.h"

@interface ClassRoomOrderViewController ()<UIScrollViewDelegate>{

    NSMutableDictionary  *_listVCQueue;
    UIScrollView *_contentScrollView;
    UISegmentedControl *_segmentedControl;
}
@end

@implementation ClassRoomOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1],NSForegroundColorAttributeName,nil]];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"big750x1206@2x"]]];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"我的订单";
    [self createSegmentedControl];
    [self initView];
    [self NoPayTabView];
    [self createLeftButton];
}


-(void)createLeftButton{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(- 10, 0, 44, 20);
    
    [backBtn setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    if (_isAppraiseSuccess == NO) {
        [backBtn addTarget:self action:@selector(popDoBack) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [backBtn addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    }
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
}
-(void)popDoBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)doBack:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)createSegmentedControl {
    NSArray *segmentedArray = [[NSArray alloc] initWithObjects:@"待支付",@"已支付",@"待评价",@"已评价",nil];
    //初始化UISegmentedControl
     _segmentedControl= [[UISegmentedControl alloc] initWithItems:segmentedArray];
    _segmentedControl.frame = CGRectMake(20,10,kWidth - 40 ,35);
    _segmentedControl.tintColor = UIColorFromRGB(0, 171, 54);
    _segmentedControl.selectedSegmentIndex = 0;
    _segmentedControl.backgroundColor = [UIColor whiteColor];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,  nil,NSFontAttributeName ,[UIColor whiteColor],NSForegroundColorAttributeName ,nil];
    [_segmentedControl setTitleTextAttributes:dic forState:UIControlStateSelected];
    [_segmentedControl addTarget:self action:@selector(didClicksegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmentedControl];

}


-(void)didClicksegmentedControlAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    switch (Index) {
        case 0:
            [self NoPayTabView];
            break;
        case 1:
            [self DidPayTableView];
            break;
        case 2:
            [self NoAppraiseTableView];
            break;
        case 3:
            [self DidAppraiseTableView];
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    //example 用于滑动的滚动视图
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,_segmentedControl.y + _segmentedControl.size.height + 20 , screenWidth, screenHeight - _segmentedControl.size.height)];
    _contentScrollView.contentSize = (CGSize){screenWidth * 1,_contentScrollView.contentSize.height};
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.delegate      = self;
    _contentScrollView.scrollsToTop  = NO;
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_contentScrollView];
    
}

-(void)NoPayTabView {
    ClassRoomOrderNoPayTableViewController * vc0 = [[ClassRoomOrderNoPayTableViewController alloc]init];
    [self addChildViewController:vc0];
    vc0.view.left = 0*screenWidth;
    vc0.view.top  = 0;
    [_contentScrollView addSubview:vc0.view];
    [_listVCQueue setObject:vc0 forKey:@(0)];
}
-(void)DidPayTableView {
    ClassRoomOrderDidPayTableViewController * vc1 = [[ClassRoomOrderDidPayTableViewController alloc]init];
    [self addChildViewController:vc1];
    vc1.view.left = 0*screenWidth;
    vc1.view.top  = 0;
    [_contentScrollView addSubview:vc1.view];
    [_listVCQueue setObject:vc1 forKey:@(1)];
}
-(void)NoAppraiseTableView {
    ClassRoomOrderNoAppraiseTableViewController * vc2 = [[ClassRoomOrderNoAppraiseTableViewController alloc]init];
    [self addChildViewController:vc2];
    vc2.view.left = 0*screenWidth;
    vc2.view.top  = 0;
    [_contentScrollView addSubview:vc2.view];
    [_listVCQueue setObject:vc2 forKey:@(2)];
}
-(void)DidAppraiseTableView {
    ClassRoomOrderDidAppraiseTableViewController * vc3 = [[ClassRoomOrderDidAppraiseTableViewController alloc]init];
    [self addChildViewController:vc3];
    vc3.view.left = 0*screenWidth;
    vc3.view.top  = 0;
    [_contentScrollView addSubview:vc3.view];
    [_listVCQueue setObject:vc3 forKey:@(3)];
}



@end
