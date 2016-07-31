//
//  ClassRoomSearchViewController.m
//  XingXingStore
//
//  Created by codeDing on 16/2/3.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "ClassRoomSearchViewController.h"
#import "GTButtonTagsView.h"
#import "Model_HisWord.h"
#import "WJCommboxView.h"
#import "ClassRoomSearchResultController.h"

@interface ClassRoomSearchViewController ()<GTButtonTagsViewDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,WJCommboxViewDelegate>{
    NSArray* reversedArray;
    
    NSInteger _searchNum;
}

@property (weak, nonatomic) IBOutlet GTButtonTagsView *labelsView;

@property(nonatomic,strong)WJCommboxView *relationCombox;//下拉选择框
//搜索框
@property (nonatomic, strong) UIView * searchView;

@property (nonatomic, strong) UITextField * inputTF;

@property (nonatomic, strong) UIButton * searchBtn;

@property (nonatomic, strong) UITableView * hisTV;

@property (nonatomic, strong) NSMutableArray * hisArr;

@property (nonatomic, strong) NSMutableArray * hisDicArr;

@property (nonatomic, strong) NSMutableDictionary * plistData;

@end

@implementation ClassRoomSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.view.backgroundColor= UIColorFromRGB(229, 233, 232);
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    self.navigationItem.title=@"搜索";
    
    _searchNum = 0;
    
    self.labelsView.delegate = self;
    //搜索框
    self.hisArr = [NSMutableArray array];
    self.hisDicArr = [NSMutableArray array];
    [self getData];
    [self createUI];
    [self keyboardHide];
    
}

- (void)keyboardHide{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}
//点击其他任意让键盘隐藏
- (void)keyboardHide:(UITapGestureRecognizer *)sender{
    [self.inputTF resignFirstResponder];
}
- (void)GTButtonTagsView:(GTButtonTagsView *)view selectIndex:(NSInteger)index selectText:(NSString *)text {
    
    self.inputTF.text = text;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark 搜索框
- (void)getData{
    //获取历史记录数据
    [self.hisArr  removeAllObjects];
    if ([self judgeFileExist:@"SearchHistory.plist"]) {
        NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *path = [documents stringByAppendingPathComponent:@"SearchHistory.plist"];
        self.plistData = [[NSDictionary dictionaryWithContentsOfFile:path] mutableCopy];
        if ([self.plistData objectForKey:@"history"] != nil) {
            self.hisDicArr = [self.plistData objectForKey:@"history"];
            for (NSMutableDictionary * wordDic in self.hisDicArr) {
                Model_HisWord * model = [Model_HisWord changDicToHisWord:wordDic];
                [self.hisArr addObject:model];
            }
            NSArray * tempArr = [[self.hisArr sortedArrayUsingSelector:@selector(compare:)]mutableCopy];
            
            self.hisArr = [tempArr mutableCopy];
        }
        [self.hisTV reloadData];
    }else{
        //文件不存在
        NSArray *storeFilePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *doucumentsDirectiory = [storeFilePath objectAtIndex:0];
        NSString *plistPath =[doucumentsDirectiory stringByAppendingPathComponent:@"SearchHistory.plist"];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"SearchHistory"ofType:@"plist"];
        NSMutableDictionary *activityDics = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        [activityDics writeToFile:plistPath atomically:YES];
    }
}

