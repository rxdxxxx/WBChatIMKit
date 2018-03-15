//
//  WBChatKit.m
//  WBChat
//
//  Created by RedRain on 2018/1/15.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBChatKit.h"
#import "WBIMClientDelegateImp.h"
#import "WBManagerHeaders.h"
#import "WBMessageModel.h"



@interface WBChatKit ()<AVIMClientDelegate>

/*!
 *  appId
 */
@property (nonatomic, copy, readwrite) NSString *appId;

/*!
 *  appkey
 */
@property (nonatomic, copy, readwrite) NSString *appKey;


/**
 具体实现
 */
@property (nonatomic, strong, readwrite) WBIMClientDelegateImp *clientImp;

@end

@implementation WBChatKit

+ (instancetype)sharedInstance{
    static WBChatKit *_sharedWBChatKit = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedWBChatKit = [[self alloc] init];
    });
    return _sharedWBChatKit;
}

- (AVIMClient *)usingClient{
    return self.clientImp.client;
}

- (BOOL)connect{
    return self.clientImp.connect;
}
- (AVIMClientStatus)connectStatus{
    return self.usingClient.status;
}
#pragma mark - 设置id和key
+ (void)setAppId:(NSString *)appId clientKey:(NSString *)appKey {
    [AVIMClient setUnreadNotificationEnabled:YES];
    [AVOSCloud setApplicationId:appId clientKey:appKey];
    [WBChatKit sharedInstance].appId = appId;
    [WBChatKit sharedInstance].appKey = appKey;
}

#pragma mark - 开启与服务器的连接
- (void)openWithClientId:(NSString *)clientId success:(void (^)(NSString *))successBlock error:(void (^)(NSError *))errorBlock{
    [self openWithClientId:clientId force:YES success:successBlock error:errorBlock];
}


/**
 开启一个账户的聊天
 
 @param clientId 连接Id
 @param force 是否使用单点登录
 */
- (void)openWithClientId:(NSString *)clientId force:(BOOL)force success:(void (^)(NSString *))successBlock error:(void (^)(NSError *))errorBlock{
    // 防止反复的开启, 先关闭上一个数据库
    if (self.clientImp) {
        [[WBUserManager sharedInstance] closeDB];
    }
    
    self.clientImp = [[WBIMClientDelegateImp alloc] init];
    [self.clientImp openWithClientId:clientId force:force success:successBlock error:errorBlock];
    
}


- (void)closeWithCallback:(void (^)(BOOL succeeded, NSError *error))callback {
    __weak typeof(self)weakSelf = self;
    [self.usingClient closeWithCallback:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            weakSelf.clientImp = nil;
            [[WBUserManager sharedInstance] closeDB];
        }
        callback(succeeded, error);
    }];
}


#pragma mark - 拉取本地的所有对话
/**
 拉取本地的所有对话
 */
- (void)fetchAllConversationsFromLocal:(void(^_Nullable)(NSArray<WBChatListModel *> * _Nullable conersations,
                                                         NSError * _Nullable error))block{
    [[WBChatListManager sharedInstance] fetchAllConversationsFromLocal:block];
}
#pragma mark - 加载聊天记录
/**
 加载聊天记录
 
 @param conversation 对应的会话
 @param queryMessage 锚点message, 如果是nil:(该方法能确保在有网络时总是从服务端拉取最新的消息，首次拉取必须使用是nil或者sendTimestamp为0)
 @param limit 拉取的条数
 */
- (void)queryTypedMessagesWithConversation:(AVIMConversation *)conversation
                              queryMessage:(AVIMMessage * _Nullable)queryMessage
                                     limit:(NSInteger)limit
                                   success:(void (^)(NSArray<WBMessageModel *> *messageArray))successBlock
                                     error:(void (^)(NSError *error))errorBlock{
    [[WBChatManager sharedInstance]
     queryTypedMessagesWithConversation:conversation
     queryMessage:queryMessage
     limit:limit
     block:^(NSArray * _Nullable array, NSError * _Nullable error) {
         if (error && errorBlock) {
             errorBlock(error);
         }else if(successBlock){
             NSMutableArray *temp = [NSMutableArray new];
             for (AVIMTypedMessage *imMessage in array) {
                 WBMessageModel *message = [WBMessageModel createWithTypedMessage:imMessage];
                 [temp addObject:message];
             }
             successBlock(temp);
         }
     }];
}

