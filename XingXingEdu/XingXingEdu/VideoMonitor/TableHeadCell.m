//
//  TableHeadCell.m
//  XingXingEdu
//
//  Created by keenteam on 16/2/16.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "TableHeadCell.h"

@implementation TableHeadCell

- (void)awakeFromNib {
    // Initialization code
}
// 模拟发送数据,3秒之后隐藏
- (IBAction)clickBtn:(UIButton*)sender {
   
    
    
    if (self.grayActivity.isAnimating) {
                   [self.grayActivity stopAnimating];
                    [sender setTitle:@"加载更多" forState:UIControlStateNormal];
      
       
    }
    else{
      
        [self.grayActivity startAnimating];
            
            [sender setTitle:@"正在拼命加载中....." forState:UIControlStateNormal];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [self.grayActivity stopAnimating];
            [sender setTitle:@"加载更多" forState:UIControlStateNormal];
        });
        
    }
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