- (void)createUI
{
    self.searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WinWidth, 50)];
    //输入框
    self.inputTF = [[UITextField alloc]initWithFrame:CGRectMake(90, 10, [UIScreen mainScreen].bounds.size.width - 150, 30)];
    self.inputTF.delegate = self;
    self.inputTF.layer.borderWidth = 1;
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    leftView.image = [UIImage imageNamed:@"搜索icon44x44"];
    self.inputTF.leftView = leftView;
    self.inputTF.rightViewMode = UITextFieldViewModeAlways;
    self.inputTF.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    self.inputTF.layer.cornerRadius = 5.0f;
    self.inputTF.font=[UIFont fontWithName:@"Times New Roman" size:14];
    self.inputTF.placeholder = @"请输入搜索内容";
    self.inputTF.backgroundColor = [UIColor whiteColor];
    self.inputTF.returnKeyType = UIReturnKeyDone;
    self.inputTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.inputTF];
    
    self.searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.inputTF.frame) + 10, 10, 40, 30)];
    [self.searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [self.searchBtn setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    self.searchBtn.titleLabel.font = [UIFont fontWithName:@"KaiTi_GB2312" size:14];
    self.searchBtn.userInteractionEnabled = YES;
    self.searchBtn.layer.masksToBounds = YES;
    self.searchBtn.layer.cornerRadius = 2;
    self.searchBtn.layer.borderWidth = 1;
    self.searchBtn.layer.borderColor = [[UIColor clearColor]CGColor];
    [self.searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.searchBtn];
    
    //历史记录tableview
    self.hisTV = [[UITableView alloc]initWithFrame:CGRectMake(90,CGRectGetMaxY(self.searchView.frame),220,200 )];
    self.hisTV.delegate = self;
    self.hisTV.dataSource = self;
    
    //添加边框效果？？没效果？
    self.hisTV.layer.shadowColor =(__bridge CGColorRef _Nullable)([UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:0.3]);
    self.hisTV.layer.shadowOffset = CGSizeMake(5, 5);
    self.hisTV.layer.shadowOpacity = 1;
    self.hisTV.clipsToBounds = false;
    
    self.hisTV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.hisTV];
    self.hisTV.hidden = YES;
    [self.hisTV setSeparatorColor:[UIColor blackColor ]];
    
    /**
     开始隐藏，当输入框称为第一响应者是显示
     有字体输入后继续隐藏
     */
    self.relationArray = [[NSArray alloc]initWithObjects:@"老师",@"课程",@"机构",nil];
    self.relationCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(10,10,70, 30)];
    self.relationCombox.textField.placeholder = @"老师";
    self.relationCombox.textField.layer.cornerRadius = 5.0f;
    self.relationCombox.textField.layer.borderWidth = 1.0f;
    self.relationCombox.textField.rightView.frame = CGRectMake(30, 10, 10, 10);
    self.relationCombox.textField.layer.borderColor = [[UIColor clearColor]CGColor];
    self.relationCombox.textField.textAlignment = NSTextAlignmentCenter;
    self.relationCombox.textField.rightView.width = - 15;
    self.relationCombox.textField.tag = 1000;
    self.relationCombox.delegate = self;
    self.relationCombox.dataArray = self.relationArray;
    
    [self.view addSubview:self.relationCombox];
    
}

