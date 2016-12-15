

//
//  XXEStoreAddUserAddressViewController.m
//  teacher
//
//  Created by Mac on 16/11/14.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEStoreAddUserAddressViewController.h"
#import "LMContainsLMComboxScrollView.h"

#import "LMComBoxView.h"


#define Kmarg 8.0f
#define KLabelX 20.0f
#define KLabelW 65.0f
#define KLabelH 20.0f
#define kUnderButtonH 64.0f
#define kDropDownListTag 1000



@interface XXEStoreAddUserAddressViewController ()<UIAlertViewDelegate, LMComBoxViewDelegate, UITextFieldDelegate>
{
    LMContainsLMComboxScrollView *bgScrollView;
    NSMutableDictionary *addressDict;   //地址选择字典
    NSDictionary *areaDic;
    NSArray *province;
    NSArray *city;
    NSArray *district;
    
    NSString *selectedProvince;
    NSString *selectedCity;
    NSString *selectedArea;
    
    UITextField *nameText;//名称
    UITextField *phoneText;//电话
    UITextField *addressText;//详细地址
    UITextField *mailText;//邮编
    UIButton * saveBtn;//保存按钮
    UIButton * defaultBtn;//设为默认按钮
    UIButton * removeBtn;//删除按钮

    UIView *view5;
    UIView *_view3;
    //所在地区
    UILabel *_areaLabel;
    
    NSString *parameterXid;
    NSString *parameterUser_Id;
}


@end

@implementation XXEStoreAddUserAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }

    
    [self creatFieldset];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [view5 addGestureRecognizer:singleTap];
    
    if (_isModify) {
        self.title = @"设置地址";
        
        //赋值
        [self showUserAddressInfo];
        
        removeBtn.hidden = NO;
        
    }else{
        [self resolveCity];
        self.title = @"添加新地址";
        removeBtn.hidden = YES;
    }
    
    
//    NSLog(@"_defaultAddress === %@", _defaultAddress);
    
    
}

//展示 地址
- (void)showUserAddressInfo{
    //名称
    nameText.text = _model.name;
    //电话
    phoneText.text = _model.phone;
    //邮编
    mailText.text = _model.zip_code;
    
    CGFloat labelW = (KScreenWidth - 120 * kScreenRatioWidth)/3;
    CGFloat labelH = 20;
    
    //省
    //CGRectMake(85+(90+3)*i, 150, (kWidth - 85) / 3, 28)
    UILabel *provinceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_areaLabel.frame.origin.x + _areaLabel.width + 5 +labelW*0, _areaLabel.frame.origin.y, labelW, labelH)];
    provinceLabel.text = [NSString stringWithFormat:@"省:%@",_model.province];
    provinceLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    [bgScrollView addSubview:provinceLabel];

    
    //市
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(_areaLabel.frame.origin.x + _areaLabel.width + 5 +labelW*1, _areaLabel.frame.origin.y, labelW, labelH)];
    cityLabel.text = [NSString stringWithFormat:@"市:%@",_model.city];
    cityLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    [bgScrollView addSubview:cityLabel];

    //区
    UILabel *areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(_areaLabel.frame.origin.x + _areaLabel.width + 5+labelW*2, _areaLabel.frame.origin.y, labelW, labelH)];
    areaLabel.text = [NSString stringWithFormat:@"区:%@",_model.district];
    areaLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    [bgScrollView addSubview:areaLabel];
    
    addressText.text = _model.address;
    
}



-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer

