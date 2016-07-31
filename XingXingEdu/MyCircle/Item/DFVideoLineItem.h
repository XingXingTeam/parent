//
//  DFVideoLineItem.h
//  DFTimelineView
//
//  Created by keenteam on 16/2/1.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "DFBaseLineItem.h"
#import "DFVideoDecoder.h"
@interface DFVideoLineItem : DFBaseLineItem

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIImage *thumbImage;
@property (nonatomic, strong) NSString *thumbUrl;

@property (nonatomic, strong) NSString *videoUrl;
@property (nonatomic, strong) NSString *localVideoPath;

@property (nonatomic, strong) NSAttributedString *attrText;

@property (nonatomic, strong) DFVideoDecoder *decorder;

@end
