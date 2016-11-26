//
//  GTButtonTagsView.m
//  GTDynamicLabels
//

#import "GTButtonTagsView.h"

const CGFloat intervalWide = 10.f;     // label间隔宽度

@interface GTButtonTagsView ()

@property (nonatomic, assign) CGRect currentLabelFrame;

@end

@implementation GTButtonTagsView

- (void)awakeFromNib {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"tongzhi" object:nil];
    
    [self getDataArr:@"1"];
    
    
}
- (void)tongzhi:(NSNotification *)text{
    
    
    for (UIView *view in [self subviews])
    {
        if ([view isKindOfClass:[UIView class]])
        {
            [view removeFromSuperview];
        }
    }
    
    NSString *typeStr = text.userInfo[@"textOne"];
    [self getDataArr:typeStr];
    
}

//获取dataArr
- (void)getDataArr:(NSString *)type
{
    self.dataArr = [NSMutableArray array];
    NSString *urlStr = @"http://www.xingxingedu.cn/Global/xkt_top_keywords";
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    NSDictionary *dict = @{@"appkey":APPKEY,
                           @"backtype":BACKTYPE,
                           @"xid":XID,
                           @"user_id":USER_ID,
                           @"user_type":USER_TYPE,
                           @"date_type":type,
                           };
    
    // 服务器返回的数据格式
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer]; // 二进制数据
    [mgr POST:urlStr parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
         
         if([[NSString stringWithFormat:@"%@",dict[@"code"]]isEqualToString:@"1"] )
         {
             self.dataArr = dict[@"data"];
         }
         
         [self createButton];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"请求失败:%@",error);
         [SVProgressHUD showErrorWithStatus:@"网络不通，请检查网络！"];
         
     }];
}


-(void)createButton {
    
    
    
    self.currentLabelFrame = CGRectZero;
    // 布局label
    for (NSInteger i = 0; i < self.dataArr.count; i++) {
        
        NSString *str = self.dataArr[i];
        
        CGFloat x = self.currentLabelFrame.origin.x;
        
        CGFloat y = self.currentLabelFrame.origin.y;
        
        
        if (i != 0) {
            
            x += kWidth /2;
            
        }else {
            
            y += intervalWide;
        }
        CGSize size = [self labelSizeFromString:str];
        
        // 判断label是否到视图边界
        CGFloat minX = x;
        CGFloat maxX = x + size.width;
        
        size.height = 30.0f;
        
        if (maxX > CGRectGetWidth(self.frame)) {
            
            x -= minX;
            y = y + size.height + intervalWide;
        }
        // 计算label的frame
        CGRect rect = CGRectMake(x + 20, y, size.width, size.height);
        self.currentLabelFrame = rect;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = rect;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [button setTitle:str forState:UIControlStateNormal];
        
        UIImageView *phoneImage=[[UIImageView alloc]initWithFrame:CGRectMake(-15, 7,15, 15)];
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        numLabel.backgroundColor = [UIColor clearColor];
        numLabel.textAlignment = NSTextAlignmentCenter;
        numLabel.textColor = [UIColor whiteColor];
        numLabel.text = [NSString stringWithFormat:@"%ld",(long)i];
        numLabel.font = [UIFont systemFontOfSize:12];
        [phoneImage addSubview:numLabel];
        phoneImage.backgroundColor = [UIColor orangeColor];;
        [button addSubview:phoneImage];

        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [self addSubview:button];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

// 根据文本计算label宽度
- (CGSize)labelSizeFromString:(NSString *)str {
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0f]};
    return [str sizeWithAttributes:attributes];
}

// 标签点击事件
- (void)buttonAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(GTButtonTagsView:selectIndex:selectText:)]) {
        [self.delegate GTButtonTagsView:self selectIndex:sender.tag selectText:sender.titleLabel.text];
    }
}

@end
