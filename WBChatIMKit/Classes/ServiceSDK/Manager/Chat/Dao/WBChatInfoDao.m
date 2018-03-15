//
//  WBChatInfoDao.m
//  WBChat
//
//  Created by RedRain on 2018/1/18.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBChatInfoDao.h"


@implementation WBChatInfoDao
WB_SYNTHESIZE_SINGLETON_FOR_CLASS(WBChatInfoDao)

- (BOOL)createDBTable{
    __block BOOL ret = NO;
    NSString *sql =@"CREATE TABLE IF NOT EXISTS t_ChatInfo(\
    conversationID          VARCHAR(63) PRIMARY KEY,\
    topTime                 INTEGER DEFAULT 0,\
    conversationBGFileID    Text,\
    draft                   Text,\
    extend                  Text\
    );";
    
    [[WBDBClient sharedInstance].dbQueue inDatabase:^(FMDatabase *db) {
        ret = [db executeUpdate:sql];
    }];
    return ret;
}

- (WBChatInfoModel *)chatInfoWithID:(NSString *)conversationId{
    if (conversationId == nil) {
        return nil;
    }
    __block WBChatInfoModel * infoModel = nil;
    [[WBDBClient sharedInstance].dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *selectSQl =@"SELECT * FROM t_ChatInfo where conversationID = ?;";
        FMResultSet *set = [db executeQuery:selectSQl withArgumentsInArray:@[conversationId]];
        if ([set next]) {
            infoModel = [WBChatInfoModel new];
            infoModel.conversationID = conversationId;
            infoModel.topTime = [set intForColumn:WBChatInfoDaoKeyTopTime];
            infoModel.conversationBGFileID = [set stringForColumn:WBChatInfoDaoKeyBGFileID];
            infoModel.draft = [set stringForColumn:WBChatInfoDaoKeyDraft];
            infoModel.extend = [set stringForColumn:WBChatInfoDaoKeyExtend];
        }
        [set close];
        
    }];
    return infoModel;
}

- (BOOL)saveChatInfo:(WBChatInfoModel *)infoModel{
    if (infoModel.conversationID.length == 0) {
        return NO;
    }
    
    __block BOOL result=NO;
    
    [[WBDBClient sharedInstance].dbQueue inDatabase:^(FMDatabase *db) {
        
        // 1.把基本信息,插入list表中
        NSString *sql = @"INSERT OR REPLACE INTO " WBChatInfoDaoTableName @" ("
        WBChatInfoDaoKeyId             @", "
        WBChatInfoDaoKeyTopTime        @", "
        WBChatInfoDaoKeyBGFileID       @", "
        WBChatInfoDaoKeyDraft          @", "
        WBChatInfoDaoKeyExtend
        @") VALUES(?, ?, ?, ?, ?);";
        
        result = [db executeUpdate:sql withArgumentsInArray:
                  @[infoModel.conversationID,
                    @(infoModel.topTime),
                    infoModel.conversationBGFileID.length ? infoModel.conversationBGFileID : @"",
                    infoModel.draft.length ? infoModel.draft : @"",
                    infoModel.extend.length ? infoModel.extend : @""
                    ]
                  ];
        
    }];
    return result;
}

/**
 根据conversationId,删除一个本地的会话
 */
- (BOOL)deleteConversation:(NSString *)conversationId{
    __block BOOL isExist=NO;
    
    [[WBDBClient sharedInstance].dbQueue inDatabase:^(FMDatabase *db) {
        
        NSString *selectSQl =@"DELETE FROM t_ChatInfo where conversationID = ?;";
        FMResultSet *set = [db executeQuery:selectSQl withArgumentsInArray:@[conversationId]];
        if ([set next]) {
            isExist=YES;
        }
        [set close];
        
    }];
    return isExist;
    
}



- (BOOL)saveConversation:(NSString *)conversationId draft:(NSString *)draft{
    WBChatInfoModel *chatInfo = [self chatInfoWithID:conversationId];
    if (chatInfo == nil) {
        chatInfo = [WBChatInfoModel new];
        chatInfo.conversationID = conversationId;
    }
    chatInfo.draft = draft;
    return [self saveChatInfo:chatInfo];
}


@end
