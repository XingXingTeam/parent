//
//  StarRemarkViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/3/21.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define kPData @"HomerRemarkCell"
#import "StarRemarkViewController.h"
#import "HomerRemarkCell.h"

#import "PhotoBrowseViewController.h"
#import "WZYTool.h"


@interface StarRemarkViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    
    //老师 名称
    NSMutableArray *titleArray;
    //评分
    NSMutableArray *starNumberArray;
    //评论 内容
    NSMutableArray *contentArray;
    //评论 时间
    NSMutableArray *timeArray;
    //头像 类型
    NSMutableArray *head_img_typeArray;
    //头像
    NSMutableArray *head_imgArray;
    //图片
    NSMutableArray *imageViewData;
    
    NSInteger buttonTag;
    NSInteger selectedRow;
    UIImageView *starImageView;
    UIView *starView;
}

@property (nonatomic, copy) NSString *schoolIdStr;

@end

@implementation StarRemarkViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        titleArray = [[NSMutableArray alloc] init];
        starNumberArray = [[NSMutableArray alloc] init];
        contentArray = [[NSMutableArray alloc] init];
        
        timeArray = [[NSMutableArray alloc] init];
        head_imgArray = [[NSMutableArray alloc] init];
        head_img_typeArray = [[NSMutableArray alloc] init];
        
        imageViewData = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =@"星级评分";
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self fetchNetData];
    
    [self createTableView];
}
- (void)createTableView{
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource =self;
    _tableView.delegate =self;
    [self.view addSubview:_tableView];

    
}


- (void)fetchNetData{
    /*
     接口:
     http://www.xingxingedu.cn/Global/sch_course_comment
     
     传参:
     school_id		//学校id
     page			//页码(加载更多),不传参默认1
     
     */
    
    //路径
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/sch_course_comment";
    
    //请求参数
    //获取学校id数组
    
    NSArray *schoolIdArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"_schoolIdArray"];
    
    //获取当前被选中的是第几行
    
    NSString *indexStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"indexStr"];
    
    _schoolIdStr = schoolIdArr[[indexStr intValue]];
    //    NSLog(@"%@",_schoolIdStr);
    
    NSDictionary *params = @{@"appkey":@"U3k8Dgj7e934bh5Y", @"backtype":@"json", @"xid":@"18884982", @"user_id":@"1", @"user_type":@"1", @"school_id":_schoolIdStr};
    
    [WZYHttpTool post:urlStr params:params success:^(id responseObj) {
        
//                        NSLog(@"=================%@", responseObj);
        
        
        if ([responseObj[@"code"] integerValue] == 1) {
            NSArray *array = responseObj[@"data"];
            for (NSDictionary *dic in array) {
                //头像 类型
                NSString *head_img_type = dic[@"head_img_type"];
                
                //头像
                //判断是否是第三方头像
                //    0 :表示 自己 头像 ，需要添加 前缀
                //    1 :表示 第三方 头像 ，不需要 添加 前缀
                NSString * head_img;
                if([[NSString stringWithFormat:@"%@",head_img_type]isEqualToString:@"0"]){
                    head_img=[picURL stringByAppendingString:dic[@"head_img"]];
                }else{
                    head_img=dic[@"head_img"];
                }
                
                [head_imgArray addObject:head_img];
                
                //时间
                NSString *date_tm = dic[@"date_tm"];
                [timeArray addObject:[WZYTool dateStringFromNumberTimer:date_tm]];
                
                //老师 名称
                NSString *nickname = dic[@"nickname"];
                [titleArray addObject:nickname];
                
                //评分
                NSString *school_score = dic[@"school_score"];
                [starNumberArray addObject:school_score];
                
                //内容
                NSString *con = dic[@"con"];
                [contentArray addObject:con];
                
                //图片
                NSArray *picArray = [[NSArray alloc] initWithArray:dic[@"pic_arr"]];
                [imageViewData addObject:picArray];
            }
            
        }else{
            
            //             无数据的时候
            UIImage *myImage = [UIImage imageNamed:@"人物"];
            CGFloat myImageWidth = myImage.size.width;
            CGFloat myImageHeight = myImage.size.height;
            
            UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 2 - myImageWidth / 2, (kHeight - 64 - 49) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
            myImageView.image = myImage;
            [self.view addSubview:myImageView];
            
            
        }
        
        
        [_tableView reloadData];
        //
    } failure:^(NSError *error) {
        
        //
        NSLog(@"iiiiii%@", error);
    }];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *imageArr = imageViewData[indexPath.row];
    
    if (imageArr.count != 0) {
        return 160;
    }
    
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001;

}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomerRemarkCell *cell = (HomerRemarkCell*) [tableView dequeueReusableCellWithIdentifier:kPData];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:kPData owner:[HomerRemarkCell class] options:nil];
        cell = (HomerRemarkCell *)[nib objectAtIndex:0];
        
    }
    //老师 名称
    cell.pareLabel.text =titleArray[indexPath.row];
    //时间
    cell.timeLabel.text = timeArray[indexPath.row];
    
    //老师 头像
    cell.imageV.layer.cornerRadius = 34;
    cell.imageV.layer.masksToBounds = YES;

    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:head_imgArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"人物头像占位图136x136"]];
