//
//  SaveInfoViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/2/4.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "SaveInfoViewController.h"
#import "TeleViewController.h"
#import "UtilityFunc.h"
#import "HHControl.h"
@interface SaveInfoViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *dataArray;
    NSArray * textArr;
    NSArray * commentArr;
    NSArray *imageArr;
    NSArray *speakArr;
    NSArray *contactArr;
    NSMutableArray *imgArr;
    NSArray *nilArr;

}
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)UISearchController *searchDC;
@end

@implementation SaveInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
      self.title = @"我的收藏";
    self.view.backgroundColor = UIColorFromRGB(158,235, 199);
    [self createTableView];
  
}
- (void)createTableView{

    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStylePlain];
    _tableView.dataSource =self;
    _tableView.delegate =self;
    [self.view addSubview:_tableView];
    //headView
    UIView *headView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 90)];
    headView.userInteractionEnabled =YES;
    [self.view addSubview:headView];
    
    //search
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kWidth, 44)];
    UIImage *backgroundImg = [UtilityFunc createImageWithColor:UIColorFromHex(0xf0eaf3) size:_searchBar.frame.size];
    [_searchBar setBackgroundImage:backgroundImg];
    _searchBar.placeholder =@"请输入你要查询的收藏内容";
    _searchBar.tintColor = [UIColor blackColor];
    _searchBar.delegate =self;
    _searchDC = [[UISearchController alloc]initWithSearchResultsController:self];
    [headView addSubview:_searchBar];
    
    //btn
    NSArray *arr=[NSArray arrayWithObjects:@"文字",@"点评",@"图片",@"语音",@"联系人", nil];
    for (int i=0; i<5; i++) {
        UIButton *btn =[HHControl createButtonWithFrame:CGRectMake(i*(kWidth/6+10)+10, 50, 60, 30) backGruondImageName:@"theme_box_07" Target:self Action:@selector(btn:) Title:[NSString stringWithFormat:@"%@",arr[i]]];
        btn.tag=i+100;
        btn.layer.cornerRadius =5;
        btn.layer.masksToBounds =YES;
        [btn setImage:[UIImage imageNamed:@"theme_box_06"] forState:UIControlStateHighlighted];
        [headView addSubview:btn];
    }
    
    
    _tableView.tableHeaderView =headView;
    
    imgArr = [[NSMutableArray alloc]init];
    dataArray =[[NSMutableArray alloc]init];
   textArr = [[NSArray alloc]initWithObjects:@"人无善志，虽勇必伤。",@"会当凌绝顶，一览众山小。",@"人若有志，万事可为。",@"天行健，君子以自强不息。",@"天下兴亡，匹夫有责。",@"时间是我的财产，我的田亩是时间。",@"合理安排时间，就等于节约时间。", nil];
    commentArr = [[NSArray alloc]initWithObjects:@"天下兴亡，匹夫有责。",@"时间是我的财产，我的田亩是时间。",@"合理安排时间，就等于节约时间。",@"人无善志，虽勇必伤。",@"会当凌绝顶，一览众山小。",@"人若有志，万事可为。",@"天行健，君子以自强不息。", nil];
    imageArr =[[NSArray alloc]initWithObjects:@"11111",@"11111",@"11111",@"11111",@"11111",@"11111",@"11111", nil];
    speakArr = [[NSArray alloc]initWithObjects:@"22222",@"22222",@"22222",@"22222",@"22222",@"22222",@"22222", nil];
   contactArr = [[NSArray alloc]initWithObjects:@"王老师",@"张老师",@"李老师",@"孙老师",@"郝老师",@"周老师",@"高老师", nil];
    nilArr =[[NSArray alloc]initWithObjects:@"",@"",@"",@"",@"",@"",@"", nil];
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
static NSString *cellID =@"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    }

    
    cell.imageView.image = [UIImage imageNamed:imgArr[indexPath.row]];
    cell.textLabel.text = dataArray[indexPath.row];
    


    return cell;

}

- (void)btn:(UIButton*)bt{
    if (bt.tag==100) {
        NSLog(@"文字");
        imgArr =[[NSMutableArray alloc]initWithArray:nilArr];
        dataArray =[[NSMutableArray alloc]initWithArray:textArr];
        [_tableView reloadData];
    }
    else if (bt.tag==101){
      NSLog(@"点评");
        imgArr =[[NSMutableArray alloc]initWithArray:nilArr];
        dataArray =[[NSMutableArray alloc]initWithArray:commentArr];
        [_tableView reloadData];
    }
    else if (bt.tag==102){
    NSLog(@"图片");
        imgArr =[[NSMutableArray alloc]initWithArray:imageArr];
        dataArray =[[NSMutableArray alloc]initWithArray:nilArr];
        [_tableView reloadData];
    }
    else if (bt.tag==103){
       NSLog(@"语音");
        imgArr =[[NSMutableArray alloc]initWithArray:nilArr];
        dataArray =[[NSMutableArray alloc]initWithArray:speakArr];
        [_tableView reloadData];
    }
    else if (bt.tag==104){
      NSLog(@"联系人");
        dataArray =[[NSMutableArray alloc]initWithArray:contactArr];
        imgArr = [[NSMutableArray alloc]initWithArray:imageArr];
        [_tableView reloadData];
    }


}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
   // if ([btn.currentTitle isEqualToString:@"联系人"]){
    
//        TeleViewController *teleVC =[[TeleViewController alloc]init];
//        
//        teleVC.name =dataArray[indexPath.row];
//        teleVC.imagStr =imgArr[indexPath.row];
//        
//        [self.navigationController pushViewController:teleVC animated:YES];
    
    
 //   }

  



}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    //搜尋結束後，恢復原狀
    return YES;
}
#pragma mark - search bar delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    
    // [searchBar setShowsCancelButton:YES animated:YES];
    _searchBar.showsCancelButton = YES;
   
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_searchBar endEditing:YES];
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
