//
//  LocalViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/3/16.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "LocalViewController.h"

@interface LocalViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *dataArray;
    NSMutableArray *titleArray;
    NSString *localText;
}
@end

@implementation LocalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor= [UIColor colorWithRed:229/255.0f green:232/255.0f blue:234/255.0f alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.barTintColor =UIColorFromRGB(0, 170, 42);
    
    self.title =@"所在位置";
    // Do any additional setup after loading the view.
    [self createTableView];
   
}

- (void)createTableView{
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStylePlain];
    _tableView.dataSource =self;
    _tableView.delegate =self;
    [self.view addSubview:_tableView];
    dataArray =[[NSMutableArray alloc]initWithObjects:@"上海市浦东新区巨峰路1058号",@"上海市浦东新区巨峰路1058弄1号",@"上海市浦东新区金高路1292号",@"上海市浦东新区",@"上海市浦东新区巨峰路1100号",@"上海市浦东新区巨峰路1058弄2号",@"上海市浦东新区巨峰路1058号",@"上海市浦东新区巨峰路1058弄1号",@"上海市浦东新区金桥",@"上海市浦东新区高行",@"上海市浦东新区金高路945号", nil];
    titleArray =[[NSMutableArray alloc]initWithObjects:@"米高梅国际影城",@"新紫茂国际大厦",@"金桥生活广场",@"华高新苑",@"上海德国学校浦东校区",@"麦当劳(巨峰店)",@"星巴克咖啡(晨达广场店)",@"味千拉面(新紫茂广场店)",@"金桥",@"高行",@"K歌达人量贩式KTV(高行店)", nil];
    
    
}
- (void)upBtn{
//    NSLog(@"搜索");

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 60;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return dataArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static  NSString *cellID =@"cellID";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    if (indexPath.row==0) {
       cell.textLabel.text =@"不显示位置";
    }
    else{
    cell.textLabel.text =titleArray[indexPath.row];
    cell.detailTextLabel.text =dataArray[indexPath.row];
    }
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        localText =@"所在位置";
    }
    else{
    localText =titleArray[indexPath.row];
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)returnText:(ReturnTextBlock)block{
    self.returnTextBlock =block;

}
- (void)viewWillDisappear:(BOOL)animated{
    self.returnTextBlock(localText);

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
