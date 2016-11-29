//
//  XXEReportModel.h
//  teacher
//
//  Created by codeDing on 16/8/26.
//  Copyright © 2016年 XingXingEdu. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface XXEReportModel : JSONModel

/** 举报字的Id */
@property (nonatomic, copy)NSString <Optional>*reportId;

/** 举报的文字 */
@property (nonatomic, copy)NSString <Optional>*reportName;

@end
