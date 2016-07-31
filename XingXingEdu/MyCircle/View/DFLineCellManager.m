//
//  DFLineCellAdapterManager.m
//  DFTimelineView
//
//  Created by keenteam on 16/2/1.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "DFLineCellManager.h"

@interface DFLineCellManager()

@property (strong, nonatomic) NSMutableDictionary *dic;

@end



@implementation DFLineCellManager

static DFLineCellManager  *_manager=nil;


#pragma mark - Lifecycle

+(instancetype) sharedInstance
{
    @synchronized(self){
        if (_manager == nil) {
            _manager = [[DFLineCellManager alloc] init];
        }
    }
    return _manager;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _dic = [NSMutableDictionary dictionary];
        
        [self registerCell:[DFTextImageLineItem class] cellClass:[DFTextImageLineCell class]];
        [self registerCell:[DFVideoLineItem class] cellClass:[DFVideoLineCell class]];

    }
    return self;
}



#pragma mark - Method


-(void) registerCell:(Class) itemClass cellClass:(Class) cellClass
{
    [_dic setObject:[[cellClass alloc] init]  forKey:NSStringFromClass(itemClass)];
}


-(DFBaseLineCell *) getCell:(Class) itemClass
{
    return [_dic objectForKey:NSStringFromClass(itemClass)];
}


@end