//    cell.imageV.image =[UIImage  imageNamed:iconArray[indexPath.row]];
    
    //评分
    CGFloat k = [starNumberArray[indexPath.row] doubleValue] ;
    CGFloat i;

    starView  = [[UIView alloc] initWithFrame:CGRectMake(120 + 16, 47, 80, 16)];

    for ( i = 0; i < 5; i++) {

        starImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16 * i , 0, 16, 16)];

        starImageView.image = [UIImage imageNamed:@"星星32x32"];

        [starView addSubview:starImageView];
        
    }
    
    [cell.contentView addSubview:starView];

    CGRect rect = starView.frame;
    rect.size.width = starView.frame.size.width / 5 * k;
    starView.frame = rect;
    
    //设置填充模式为靠左
    starView.contentMode = UIViewContentModeLeft;
    //超出边界剪切掉
    starView.clipsToBounds = YES;
  
    //评论 内容
    cell.contentLabel.text = contentArray[indexPath.row];
    
    //评论 是否有图片
    NSArray *imageArr = imageViewData[indexPath.row];
    
    NSLog(@"KKKK%@", imageArr);
    NSInteger num = imageArr.count;
    if (num != 0) {
        NSInteger j;
        for ( j = 0; j < num; j++) {
//            UIButton *pictureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//            pictureBtn.frame = CGRectMake(100 + (50 + 10) * j, 100, 50, 50);
//            pictureBtn.tag = 10 + indexPath.row;
////            pictureBtn.userInteractionEnabled = YES;
//            buttonTag = pictureBtn.tag;
//            selectedRow = indexPath.row;
//            [pictureBtn setImage:[UIImage imageNamed:imageArr[j]] forState:UIControlStateNormal];
//            [pictureBtn addTarget:self action:@selector(pictureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//            
//            [cell.contentView addSubview:pictureBtn];
            
            UIImageView *pictureImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100 + (50 + 10) * j, 100, 50, 50)];
            
//            [pictureImageView sd_setImageWithURL:[URL ]]
                [pictureImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", picURL, imageArr[j]]]];
            pictureImageView.tag = 20 + j;
            pictureImageView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickPicture:)];
            [pictureImageView addGestureRecognizer:tap];
            [cell.contentView addSubview:pictureImageView];
            
        }

    }else{
        cell.pictureLabel.hidden = YES;
    }
    
        return cell;
    
}

- (void)onClickPicture:(UITapGestureRecognizer *)tap{
    
    
    /*
     -[(void)addMembers:(id)sender{//手势的响应方法带一个参数，返回对应的手势
     UIImageView * imgView = ((UITapGestureRecognizer *)sender).view; //由手势取到被点击的那个imageView;
     EWorkDepartmentManageCell * cell = imgView.superview.superview;//这里看cell和imageView之间的关系，你的图片放在cell上面的话，肯定可以通过superView取到图片对应的cell；
     NSIndexPath index = [_betTabView indexPathForCell:cell];//这个方法就是根据cell获取它对应的indexPath
     }
     
     */
    
    UIImageView *clickImageView = (UIImageView *)tap.view;
    
    HomerRemarkCell *cell = (HomerRemarkCell *)clickImageView.superview.superview;
    
    NSIndexPath *path = [_tableView indexPathForCell:cell];
    
//        StarRankPhotoBrowseViewController *starRankPhotoBrowseVC = [[StarRankPhotoBrowseViewController alloc] init];
//        NSMutableArray *imageArr = imageViewData[path.row];
//        starRankPhotoBrowseVC.imageA = imageArr;
//        starRankPhotoBrowseVC.i = imageArr.count;
//        starRankPhotoBrowseVC.index = path.row;
//        [self.navigationController pushViewController:starRankPhotoBrowseVC animated:YES];
    
    PhotoBrowseViewController *photoBrowseVC =[[PhotoBrowseViewController alloc]init];
    NSMutableArray *imageArr = imageViewData[path.row];
    photoBrowseVC.i =imageArr.count;
    photoBrowseVC.index =path.row;
    photoBrowseVC.imageA =imageArr;
    [self.navigationController pushViewController:photoBrowseVC animated:YES];

}


//- (void)pictureBtnClick:(UIButton *)button{
//   // button = (UIButton *)[self.view viewWithTag:buttonTag];
//
//    UITableViewCell *cell = (UITableViewCell *)[[button superview] superview];
//    NSIndexPath *path = [_tableView indexPathForCell:cell];
////    NSLog(@"---------index row %ld", path.row);
//    
//    StarRankPhotoBrowseViewController *starRankPhotoBrowseVC = [[StarRankPhotoBrowseViewController alloc] init];
//    NSMutableArray *imageArr = imageViewData[path.row];
//    starRankPhotoBrowseVC.imageA = imageArr;
//    starRankPhotoBrowseVC.i = imageArr.count;
//    
//    [self.navigationController pushViewController:starRankPhotoBrowseVC animated:YES];
//
//}

@end
