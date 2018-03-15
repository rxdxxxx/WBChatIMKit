//
//  WBChatBaseCellModel.h
//  WBChat
//
//  Created by RedRain on 2018/1/18.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBChatCellConfig.h"
#import "WBServiceSDKHeaders.h"


@interface WBChatMessageBaseCellModel : NSObject

+ (instancetype)modelWithMessageModel:(WBMessageModel *)messageModel;

@property (nonatomic, strong) WBMessageModel *messageModel;

///< 消息类型
@property (nonatomic, assign) WBChatMessageType cellType;

///< 对方头像的位置
@property (nonatomic, assign) CGRect headerRectFrame;

///< 自己头像的位置
@property (nonatomic, assign) CGRect myHeaderRectFrame;

///<  cell的高度
@property (nonatomic, assign) CGFloat cellHeight;

///< 发送的消息的状态位置
@property (nonatomic, assign) CGRect messageStatusRectFrame;

///< 会话界面消息阅读状态
@property (nonatomic, assign) CGRect messageReadStateRectFrame;

///< 对方昵称的位置
@property (nonatomic, assign) CGRect usernameRectFrame;


@property (nonatomic, assign) BOOL showName;

- (int64_t)cellTimeStamp;

@end
