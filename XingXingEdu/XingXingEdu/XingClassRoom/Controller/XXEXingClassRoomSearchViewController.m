
//
//  XXEXingClassRoomViewController.m
//  teacher
//
//  Created by Mac on 16/10/21.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEXingClassRoomSearchViewController.h"

#import "WJCommboxView.h"


@interface XXEXingClassRoomSearchViewController ()
{

    WJCommboxView *categoryCommbox;
    
    UIView *categoryCommboxBgView;
    
    //
    UITextField *searchTextField;
    
    //
    UIButton *searchButton;
    
    //中间 背景
    UIView *middleBgView;
    
    //按钮 背景
    UIView *btnBgView;

    //热门 词语
    NSMutableArray *hotWordArray;

    NSString *parameterXid;
    NSString *parameterUser_Id;

}
//下面 背景
@property (nonatomic, strong) UIView *downBgView;
@property (nonatomic, assign) CGRect currentLabelFrame;

@end

@implementation XXEXingClassRoomSearchViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

    if (btnBgView) {
        [btnBgView removeFromSuperview];
    }
    
    [self fetchHotWordData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    //创建 上面 下拉框和输入框
    [self createUpContent];
    
    //创建 中间 部分
    [self createMiddleContent];
    
    //创建 下面 热搜 内容
        [self createDownContent];

}


- (void)createUpContent{
#pragma mark - ================== 左边 下拉框 ====================
    //搜索类型
    categoryCommbox = [[WJCommboxView alloc] initWithFrame:CGRectMake(10, 10, 70 * kWidth / 375, 30)];

    [self.view addSubview:categoryCommbox];
    
    categoryCommbox.dataArray = [[NSMutableArray alloc] initWithObjects:@"老师", @"课程", @"机构", nil];
    
    categoryCommbox.textField.placeholder = @"种类";
    
    categoryCommbox.textField.textAlignment = NSTextAlignmentCenter;
    categoryCommbox.textField.borderStyle = UITextBorderStyleRoundedRect;
    [categoryCommbox.textField addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    if ([_date_type integerValue] == 1) {
        categoryCommbox.textField.text = @"老师";
    }else if ([_date_type integerValue] == 2) {
        categoryCommbox.textField.text = @"课程";
    }else if ([_date_type integerValue] == 3) {
        categoryCommbox.textField.text = @"机构";
    }

    
    #pragma mark - ================== 右边 输入框 ====================
    searchTextField = [HHControl createTextFieldWithFrame:CGRectMake(categoryCommbox.frame.origin.x + categoryCommbox.width + 10, 10, kWidth - 150 * kWidth / 375, 30) placeholder:@"请输入搜索内容" passWord:NO leftImageView:nil rightImageView:nil Font:14];
    searchTextField.backgroundColor = [UIColor whiteColor];
    searchTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:searchTextField];
    
    searchButton = [HHControl createButtonWithFrame:CGRectMake(searchTextField.frame.origin.x + searchTextField.width + 10, 10, 50 * kWidth / 375, 30) backGruondImageName:nil Target:self Action:@selector(searchButtonClick) Title:@"搜索"];
    searchButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:searchButton];

}

- (void)searchButtonClick{
    
    NSString *str1 = searchTextField.text;
    NSString *str2 = _date_type;

    NSMutableArray *mArr = [[NSMutableArray alloc] initWithObjects:str1, str2, nil];
    self.ReturnArrayBlock(mArr);
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)createMiddleContent{

    middleBgView = [[UIView alloc] initWithFrame:CGRectMake(0, categoryCommbox.frame.origin.y + categoryCommbox.height + 10, kWidth, 40)];
    middleBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:middleBgView];
    
    UILabel *titleLabel = [HHControl createLabelWithFrame:CGRectMake(10, 10, 200, 20) Font:14 Text:@"热门搜索"];
    [middleBgView addSubview:titleLabel];
    

}

