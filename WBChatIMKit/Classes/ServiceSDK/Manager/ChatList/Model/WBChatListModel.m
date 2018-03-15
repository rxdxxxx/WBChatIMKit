//
//  WBChatListModel.m
//  WBChat
//
//  Created by RedRain on 2018/1/17.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBChatListModel.h"
#import "NSDate+WBExt.h"

@implementation WBChatListModel

+ (instancetype)createWithConversation:(AVIMConversation *)conversation{
    WBChatListModel *list = [WBChatListModel new];
    list.conversationID = conversation.conversationId;
    list.conversation = conversation;
    list.unreadCount = conversation.unreadMessagesCount;
    list.lastMessageAt = conversation.lastMessageAt.wb_currentTimeStamp.integerValue;
    list.mentioned = conversation.lastMessage.mentioned;
    return list;
}

@end
