//
//  WBChatKitProtocol.h
//  Pods
//
//  Created by RedRain on 2018/3/14.
//

#ifndef WBChatKitProtocol_h
#define WBChatKitProtocol_h

#import <Foundation/Foundation.h>

@protocol WBChatKitProtocol <NSObject>

- (NSString *)memberNameWithClientID:(NSString *)clientId;


/**
 根据ClientId设置头像
 
 @param imageView 需要设置头像的View
 @param clientId 区分id
 @param placeholdImage 占位图片
 */
- (void)imageView:(UIImageView *)imageView
         clientID:(NSString *)clientId
   placeholdImage:(UIImage *)placeholdImage;


/**
 根据会话id设置列表头像
 
 @param imageView 需要设置头像的View
 @param conversationId 会话的id
 @param placeholdImage 占位图片
 */
- (void)imageView:(UIImageView *)imageView
   conversationId:(NSString *)conversationId
   placeholdImage:(UIImage *)placeholdImage;

@end

#endif /* WBChatKitProtocol_h */

