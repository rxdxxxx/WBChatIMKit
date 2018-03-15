//
//  WBChatMessageTextCellModel.h
//  WBChat
//
//  Created by RedRain on 2018/1/19.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBChatMessageBaseCellModel.h"

@interface WBChatMessageTextCellModel : WBChatMessageBaseCellModel

@property (nonatomic, copy) NSString *content; ///< 消息内容

@property (nonatomic, assign, readonly) CGRect textRectFrame;

@property (nonatomic, assign, readonly) CGRect textWithBubbleRectFrame;

@end
