//
//  NSDate+WBExt.m
//  WBChat
//
//  Created by RedRain on 2018/1/17.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "NSDate+WBExt.h"

@implementation NSDate (WBExt)
+ (NSString *)wb_currentTimeStamp{
    return @([[NSDate date]timeIntervalSince1970] * 1000).stringValue;
}
- (NSString *)wb_currentTimeStamp{
    return @([self timeIntervalSince1970] * 1000).stringValue;
}
@end
