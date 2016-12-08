

//
//  SchoolVideoViewController.m
//  XingXingEdu
//
//  Created by Mac on 16/5/20.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#define bgt    @"http://data.vod.itc.cn/?prod=app&new=/194/216/JBUeCIHV4s394vYk3nbgt2.mp4"
#define ktpqk  @"http://data.vod.itc.cn/?prod=app&new=/5/36/aUe9kB0906IvkI5UCpq11K.mp4"
#define hvd    @"http://data.vod.itc.cn/?prod=app&new=/10/66/eCGPkAewSVqy9P57hvB11D.mp4"
#define cpf    @"http://data.vod.itc.cn/?prod=app&new=/125/206/g586XlZhJQBGTnFDS75cPF.mp4"
#define kPData @"SchoolVideoTableViewCell"
#define tbC    @"TableHeadCell"
#import "SchoolVideoViewController.h"
//splitList
#import "LMContainsLMComboxScrollView.h"
#import "WJCommboxView.h"
#import "LMComBoxView.h"
#import "UtilityFunc.h"
#import "HHControl.h"
#import "VedioCell.h"
#import "SSVideoPlayContainer.h"
#import "VedioSaveViewController.h"
#import "SSVideoPlayController.h"
#import "WMConversationViewController.h"
#import "PurchasedViewController.h"

#import "SchoolVideoTableViewCell.h"
#import "SchoolVideoPlayViewController.h"
#import "WZYTool.h"


@interface SchoolVideoViewController ()<UITableViewDataSource,UITableViewDelegate,LMComBoxViewDelegate,UISearchBarDelegate,UIAlertViewDelegate>
{
    LMContainsLMComboxScrollView *bgScrollView;
    UITableView *_tableView;
//    NSMutableArray *dataSourse;
    NSInteger olderValue;
    NSArray *ktArr;
    UIAlertView *_alert;
    
}

@end

@implementation SchoolVideoViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataSource = [[NSMutableArray alloc]init];
        _videoImageViewArray = [[NSMutableArray alloc] init];
        _videoTitleArray = [[NSMutableArray alloc] init];
        _videoTimeArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"视频";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);

    [self createContent];
    
}

- (void)createContent{
    if (_videoImageViewArray.count == 0) {
        // 1、无数据的时候
        UIImage *myImage = [UIImage imageNamed:@"人物"];
        CGFloat myImageWidth = myImage.size.width;
        CGFloat myImageHeight = myImage.size.height;
        
        UIImageView *myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth / 2 - myImageWidth / 2, (kHeight - 64 - 49) / 2 - myImageHeight / 2, myImageWidth, myImageHeight)];
        myImageView.image = myImage;
        [self.view addSubview:myImageView];
    }else{
    
    [self createTableView];
    
    }

}

- (void)createTableView{
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(4, 0, kWidth-8, kHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource =self;
    _tableView.delegate =self;
    [self.view addSubview:_tableView];
//    _tableView.tableFooterView =[[NSBundle mainBundle]loadNibNamed:tbC owner:nil options:nil][0];

    
}

-(void)selectAtIndex:(int)index inCombox:(LMComBoxView *)_combox{
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 230;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _videoImageViewArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SchoolVideoTableViewCell *cell =(SchoolVideoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"SchoolVideoTableViewCell"];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"SchoolVideoTableViewCell" owner:[SchoolVideoTableViewCell class] options:nil];
        cell = (SchoolVideoTableViewCell*)[nib objectAtIndex:0];
        
    }
    
    [cell.videoImageView sd_setImageWithURL:[NSURL URLWithString:_videoImageViewArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"vedioimg"]];
    cell.titleLabel.text = _videoTitleArray[indexPath.row];
    
    NSString *timeStr = [WZYTool dateStringFromNumberTimer:_videoTimeArray[indexPath.row]];
    
    cell.timeLabel.text = timeStr;

    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.00000000000001;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

            NSMutableArray *videoList = [NSMutableArray array];
            for (NSInteger i = 0; i<_videoImageViewArray.count; i++) {
                SSVideoModel *model = [[SSVideoModel alloc]init];
                model.path = _videoImageViewArray[i];
//                model.name = _dataSource[i];
                [videoList addObject:model];
            }
            SchoolVideoPlayViewController *playController = [[SchoolVideoPlayViewController alloc]initWithVideoList:videoList];
            SSVideoPlayContainer *playContainer = [[SSVideoPlayContainer alloc]initWithRootViewController:playController];
    NSLog(@"kkk%@", _videoImageViewArray[0]);
            playController.urlPath =_videoImageViewArray[0];
//             playContainer.navigationItem.rightBarButtonItem = nil;
            [self presentViewController:playContainer animated:NO completion:nil];
    
}



@end