- (void)searchAction{
    
    if ([@"" isEqualToString:self.inputTF.text]) {
        [SVProgressHUD showInfoWithStatus:@"请输入搜索文字"];
    }
    else{
        
        //去重
        int duplicateIndex = 999;
        
        for (NSMutableDictionary * hisWordDic in self.hisDicArr) {
            
            Model_HisWord * hisWord = [Model_HisWord changDicToHisWord:hisWordDic];
            
            if ([hisWord.word isEqualToString:self.inputTF.text]) {
                duplicateIndex = [self.hisDicArr indexOfObject:hisWordDic];
            }
        }
        
        if (duplicateIndex != 999) {
            [self.hisDicArr removeObjectAtIndex:duplicateIndex];
            
        }
        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *  nowStr = [formatter stringFromDate:[NSDate date]];
        
        Model_HisWord * lastWord = [Model_HisWord hisWordWithSearchDate:nowStr andWord:self.inputTF.text];
        [self.hisDicArr addObject:[lastWord changeModelToDic]];
        [self.hisTV reloadData];
        
        //写入plist
        [self.plistData setObject:self.hisDicArr forKey:@"history"];
        NSString *home = NSHomeDirectory();
        NSString *documents = [home stringByAppendingPathComponent:@"Documents"];
        NSString *path = [documents stringByAppendingPathComponent:@"SearchHistory.plist"];
        [self.plistData writeToFile:path atomically:YES];
        
        
        ClassRoomSearchResultController *resultVC = [[ClassRoomSearchResultController alloc] init];
        if (_searchNum == 0) {
            resultVC.searchWord = self.inputTF.text;
            resultVC.seletNum = _searchNum;
        }else if (_searchNum == 1){
            resultVC.searchWord = self.inputTF.text;
            resultVC.seletNum = _searchNum;
        }else if (_searchNum == 2){
            resultVC.searchWord = self.inputTF.text;
            resultVC.seletNum = _searchNum;
        }else{
            return;
        }
        [self.navigationController pushViewController:resultVC animated:YES];
        
        
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    //搜索历史显示
    [self getData];
    
    self.hisTV.hidden = NO;
}
#pragma mark -WJCommboxViewDelegate
-(void)sendSelectCellNum:(NSInteger)num{

    _searchNum = num;
    
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)num + 1],@"textOne",nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"tongzhi" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [_labelsView reloadInputViews];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    //开始搜索
    if ([@"" isEqualToString:textField.text]) {
        //        NSLog(@"请输入文字");
       [SVProgressHUD showInfoWithStatus:@"请输入搜索文字"];
     
    }else{
        
        //去重
        int duplicateIndex = 999;
        for (NSMutableDictionary * hisWordDic in self.hisDicArr) {
            Model_HisWord * hisWord = [Model_HisWord changDicToHisWord:hisWordDic];
            if ([hisWord.word isEqualToString:self.inputTF.text]) {
                duplicateIndex = [self.hisDicArr indexOfObject:hisWordDic];
            }
        }
        if (duplicateIndex != 999) {
            [self.hisDicArr removeObjectAtIndex:duplicateIndex];
            
        }
        NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *  nowStr = [formatter stringFromDate:[NSDate date]];
        Model_HisWord * lastWord = [Model_HisWord hisWordWithSearchDate:nowStr andWord:self.inputTF.text];
        [self.hisDicArr addObject:[lastWord changeModelToDic]];
        [self.hisTV reloadData];
        //写入plist
        [self.plistData setObject:self.hisDicArr forKey:@"history"];
        NSString *home = NSHomeDirectory();
        NSString *documents = [home stringByAppendingPathComponent:@"Documents"];
        NSString *path = [documents stringByAppendingPathComponent:@"SearchHistory.plist"];
        [self.plistData writeToFile:path atomically:YES];
        
        
        ClassRoomSearchResultController *resultVC = [[ClassRoomSearchResultController alloc] init];
        if (_searchNum == 0) {
            resultVC.searchWord = self.inputTF.text;
            resultVC.seletNum = _searchNum;
        }else if (_searchNum == 1){
            resultVC.searchWord = self.inputTF.text;
            resultVC.seletNum = _searchNum;
        }else if (_searchNum == 2){
            resultVC.searchWord = self.inputTF.text;
            resultVC.seletNum = _searchNum;
        }else{
          
        }
        [self.navigationController pushViewController:resultVC animated:YES];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //输入文字后历史记录隐藏
    self.hisTV.hidden = YES;
    return YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.hisArr && self.hisArr.count > 0) {
        return self.hisArr.count + 1 ;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if (self.hisArr && self.hisArr.count >0) {
        if (indexPath.row == self.hisArr.count) {
            
            cell.textLabel.text = @"清除历史记录";
            cell.textLabel.textColor = [UIColor grayColor];
            cell.textLabel.font=[UIFont fontWithName:@"Times New Roman" size:14];
            
        }else{
            cell.contentView.backgroundColor = [UIColor whiteColor];
            Model_HisWord * curWord = self.hisArr[indexPath.row];
            cell.textLabel.text = curWord.word;
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //清空历史记录
    if (self.hisDicArr && self.hisDicArr.count >0) {
        if (indexPath.row == self.hisDicArr.count) {
            NSString *documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
            NSString *path = [documents stringByAppendingPathComponent:@"SearchHistory.plist"];
            NSMutableDictionary * data = [[NSDictionary dictionaryWithContentsOfFile:path] mutableCopy];
            [data removeObjectForKey:@"history"];
            [self.hisDicArr removeAllObjects];
            [self.hisArr removeAllObjects];
            [data writeToFile:path atomically:YES];
            [self.hisTV reloadData];
            
        }
        else{
            reversedArray = [[self.hisDicArr reverseObjectEnumerator] allObjects];
            self.inputTF.text=reversedArray[indexPath.row][@"word"];
            self.hisTV.hidden = YES;
        }
    }
    
}
#pragma mark - 数组排序
- (void) changeArray:(NSMutableArray *)dicArray orderWithKey:(NSString *)key ascending:(BOOL)yesOrNo{
    NSSortDescriptor *distanceDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:yesOrNo];
    
    NSArray *descriptors = [NSArray arrayWithObjects:distanceDescriptor,nil];
    
    [dicArray sortUsingDescriptors:descriptors];
}

#pragma mark - 判断文件是否存在
-(BOOL)judgeFileExist:(NSString * )fileName{
    
    NSArray *storeFilePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *doucumentsDirectiory = [storeFilePath objectAtIndex:0];
    NSString *plistPath =[doucumentsDirectiory stringByAppendingPathComponent:fileName];
    //获取文件路径
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if( [fileManager fileExistsAtPath:plistPath]== NO ) {
        return NO;
    }else{
        return YES;
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    self.hisTV.hidden = YES;
}

@end
