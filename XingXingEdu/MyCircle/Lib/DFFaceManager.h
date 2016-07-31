//
//  DFPluginsManager.h
//  DFWeChatView
//
//  Created by keenteam on 16/2/1.
//  Copyright © 2016年 xingxingEdu. All rights reserved.
//

#import "MLExpressionManager.h"



@interface DFFaceManager : NSObject


+(instancetype) sharedInstance;

-(MLExpression *) sharedMLExpression;

@end