{
    [self.view endEditing:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [bgScrollView endEditing:YES];
}

-(void)creatFieldset{
    bgScrollView = [[LMContainsLMComboxScrollView alloc]initWithFrame:CGRectMake(0, 0, WinWidth, WinHeight - 64)];
    bgScrollView.backgroundColor = [UIColor whiteColor];
    bgScrollView.showsVerticalScrollIndicator = NO;
    bgScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:bgScrollView];
    
    
    //收货人姓名
    UILabel * consignee = [HHControl createLabelWithFrame:CGRectMake(KLabelX, Kmarg, KLabelW, KLabelH) Font:14 Text:@"收货人:"];
    consignee.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    [bgScrollView addSubview:consignee];
    
    nameText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(consignee.frame) + Kmarg, Kmarg, kWidth - CGRectGetMaxX(consignee.frame) - KLabelX *2, KLabelH)];
    nameText.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    nameText.delegate = self;
    [nameText addTarget:self action:@selector(nameTextFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    
    [bgScrollView addSubview:nameText];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(consignee.frame) + Kmarg, kWidth, 1)];
    view1.backgroundColor=UIColorFromRGB(193, 193, 193);
    [bgScrollView addSubview:view1];
    
    //电话
    UILabel *phoneTitleLabel = [HHControl createLabelWithFrame:CGRectMake(KLabelX, CGRectGetMaxY(view1.frame) + Kmarg , KLabelW, KLabelH) Font:14 Text:@"联系电话:"];
    phoneTitleLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    [bgScrollView addSubview:phoneTitleLabel];
    
    phoneText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(consignee.frame) + Kmarg, CGRectGetMaxY(view1.frame) + Kmarg, kWidth - CGRectGetMaxX(consignee.frame) - KLabelX *2, KLabelH)];
    phoneText.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    phoneText.delegate = self;
    phoneText.keyboardType=UIKeyboardTypeNumberPad;
    [nameText addTarget:self action:@selector(phoneTextFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [bgScrollView addSubview:phoneText];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(phoneText.frame) + Kmarg, kWidth, 1)];
    
    view2.backgroundColor=UIColorFromRGB(193, 193, 193);
    [bgScrollView addSubview:view2];
    
    //邮政编码
    UILabel *codeLabel = [HHControl createLabelWithFrame:CGRectMake(KLabelX, CGRectGetMaxY(view2.frame) + Kmarg, KLabelW, KLabelH) Font:14 Text:@"邮政编码:"];
    codeLabel.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    [bgScrollView addSubview:codeLabel];
    
    
    mailText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(consignee.frame) + Kmarg, CGRectGetMaxY(view2.frame) + Kmarg, kWidth - CGRectGetMaxX(consignee.frame) - KLabelX *2, KLabelH)];
    mailText.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    mailText.keyboardType=UIKeyboardTypeNumberPad;
    [bgScrollView addSubview:mailText];
    
    _view3 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(mailText.frame) + Kmarg, kWidth, 1)];
    _view3.backgroundColor=UIColorFromRGB(193, 193, 193);
    [bgScrollView addSubview:_view3];
    
    //所在地区
    _areaLabel =  [HHControl createLabelWithFrame:CGRectMake(KLabelX, CGRectGetMaxY(_view3.frame) + Kmarg, KLabelW, KLabelH) Font:14 * kScreenRatioWidth Text:@"所在地区:"];

    [bgScrollView addSubview:_areaLabel];
    
    UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_areaLabel.frame) + Kmarg, kWidth, 1)];
    
    view4.backgroundColor=UIColorFromRGB(193, 193, 193);
    [bgScrollView addSubview:view4];
    
    //详细地址
    UILabel *addressLabel = [HHControl createLabelWithFrame:CGRectMake(KLabelX, CGRectGetMaxY(view4.frame) + Kmarg, KLabelW, KLabelH) Font:14 * kScreenRatioWidth Text:@"详细地址:"];
        [bgScrollView addSubview:addressLabel];
    
    
    addressText = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(consignee.frame) + Kmarg, CGRectGetMaxY(view4.frame) + Kmarg, kWidth - CGRectGetMaxX(consignee.frame) - KLabelX *2, KLabelH)];
    addressText.font = [UIFont systemFontOfSize:14 * kScreenRatioWidth];
    [bgScrollView addSubview:addressText];
    
    view5 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(addressText.frame) + Kmarg, kWidth, kHeight - CGRectGetMaxY(addressText.frame))];
    view5.backgroundColor=UIColorFromRGB(229, 232, 233);
    [bgScrollView addSubview:view5];
    
    UIView *view6 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(addressText.frame) + Kmarg, kWidth, 1)];
    view6.backgroundColor=UIColorFromRGB(193, 193, 193);
    [bgScrollView addSubview:view6];
    
    //保存地址
    CGFloat buttonX = (KScreenWidth - 325 * kScreenRatioWidth) / 2;
    CGFloat buttonW = 325 * kScreenRatioWidth;
    CGFloat buttonH = 42 * kScreenRatioHeight;
    
    saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.frame = CGRectMake(buttonX, CGRectGetMaxY(view6.frame) + KLabelX *2, buttonW, buttonH);
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"按钮big650x84"] forState:UIControlStateNormal];
    [saveBtn setTitle:@"保存地址" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if (_isModify == YES) {
        //修改  后 的保存
        saveBtn.hidden = YES;
//        [saveBtn addTarget:self action:@selector(modifySaveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        //新增 地址 的保存
        [saveBtn addTarget:self action:@selector(addNewAddressSaveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    [bgScrollView addSubview:saveBtn];
    

    //设为默认
    defaultBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    defaultBtn.frame = CGRectMake(buttonX, CGRectGetMaxY(saveBtn.frame) + KLabelX, buttonW, buttonH);
    [defaultBtn setBackgroundImage:[UIImage imageNamed:@"按钮big650x84"] forState:UIControlStateNormal];
    //如果是 修改 已有 地址
    if (_isModify == YES) {
        if ([_defaultAddress integerValue] == 1) {
            //是 默认 地址
            [defaultBtn setTitle:@"已默认" forState:UIControlStateNormal];
            defaultBtn.enabled = NO;
            
        }else if ([_defaultAddress integerValue] == 0){
            //不是 默认 地址
            [defaultBtn setTitle:@"设为默认" forState:UIControlStateNormal];
            defaultBtn.enabled = YES;
            [defaultBtn addTarget:self action:@selector(defaultBtnClick) forControlEvents:UIControlEventTouchUpInside];
        }
    }else{
        
        //新增 地址 ,且设为 默认地址
        [defaultBtn setTitle:@"设为默认" forState:UIControlStateNormal];
        defaultBtn.enabled = YES;
        [defaultBtn addTarget:self action:@selector(setNewAddressDefaultBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }

    [defaultBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bgScrollView addSubview:defaultBtn];

    
    //删除地址
    removeBtn = [HHControl createButtonWithFrame:CGRectMake(buttonX, CGRectGetMaxY(defaultBtn.frame) + KLabelX, buttonW, buttonH) backGruondImageName:@"按钮big650x84" Target:nil Action:@selector(removeBtnClick) Title:nil];
    [removeBtn setTitle:@"删除地址" forState:UIControlStateNormal];
    [removeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bgScrollView addSubview:removeBtn];
}

#pragma mark ====== textField  方法 =======
//姓名
- (void) nameTextFieldTextChange:(UITextField *)textField{
    if (textField == nameText) {
        
        NSLog(@"nameText.text.length == %lu", nameText.text.length);
        
        if (nameText.text.length > 15) {
            [self showHudWithString:@"最多可输入15个字符"];
            nameText.text = [nameText.text substringToIndex:15];
        }
    }
    
}

//电话
- (void)phoneTextFieldTextChange:(UITextField *)textField{

    if (textField == phoneText) {
        
        NSLog(@"phoneText.text.length == %lu", phoneText.text.length);
        
        if (phoneText.text.length >= 11) {
            [self showString:@"请输入11位手机号码" forSecond:1.5];
            
        }else{
        
        //判断是否是电话号
            if ([self isChinaMobile:phoneText.text] == NO) {
                [self showString:@"请输入11位手机号码" forSecond:1.5];
            }else{
                phoneText.text = @"";
            }
        }
    }

}

#pragma mark ======= 判断 是否 是 手机号码 ==============
- (BOOL)isChinaMobile:(NSString *)phoneNum{
    BOOL isChinaMobile = NO;
    
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    if([regextestcm evaluateWithObject:phoneNum] == YES){
        isChinaMobile = YES;
        //        NSLog(@"中国移动");
    }
    
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    if([regextestcu evaluateWithObject:phoneNum] == YES){
        isChinaMobile = YES;
        //        NSLog(@"中国联通");
    }
    
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if([regextestct evaluateWithObject:phoneNum] == YES){
        isChinaMobile = YES;
        //        NSLog(@"中国电信");
    }
    return isChinaMobile;
}



#pragma mark ---------- 新增 地址 的保存 且不设为默认地址----------
- (void)addNewAddressSaveButtonClick:(UIButton *)button{

    if (_defaultAddress == nil) {
        //设置默认地址,可以传值0或者1, 1代表设为默认
        [self addAddress:@"0"];
    }
}

#pragma mark ========== 新增 地址 且 设为 默认地址 ==========
- (void)setNewAddressDefaultBtnClick:(UIButton *)button{

    if (_defaultAddress == nil) {
        //设置默认地址,可以传值0或者1, 1代表设为默认
        [self addAddress:@"1"];
    }
}




#pragma mark ============= 保存用户地址 ===============
- (void)addAddress:(NSString *)defaultAddress
{
    
    if ([selectedProvince isEqualToString:@""]) {
        [self showString:@"请完善省" forSecond:1.5];
    }else if ([selectedCity isEqualToString:@""]){
        [self showString:@"请完善市" forSecond:1.5];
    }else if ([selectedArea isEqualToString:@""]){
        [self showString:@"请完善区" forSecond:1.5];
    }else if ([addressText.text isEqualToString:@""]){
        [self showString:@"请完善详细地址" forSecond:1.5];
    }else if([nameText.text isEqualToString:@""]){
        [self showString:@"请完善姓名" forSecond:1.5];
    }else if ([phoneText.text isEqualToString:@""]){
        [self showString:@"请完善电话" forSecond:1.5];
    }else if([self isChinaMobile:phoneText.text] == NO){
        [self showString:@"请输入正确的电话号码" forSecond:1.5];
    }else if ([mailText.text isEqualToString:@""]){
        [self showString:@"请完善邮编" forSecond:1.5];
    }else{
    
        NSString *urlStr = @"http://www.xingxingedu.cn/Global/add_shopping_address";
        //    NSLog(@"selectedProvince === %@", selectedProvince);
        
        NSDictionary *params = @{@"appkey":APPKEY,
                                 @"backtype":BACKTYPE,
                                 @"xid":parameterXid,
                                 @"user_id":parameterUser_Id,
                                 @"user_type":USER_TYPE,
                                 @"province":selectedProvince,
                                 @"city":selectedCity,
                                 @"district":selectedArea,
                                 @"address":addressText.text,
                                 @"name":nameText.text,
                                 @"phone":phoneText.text,
                                 @"zip_code":mailText.text,
                                 @"selected":defaultAddress,
                                 };
//        NSLog(@"params == %@",params);
        
        [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
            
//            NSLog(@"结果===== %@", responseObj);
            
            if ([responseObj[@"code"] integerValue] == 1) {
                
                [self showString:@"添加成功" forSecond:1.5];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
            
            
        } failure:^(NSError *error) {
            //
            [self showString:@"网络不通,请检查网络" forSecond:1.5];
        }];

    }
    
 }
//解析全国省市区信息
-(void)resolveCity{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    areaDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *components = [areaDic allKeys];
    NSArray *sortedArray = [components sortedArrayUsingComparator: ^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    NSMutableArray *provinceTmp = [NSMutableArray array];
    for (int i=0; i<[sortedArray count]; i++) {
        NSString *index = [sortedArray objectAtIndex:i];
        NSArray *tmp = [[areaDic objectForKey: index] allKeys];
        [provinceTmp addObject: [tmp objectAtIndex:0]];
    }
    
    province = [NSArray arrayWithArray:provinceTmp];
    
//    NSLog(@"mmmm %@", province);
    
    NSString *index = [sortedArray objectAtIndex:0];
    NSString *selected = [province objectAtIndex:0];
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [[areaDic objectForKey:index]objectForKey:selected]];
    
    NSArray *cityArray = [dic allKeys];
    NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [cityArray objectAtIndex:0]]];
    city = [NSArray arrayWithArray:[cityDic allKeys]];
    
    selectedCity = [city objectAtIndex:0];
    district = [NSArray arrayWithArray:[cityDic objectForKey:selectedCity]];
    
    addressDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                   province,@"province",
                   city,@"city",
                   district,@"area",nil];
    
    selectedProvince = [province objectAtIndex:0];
    selectedArea = [district objectAtIndex:0];
    
    [self setUpBgScrollView];
}

-(void)setUpBgScrollView
{
    
    NSArray *keys = [NSArray arrayWithObjects:@"province",@"city",@"area", nil];
    for(NSInteger i=0;i<3;i++)
    {
        CGFloat comboxW = (KScreenWidth - 120 * kScreenRatioWidth)/3;
        CGFloat comboxH = 20;
        
        LMComBoxView *comBox = [[LMComBoxView alloc]initWithFrame:CGRectMake(_areaLabel.frame.origin.x + _areaLabel.width + 5 +comboxW*i, _areaLabel.frame.origin.y, comboxW, comboxH)];
        comBox.backgroundColor = [UIColor whiteColor];
        comBox.arrowImgName = @"down_dark0.png";
        
        NSMutableArray *itemsArray = [NSMutableArray arrayWithArray:[addressDict objectForKey:[keys objectAtIndex:i]]];
        comBox.titlesList = itemsArray;
        
        comBox.delegate = self;
        comBox.supView = bgScrollView;
        [comBox defaultSettings];
        comBox.tag = kDropDownListTag + i;
        [bgScrollView addSubview:comBox];
    }
}

#pragma mark -LMComBoxViewDelegate
-(void)selectAtIndex:(int)index inCombox:(LMComBoxView *)_combox
{
    NSInteger tag = _combox.tag - kDropDownListTag;
    switch (tag) {
        case 0:
        {
            selectedProvince =  [[addressDict objectForKey:@"province"]objectAtIndex:index];
            //字典操作
            NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: [NSString stringWithFormat:@"%d", index]]];
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
            NSArray *cityArray = [dic allKeys];
            NSArray *sortedArray = [cityArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
                
                if ([obj1 integerValue] > [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedDescending;//递减
                }
                
                if ([obj1 integerValue] < [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedAscending;//上升
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (int i=0; i<[sortedArray count]; i++) {
                NSString *index = [sortedArray objectAtIndex:i];
                NSArray *temp = [[dic objectForKey: index] allKeys];
                [array addObject: [temp objectAtIndex:0]];
            }
            city = [NSArray arrayWithArray:array];
            
            NSDictionary *cityDic = [dic objectForKey: [sortedArray objectAtIndex: 0]];
            district = [NSArray arrayWithArray:[cityDic objectForKey:[city objectAtIndex:0]]];
            //刷新市、区
            addressDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                           province,@"province",
                           city,@"city",
                           district,@"area",nil];
            LMComBoxView *cityCombox = (LMComBoxView *)[bgScrollView viewWithTag:tag + 1 + kDropDownListTag];
            cityCombox.titlesList = [NSMutableArray arrayWithArray:[addressDict objectForKey:@"city"]];
            [cityCombox reloadData];
            LMComBoxView *areaCombox = (LMComBoxView *)[bgScrollView viewWithTag:tag + 2 + kDropDownListTag];
            areaCombox.titlesList = [NSMutableArray arrayWithArray:[addressDict objectForKey:@"area"]];
            [areaCombox reloadData];
            
            selectedCity = [city objectAtIndex:0];
            selectedArea = [district objectAtIndex:0];
            break;
        }
        case 1:
        {
            selectedCity = [[addressDict objectForKey:@"city"]objectAtIndex:index];
            
            NSString *provinceIndex = [NSString stringWithFormat: @"%li", (unsigned long)[province indexOfObject: selectedProvince]];
            NSDictionary *tmp = [NSDictionary dictionaryWithDictionary: [areaDic objectForKey: provinceIndex]];
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary: [tmp objectForKey: selectedProvince]];
            NSArray *dicKeyArray = [dic allKeys];
            NSArray *sortedArray = [dicKeyArray sortedArrayUsingComparator: ^(id obj1, id obj2) {
                
                if ([obj1 integerValue] > [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                
                if ([obj1 integerValue] < [obj2 integerValue]) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
                return (NSComparisonResult)NSOrderedSame;
            }];
            
            NSDictionary *cityDic = [NSDictionary dictionaryWithDictionary: [dic objectForKey: [sortedArray objectAtIndex: index]]];
            NSArray *cityKeyArray = [cityDic allKeys];
            district = [NSArray arrayWithArray:[cityDic objectForKey:[cityKeyArray objectAtIndex:0]]];
            //刷新区
            addressDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                           province,@"province",
                           city,@"city",
                           district,@"area",nil];
            LMComBoxView *areaCombox = (LMComBoxView *)[bgScrollView viewWithTag:tag + 1 + kDropDownListTag];
            areaCombox.titlesList = [NSMutableArray arrayWithArray:[addressDict objectForKey:@"area"]];
            [areaCombox reloadData];
            
            selectedArea = [district objectAtIndex:0];
            break;
        }
        case 2:
        {
            selectedArea = [[addressDict objectForKey:@"area"]objectAtIndex:index];
            break;
        }
        default:
            break;
    }
    
}

-(void)saveBtn:(NSString *)newAddressFlagStr{
    if ([nameText.text isEqualToString:@""])
    {
        [self showString:@"亲,请输入您的姓名" forSecond:1.5];
        return;
    }
    else if (phoneText.text.length !=11)
    {
        [self showString:@"亲,请输入您正确的手机号" forSecond:1.5];
        return;
    }else if([self isChinaMobile:phoneText.text] == NO){
        [self showString:@"请输入正确的电话号码" forSecond:1.5];
    }
    else if (mailText.text.length !=6)
    {
        [self showString:@"亲,请输入您正确的邮编" forSecond:1.5];
        return;
    }
    else if ([addressText.text isEqualToString:@""])
    {
        [self showString:@"亲,请输入您的详细地址" forSecond:1.5];
        return;
    }
    
    
    if (_defaultAddress == nil) {
        //新增 地址
        //新增 地址 直接 保存 ,没有设为 默认,故_defaultAddress = @"0";
        _defaultAddress = @"0";
        
    }
    [self addAddress: _defaultAddress];

}


-(void)defaultBtnClick{
    
    if ([nameText.text isEqualToString:@""])
    {
        [self showString:@"亲,请输入您的姓名" forSecond:1.5];
        return;
    }
    else if (phoneText.text.length !=11)
    {
        [self showString:@"亲,请输入您正确的手机号" forSecond:1.5];
        return;
    }else if([self isChinaMobile:phoneText.text] == NO){
        [self showString:@"请输入正确的电话号码" forSecond:1.5];
    }
    else if (mailText.text.length !=6)
    {
        [self showString:@"亲,请输入您正确的邮编" forSecond:1.5];
        return;
    }
    else if ([addressText.text isEqualToString:@""])
    {
        [self showString:@"亲,请输入您的详细地址" forSecond:1.5];
        return;
    }
    
    if ([_defaultAddress isEqualToString:@"0"]) {
        _defaultAddress=@"1";
        [defaultBtn setTitle:@"已默认" forState:UIControlStateNormal];
//        [self settingDefaultAddress];
    }
    else if([_defaultAddress isEqualToString:@"1"]){
        _defaultAddress=@"0";
        [defaultBtn setTitle:@"设为默认" forState:UIControlStateNormal];
        
    }
    
    [self settingDefaultAddress];
    
}

#pragma mark ============= 设置默认地址 ===============
- (void)settingDefaultAddress{
/*
 【猩猩商城--选择默认地址】
 接口类型:2
 接口:
 http://www.xingxingedu.cn/Global/set_default_shopping_address
 传参:(测试xid = 18884982)
	address_id	//购物地址id
 */
  
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/set_default_shopping_address";
    
    NSString *address_id = _model.address_id;
    
    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE,
                             @"address_id":address_id
                             };
[WZYHttpTool post:urlStr params:params success:^(id responseObj) {
    //
//    NSLog(@"nnn%@", responseObj);
    
    if ([responseObj[@"code"]  integerValue] == 1) {
        [self showString:@"设置成功!" forSecond:1.5];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }
    
} failure:^(NSError *error) {
    //
    [self showString:@"获取数据失败!" forSecond:1.5];
}];
    
    

}

#pragma mark ========== 删除用户地址 ================
- (void)removeBtnClick{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"删除地址" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
    }else if(buttonIndex == 1){
    
        [self removeUserAddressInfo];
    }

}

- (void)removeUserAddressInfo{
    /*
     【猩猩商城--删除购物地址】
     接口类型:2
     接口:
     http://www.xingxingedu.cn/Global/delete_shopping_address
     传参:
     address_id	//地址id
     */
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/delete_shopping_address";
    
    NSString *address_id = _model.address_id;
    
    NSDictionary *params = @{@"appkey":APPKEY,
                             @"backtype":BACKTYPE,
                             @"xid":parameterXid,
                             @"user_id":parameterUser_Id,
                             @"user_type":USER_TYPE,
                             @"address_id":address_id
                             };
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        //
        //        NSLog(@"删除 地址 %@", responseObj);
        
        if ([responseObj[@"code"] integerValue] == 1) {
            [self showHudWithString:@"删除成功!" forSecond:1.5];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else {
            [self showHudWithString:@"删除失败!" forSecond:1.5];
        }
        
    } failure:^(NSError *error) {
        //
        [self showHudWithString:@"数据获取失败!" forSecond:1.5];
    }];

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
