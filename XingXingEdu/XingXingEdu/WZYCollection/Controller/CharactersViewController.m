//
//  CharactersViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/5/19.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define KPATA @"SunDerTableViewCell"
#import "CharactersViewController.h"
#import "CheractersNextViewController.h"
#import "SunDerTableViewCell.h"
#import "detailedViewController.h"
#import "LandingpageViewController.h"

@interface CharactersViewController ()<UITableViewDataSource,UITableViewDelegate, UIAlertViewDelegate>
{
UITableView *_tableView;
NSMutableArray *dataArray;
   NSMutableArray *idArray;
    NSMutableArray *baby_idArray;
    NSMutableArray *school_typeArray;
    NSMutableArray *class_nameArray;
    NSMutableArray *positionArray;
    NSMutableArray *school_idArray;
    NSMutableArray *school_nameArray;
    NSMutableArray *tnameArray;
    NSMutableArray *head_imgArray;
    NSMutableArray *date_tmArray;
    NSMutableArray *picArray;
    NSMutableArray *numArray;
    NSMutableArray *conArray;
    NSMutableArray *class_idArray;
    NSMutableArray *teach_courseArray;
    NSMutableArray *tidArray;
    NSString *parameterXid;
    NSString *parameterUser_Id;
}

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *collectionId;


@end

@implementation CharactersViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initArray];
    
//    [_tableView reloadData];

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [_tableView.header beginRefreshing];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
}


- (void)initArray{
    idArray = [[NSMutableArray alloc] init];
    
    baby_idArray = [[NSMutableArray alloc] init];
    school_typeArray = [[NSMutableArray alloc] init];
    class_nameArray = [[NSMutableArray alloc] init];
    positionArray = [[NSMutableArray alloc] init];
    school_idArray = [[NSMutableArray alloc] init];
    school_nameArray = [[NSMutableArray alloc] init];
    tnameArray = [[NSMutableArray alloc] init];
    head_imgArray = [[NSMutableArray alloc] init];
    date_tmArray = [[NSMutableArray alloc] init];
    picArray = [[NSMutableArray alloc] init];
    numArray = [[NSMutableArray alloc] init];
    conArray = [[NSMutableArray alloc] init];
    class_idArray = [[NSMutableArray alloc] init];
    teach_courseArray = [[NSMutableArray alloc] init];
    tidArray = [[NSMutableArray alloc] init];


}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(158,235, 199);
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }
    
    [self createTableView];
    
}


- (void)createTableView{
    
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight - 64 - 15) style:UITableViewStyleGrouped];
    _tableView.dataSource =self;
    _tableView.delegate =self;

    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    [self.view addSubview:_tableView];

}



-(void)loadNewData{
    [self fetchNetData];
    [ _tableView.header endRefreshing];
}
-(void)endRefresh{
    [_tableView.header endRefreshing];
    //    [self.tableView.footer endRefreshing];
}

- (void)fetchNetData{
    /*
     接口:
     http://www.xingxingedu.cn/Global/col_flower_list  */
    
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/col_flower_list";
    
    //请求参数  无
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE};
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        
//        NSLog(@"---  %@", responseObj);

        if([[NSString stringWithFormat:@"%@",responseObj[@"code"]]isEqualToString:@"1"] ){
            NSDictionary *dict = responseObj[@"data"];
            NSArray * flowerArr = [NSArray arrayWithArray:dict[@"list"]];
            for (NSDictionary *dic in flowerArr) {
                [idArray addObject:dic[@"id"]];
                
                [baby_idArray addObject:dic[@"baby_id"]];
                [school_typeArray addObject:dic[@"school_type"]];
                [class_nameArray addObject:dic[@"class_name"]];
                [positionArray addObject:dic[@"position"]];
                [school_idArray addObject:dic[@"school_id"]];
                [school_nameArray addObject:dic[@"school_name"]];
                [tnameArray addObject:dic[@"tname"]];
                
                //小红花 里面 的图片 (可多张,用逗号拼接 )
                [picArray addObject:dic[@"pic"]];

                NSString *dateStr = [WZYTool dateStringFromNumberTimer:dic[@"date_tm"]];
                [date_tmArray addObject:dateStr];
                NSString * head_img;
                if([[NSString stringWithFormat:@"%@",dic[@"head_img_type"]]isEqualToString:@"0"]){
                    head_img=[picURL stringByAppendingString:dic[@"head_img"]];
                }else{
                    head_img=dic[@"head_img"];
                }
                
                [head_imgArray addObject:head_img];
                
                [numArray addObject:dic[@"num"]];
                [conArray addObject:dic[@"con"]];
                [class_idArray addObject:dic[@"class_id"]];
                [teach_courseArray addObject:dic[@"teach_course"]];
                [tidArray addObject:dic[@"tid"]];
              
            }
        }
        
        [self customContent];
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
    }];
    
}

