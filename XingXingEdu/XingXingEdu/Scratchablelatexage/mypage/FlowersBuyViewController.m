//
//  FlowersBuyViewController.m
//  XingXingEdu
//
//  Created by keenteam on 16/5/27.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "FlowersBuyViewController.h"
#import "FlowersPresentViewController.h"
#import "AccountManagerViewController.h"
#import "CoreUMeng.h"
#import "XXEStorePayViewController.h"
@interface FlowersBuyViewController ()
{
    NSString *priceStr;
    NSString *conStr;
    NSString *_flowerId;
    NSMutableArray *articleArray;
    NSString *parameterXid;
    NSString *parameterUser_Id;
    

}
@property (weak, nonatomic) IBOutlet UIButton *minBtn;
@property (weak, nonatomic) IBOutlet UILabel *numLbl;
@property (weak, nonatomic) IBOutlet UIButton *maxLbl;
@property (weak, nonatomic) IBOutlet UILabel *PriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *conLbl;

@end

@implementation FlowersBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([XXEUserInfo user].login){
        parameterXid = [XXEUserInfo user].xid;
        parameterUser_Id = [XXEUserInfo user].user_id;
    }else{
        parameterXid = XID;
        parameterUser_Id = USER_ID;
    }

    self.title =@"花篮购买";
    self.numLbl.text =@"1";
    articleArray = [NSMutableArray array];
    
    //选择赠送 对象 按钮
    [self createRightBar];
    //获取 花篮 详情
    [self initData];
    //创建 返回 按钮
    [self createLeftButton];
}

#pragma Mark ********** 创建 返回 按钮 ***************
-(void)createLeftButton{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(- 10, 0, 44, 20);
    
    [backBtn setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = backItem;
}


-(void)doBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma Mark =========== 【猩猩商城--花篮详情】 =========
- (void)initData{
    /*
     接口类型:1
     接口:
     http://www.xingxingedu.cn/Global/flowers_basket_info
     */
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/flowers_basket_info";
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":parameterXid,
                           @"user_id":parameterUser_Id,
                           @"user_type":USER_TYPE,
                           };
    
    [WZYHttpTool post:urlStr params:dict success:^(id responseObj) {
//        NSLog(@"花篮 详情 ===== %@", responseObj);
        
    if([[NSString stringWithFormat:@"%@",responseObj[@"code"]]isEqualToString:@"1"] )
        {
            priceStr =responseObj[@"data"][@"exchange_price"];
            conStr=responseObj[@"data"][@"con"];
            _flowerId = responseObj[@"data"][@"id"];
        }
        [self initUI];
        
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"获取数据失败!"];
    }];

}

- (void)initUI{
    self.PriceLbl.text =[NSString stringWithFormat:@"¥ %@",priceStr];
    self.conLbl.text =[NSString stringWithFormat:@"%@",conStr];
}


- (void)createRightBar{
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,22,22)];
    [rightButton setImage:[UIImage imageNamed:@"赠icon44x44"]forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(flowersPresent)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
}


- (void)flowersPresent{
//    NSLog(@"sent");
    FlowersPresentViewController * flowerVC = [[FlowersPresentViewController alloc] init];
    flowerVC.flowersRemain = _flowersRemain;
    [self.navigationController pushViewController:flowerVC animated:YES];
}
- (IBAction)minBt:(id)sender {
    if ([self.numLbl.text intValue] <1) {
        [SVProgressHUD showInfoWithStatus:@"最少为1个"];
        return;
    }else{
        self.numLbl.text =[NSString stringWithFormat:@"%d",[self.numLbl.text intValue] -1];
    }
    
}

- (IBAction)maxBt:(UIButton *)sender {
      self.numLbl.text =[NSString stringWithFormat:@"%d",[self.numLbl.text intValue] +1];
}

- (IBAction)shareBtn:(UIButton *)sender {
     [CoreUmengShare show:self text:@"为了孩子的未来,这里有你想要的一切,快点点击下载吧！https://itunes.apple.com/cn/app/jie-dian-qian-zhuan-ye-ban/id1112373854?mt=8&v0=WWW-GCCN-ITSTOP100-FREEAPPS&l=&ign-mpt=uo%3D4" image:[UIImage imageNamed:@"猩猩教室.png"]];
    
}

- (IBAction)buyBtn:(UIButton *)sender {
    
    [self initFlowers_Basket_PayData];
}


//花篮点击支付(产生订单)
- (void)initFlowers_Basket_PayData{
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/flowers_basket_pay";
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":parameterXid,
                           @"user_id":parameterUser_Id,
                           @"user_type":USER_TYPE,
                           @"goods_id":_flowerId,
                           @"buy_num":self.numLbl.text,
                           };
    
    [WZYHttpTool post:urlStr params:dict success:^(id responseObj) {
        NSDictionary *dict =responseObj;
        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
        {
            NSDictionary *daizhifuOrderDictInfo = [[NSDictionary alloc] init];
            
            daizhifuOrderDictInfo = responseObj[@"data"];
            
            XXEStorePayViewController *storePayVC = [[XXEStorePayViewController alloc] init];
            storePayVC.dict = daizhifuOrderDictInfo;
            storePayVC.order_id = daizhifuOrderDictInfo[@"order_id"];
            
            [self.navigationController pushViewController:storePayVC animated:YES];
            
            
        }
        [self initUI];
        
    } failure:^(NSError *error) {
        
    }];
    
}



@end
