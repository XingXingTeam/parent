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
#import "PayMannerViewController.h"
@interface FlowersBuyViewController ()
{
    NSString *priceStr;
    NSString *conStr;
    NSString *_flowerId;
    NSMutableArray *articleArray;

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
    self.title =@"花篮购买";
    self.numLbl.text =@"1";
    articleArray = [NSMutableArray array];
    
    
    [self createRightBar];
    [self initData];
    [self createLeftButton];
    // Do any additional setup after loading the view from its nib.
}

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
- (void)initData{
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/flowers_basket_info";
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           };
    
    [WZYHttpTool post:urlStr params:dict success:^(id responseObj) {
    NSDictionary *dict =responseObj;
    if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
        {
            priceStr =dict[@"data"][@"exchange_price"];
            conStr=dict[@"data"][@"con"];
            _flowerId = dict[@"data"][@"id"];
        }
        [self initUI];
        
    } failure:^(NSError *error) {
        
    }];

}

- (void)initUI{
    self.PriceLbl.text =[NSString stringWithFormat:@"¥ %@",priceStr];
    self.conLbl.text =[NSString stringWithFormat:@"%@",conStr];
}


- (void)createRightBar{
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,22,22)];
    [rightButton setImage:[UIImage imageNamed:@"赠icon44x44.png"]forState:UIControlStateNormal];
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
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"goods_id":_flowerId,
                           @"buy_num":self.numLbl.text,
                           };
    
    [WZYHttpTool post:urlStr params:dict success:^(id responseObj) {
        NSDictionary *dict =responseObj;
        if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
        {
            
           NSString *order_id =dict[@"data"][@"order_id"];
           NSString *order_index=dict[@"data"][@"order_index"];
           NSString *exchange_price = dict[@"data"][@"exchange_price"];
            
            PayMannerViewController *BuyDetailMessageVC = [[PayMannerViewController alloc] init];
            BuyDetailMessageVC.price = exchange_price;
            BuyDetailMessageVC.orderId = order_id;
            BuyDetailMessageVC.order_index = order_index;
            BuyDetailMessageVC.isFlower = YES;
            [self.navigationController pushViewController:BuyDetailMessageVC animated:YES];
        }
        [self initUI];
        
    } failure:^(NSError *error) {
        
    }];
    
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
