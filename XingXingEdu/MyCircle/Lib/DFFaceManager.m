//
//  DFPluginsManager.m
//  DFWeChatView
//
//  Created by keenteam on 16/2/1.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "DFFaceManager.h"

@interface DFFaceManager()


@property (strong, nonatomic) NSMutableArray *emotions;

@property (strong, nonatomic) MLExpression *expression;

@end


@implementation DFFaceManager

static  DFFaceManager *_manager=nil;


#pragma mark - Lifecycle

+(instancetype) sharedInstance
{
    @synchronized(self){
        if (_manager == nil) {
            _manager = [[DFFaceManager alloc] init];
        }
    }
    return _manager;
}




- (instancetype)init
{
    self = [super init];
    if (self) {
        _emotions = [NSMutableArray array];
    }
    return self;
}





#pragma mark - Method


-(MLExpression *)sharedMLExpression
{
    if (_expression == nil) {
        _expression = [MLExpression expressionWithRegex:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]" plistName:@"Expression" bundleName:@"ClippedExpression"];
    }
    
    return _expression;
}

@end
