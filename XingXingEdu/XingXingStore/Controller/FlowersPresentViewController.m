//
//  FlowersPresentViewController.m
//  XingXingStore
//
//  Created by codeDing on 16/1/22.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "FlowersPresentViewController.h"
#import "WJCommboxView.h"
#import "HHControl.h"
#import "SVProgressHUD.h"
#import "FlowersHistoryTableViewController.h"
#import "ClassTelephoneViewController.h"
#import "FbasketGiveViewController.h"
#define KMarg 10.0f
#define KLabelW 80.0f
#define KLabelH 30.0f

@interface FlowersPresentViewController () {
    
        UITextField * flowersText;
        UITextView * adviceWord;
        UILabel *flowersRemainLabel;
        UIButton * peopleBtn;
        NSString *KTID;
}
@property(nonatomic,strong)WJCommboxView *familyCombox;

@end

@implementation FlowersPresentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor=[UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [[self navigationItem] setTitle:@"赠送花篮"];
    
    UIButton*rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,22,22)];
    [rightButton setImage:[UIImage imageNamed:@"presenthistoryicon44.png"]forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(flowersHistory)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    
//    self.flowersRemain=@"5";
    [self creatFieldset];
    
}
-(void)creatFieldset{
    
    //花篮剩余
    UILabel *flowerL = [HHControl createLabelWithFrame:CGRectMake(KMarg, KMarg, KLabelW, KLabelH) Font:16 Text:@"花篮剩余:"];
    [self.view addSubview:flowerL];
    
    flowersRemainLabel=[HHControl createLabelWithFrame:CGRectMake(CGRectGetMaxX(flowerL.frame), KMarg, kWidth - CGRectGetMaxX(flowerL.frame) - KLabelH, KLabelH) Font:16 Text:_flowersRemain];
    flowersRemainLabel.textColor=UIColorFromRGB(29, 29, 29);
    flowersRemainLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:flowersRemainLabel];
    
    UIView *view1=[HHControl createViewWithFrame:CGRectMake(0, CGRectGetMaxY(flowersRemainLabel.frame), kWidth, 1)];
    view1.backgroundColor=UIColorFromRGB(193, 193, 193);
    [self.view addSubview:view1];
    
    //赠送对象
    [self.view addSubview: [HHControl createLabelWithFrame:CGRectMake(KMarg,CGRectGetMaxY(flowersRemainLabel.frame)+ 5 , KLabelW, KLabelH) Font:16 Text:@"赠送对象:"]];
    peopleBtn=[HHControl createButtonWithFrame:CGRectMake(CGRectGetMaxX(flowerL.frame),CGRectGetMaxY(flowersRemainLabel.frame) + 5 , kWidth - CGRectGetMaxX(flowerL.frame) - KLabelH, KLabelH) backGruondImageName:nil Target:self Action:@selector(openAddressBook) Title:@"请选择对象"];
    peopleBtn.titleLabel.font = [UIFont systemFontOfSize: 14];
    peopleBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:peopleBtn];

    
    UIView *view2=[HHControl createViewWithFrame:CGRectMake(0, CGRectGetMaxY(peopleBtn.frame), kWidth, 1)];
    view2.backgroundColor=UIColorFromRGB(193, 193, 193);
    [self.view addSubview:view2];

    //转赠花篮数目
    [self.view addSubview: [HHControl createLabelWithFrame:CGRectMake(KMarg, CGRectGetMaxY(peopleBtn.frame)+ 5, kWidth - CGRectGetMaxX(flowerL.frame) - KLabelH, KLabelH) Font:16 Text:@"花篮数目:"]];
    flowersText= [HHControl createTextFielfFrame:CGRectMake(CGRectGetMaxX(flowerL.frame), CGRectGetMaxY(peopleBtn.frame)+ 5, kWidth - CGRectGetMaxX(flowerL.frame) - KLabelH, KLabelH) font:[UIFont fontWithName:@"Arial" size:14] placeholder:@"最多可赠送5个"];
    flowersText.keyboardType=UIKeyboardTypeNumberPad;
    flowersText.borderStyle = UITextBorderStyleNone;
    flowersText.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview: flowersText];
    
    UIView *view3=[HHControl createViewWithFrame:CGRectMake(0, CGRectGetMaxY(flowersText.frame), kWidth, 1)];
    view3.backgroundColor=UIColorFromRGB(193, 193, 193);
    [self.view addSubview:view3];
    
    UIView *view4=[HHControl createViewWithFrame:CGRectMake(0, 235, kWidth, kHeight-235)];
    view4.backgroundColor=UIColorFromRGB(229, 232, 233);
    [self.view addSubview:view4];
    
    
    //确认转赠
    [self.view addSubview:[HHControl createButtonWithFrame:CGRectMake(25, kHeight - 170,kWidth - 50, 42) backGruondImageName:@"surepresent.png" Target:nil Action:@selector(affirmBtn) Title:nil]];
    
    //赠言
    [self.view addSubview: [HHControl createLabelWithFrame:CGRectMake(15, 118, 50, 30) Font:16 Text:@"赠言："]];
    adviceWord=[[UITextView alloc]initWithFrame:CGRectMake(65,118, 280,100)];
    adviceWord.font =[UIFont systemFontOfSize:14];
    [self.view addSubview:adviceWord];
  
    adviceWord.layer.borderColor = UIColorFromRGB(255, 255, 255).CGColor;
    adviceWord.layer.borderWidth =0;//该属性显示外边框
    adviceWord.layer.cornerRadius = 1.0;//通过该值来设置textView边角的弧度
    adviceWord.layer.masksToBounds = YES;
    
    
