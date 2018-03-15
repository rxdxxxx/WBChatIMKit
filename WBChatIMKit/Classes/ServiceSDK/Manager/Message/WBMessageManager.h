//
//  WBMessageManager.h
//  WBChat
//
//  Created by RedRain on 2018/1/27.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBCoreConfiguration.h"
#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudIM/AVOSCloudIM.h>

#define WBMessageConversationKey @"conversation"
#define WBMessageMessageKey @"message"


#define WBMessageNewReceiveNotification @"WBMessageNewReceiveNotification"


NS_ASSUME_NONNULL_BEGIN

@interface WBMessageManager : NSObject
WB_SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(WBMessageManager)


/**
 收到新的消息
 */
- (void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message;

@end
NS_ASSUME_NONNULL_END
