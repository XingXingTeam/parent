//
//  ZJCircularBtn.m
//  CircularBtn
//
//  Created by zhuoyue on 16/3/14.
//  Copyright © 2016年 YZ. All rights reserved.
//

#import "ZJCircularBtn.h"



@implementation ZJCircularBtn

-(void)createCircularBtnWithBtnNum:(NSInteger)btnNum center:(CGPoint)center raiuds:(CGFloat)raiuds btnRaiuds:(CGFloat)btnRaiuds btnImages:(NSArray *)imageArray titleArray:(NSArray *)titleArray superView:(UIView *)superView{
    
//    NSLog(@"imageArray ---  %@", imageArray);
    
    
    for (int i = 0; i < btnNum; i++) {
        
        CGFloat x = raiuds*(cosf(M_PI_2 +(i - 1)*M_PI*2/btnNum)) * 0.8;
        
        CGFloat y = raiuds*(sinf(M_PI_2 +(i - 1)*M_PI*2/btnNum)) * 0.8;
        
        CGPoint point1 = CGPointMake(center.x - x,center.y - y);
        
        NSDictionary *dic = imageArray[i];
    
        //判断头像 用户上传的头像,http:代表第三方头像
        //#define picURL    @"http://www.xingxingedu.cn/Public/"
        NSString * head_img;
        if([[NSString stringWithFormat:@"%@",dic[@"head_img_type"]]isEqualToString:@"0"]){
             head_img=[picURL stringByAppendingString:dic[@"head_img"]];
             }else{
             head_img=dic[@"head_img"];
         }
        
        /*
         id = 17,
         head_img = app_upload/text/parent/p12.jpg,
         head_img_type = 0
         */

        UIImageView *familyMemberHeadImageView = [[UIImageView alloc] init];
        [familyMemberHeadImageView sd_setImageWithURL:[NSURL URLWithString:head_img] placeholderImage:[UIImage imageNamed:@"人物头像172x172"]];
        
        UIButton *subBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        subBtn.frame = CGRectMake(0, 0, btnRaiuds, btnRaiuds);
        
        if (titleArray.count > i) {
            
            [subBtn setTitle:titleArray[i] forState:UIControlStateNormal];
            
        }else{

            [subBtn setImage:familyMemberHeadImageView.image forState:UIControlStateNormal];
    
        }
//        subBtn.tag = i;
        subBtn.tag = [dic[@"id"] integerValue];
        [subBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        subBtn.center = point1;
        subBtn.layer.masksToBounds = YES;
        subBtn.layer.cornerRadius = subBtn.frame.size.width/2;
        [superView addSubview:subBtn];
    }

}

-(void)clickBtn:(UIButton *)btn{
    
    [self.delegate clickCircularBtnNum:btn.tag];

}



@end
