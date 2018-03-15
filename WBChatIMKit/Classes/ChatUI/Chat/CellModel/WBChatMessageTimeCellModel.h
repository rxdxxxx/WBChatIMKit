//
//  WBChatMessageTimeCellModel.h
//  WBChat
//
//  Created by RedRain on 2018/3/1.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBChatMessageBaseCellModel.h"

@interface WBChatMessageTimeCellModel : WBChatMessageBaseCellModel

+ (instancetype)modelWithTimeStamp:(NSTimeInterval)timeStamp;

@property (nonatomic, assign) NSTimeInterval timeStamp;

@property (nonatomic, copy) NSString *timeString;

@end
