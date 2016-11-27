//
//  UploadParam.m
//  基于AFNetWorking的再封装
//
//  Created by 吴红星 on 7/26/16.
//  Copyright © 2016 wuhongxing. All rights reserved.
//

#import "UploadParam.h"

@implementation UploadParam
- (void)configureWithData:(NSData*)data name:(NSString*)name filename:(NSString*)filename mimetype:(NSString*)mimetype {
    self.data = data;
    self.name = name;
    self.filename = filename;
    self.mimeType = mimetype;
}
@end
