//
//  NSDate+Extension.m
//  CMBMobileBank
//
//  Created by Jason Ding on 15/12/8.
//  Copyright © 2015年 efetion. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)


/**
 *  判断某个时间是否为今年
 */
- (BOOL)wb_isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 获得某个时间的年月日时分秒
    NSDateComponents *dateCmps = [calendar components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *nowCmps = [calendar components:NSCalendarUnitYear fromDate:[NSDate date]];
    return dateCmps.year == nowCmps.year;
}

/**
 *  判断某个时间是否为昨天
 */
- (BOOL)wb_isYesterday
{
    NSDate *now = [NSDate date];
    
    // date ==  2014-04-30 10:05:28 --> 2014-04-30 00:00:00
    // now == 2014-05-01 09:22:10 --> 2014-05-01 00:00:00
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    // 2014-04-30
    NSString *dateStr = [fmt stringFromDate:self];
    // 2014-10-18
    NSString *nowStr = [fmt stringFromDate:now];
    
    // 2014-10-30 00:00:00
    NSDate *date = [fmt dateFromString:dateStr];
    // 2014-10-18 00:00:00
    now = [fmt dateFromString:nowStr];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmps = [calendar components:unit fromDate:date toDate:now options:0];
    
    return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;
}

/**
 *  判断某个时间是否为今天
 */
- (BOOL)wb_isToday
{
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *dateStr = [fmt stringFromDate:self];
    NSString *nowStr = [fmt stringFromDate:now];
    
    return [dateStr isEqualToString:nowStr];
}

+ (BOOL)isDate:(long long)dateNumber1 inSameDayAsDate:(long long)dateNumber2{
    
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:dateNumber1];
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:dateNumber2];

    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *dateStr1 = [fmt stringFromDate:date1];
    NSString *dateStr2 = [fmt stringFromDate:date2];
    
    return [dateStr1 isEqualToString:dateStr2];
    
}

- (NSString *)rr_formatStrig{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [fmt stringFromDate:self];
}

- (NSString *)wb_chatListTimeString{
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 如果是真机调试，转换时间，需要设置locale
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    
    NSDate *createDate = self;
    
    // 当前时间
    if ([createDate wb_isToday]) { // 今天
        
        fmt.dateFormat = @"HH:mm";
        return [fmt stringFromDate:createDate];
        
    } else if ([createDate wb_isYesterday]) { // 昨天
        
        return @"昨天";
        
    } else { // 其他日子
        fmt.dateFormat = @"MM月dd日";
        return [fmt stringFromDate:createDate];
    }
}


+ (BOOL)wb_miniteInterval:(NSInteger)miniteInterval firstTime:(long long)firstTime secondTime:(long long)secondTime{
    
    BOOL outFiftten = NO;
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    if (firstTime > 10000000000) {
        firstTime /= 1000;
    }
    if (secondTime > 10000000000) {
        secondTime /= 1000;
    }
    NSDate *firstDate = [NSDate dateWithTimeIntervalSince1970:firstTime];
    NSDate *secondDate = [NSDate dateWithTimeIntervalSince1970:secondTime];
    
    NSTimeInterval time=[secondDate timeIntervalSinceDate:firstDate];
    
    if (fabs(time / 60) > miniteInterval) {
        outFiftten = YES;
    }
    return outFiftten;
}

@end