// 有数据 和 无数据 进行判断
- (void)customContent{
    
    if (head_imgArray.count == 0) {
        
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
    
    return head_imgArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SunDerTableViewCell *cell =(SunDerTableViewCell*)[tableView dequeueReusableCellWithIdentifier:KPATA];
    if (cell == nil) {
        NSArray *nib =[[NSBundle mainBundle] loadNibNamed:KPATA owner:[SunDerTableViewCell class] options:nil];
        cell =(SunDerTableViewCell *)[nib objectAtIndex:0];
    }

    [cell.Rphone sd_setImageWithURL:[NSURL URLWithString:head_imgArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"人物头像172x172"]];
    
    cell.TLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",tnameArray[indexPath.row],teach_courseArray[indexPath.row],school_nameArray[indexPath.row],class_nameArray[indexPath.row]];

    cell.TimeLabel.text =[NSString stringWithFormat:@"%@",date_tmArray[indexPath.row]];

    cell.reasonLabel.text = [NSString stringWithFormat:@"赠言: %@",conArray[indexPath.row]];

    cell.saveBtn.hidden = YES;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressClick:)];
    [cell.contentView addGestureRecognizer:longPress];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([XXEUserInfo user].login) {
        detailedViewController *detailVC =[[detailedViewController alloc]init];
        detailVC.name =tnameArray[indexPath.row];
        detailVC.time = date_tmArray[indexPath.row];
        detailVC.schoolName =school_nameArray[indexPath.row];
        detailVC.className =class_nameArray[indexPath.row];
        detailVC.couseName =teach_courseArray[indexPath.row];
        detailVC.text =conArray[indexPath.row];
        detailVC.imageName =head_imgArray[indexPath.row];
        detailVC.imageStr =picArray[indexPath.row];
        detailVC.idKT =idArray[indexPath.row];
        [self.navigationController pushViewController:detailVC animated:YES];
   
    }else{
        [SVProgressHUD showInfoWithStatus:@"请用账号登录后查看"];
    }

}

#pragma 取消收藏 代理方法
- (void)longPressClick:(UILongPressGestureRecognizer *)longPress{

    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"取消收藏？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
#pragma mark - 取消收藏=================================================
        SunDerTableViewCell *cell = (SunDerTableViewCell *)[longPress.view superview];
       
        NSIndexPath *path = [_tableView indexPathForCell:cell];
        
//        [dataArray removeObjectAtIndex:path.row];
        
        _collectionId = idArray[path.row];
        
//        NSLog(@"gggggg%@", _collectionId);
        
        [self cancelCollection];
        
        
        [_tableView.header beginRefreshing];
        
        [SVProgressHUD showSuccessWithStatus:@"取消收藏成功"];

    }];
    [alertController addAction:ok];
    [alertController addAction:cancel];
    [self presentViewController:alertController animated:YES completion:nil];

}

- (void)cancelCollection{

    /*
     接口:
     http://www.xingxingedu.cn/Global/deleteCollect
     传参:
     collect_id	//收藏id (如果是收藏用户,这里是xid)
     collect_type	//收藏品种类型	1:商品  2:点评  3:用户  4:课程  5:学校  6:花朵
     */
    
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/deleteCollect";
    
    //请求参数
    
    NSDictionary *params = @{@"appkey":APPKEY, @"backtype":BACKTYPE, @"xid":parameterXid, @"user_id":parameterUser_Id, @"user_type":USER_TYPE, @"collect_id":_collectionId, @"collect_type":@"6"};
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        
//        NSLog(@"yyyyy%@", responseObj);
        
    } failure:^(NSError *error) {
        //
        NSLog(@"%@", error);
    }];

}


@end
