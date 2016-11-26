//
//  contentRepositoryViewController.m
//  XingXingEdu
//
//  Created by super on 16/2/24.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "contentRepositoryViewController.h"
#import "HHControl.h"
#import "WebViewController.h"
#import "CommunityImageTableViewCell.h"
#import "CommunityImageTableViewCell.h"
#define WinWidth [UIScreen mainScreen].bounds.size.width
#define WinHeight [UIScreen mainScreen].bounds.size.height
#define W(x) WinWidth*(x)/375.0
#define H(y) WinHeight*(y)/667.0
@interface contentRepositoryViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray * array;
    UITableView *myTableView;
}

@end

@implementation contentRepositoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    array=[NSArray arrayWithObjects:@"community5.png", @"community6.png",@"community7.png",@"community8.png",nil];
    
    myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WinWidth, WinHeight)];
    myTableView.delegate=self;
    myTableView.dataSource=self;
    [self.view addSubview:myTableView];
    
    UINib *nib = [UINib nibWithNibName:@"CommunityImageTableViewCell" bundle:nil];
    [myTableView registerNib:nib forCellReuseIdentifier:@"cell"];

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommunityImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell==nil){
        cell=[[CommunityImageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
//    cell.textLabel.text=array[indexPath.row];
    cell.image.image=[UIImage imageNamed:array[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 88;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WebViewController * webVC = [[WebViewController alloc]init];
    
    if(indexPath.row==0){
         webVC.url=@"http://g.beva.com/?from=bdquery";
    }
    else if (indexPath.row==1)
    {
        webVC.url=@"http://www.youban.com/story/";

    }
    else if (indexPath.row==2)
    {
        webVC.url=@"http://baike.pcbaby.com.cn/2013/0812/zt1213244.html";
    }
    else if (indexPath.row==3)
    {
        webVC.url=@"http://www.7k7k.com/";

    }
    
   
    [self.navigationController pushViewController:webVC animated:YES];

    
}

@end
