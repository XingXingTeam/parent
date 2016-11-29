//
//  CGFloat_Extension.h
//  teacher
//
//  Created by codeDing on 16/11/22.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//



@interface CGFloat ()
-(CGFloat)sw {
    return self * kScreenRatioWidth;
}

-(CGFloat)sh {
    return self * kScreenRatioHeight;
}
@end
