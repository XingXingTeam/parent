//
//  DFTextImageLineItem.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFTextImageLineItem.h"


@implementation DFTextImageLineItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        _text = @"";
        _thumbImages = [NSMutableArray array];
        _srcImages = [NSMutableArray array];
    }
    return self;
}

-(void)configure:(XXECircleModel*)circleModel {
    self.userId = [circleModel.xid intValue];
    
    if ([circleModel.head_img_type isEqual: @"0"]) {
        self.userAvatar = [NSString stringWithFormat:@"%@%@",picURL,circleModel.head_img];
    } else if ([circleModel.head_img_type  isEqual: @"1"]) {
        self.userAvatar = circleModel.head_img;
    }
    
    self.talkId = circleModel.talkId;
    self.userNick = circleModel.nickname;
    self.title = @"发表了";
    self.text = circleModel.words;
    self.location = circleModel.position;
//    NSString *timeString = [XXETool dateAboutStringFromNumberTimer:circleModel.date_tm];
    //            NSLog(@"时间:%@",timeString);
    self.ts = [circleModel.date_tm integerValue]*1000;;
    self.speak_Id = circleModel.talkId;

}

-(void)configureWithGoodUser:(XXEGoodUserModel*)model {
    self.userNick = model.goodNickName;
    self.userId = [model.goodXid integerValue];
}

@end
