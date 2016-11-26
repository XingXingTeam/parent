//
//  ZXOrderCell.m
//  XingXingStore
//
//  Created by codeDing on 16/3/2.
//  Copyright © 2016年 codeDing. All rights reserved.
//

#import "ZXOrderCell.h"
#import "ZXOrderModel.h"
#import <UIImageView+WebCache.h>
@interface ZXOrderCell ()

@end

@implementation ZXOrderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    _BgView.frame = CGRectMake(0, 0, kWidth, 105);
    // Configure the view for the selected state
}

- (void)setOrder:(ZXOrderModel *)order {
    
    _order = order;
    
    NSString *goodsIconUrl = [NSString new];
    goodsIconUrl = [NSString stringWithFormat:@"http://www.xingxingedu.cn/Public/%@",order.orderImage];
     [_orderImage sd_setImageWithURL:[NSURL URLWithString:goodsIconUrl]  placeholderImage:[UIImage imageNamed:@"sdimg1.png"]];
    _orderIDLabel.text = [NSString stringWithFormat:@"订单编号:%@",order.order_index];
    _orderTimeLabel.text =  [NSString stringWithFormat:@"下单时间:%@",[CodeDingUtil timestampToTimeWith: order.orderTime]];
    _orderTypeName.text =order.orderGoodsName;
    _orderPriceLabel.text =order.orderSalePrice;
    _orderXingMoney.text=order.orderSaleXingMoney;
    
    if ([[NSString stringWithFormat:@"%@",order.ordercondit] isEqualToString:@"0"]) {
         _orderCondit.text=@"待付款";
        _orderCondit.userInteractionEnabled = NO;
        
    }
    else if ([[NSString stringWithFormat:@"%@",order.ordercondit] isEqualToString:@"1"]) {
        if ([order.orderGoodsName isEqualToString:@"花篮"]) {
            _orderCondit.text = @"已支付";
        }else{
            _orderCondit.text = @"待发货";
        }
        _orderCondit.userInteractionEnabled = NO;
        
    }
    else if ([[NSString stringWithFormat:@"%@",order.ordercondit] isEqualToString:@"2"]) {
        
        _orderCondit.text=@"待收货";
        _orderCondit.userInteractionEnabled = NO;
        
    }else if ([[NSString stringWithFormat:@"%@",order.ordercondit] isEqualToString:@"3"]) {
        
        _orderCondit.text=@"已完成";
        _orderCondit.userInteractionEnabled = NO;
        
    }else if ([order.ordercondit intValue] >= 10){
        
//        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(buttonpress)];
        _orderCondit.text=@"查看详情";
//        _orderCondit.userInteractionEnabled = YES;
//        [_orderCondit addGestureRecognizer:singleTap];
    }
   
}

-(void)buttonpress{


}





@end
