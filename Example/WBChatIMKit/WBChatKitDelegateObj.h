//
//  WBChatKitDelegateObj.h
//  WBChatIMKit_Example
//
//  Created by RedRain on 2018/3/14.
//  Copyright © 2018年 Ding RedRain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WBChatIMKit/WBChatIMKit.h>
@interface WBChatKitDelegateObj : NSObject <WBChatKitProtocol>
+ (instancetype)sharedManager;

@end
