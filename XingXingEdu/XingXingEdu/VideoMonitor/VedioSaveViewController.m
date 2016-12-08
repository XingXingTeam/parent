//
//  VedioSaveViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/2/22.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//
#define bgt    @"http://data.vod.itc.cn/?prod=app&new=/194/216/JBUeCIHV4s394vYk3nbgt2.mp4"
#define ktpqk  @"http://data.vod.itc.cn/?prod=app&new=/5/36/aUe9kB0906IvkI5UCpq11K.mp4"
#define hvd    @"http://data.vod.itc.cn/?prod=app&new=/10/66/eCGPkAewSVqy9P57hvB11D.mp4"
#define cpf    @"http://data.vod.itc.cn/?prod=app&new=/125/206/g586XlZhJQBGTnFDS75cPF.mp4"
#define kPData @"VedioCell"
#define tbC    @"TableHeadCell"
#import "VedioSaveViewController.h"
#import "UtilityFunc.h"
#import "HHControl.h"
#import "VedioCell.h"
#import "SSVideoPlayContainer.h"
#import "SSVideoPlayController.h"
@interface VedioSaveViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *dataSourse;
    NSArray *ktArr;
}
@end

@implementation VedioSaveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的收藏视频";
    self.view.backgroundColor = UIColorFromRGB(229, 232, 233);
    // Do any additional setup after loading the view.
    [self createTableView];
}
- (void)createTableView{
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(4, 0, kWidth-8, kHeight) style:UITableViewStyleGrouped];
    _tableView.dataSource =self;
    _tableView.delegate =self;
    [self.view addSubview:_tableView];
  
    _tableView.tableFooterView =[[NSBundle mainBundle]loadNibNamed:tbC owner:nil options:nil][0];
    dataSourse = [[NSMutableArray alloc]init];
   ktArr =[NSArray arrayWithObjects:@"教室",@"走廊",@"操场",@"大厅",@"大门", nil];
    [dataSourse addObjectsFromArray:ktArr];
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    //如果被观察者的对象是_playList
    if ([object isKindOfClass:[UITextField class]]) {
        //如果是name属性值发生变化
        if ([keyPath isEqualToString:@"text"]) {
            //取出name的旧值和新值
            
            NSString * newName=[change objectForKey:@"new"];
            
            if([newName isEqualToString:@"教学区域"]){
                
            }
            else  if([newName isEqualToString:@"公共区域"]){
                
            }
        }
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.000001;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSourse.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    VedioCell *cell =(VedioCell*)[tableView dequeueReusableCellWithIdentifier:kPData];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:kPData owner:[VedioCell class] options:nil];
        cell = (VedioCell*)[nib objectAtIndex:0];
        
    }
 
    [cell.VedioBtn setBackgroundImage:[UIImage imageNamed:@"vedioimg"] forState:UIControlStateNormal];
    cell.addressLabel.text =[NSString stringWithFormat:@"%@",ktArr[indexPath.row]];
    cell.instructionLabel.text = [NSString stringWithFormat:@"说明:%@",@"暂无情况"];
    
    cell.timeLabel.text =[NSString stringWithFormat:@"%@",@"2016-04-03 12:20"];
    cell.VedioBtn.userInteractionEnabled =NO;
    
    return cell;
}
// 加载数据
- (void)play{
    NSArray *paths = @[bgt,
                       ktpqk,
                       hvd,
                       cpf,
                       [[NSBundle mainBundle]pathForResource:@"dzs" ofType:@"mp4"]
                       ];
    NSArray *names = @[@"教室",@"走廊",@"操场",@"大厅",@"大门"];
    NSMutableArray *videoList = [NSMutableArray array];
    for (NSInteger i = 0; i<paths.count; i++) {
        SSVideoModel *model = [[SSVideoModel alloc]init];
        model.path = paths[i];
        model.name = names[i];
        [videoList addObject:model];
    }
    SSVideoPlayController *playController = [[SSVideoPlayController alloc]initWithVideoList:videoList];
    SSVideoPlayContainer *playContainer = [[SSVideoPlayContainer alloc]initWithRootViewController:playController];
    [self presentViewController:playContainer animated:NO completion:nil];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==0) {
        
        NSArray *paths = @[bgt,
                           ktpqk,
                           hvd,
                           cpf,
                           [[NSBundle mainBundle]pathForResource:@"dzs" ofType:@"mp4"]
                           ];
        NSArray *names = @[@"教室",@"走廊",@"操场",@"大厅",@"大门"];
        NSMutableArray *videoList = [NSMutableArray array];
        for (NSInteger i = 0; i<paths.count; i++) {
            SSVideoModel *model = [[SSVideoModel alloc]init];
            model.path = paths[i];
            model.name = names[i];
            [videoList addObject:model];
        }
        SSVideoPlayController *playController = [[SSVideoPlayController alloc]initWithVideoList:videoList];
        SSVideoPlayContainer *playContainer = [[SSVideoPlayContainer alloc]initWithRootViewController:playController];
        [self presentViewController:playContainer animated:NO completion:nil];
    }
    else if (indexPath.row ==1)
    {
        
        NSArray *paths = @[ ktpqk,
                            bgt,
                            hvd,
                            cpf,
                            [[NSBundle mainBundle]pathForResource:@"dzs" ofType:@"mp4"]
                            ];
        NSArray *names = @[@"教室",@"走廊",@"操场",@"大厅",@"大门"];
        NSMutableArray *videoList = [NSMutableArray array];
        for (NSInteger i = 0; i<paths.count; i++) {
            SSVideoModel *model = [[SSVideoModel alloc]init];
            model.path = paths[i];
            model.name = names[i];
            [videoList addObject:model];
        }
        SSVideoPlayController *playController = [[SSVideoPlayController alloc]initWithVideoList:videoList];
        SSVideoPlayContainer *playContainer = [[SSVideoPlayContainer alloc]initWithRootViewController:playController];
        [self presentViewController:playContainer animated:NO completion:nil];
        
    }
    else if (indexPath.row ==2)
    {
        
        NSArray *paths = @[ hvd,
                            ktpqk,
                            bgt,
                            cpf,
                            [[NSBundle mainBundle]pathForResource:@"dzs" ofType:@"mp4"]
                            ];
        NSArray *names = @[@"教室",@"走廊",@"操场",@"大厅",@"大门"];
        NSMutableArray *videoList = [NSMutableArray array];
        for (NSInteger i = 0; i<paths.count; i++) {
            SSVideoModel *model = [[SSVideoModel alloc]init];
            model.path = paths[i];
            model.name = names[i];
            [videoList addObject:model];
        }
        SSVideoPlayController *playController = [[SSVideoPlayController alloc]initWithVideoList:videoList];
        SSVideoPlayContainer *playContainer = [[SSVideoPlayContainer alloc]initWithRootViewController:playController];
        [self presentViewController:playContainer animated:NO completion:nil];
        
    }
    else if (indexPath.row ==3)
    {
        
        NSArray *paths = @[ cpf,
                            hvd,
                            ktpqk,
                            bgt,
                            [[NSBundle mainBundle]pathForResource:@"dzs" ofType:@"mp4"]
                            ];
        NSArray *names = @[@"教室",@"走廊",@"操场",@"大厅",@"大门"];
        NSMutableArray *videoList = [NSMutableArray array];
        for (NSInteger i = 0; i<paths.count; i++) {
            SSVideoModel *model = [[SSVideoModel alloc]init];
            model.path = paths[i];
            model.name = names[i];
            [videoList addObject:model];
        }
        SSVideoPlayController *playController = [[SSVideoPlayController alloc]initWithVideoList:videoList];
        SSVideoPlayContainer *playContainer = [[SSVideoPlayContainer alloc]initWithRootViewController:playController];
        [self presentViewController:playContainer animated:NO completion:nil];
        
    }
    else{
        
        NSArray *paths = @[[[NSBundle mainBundle]pathForResource:@"dzs" ofType:@"mp4"],
                           cpf,
                           hvd,
                           ktpqk,
                           bgt                            ];
        NSArray *names = @[@"教室",@"走廊",@"操场",@"大厅",@"大门"];
        NSMutableArray *videoList = [NSMutableArray array];
        for (NSInteger i = 0; i<paths.count; i++) {
            SSVideoModel *model = [[SSVideoModel alloc]init];
            model.path = paths[i];
            model.name = names[i];
            [videoList addObject:model];
        }
        SSVideoPlayController *playController = [[SSVideoPlayController alloc]initWithVideoList:videoList];
        SSVideoPlayContainer *playContainer = [[SSVideoPlayContainer alloc]initWithRootViewController:playController];
        [self presentViewController:playContainer animated:NO completion:nil];
        
    }
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
