//
//  WBMessageModel.h
//  WBChat
//
//  Created by RedRain on 2018/1/26.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import <AVOSCloud/AVOSCloud.h>
#import <AVOSCloudIM/AVOSCloudIM.h>

typedef NS_ENUM(NSUInteger, WBChatMessageType) {
    WBChatMessageTypeUnknow = 0,
    WBChatMessageTypeText  = -1,
    WBChatMessageTypeImage = -2 ,
    WBChatMessageTypeAudio = -3,
    WBChatMessageTypeVideo = -4,
    WBChatMessageTypeLocation = -5,
    WBChatMessageTypeFile = -6,
    WBChatMessageTypeRecalled = -127,// 回撤消息
    
    WBChatMessageTypeTime = 50,               // 时间
    WBChatMessageTypeNoMoreMessage = 51,            // 没有更多消息了
    WBChatMessageTypeUnderLineNewMessage = 52,      // 以下是最新消息
    WBChatMessageTypeNotification = 53,             // 通知类
    WBChatMessageTypeCallHint = 54,                 // 提示
    WBChatMessageTypeCardInfo = 55,                 // 个人名片
    WBChatMessageTypePSRichContent = 56,            // 公众号单图文
    WBChatMessageTypePSMultiRichContent = 57,       // 公众号多图文
    WBChatMessageTypeRichContent = 58               // 单链接
};

@interface WBMessageModel : NSObject

@property (nonatomic, assign) WBChatMessageType messageType;
/*!
 * 表示消息状态
 */
@property (nonatomic, assign) AVIMMessageStatus status;


@property (nonatomic, strong) AVIMTypedMessage *content;



+ (instancetype)createWithTypedMessage:(AVIMTypedMessage *)message;



/**
 发送消息时,创建模型

 @param text 发送内容
 */
+ (instancetype)createWithText:(NSString *)text;



/**
 生成适配的发送model

 @param image 需要发送的image
 */
+ (instancetype)createWithImage:(UIImage *)image;

@property (nonatomic, strong) UIImage *thumbImage;
@property (nonatomic, copy) NSString *imagePath;


/**
 生成音频model

 @param audioPath 音频路径
 */
+ (instancetype)createWithAudioPath:(NSString *)audioPath duration:(NSNumber *)duration;
@property (nonatomic, copy) NSString *audioPath;
@property (nonatomic, copy) NSString *voiceDuration;

@end
