//
//  WBChatInfoModel.h
//  WBChat
//
//  Created by RedRain on 2018/3/9.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBChatInfoModel : NSObject

@property (nonatomic, copy) NSString *conversationID;           ///< 会话ID
@property (nonatomic, copy) NSString *draft;                    ///< 会话 草稿
@property (nonatomic, strong) NSString *conversationBGFileID;   // 会话页面背景图片
@property (nonatomic, assign) NSTimeInterval topTime;           ///< 置顶的时间
@property (nonatomic, copy) NSString *extend;                   ///< 扩展使用

@end