#pragma mark - 创建一个Conversation

/**
 根据传入姓名和成员,获取到相应的Conversation对象
 
 @param name 会话的名称
 @param members 成员clientId的数组
 */
- (void)createConversationWithName:(NSString *)name
                           members:(NSArray *)members
                           success:(void (^)(AVIMConversation *convObj))successBlock
                             error:(void (^)(NSError *error))errorBlock{
    
    [[WBChatManager sharedInstance]
     createConversationWithName:name
     members:members
     reuseConversation:YES
     callback:^(AVIMConversation * _Nullable con, NSError * _Nullable error)
     {
         if (error && errorBlock) {
             errorBlock(error);
         }else if(successBlock){
             successBlock(con);
         }
     }];
}
#pragma mark - 往对话中发送消息。
/*!
 往对话中发送消息。
 @param message － 消息对象
 */
- (void)sendTargetConversation:(AVIMConversation *)targetConversation
                       message:(WBMessageModel *)message
                       success:(nonnull void (^)(WBMessageModel *aMessage))successBlock
                         error:(nonnull void (^)(WBMessageModel *aMessage,NSError * _Nonnull))errorBlock{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        [[WBChatManager sharedInstance]
         sendTargetConversation:targetConversation
         message:message
         callback:^(BOOL success, NSError * _Nullable error)
         {
             
             // 1.更新消息到聊天列表页面
             [[WBChatListManager sharedInstance] insertConversationToList:targetConversation];
             
             dispatch_async(dispatch_get_main_queue(), ^(void) {
                 if (error && errorBlock) {
                     message.status = AVIMMessageStatusFailed;
                     
                     errorBlock(message,error);
                     
                 }else if(successBlock){
                     
                     message.status = AVIMMessageStatusSent;
                     successBlock(message);
                 }
             });
             
         }];
        
        
    });
}

- (void)sendTargetUserId:(NSString *)userID
                 message:(WBMessageModel *)message
                 success:(void (^)(WBMessageModel * _Nonnull))successBlock
                   error:(void (^)(WBMessageModel * _Nonnull, NSError * _Nonnull))errorBlock{
    
    [self createConversationWithName:userID
                             members:@[userID]
                             success:^(AVIMConversation * _Nonnull convObj)
    {
        [self sendTargetConversation:convObj message:message success:successBlock error:errorBlock];
        
    } error:^(NSError * _Nonnull error) {
        if (errorBlock) {
            errorBlock(message,error);
        }
    }];
    
}

#pragma mark - 改变某个会话的会话状态
/**
 阅读了某个会话
 
 @param conversation 被阅读的会话
 */
- (void)readConversation:(AVIMConversation *)conversation{
    [[WBChatListManager sharedInstance] readConversation:conversation];
}

#pragma mark - 删除一个会话
- (void)deleteConversation:(NSString *)conversationId{
    [[WBChatListManager sharedInstance] deleteConversation:conversationId];
}
#pragma mark - 获取会话的信息
- (WBChatInfoModel *)chatInfoWithID:(NSString *)conversationId{
    return [[WBChatManager sharedInstance] chatInfoWithID:conversationId];
}

#pragma mark - 草稿
- (BOOL)saveConversation:(NSString *)conversationId draft:(NSString *)draft{
    return [[WBChatManager sharedInstance] saveConversation:conversationId draft:draft];
}

@end


void do_dispatch_async_mainQueue(dispatch_block_t _Nullable task) {
    if ([NSThread isMainThread]){
        task();
    }else{
        dispatch_async(dispatch_get_main_queue(), task);
    }
}

