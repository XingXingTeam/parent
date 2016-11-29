//
//  KTPicterViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/5/19.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define KPATA @"KTPicterCell"
#import "KTPicterViewController.h"
#import "KTPicterCell.h"
@interface KTPicterViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
//    NSMutableArray *dataArray;
    NSMutableArray *idArray;
    NSMutableArray *timeArray;
    NSMutableArray *imageArray;
    NSString *parameterXid;
    NSString *parameterUser_Id;

}

@property (nonatomic, copy) NSString *collectionId;

@end

@implementation KTPicterViewController

- (void)viewWillAppear:(BOOL)animated{

//    [_tableView reloadData];

}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    [_tableView.header beginRefreshing];

}

- (void)viewDidDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColorFromRGB(158,235, 199);

    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
//    [self createDate];
    
    
    [self createTableView];
    
}

//- (void)createDate{
//
//    imageArr =[[NSMutableArray alloc]initWithObjects:@"猩猩教室",@"猩猩",@"猩猩教室",@"猩猩",@"猩猩教室",@"猩猩",nil];
//}

- (void)createTableView{
    
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 64 - 15) style:UITableViewStyleGrouped];
    _tableView.dataSource =self;
    _tableView.delegate =self;
    [self.view addSubview:_tableView];

    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
}

- (void)loadNewData{

    [self fetchNetData];
    
    [_tableView.header endRefreshing];

}

- (void)endRefresh{

    [_tableView.header endRefreshing];

}


- (void)fetchNetData{

    /*
     【我的收藏---图片】
     
     接口:
     http://www.xingxingedu.cn/Global/col_pic_list
     
     传参:
     */

    NSString *urlStr = @"http://www.xingxingedu.cn/Global/col_pic_list";
    
    //请求参数  无
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE};

    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        
        idArray = [[NSMutableArray alloc] init];
        timeArray = [[NSMutableArray alloc] init];
        imageArray = [[NSMutableArray alloc] init];
        
        //
//        NSLog(@"gggg%@", responseObj);
        
        /*
         {
         id = 1,
         pic = app_upload/text/class/class_c1.jpg,
         date_tm = 1465979319
         }
         */
        
        NSArray *dataSource = responseObj[@"data"];
        
        NSString *codeStr = [NSString stringWithFormat:@"%@", responseObj[@"code"]];
        
        if ([codeStr isEqualToString:@"1"]) {
            
            for (NSDictionary *dic in dataSource) {
                [idArray addObject:dic[@"id"]];
                
                NSString *picStr = [NSString stringWithFormat:@"%@%@",picURL, dic[@"pic"]];
                
                [imageArray addObject:picStr];
                
                NSString *timeStr = [WZYTool dateStringFromNumberTimer:dic[@"date_tm"]];
                [timeArray addObject:timeStr];
                
            }
            
        }else{
        
        
        }
        
        [self customContent];
        
    } failure:^(NSError *error) {
        //
        
        NSLog(@"%@", error);
    }];
    

}

// 有数据 和 无数据 进行判断
- (void)customContent{
    
    if (imageArray.count == 0) {
        // 1、无数据的时候
        UIImage *myImage = [UIImage imageNamed:@"人物"];
        CGFloat myImageWidth = myImage.size.width;
        CGFloat myImageHeight = myImage.size.height;
        
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 2 - myImageWidth / 2, (kHeight - 64 - 49) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
        myImageView.image = myImage;
        [self.view addSubview:myImageView];
        
    }else{
        //2、有数据的时候
        [_tableView reloadData];
        
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return idArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 250;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KTPicterCell *cell =(KTPicterCell*)[tableView dequeueReusableCellWithIdentifier:KPATA];
    if (!cell) {
        NSArray *nib =[[NSBundle mainBundle]loadNibNamed:KPATA owner:[KTPicterCell class] options:nil];
        cell =(KTPicterCell*)[nib objectAtIndex:0];
        // cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    }
    
   
  [cell.bgImagV sd_setImageWithURL:[NSURL URLWithString:imageArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"Placeholder-figure"]];

    cell.timeLbl.text = timeArray[indexPath.row];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickUserImage:)];
    [cell.contentView addGestureRecognizer:tap];
    
    
    //添加 长按 取消 收藏 手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressClick:)];
    
    [cell.contentView addGestureRecognizer:longPress];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"选中 某一行");
    
}

- (void)onClickUserImage:(UITapGestureRecognizer *)tap{

    NSLog(@"单击 图片");

}


- (void)longPressClick:(UILongPressGestureRecognizer *)longPress{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"取消收藏" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *doneAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        KTPicterCell *cell = (KTPicterCell *)[longPress.view superview];
        
        NSIndexPath *path = [_tableView indexPathForCell:cell];
        
        _collectionId = idArray[path.row];
        
        [self cancelCollection];
        
        [_tableView.header beginRefreshing];
        
        [SVProgressHUD showSuccessWithStatus:@"取消收藏成功"];
        
    }];
    
    
    [alertController addAction:cancelAction];
    [alertController addAction:doneAction];
    
    [self presentViewController:alertController animated:YES completion:nil];

}

- (void)cancelCollection{
    
    /*
     接口:
     http://www.xingxingedu.cn/Global/deleteCollect
     
     传参:
     collect_id	//收藏id (如果是收藏用户,这里是xid)
     collect_type	//收藏品种类型	1:商品  2:点评  3:用户  4:课程  5:学校  6:花朵  7、图片
     */
    
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/deleteCollect";
    
    //请求参数
    
    NSLog(@"ppppppp%@", _collectionId);
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"collect_id":_collectionId, @"collect_type":@"7"};
    
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        
        //        NSLog(@"yyyyy%@", responseObj);
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
    }];
    
    
}



@end
