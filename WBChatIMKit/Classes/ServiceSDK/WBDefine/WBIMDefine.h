//
//  WBDefine.h
//  WBChat
//
//  Created by RedRain on 2018/1/15.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef WBIMDefine
#define WBIMDefine


#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudIM/AVOSCloudIM.h>


#define WBIMConversationFindErrorDomain @"WBIMConversationFindErrorDomain" ///< 查询会话信息


#define WBIM_CONVERSATION_TYPE @"type"
#define WBIMCustomMessageDegradeKey @"degrade"
#define WBIMCustomMessageIsCustomKey @"isCustom"


typedef NS_ENUM(NSUInteger, WBChatListCellType) {
    // 防止未明确赋值
    WBChatListCellTypeNone = 0,
    // 默认样式
    WBChatListCellTypeNormal = 1
};

typedef NS_ENUM(NSUInteger, WBConversationType) {
    // 防止未明确赋值
    WBConversationTypeNone = 0,
    // 单聊
    WBConversationTypeSingle = 1,
    // 讨论组
    WBConversationTypeDiscussion = 2,
    // 群组
    WBConversationTypeGroup = 3,
    // 聊天室
    WBConversationTypeChatRoom = 4
};

typedef NS_ENUM(NSUInteger, WBReceivedStatus) {
    // 防止未明确赋值
    WBReceivedStatusNone = 0,
    // 未读
    WBReceivedStatusUnread = 1,
    // 已读
    WBReceivedStatusRead = 2,
    // 语音已读
    WBReceivedStatusListened = 3
};

typedef NS_ENUM(NSUInteger, WBSentStatus) {
    // 防止未明确赋值
    WBSentStatusNone = 0,
    // 发送中
    WBSentStatusSending = 1,
    // 发送失败
    WBSentStatusFailed = 2,
    // 发送成功
    WBSentStatusSended = 3
};

typedef NS_ENUM(NSUInteger, WBMessageDirection) {
    // 防止未明确赋值
    WBMessageDirectionNone = 0,
    // 发送
    WBMessageDirectionSent = 1,
    // 接收
    WBMessageDirectionReceived = 2
};



/**
 用户使用国际化文件,展示UI界面

 @param key 统一key值
 @return 根据环境返回的字符串
 */
#ifndef WBIMLocalizedStrings
#define WBIMLocalizedStrings(key) \
NSLocalizedStringFromTableInBundle(key, @"LCChatKitString", [NSBundle lcck_bundleForName:@"Other" class:[self class]], nil)
#endif


#ifdef DEBUG
#define WBIMLog(fmt, ...) NSLog((@"\n%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__);
#else
#define WBIMLog(...)
#endif



#endif /* WBConfig_pch */
