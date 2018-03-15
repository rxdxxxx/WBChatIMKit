//
//  WBChatListModel.h
//  WBChat
//
//  Created by RedRain on 2018/1/17.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBIMDefine.h"
@class AVIMConversation;
@class AVIMMessage;

@interface WBChatListModel : NSObject

@property (nonatomic, copy) NSString *conversationID;           ///< 会话ID
@property (nonatomic, strong) AVIMConversation *conversation;///< 扩展使用
@property (nonatomic, assign) NSInteger unreadCount;///< 会话消息未读数
@property (nonatomic, assign) NSTimeInterval lastMessageAt; // 最后一条消息的时间
@property (nonatomic, assign) BOOL mentioned;///< 是否有人@当前用户
@property (nonatomic, copy) NSString *draft;///< 会话 草稿
@property (nonatomic, assign) BOOL isTop;///< 会话是否置顶
@property (nonatomic, assign) NSTimeInterval topTime;///< 置顶的时间
@property (nonatomic, copy) NSString *extend;///< 扩展使用



/**
 快速通过 IM 对象的到 list对象
 */
+ (instancetype)createWithConversation:(AVIMConversation *)conversation;

@end

