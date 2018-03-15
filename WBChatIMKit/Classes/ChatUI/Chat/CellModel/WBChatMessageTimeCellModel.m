//
//  WBChatMessageTimeCellModel.m
//  WBChat
//
//  Created by RedRain on 2018/3/1.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBChatMessageTimeCellModel.h"
#import "NSDate+Extension.h"
@implementation WBChatMessageTimeCellModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellType = WBChatMessageTypeTime;
        self.cellHeight = 36;
    }
    return self;
}

+ (instancetype)modelWithTimeStamp:(NSTimeInterval)timeStamp{
    WBChatMessageTimeCellModel *model = [WBChatMessageTimeCellModel new];
    model.timeStamp = timeStamp;
    return model;
}

- (void)setTimeStamp:(NSTimeInterval)timeStamp{
    _timeStamp = timeStamp;
    self.timeString = [self timeStringByTimeStamp:timeStamp];
}

- (NSString *)timeStringByTimeStamp:(long long)timeStamp {
    // 公众号的时间戳, 会多1000.
    if (timeStamp > 10000000000) {
        timeStamp = timeStamp/1000;
    }
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    NSDate *createDate = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    if ([createDate wb_isToday]) {
        fmt.dateFormat = @"HH:mm";
        return [fmt stringFromDate:createDate];
    }else if ([createDate wb_isThisYear]){
        
        fmt.dateFormat = @"MM月dd日 HH:mm";
        return [fmt stringFromDate:createDate];
    }else {
        //如果当前时间是12小时制，就会显示08:07
        fmt.dateFormat = @"yyyy年MM月dd日 HH:mm";
        return [fmt stringFromDate:createDate];
    }
}
@end
