//
//  WBChatListCellModel.m
//  WBChat
//
//  Created by RedRain on 2017/12/11.
//  Copyright © 2017年 RedRain. All rights reserved.
//

#import "WBChatListCellModel.h"
#import "WBConfig.h"
@interface WBChatListCellModel ()
@property (nonatomic, assign) BOOL didSearchName;
@end


@implementation WBChatListCellModel

- (void)handleLastMessageString:(WBChatListModel *)dataModel {
    if (dataModel.draft.length) {
        self.lastMessageString = [[NSString stringWithFormat:@"[草稿]%@", dataModel.draft]
                                  wb_makeSearchString:@"[草稿]"
                                  color:[UIColor redColor]];;
        return;
    }
    
    
    AVIMTypedMessage *typedMessage = [dataModel.conversation.lastMessage wb_getValidTypedMessage];
    NSString *lastString = @"";
    
    switch (typedMessage.messageType_wb) {
        case WBChatMessageTypeText:
            lastString = typedMessage.text;
            break;
        case WBChatMessageTypeImage:
            lastString = @"[图片]";
            break;
        case WBChatMessageTypeAudio:
            lastString = @"[语音]";
            break;
        case WBChatMessageTypeVideo:
            lastString = @"[视频]";
            break;
        case WBChatMessageTypeLocation:
            lastString = @"[位置]";
            break;
        case WBChatMessageTypeFile:
            lastString = @"[文件]";
            break;
        case WBChatMessageTypeRecalled:
            lastString = @"[有一条撤回的消息]";
            break;
        case WBChatMessageTypeUnknow:
            lastString = @"[错误的消息类型]";
            break;
        default:
            lastString = @"[不支持的消息类型]";
            break;
    }
    self.lastMessageString = [[NSAttributedString alloc] initWithString:lastString];
}

- (void)handleTitle:(WBChatListModel *)dataModel{
    WBConversationType type = dataModel.conversation.wb_conversationType;
    if (type == WBConversationTypeSingle) {
        NSArray *member = dataModel.conversation.members;
        // 如果实现了代理, 那么使用代理返回的数据
        if ([[WBChatKit sharedInstance].delegate respondsToSelector:@selector(memberNameWithClientID:)]) {
            NSString *otherObjectId = member.firstObject;
            if ([otherObjectId isEqualToString:[WBUserManager sharedInstance].clientId]) {
                otherObjectId = member.lastObject;
            }
            
            NSString *memberName = [[WBChatKit sharedInstance].delegate memberNameWithClientID:otherObjectId];
            self.title = memberName;
        }else{
            self.title = dataModel.conversation.name;
        }
        
    }else{
        self.title = dataModel.conversation.name;
    }
}

- (void)setDataModel:(WBChatListModel *)dataModel{
    _dataModel = dataModel;
    
    CGFloat cellW = kWBScreenWidth;
    CGFloat margin = 10;
    CGFloat cellH = 70;

    CGFloat headerWH = 50;
    _chatUserHeaderViewF = CGRectMake(margin, margin, headerWH, headerWH);
    
    
    CGFloat chatTitleW = cellW - headerWH - 2 * margin - 80;
    CGFloat chatTitleX = CGRectGetMaxX(_chatUserHeaderViewF) + margin;
    _chatTitleF = CGRectMake(chatTitleX, margin, chatTitleW, 26);
    
    
    CGFloat chatTimeW = 60;
    CGFloat chatTimeH = 16;
    CGFloat chatTimeX = cellW - chatTimeW - margin;
    CGFloat chatTimeY = ceil(CGRectGetHeight(_chatTitleF) - chatTimeH) / 2 + margin;
    _chatTimeF = CGRectMake(chatTimeX, chatTimeY, chatTimeW, chatTimeH);
    
    
    CGFloat chatMessageH = 18;
    CGFloat chatMessageY = cellH - margin * 1.3 - chatMessageH;
    CGFloat chatMessageW = cellW - chatTitleX - 2 * margin;
    _chatMessageF = CGRectMake(chatTitleX, chatMessageY, chatMessageW, chatMessageH);
    
    
    CGFloat unreadBadgeBtnWH = 20;
    CGFloat unreadBadgeBtnX = CGRectGetMaxX(_chatUserHeaderViewF) - 12;
    CGFloat unreadBadgeBtnY = CGRectGetMinY(_chatUserHeaderViewF) - 4;
    _unreadBadgeBtnF = CGRectMake(unreadBadgeBtnX, unreadBadgeBtnY, unreadBadgeBtnWH, unreadBadgeBtnWH);
    
    CGFloat cutLineH = 1;
    CGFloat cutLineY = cellH - cutLineH;
    CGFloat cutLineW = cellW;
    _cutLineF = CGRectMake(0, cutLineY, cutLineW, cutLineH);
    
    [self handleLastMessageString:dataModel];
    [self handleTitle:dataModel];

}


@end