- (void)createDownContent{
    self.downBgView = [[UIView alloc] initWithFrame:CGRectMake(0, middleBgView.frame.origin.y + middleBgView.height + 3, kWidth, 300 * kHeight / 667)];
    self.downBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.downBgView];

}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{

    if ([keyPath isEqualToString:@"text"]) {
        NSString * newName=[change objectForKey:@"new"];
//        NSLog(@"pp %@", newName);
        if ([newName isEqualToString:@"老师"]) {
            _date_type = @"1";
        }else if ([newName isEqualToString:@"课程"]) {
            _date_type = @"2";
        }else if ([newName isEqualToString:@"机构"]) {
            _date_type = @"3";
        }
        if (btnBgView) {
            [btnBgView removeFromSuperview];
        }
        [self fetchHotWordData];
    }
}

- (void)fetchHotWordData{
    btnBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _downBgView.frame.size.width, _downBgView.frame.size.height)];
    [_downBgView addSubview:btnBgView];
    
    /*
     【猩课堂--显示热门关键词(老师,课程,机构通用)】
     接口类型:1
     接口:
     http://www.xingxingedu.cn/Global/xkt_top_keywords
     传参:
     date_type		//需要查询的数据类型,填数字 1: 老师  2:课程 3:机构
     */
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/xkt_top_keywords";
    
    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE,
                             @"date_type":_date_type
                             };
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
        NSLog(@"s搜索 == %@", responseObj);
        
        if ([responseObj[@"code"] integerValue] == 1) {
            hotWordArray = [[NSMutableArray alloc] init];
            hotWordArray = responseObj[@"data"];
        }
        [self createButtons];
    } failure:^(NSError *error) {
        //
        [SVProgressHUD showInfoWithStatus:@""];
    }];
    
}


-(void)createButtons {
    self.currentLabelFrame = CGRectZero;
    CGFloat intervalWide = 10.f;     // label间隔宽度
    
    // 布局label
    for (NSInteger i = 0; i < hotWordArray.count; i++) {
        
        NSString *str = hotWordArray[i];
        
        CGFloat x = self.currentLabelFrame.origin.x;
        
        CGFloat y = self.currentLabelFrame.origin.y;
        
        
        if (i != 0) {
            
            x += kWidth /2;
            
        }else {
            
            y += intervalWide;
        }
        CGSize size = [self labelSizeFromString:str];
        
        // 判断label是否到视图边界
        CGFloat minX = x;
        CGFloat maxX = x + size.width;
        
        size.height = 30.0f;
        
        if (maxX > CGRectGetWidth(self.downBgView.frame)) {
            
            x -= minX;
            y = y + size.height + intervalWide;
        }
        // 计算label的frame
        CGRect rect = CGRectMake(x + 30, y, size.width, size.height);
        self.currentLabelFrame = rect;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = rect;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        
        [button setTitle:str forState:UIControlStateNormal];
        
        UIImageView *phoneImage=[[UIImageView alloc]initWithFrame:CGRectMake(-15, 7,15, 15)];
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        numLabel.backgroundColor = [UIColor clearColor];
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.textColor = [UIColor whiteColor];
        numLabel.text = [NSString stringWithFormat:@"%ld",(long)i];
        numLabel.font = [UIFont systemFontOfSize:12];
        [phoneImage addSubview:numLabel];
        phoneImage.backgroundColor = [UIColor orangeColor];;
        [button addSubview:phoneImage];
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [btnBgView addSubview:button];
    }
}


// 根据文本计算label宽度
- (CGSize)labelSizeFromString:(NSString *)str {
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0f]};
    return [str sizeWithAttributes:attributes];
}

// 标签点击事件
- (void)buttonAction:(UIButton *)sender {
    
    searchTextField.text = sender.titleLabel.text;
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [categoryCommbox.textField removeObserver:self forKeyPath:@"text" context:nil];

}



- (void)returnArray:(ReturnArrayBlock)block{
    self.ReturnArrayBlock = block;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
