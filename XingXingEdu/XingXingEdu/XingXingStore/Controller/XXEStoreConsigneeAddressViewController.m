


//
//  XXEStoreConsigneeAddressViewController.m
//  teacher
//
//  Created by Mac on 16/11/11.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import "XXEStoreConsigneeAddressViewController.h"
#import "XXEStoreConsigneeAddressTableViewCell.h"
#import "XXEStoreAddUserAddressViewController.h"
#import "XXEStoreAddressModel.h"


@interface XXEStoreConsigneeAddressViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_myTableView;
    
    NSMutableArray *_dataSourceArray;
    
//    NSInteger page;
    
    UIImageView *placeholderImageView;
    NSString *parameterXid;
    NSString *parameterUser_Id;
}


@end

@implementation XXEStoreConsigneeAddressViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];

    _dataSourceArray = [[NSMutableArray alloc] init];
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }

//    page = 0;
    [self fetchNetData];
    
    [_myTableView reloadData];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_myTableView.header beginRefreshing];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.title = @"收货地址";
    
    UIButton *addBtn =[HHControl createButtonWithFrame:CGRectMake(0, 0, 22, 22) backGruondImageName:@"addicon4" Target:self Action:@selector(addBtnClick:) Title:@""];
    UIBarButtonItem *addItem =[[UIBarButtonItem alloc]initWithCustomView:addBtn];
    self.navigationItem.rightBarButtonItem =addItem;
    
    //
    
    [self createTableView];
    
}



- (void)addBtnClick:(UIButton *)button{
    
    XXEStoreAddUserAddressViewController *storeAddUserAddressVC = [[XXEStoreAddUserAddressViewController alloc] init];
    

    [self.navigationController pushViewController:storeAddUserAddressVC animated:YES];
    
}

- (void)fetchNetData{
    /*
     【猩猩商城--获取购物地址】
     接口类型:1
     接口:
     http://www.xingxingedu.cn/Global/get_shopping_address
     传参:(测试xid = 18884982)*/
    
//    NSString *pageStr = [NSString stringWithFormat:@"%ld", page];
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/get_shopping_address";
    
    NSDictionary *params = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":parameterXid,
                           @"user_id":parameterUser_Id,
                           @"user_type":USER_TYPE
                           };
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
    
//        NSLog(@"UUUU %@", responseObj);
        NSString *codeStr = responseObj[@"code"];
        if ([codeStr integerValue] == 1) {
            
            NSArray *arr = [[NSArray alloc] init];
            arr = [XXEStoreAddressModel parseResondsData:responseObj[@"data"]];
            [_dataSourceArray addObjectsFromArray:arr];
            
        }
        
        [self customContent];
        
    } failure:^(NSError *error) {
        //
        [self showHudWithString:@"获取数据失败!" forSecond:1.5];
    }];
    
}


// 有数据 和 无数据 进行判断
- (void)customContent{
    // 如果 有占位图 先 移除
    [self removePlaceholderImageView];
    
    if (_dataSourceArray.count == 0) {
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        // 1、无数据的时候
        [self createPlaceholderView];
        
    }else{
        //2、有数据的时候
    }
    
    [_myTableView reloadData];
    
}


//没有 数据 时,创建 占位图
- (void)createPlaceholderView{
    // 1、无数据的时候
    UIImage *myImage = [UIImage imageNamed:@"人物"];
    CGFloat myImageWidth = myImage.size.width;
    CGFloat myImageHeight = myImage.size.height;
    
    placeholderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 2 - myImageWidth / 2, (kHeight - 64 - 49) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
    placeholderImageView.image = myImage;
    [self.view addSubview:placeholderImageView];
}

//去除 占位图
- (void)removePlaceholderImageView{
    if (placeholderImageView != nil) {
        [placeholderImageView removeFromSuperview];
    }
}



- (void)createTableView{
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 64) style:UITableViewStyleGrouped];
    
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    
    [self.view addSubview:_myTableView];
}


#pragma mark
#pragma mark - dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataSourceArray.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    XXEStoreConsigneeAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"XXEStoreConsigneeAddressTableViewCell" owner:self options:nil]lastObject];
    }
    XXEStoreAddressModel *model = _dataSourceArray[indexPath.row];
    /*
     0 :表示 自己 头像 ，需要添加 前缀
     1 :表示 第三方 头像 ，不需要 添加 前缀
     //判断是否是第三方头像
     */
    cell.nameLabel.text = model.name;
    cell.phoneLabel.text = model.phone;
    cell.addressLabel.text = [NSString stringWithFormat:@"%@ %@ %@", model.province, model.city, model.address];
    
    if (indexPath.row == 0) {
        cell.defaultAddressLabel.hidden = NO;
    }else{
        cell.defaultAddressLabel.hidden = YES;
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    XXEStoreAddressModel *model = _dataSourceArray[indexPath.row];
    if (_isBuy) {
        NSString *str = [NSString stringWithFormat:@"%@ %@ %@", model.province, model.city, model.address];
        NSMutableArray *mArray = [[NSMutableArray alloc] initWithObjects:model.name, model.phone, str,model.address_id, nil];
        self.returnArrayBlock(mArray);
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        XXEStoreAddUserAddressViewController *storeAddUserAddressVC = [[XXEStoreAddUserAddressViewController alloc] init];
        storeAddUserAddressVC.isModify = YES;
        storeAddUserAddressVC.model = model;
        if (indexPath.row == 0) {
            //是 默认收货 地址
            storeAddUserAddressVC.defaultAddress = @"1";
        }else{
            //不是 默认收货 地址
            storeAddUserAddressVC.defaultAddress = @"0";
        }
        
        [self.navigationController pushViewController:storeAddUserAddressVC animated:YES];
    
    }

}

//滑动 删除 地址
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self deleteFriend:indexPath];

    }
}


- (void)deleteFriend:(NSIndexPath *)path{
    /*
     【猩猩商城--删除购物地址】
     接口类型:2
     接口:
     http://www.xingxingedu.cn/Global/delete_shopping_address
     传参:
     address_id	//地址id
     */
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/delete_shopping_address";
    
    XXEStoreAddressModel *model = _dataSourceArray[path.row];
    
    NSString *address_id = model.address_id;
    
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
            
            [_dataSourceArray removeObjectAtIndex:path.row];
            [_myTableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
            
        }else {
            [self showHudWithString:@"删除失败!" forSecond:1.5];
        }
        
    } failure:^(NSError *error) {
        //
        [self showHudWithString:@"数据获取失败!" forSecond:1.5];
    }];
    
}


- (void)returnArrayBlock:(returnArrayBlock)block{
    self.returnArrayBlock = block;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
