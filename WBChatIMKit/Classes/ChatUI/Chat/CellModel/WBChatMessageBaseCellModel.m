//
//  WBChatBaseCellModel.m
//  WBChat
//
//  Created by RedRain on 2018/1/18.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBChatMessageBaseCellModel.h"
#import "WBChatMessageTextCellModel.h"
#import "WBChatMessageImageCellModel.h"
#import "WBChatMessageVoiceCellModel.h"
#import "WBChatMessageRecallCellModel.h"
@implementation WBChatMessageBaseCellModel

+ (instancetype)modelWithMessageModel:(WBMessageModel *)messageModel{
    AVIMTypedMessage *typedMessage = [messageModel.content wb_getValidTypedMessage];
    
    // 默认使用发送中
    
    WBChatMessageBaseCellModel *model = nil;
    switch (typedMessage.mediaType) {
        case kAVIMMessageMediaTypeText:
             model = [WBChatMessageTextCellModel new];
            break;
        case kAVIMMessageMediaTypeImage:
            model = [WBChatMessageImageCellModel new];

            break;
        case kAVIMMessageMediaTypeAudio:
            model = [WBChatMessageVoiceCellModel new];
            break;
        case kAVIMMessageMediaTypeVideo:
            
            break;
        case kAVIMMessageMediaTypeLocation:
            
            break;
        case kAVIMMessageMediaTypeFile:
            
            break;
        case kAVIMMessageMediaTypeRecalled:
            model = [WBChatMessageRecallCellModel new];
            break;
        default:
            break;
    }
    if (model == nil) {
        // 如果没有对应的model, 会使用WBChatMessageHintCell显示在页面中.
        model = [WBChatMessageBaseCellModel new];
        model.cellHeight = 36;

    }
    model.messageModel = messageModel;
    
    return model;
}

- (void)setMessageModel:(WBMessageModel *)messageModel{
    _messageModel = messageModel;
    
    
    
    
    WBChatCellConfig *config = [WBChatCellConfig sharedInstance];
    CGFloat headerMarginSpace = config.headerMarginSpace;
    CGSize headerSize = config.headerImageSize;
    
    
    _messageReadStateRectFrame = CGRectZero;
    _usernameRectFrame = CGRectZero;
    
    // 如果是多图文消息 或者 回撤消息.
    if (self.cellType == WBChatMessageTypeUnknow ||
        self.cellType == WBChatMessageTypeTime ||
        self.cellType == WBChatMessageTypeNotification ||
        self.cellType == WBChatMessageTypeCallHint ||
        self.cellType == WBChatMessageTypePSRichContent||
        self.cellType == WBChatMessageTypePSMultiRichContent ||
        self.cellType == WBChatMessageTypeRecalled) {
        
        _headerRectFrame = CGRectZero;
        _myHeaderRectFrame = CGRectZero;
        _messageStatusRectFrame = CGRectZero;
        _myHeaderRectFrame = CGRectZero;
        
    } else if (messageModel.content.ioType == AVIMMessageIOTypeIn) {
        // 收到的消息的状态就是MessageStatusNone
        _headerRectFrame = CGRectMake(headerMarginSpace, headerMarginSpace, headerSize.width, headerSize.height);
        
    } else {
        CGFloat headerX = kWBScreenWidth - headerMarginSpace - headerSize.width;
        _myHeaderRectFrame = CGRectMake(headerX, headerMarginSpace, headerSize.width, headerSize.height);
    }
    if (self.showName) {
        CGFloat userNameX = CGRectGetMaxX(_headerRectFrame) + config.headerBubbleSpace + config.bubbleClosedAngleWidth;
        CGFloat userNameY = CGRectGetMinY(_headerRectFrame);
        _usernameRectFrame = CGRectMake(userNameX, userNameY, config.userNameSize.width, config.userNameSize.height);
    }
}

- (void)setCellHeight:(CGFloat)cellHeight{
    _cellHeight = ceilf(cellHeight);
    
}

- (int64_t)cellTimeStamp{
    int64_t time = self.messageModel.content.sendTimestamp ? : self.messageModel.content.readTimestamp;
    return time ? : [[NSDate date] timeIntervalSince1970];
}
@end
