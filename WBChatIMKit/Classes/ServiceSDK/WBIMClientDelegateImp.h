//
//  WBIMClientDelegateImp.h
//  WBChat
//
//  Created by RedRain on 2018/1/15.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudIM/AVOSCloudIM.h>



@interface WBIMClientDelegateImp : NSObject

@property (nonatomic, copy, readonly) NSString *clientId;

/*!
 * AVIMClient 实例
 */
@property (nonatomic, strong, readonly) AVIMClient *client;

/**
 *  是否和聊天服务器连通
 */
@property (nonatomic, assign, readonly) BOOL connect;



/**
 使用ClientId连接服务器

 @param clientId 用户IM身份的标识
 */
- (void)openWithClientId:(NSString *)clientId
                 success:(void (^)(NSString *clientId))successBlock
                   error:(void (^)(NSError *error))errorBlock;


/**
 使用ClientId连接服务器

 @param clientId 用户IM身份的标识
 @param force Just for Single Sign On
 */
- (void)openWithClientId:(NSString *)clientId
                   force:(BOOL)force
                 success:(void (^)(NSString *clientId))successBlock
                   error:(void (^)(NSError *error))errorBlock;

@end
