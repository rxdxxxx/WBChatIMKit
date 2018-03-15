//
//  WBChatListDao.h
//  WBChat
//
//  Created by RedRain on 2018/1/17.
//  Copyright © 2018年 RedRain. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "WBCoreConfiguration.h"
#import "WBChatListModel.h"

NS_ASSUME_NONNULL_BEGIN

//  此张表记录的数据, 均是AVOS提供的数据,
//  客户端产生的行为数据如: 草稿,置顶等信息存放在 WBChatInfoDao 中
@interface WBChatListDao : NSObject
WB_SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(WBChatListDao)

- (BOOL)createDBTable;

/**
 插入会话信息
 */
- (void)insertChatListModel:(WBChatListModel *)chatListModel;

/**
 插入会话信息
 */
- (void)insertChatListModelArray:(NSArray<WBChatListModel *> * )chatListModelArray;

/**
 加载本地会话列表
 */
- (void)loadChatListWithClient:(AVIMClient *)client result:(void (^)(NSArray<WBChatListModel *> *modelArray))resultBlock;

/**
 查询一个本地是否有某个会话
 */
- (BOOL)isExistWithConversationId:(NSString *)conversationId;

/**
 根据conversationId,删除一个本地的会话
 */
- (BOOL)deleteConversation:(NSString *)conversationId;
#pragma mark - 获取到一个AVIMConversation

/**
 单独获取某个WBChatListModel对象
 */
- (WBChatListModel *)chatListModelWithConversationId:(NSString *)conversationId client:(AVIMClient *)client;

@end
NS_ASSUME_NONNULL_END
