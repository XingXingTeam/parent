//
//  ClassRoomOrderAppraiseViewController.m
//  XingXingEdu
//
//  Created by codeDing on 16/3/31.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "ClassRoomOrderAppraiseViewController.h"
#import "StarView.h"
#import "FSImagePickerView.h"
#import "SVProgressHUD.h"
#import "ClassRoomOrderViewController.h"
#import "FSImageModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface ClassRoomOrderAppraiseViewController ()<StarDelegate,UITextViewDelegate>{
    NSInteger _starViewNumber1;
    NSInteger _starViewNumber2;
    NSInteger _starViewNumber3;
    NSInteger _starViewNumber4;
    NSMutableArray *_imagesArr;

}

@end

@implementation ClassRoomOrderAppraiseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self creatUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"tongzhi" object:nil];
    
}

- (void)tongzhi:(NSNotification *)text{
    
    _imagesArr = [NSMutableArray array];
    _imagesArr = [NSMutableArray arrayWithArray:text.userInfo[@"assets"]];
    
}
-(void)creatUI{
    //评价星星
    StarView *star1 = [[StarView alloc] initWithFrame:CGRectMake(-30, 0, self.starView1.frame.size.width, 35)];
    star1.delegate = self;
    star1.tag = 1;
    [self.starView1 addSubview:star1];
    
    StarView *star2 = [[StarView alloc] initWithFrame:CGRectMake(-30, 0, self.starView2.frame.size.width , 35)];
    star2.delegate = self;
    star2.tag = 2;
    [self.starView2 addSubview:star2];
    
    StarView *star3 = [[StarView alloc] initWithFrame:CGRectMake(-30, 0, self.starView3.frame.size.width , 35)];
    star3.delegate = self;
    star3.tag = 3;
    [self.starView3 addSubview:star3];
    
    StarView *star4 = [[StarView alloc] initWithFrame:CGRectMake(-30, 0, self.starView4.frame.size.width, 35)];
    star4.delegate = self;
    star4.tag = 4;
    [self.starView4 addSubview:star4];
    
    UIImageView *line1=[self createImageViewFrame:CGRectMake(_courseL.x, _courseL.y + _courseL.size.height + 5, kWidth - _courseL.x, 1) imageName:nil color:[UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:.3]];
    UIImageView *line2=[self createImageViewFrame:CGRectMake(_courseL.x, _teachL.y + _teachL.size.height + 5, kWidth - _courseL.x, 1) imageName:nil color:[UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:.3]];
    
    UIImageView *line3=[self createImageViewFrame:CGRectMake(_courseL.x, _teacherL.y + _teacherL.size.height + 3, kWidth - _courseL.x, 1) imageName:nil color:[UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:.3]];
    UIImageView *line4=[self createImageViewFrame:CGRectMake(_courseL.x, _attitudeL.y + _attitudeL.size.height + 8, kWidth - _courseL.x, 1) imageName:nil color:[UIColor colorWithRed:180/255.0f green:180/255.0f blue:180/255.0f alpha:.3]];
    
    [self.view addSubview:line1];
    [self.view addSubview:line2];
    [self.view addSubview:line3];
    [self.view addSubview:line4];
    
    //    输入边框
    _assessTextT.layer.backgroundColor = [[UIColor clearColor] CGColor];
    _assessTextT.layer.borderColor = [[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0]CGColor];
    _assessTextT.delegate = self;
    _assessTextT.layer.borderWidth = 1.0;
    _assessTextT.layer.cornerRadius = 8.0f;
    [_assessTextT.layer setMasksToBounds:YES];
    
    //选取照片
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    FSImagePickerView *picker = [[FSImagePickerView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 75) collectionViewLayout:layout];
    picker.showsHorizontalScrollIndicator = NO;
    picker.controller = self;
    [self.photoView addSubview:picker];
    
    
    [_sureBtton setFrame:CGRectMake((kWidth - _sureBtton.size.width)/2, kHeight - 80, _sureBtton.size.width, _sureBtton.size.height)];
    [_sureBtton setImage:[UIImage imageNamed:@"确定评价650x84@2x"] forState:UIControlStateNormal];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidEndEditing:(UITextView *)textView;{
    _assessTextT.text = textView.text;
}

#pragma mark - starViewDelegate
- (void)starView:(UIView *)starView selectIndex:(NSInteger)index
{
    if (starView.tag == 1) {
        _starViewNumber1 = index;
    }
    else if (starView.tag == 2) {
        _starViewNumber2 = index;
    }
    else if  (starView.tag == 3) {
        _starViewNumber3 = index;
    }
    else if  (starView.tag == 4) {
        _starViewNumber4 = index;

    }
    
}
- (IBAction)goBtn:(id)sender {
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"确定评价？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ok=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //传参
        [self requestData];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ClassRoomOrderViewController *  ClassRoomOrderVC = [[ClassRoomOrderViewController alloc] init];
            ClassRoomOrderVC.isAppraiseSuccess = YES;
            [self.navigationController pushViewController:ClassRoomOrderVC animated:YES];
        });
    }];
    [alert addAction:ok];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)requestData{
    
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/publish_course_comment";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"order_id":_orderId,
                           @"c_score_env":[NSString stringWithFormat:@"%ld",(long)_starViewNumber1],
                           @"c_score_quality":[NSString stringWithFormat:@"%ld",(long)_starViewNumber2],
                           @"t_score_cult":[NSString stringWithFormat:@"%ld",(long)_starViewNumber3],
                           @"t_score_attitude":[NSString stringWithFormat:@"%ld",(long)_starViewNumber4],
                           @"con":_assessTextT.text,
                           };
    
    // 服务器返回的数据格式
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [mgr POST:urlStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

            int i=0;
            for ( UIImage *img in _imagesArr) {
                
                NSData *data =UIImagePNGRepresentation(img);
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyy-MM-dd HHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                
                [formData appendPartWithFileData:data name:[NSString stringWithFormat:@"file%@",@(i)] fileName:[NSString stringWithFormat:@"%@%@",str,@(i)] mimeType:@"image/png"];
                i++;
        }
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
//        NSLog(@"=============>%@",responseObject);
          [SVProgressHUD showSuccessWithStatus:@"评价成功"];
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"Error:%@", error);
        
        [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
        
    }];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(UIImageView *)createImageViewFrame:(CGRect)frame imageName:(NSString *)imageName color:(UIColor *)color
{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:frame];
    
    if (imageName)
    {
        imageView.image=[UIImage imageNamed:imageName];
    }
    if (color)
    {
        imageView.backgroundColor=color;
    }
    
    return imageView;
}
@end
