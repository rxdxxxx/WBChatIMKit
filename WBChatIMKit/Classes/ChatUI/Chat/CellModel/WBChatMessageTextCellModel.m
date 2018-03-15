//
//  WBChatMessageTextCellModel.m
//  WBChat
//
//  Created by RedRain on 2018/1/19.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBChatMessageTextCellModel.h"
#import "NSString+OPSize.h"
@implementation WBChatMessageTextCellModel


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellType = WBChatMessageTypeText;
        _textWithBubbleRectFrame = CGRectZero;
        _textRectFrame = CGRectZero;
    }
    return self;
}


- (void)setMessageModel:(WBMessageModel *)messageModel{
    
    [super setMessageModel:messageModel];
    
    AVIMTextMessage *textMessage = (AVIMTextMessage*)messageModel.content;
    self.content = textMessage.text;
    WBChatCellConfig *config = [WBChatCellConfig sharedInstance];
    CGFloat textSpaceL = config.textbubbleContentInset.left;
    CGFloat textSpaceR = config.textbubbleContentInset.right;
    CGFloat textSpaceT = config.textbubbleContentInset.top;
    CGFloat textSpaceB = config.textbubbleContentInset.bottom;
    
    CGFloat angleWidth = config.bubbleClosedAngleWidth;
    CGFloat headerMarginSpace = config.headerMarginSpace;
    CGSize headerSize = config.headerImageSize;
    CGFloat headerBubbleSpace = config.headerBubbleSpace;
    
    //文本尺寸
    CGSize textSize = [self getContentSizeWithChatModel:textMessage];
    //文本加上气泡的宽高
    CGSize textWithBubbleSize = CGSizeMake(textSize.width + textSpaceL + textSpaceR + angleWidth,
                                           textSize.height + textSpaceT + textSpaceB);

    
    //收到的会话
    if (messageModel.content.ioType == AVIMMessageIOTypeIn) {
        //文本气泡frame
        CGFloat textBubleX = headerMarginSpace + headerSize.width + headerBubbleSpace;
        CGFloat textBubleY = headerMarginSpace;
        CGFloat textBubleW = textWithBubbleSize.width;
        CGFloat textBubleH = textWithBubbleSize.height;
        _textWithBubbleRectFrame = CGRectMake(textBubleX, textBubleY, textBubleW, textBubleH);

        //文本frame
        _textRectFrame = CGRectMake(_textWithBubbleRectFrame.origin.x +  textSpaceL + angleWidth,
                                    textBubleY + textSpaceT,
                                    textSize.width,
                                    textSize.height);
    }
    
    
    else {
        
        _textWithBubbleRectFrame = CGRectMake(kWBScreenWidth - headerMarginSpace - headerSize.width - headerBubbleSpace - textWithBubbleSize.width,
                                              headerMarginSpace,
                                              textWithBubbleSize.width,
                                              textWithBubbleSize.height);
        
        _textRectFrame = CGRectMake(_textWithBubbleRectFrame.origin.x + textSpaceL,
                                    _textWithBubbleRectFrame.origin.y + textSpaceT,
                                    textSize.width,
                                    textSize.height);
        //发送消息状态frame
        self.messageStatusRectFrame = CGRectMake(_textWithBubbleRectFrame.origin.x - config.messageStatusIconToBubble - config.messageStatusIconSize.width,
                                                 _textWithBubbleRectFrame.origin.y + (_textWithBubbleRectFrame.size.height - config.messageStatusIconSize.width)/2,
                                                 config.messageStatusIconSize.width,
                                                 config.messageStatusIconSize.height);
        
        //发送消息已读未读
        self.messageReadStateRectFrame = CGRectMake(CGRectGetMinX(_textWithBubbleRectFrame) - config.messageStatusLabelSize.width,
                                                    CGRectGetMaxY(_textWithBubbleRectFrame) - config.messageStatusLabelSize.height,
                                                    config.messageStatusLabelSize.width,
                                                    config.messageStatusLabelSize.height);

    }
    self.cellHeight = CGRectGetMaxY(_textWithBubbleRectFrame);
}

//获取文本显示尺寸
- (CGSize)getContentSizeWithChatModel:(AVIMTextMessage *)model {
    //    MLLinkLabel *textView=[[MLLinkLabel alloc] initWithFrame:CGRectMake(0,0,kDialogTextContentMaxWidth, CGFLOAT_MAX)];
    //    textView.font = kDialogTextFont;
    //    textView.numberOfLines = 0;
    //    textView.lineBreakMode = NSLineBreakByWordWrapping;
    //    textView.text=model.messageText;
    //    [textView sizeToFit];
    //    return textView.frame.size;

    return [model.text lcg_sizeWithFont:[WBChatCellConfig sharedInstance].textFont maxW:[WBChatCellConfig sharedInstance].textMaxWidth];


}
@end
