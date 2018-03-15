//
//  WBIMClientDelegateImp.m
//  WBChat
//
//  Created by RedRain on 2018/1/15.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBIMClientDelegateImp.h"
#import "WBIMDefine.h"
#import "WBManagerHeaders.h"
#import "WBServiceSDKHeaders.h"

@interface WBIMClientDelegateImp ()

@property (nonatomic, strong, readwrite) AVIMClient *client;
@property (nonatomic, copy, readwrite) NSString *clientId;
@property (nonatomic, assign, readwrite) BOOL connect;

@end

@interface WBIMClientDelegateImp (WB_IMDelegate)<AVIMClientDelegate>

@end

@implementation WBIMClientDelegateImp

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
#pragma mark - status

// 除了 sdk 的上面三个回调调用了，还在 open client 的时候调用了，好统一处理
- (void)updateConnectStatus {
    
    self.connect = _client.status == AVIMClientStatusOpened;
    [[NSNotificationCenter defaultCenter] postNotificationName:WBIMNotificationConnectivityUpdated object:@(self.connect)];
}

#pragma mark - Public Methods
- (void)openWithClientId:(NSString *)clientId success:(void (^)(NSString *clientId))successBlock error:(void (^)(NSError *error))errorBlock{
    
    [self openWithClientId:clientId force:YES success:successBlock error:errorBlock];
}

- (void)openWithClientId:(NSString *)clientId force:(BOOL)force success:(void (^)(NSString *clientId))successBlock error:(void (^)(NSError *error))errorBlock{
    
    self.clientId = clientId;
    
    // 1.开启一个此clientId的本地数据库
    [WBUserManager sharedInstance].clientId = clientId;
    [[WBUserManager sharedInstance] openDB];
    
    
    // 2.创建AVIMClient相关对象
    self.client = [[AVIMClient alloc] initWithClientId:clientId];
    self.client.delegate = self;
    
    // 3.开始连接服务器
    AVIMClientOpenOption option = force ? AVIMClientOpenOptionForceOpen : AVIMClientOpenOptionReopen;
    
    [self.client openWithOption:option callback:^(BOOL succeeded, NSError * _Nullable error) {
        
        [self updateConnectStatus];
        
        // 根据结果,调用不同的Block
        
        if (succeeded && successBlock) {
            successBlock(clientId.copy);
            
        }else if (errorBlock){
            errorBlock(error);
        }
        
    }];
}





@end



@implementation WBIMClientDelegateImp (WB_IMDelegate) // AVIMClientDelegate

// ↓↓↓↓↓↓↓↓↓↓↓↓↓ 网络状态变更 ↓↓↓↓↓↓↓↓↓↓↓↓
- (void)imClientPaused:(AVIMClient *)imClient {
    [self updateConnectStatus];
}

- (void)imClientResuming:(AVIMClient *)imClient {
    [self updateConnectStatus];
}

- (void)imClientResumed:(AVIMClient *)imClient {
    [self updateConnectStatus];
}
// ↑↑↑↑↑↑↑↑↑↑↑↑ 网络状态变更 ↑↑↑↑↑↑↑↑↑↑↑↑



/*!
 接收到新的普通消息。
 @param conversation － 所属对话
 @param message - 具体的消息
 */
- (void)conversation:(AVIMConversation *)conversation didReceiveCommonMessage:(AVIMMessage *)message{
    if (!message.wb_isValidMessage) {
        return;
    }
    
    AVIMTypedMessage *typedMessage = [message wb_getValidTypedMessage];
    [self conversation:conversation didReceiveTypedMessage:typedMessage];
}

/*!
 接收到新的富媒体消息。
 @param conversation － 所属对话
 @param message - 具体的消息
 */
- (void)conversation:(AVIMConversation *)conversation didReceiveTypedMessage:(AVIMTypedMessage *)message{
    if (!message.wb_isValidMessage) {
        return;
    }
    dispatch_async(WBDBClientSqlQueue, ^{
        
        [conversation setValue:message forKeyPath:@"lastMessage"];
        
        // 交给准备的类处理收到的消息
        [[WBMessageManager sharedInstance] conversation:conversation didReceiveTypedMessage:message];
    });
}
/**
 https://leancloud.cn/docs/realtime_guide-objc.html#hash1862532095
 未读消息数更新通知
 未读消息数更新通知的机制为：当客户端上线时，会收到其参与过的对话的离线消息数量，
 云端不会主动将离线消息通知发送至客户端，而是由客户端负责主动拉取。
 Update unread message count, last message and receipt timestamp, etc.
 */
- (void)conversation:(AVIMConversation *)conversation didUpdateForKey:(NSString *)key{
    dispatch_async(WBDBClientSqlQueue, ^{        
        if ([key isEqualToString:@"unreadMessagesCount"]) {
            [[WBChatListManager sharedInstance] insertConversationToList:conversation];
        }
    });
    
}

- (void)imClientClosed:(nonnull AVIMClient *)imClient error:(NSError * _Nullable)error {
    do_dispatch_async_mainQueue(^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kIMClientClosedInError object:error];
    });
}



@end

