//
//  WBChatInfoDao.h
//  WBChat
//
//  Created by RedRain on 2018/1/18.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBCoreConfiguration.h"
#import "WBChatInfoModel.h"

#define WBChatInfoDaoTableName @"t_ChatInfo"
#define WBChatInfoDaoKeyDraft @"draft"
#define WBChatInfoDaoKeyTopTime @"topTime"
#define WBChatInfoDaoKeyId @"conversationID"
#define WBChatInfoDaoKeyBGFileID @"conversationBGFileID"
#define WBChatInfoDaoKeyExtend @"extend"

NS_ASSUME_NONNULL_BEGIN
@interface WBChatInfoDao : NSObject
WB_SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(WBChatInfoDao)

- (BOOL)createDBTable;

/**
 根据conversationId,删除一个本地的会话
 */
- (BOOL)deleteConversation:(NSString *)conversationId;

- (WBChatInfoModel *)chatInfoWithID:(NSString *)conversationId;

- (BOOL)saveConversation:(NSString *)conversationId draft:(NSString *)draft;

@end
NS_ASSUME_NONNULL_END