//    //赠送对象
    self.familyArray = [[NSArray alloc]initWithObjects:@"张非(语文老师)",@"张日(语文老师)",@"张个(语文老师)",@"李芙(语文老师)",nil];
    self.familyCombox = [[WJCommboxView alloc] initWithFrame:CGRectMake(100, 45, 250, 30)];
    self.familyCombox.textField.placeholder = @"请选择赠送对象";
    self.familyCombox.textField.textAlignment = NSTextAlignmentLeft;
    self.familyCombox.textField.tag = 101;
    self.familyCombox.dataArray = self.familyArray;
//    [self.view addSubview:self.familyCombox];
    
    self.comBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WinWidth, WinHeight+300)];
    self.comBackView.backgroundColor = [UIColor clearColor];
    self.comBackView.alpha = 0.5;
    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commboxHidden)];
    [self.comBackView addGestureRecognizer:singleTouch];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commboxAction:) name:@"commboxNotice"object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commboxAction2:) name:@"commboxNotice2"object:nil];
    
}

-(void)affirmBtn{
    
    if([flowersText.text intValue]>[self.flowersRemain intValue]){
        [SVProgressHUD showErrorWithStatus:@"剩余鲜花不足，赠送失败"];
        return;
    }
    else if([peopleBtn.currentTitle isEqualToString:@"请选择对象"]){
        [SVProgressHUD showErrorWithStatus:@"请选择赠送对象"];
        return;
    }
    else if([flowersText.text isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"请输入转赠数目"];
        return;
    }
    else if([[flowersText.text substringToIndex:1]isEqualToString:@"0"]){
        [SVProgressHUD showErrorWithStatus:@"赠送数目不能以0开头"];
        return;
    }
    
    else{
        
        flowersRemainLabel.text=[NSString stringWithFormat:@"%i",[self.flowersRemain intValue]-[flowersText.text intValue]];
        //sent
        NSString *urlStr = @"http://www.xingxingedu.cn/Global/give_fbasket";
        NSDictionary *dict = @{@"appkey":APPKEY,
                               @"backtype":BACKTYPE,
                               @"xid":XID,
                               @"user_id":USER_ID,
                               @"user_type":USER_TYPE,
                               @"tid":KTID,
                               @"num":flowersText.text,
                               @"con":adviceWord.text,
                               };
        
        [WZYHttpTool post:urlStr params:dict success:^(id responseObj) {
            NSDictionary *dict =responseObj;
//            NSLog(@"==========dict==============%@",dict); 
            if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
            {
                
                UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"赠送成功" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"继续赠送" style:UIAlertActionStyleCancel handler:nil];
                UIAlertAction *ok=[UIAlertAction actionWithTitle:@"离开" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }];
                [alert addAction:ok];
                [alert addAction:cancel];
                [self presentViewController:alert animated:YES completion:nil];
  
            }
            
        } failure:^(NSError *error) {
            
        }];
        
        
    }
    
}

-(void)flowersHistory{
    [self.navigationController pushViewController:[FlowersHistoryTableViewController alloc] animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)commboxAction:(NSNotification *)notif{
    switch ([notif.object integerValue]) {
        case 101:
            [self.self.familyCombox removeFromSuperview];
            [self.view addSubview:self.comBackView];
            [self.view addSubview:self.familyCombox];
            break;
        default:
            break;
    }
    
}

- (void)commboxAction2:(NSNotification *)notif{
    
    [self.comBackView removeFromSuperview];
}

- (void)commboxHidden{
    [self.comBackView removeFromSuperview];
    
    [self.familyCombox setShowList:NO];
    self.familyCombox.listTableView.hidden = YES;
    
    CGRect sf = self.familyCombox.frame;
    sf.size.height = 30;
    self.familyCombox.frame = sf;
    CGRect frame = self.familyCombox.listTableView.frame;
    frame.size.height = 0;
    self.familyCombox.listTableView.frame = frame;
    
    [self.familyCombox removeFromSuperview];
    [self.view addSubview:self.familyCombox];
}

-(void)openAddressBook{
    
    FbasketGiveViewController *fbascktGiveVC =[[FbasketGiveViewController alloc]init];
        fbascktGiveVC.isFlowerView = YES;
        [fbascktGiveVC ReturnTextBlock:^(NSString *text) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [peopleBtn setTitle:text forState:UIControlStateNormal];
    
            });
        }];
    [fbascktGiveVC ReturnIDBlock:^(NSString *text) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
              KTID =text;
            
        });

    }];

    [self.navigationController pushViewController:fbascktGiveVC animated:NO];
   

}
@end
