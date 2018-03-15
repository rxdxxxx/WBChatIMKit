//
//  WBChatMessageImageCellModel.m
//  WBChat
//
//  Created by RedRain on 2018/2/5.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBChatMessageImageCellModel.h"

@implementation WBChatMessageImageCellModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.cellType = WBChatMessageTypeImage;
        
    }
    return self;
}

- (void)setMessageModel:(WBMessageModel *)messageModel{
    [super setMessageModel:messageModel];
    
    CGSize imageSize = [self setImageSizeWithMessageModel:messageModel];
    
    WBChatCellConfig *config = [WBChatCellConfig sharedInstance];
    CGFloat headerMarginSpace = config.headerMarginSpace;
    CGSize headerSize = config.headerImageSize;
    CGFloat headerBubbleSpace = config.headerBubbleSpace;
    CGFloat angleWidth = config.bubbleClosedAngleWidth;
    CGFloat progressWidth = config.imageProgressSize.width;
    
    //区分收到的消息及发送的消息
    if (messageModel.content.ioType == AVIMMessageIOTypeIn) {
        _imageRectFrame = CGRectMake(headerMarginSpace + headerSize.width + headerBubbleSpace, headerBubbleSpace, imageSize.width, imageSize.height);
    } else {
        _imageRectFrame = CGRectMake(kWBScreenWidth - headerMarginSpace - headerSize.width - headerBubbleSpace - imageSize.width, headerMarginSpace, imageSize.width, imageSize.height);
        
        //发送图片时，进度显示，如果图片正常
        if (imageSize.width >= 40) {
            _imageProcessRectFrame = CGRectMake((_imageRectFrame.size.width - progressWidth - angleWidth)/2,
                                                _imageRectFrame.size.height/2 - progressWidth,
                                                progressWidth,
                                                config.imageProgressSize.height);
            
        } else {
            //如果图片过窄，则缩小进度图片
            CGFloat sig = imageSize.width / 40;
            _imageProcessRectFrame = CGRectMake((_imageRectFrame.size.width - progressWidth * sig - angleWidth)/2,
                                                _imageRectFrame.size.height/2 - progressWidth*sig,
                                                progressWidth * sig,
                                                progressWidth * sig);
        }
        
        _labelProcessRectFrame = CGRectMake(0, _imageProcessRectFrame.origin.y + _imageProcessRectFrame.size.height + 5,
                                            _imageRectFrame.size.width - angleWidth, 30);
        
        //发送消息状态frame
        self.messageStatusRectFrame = CGRectMake(_imageRectFrame.origin.x - config.messageStatusIconToBubble - config.messageStatusIconSize.width,
                                                 _imageRectFrame.origin.y + (_imageRectFrame.size.height - config.messageStatusIconSize.width)/2,
                                                 config.messageStatusIconSize.width,
                                                 config.messageStatusIconSize.height);
        
        //发送消息已读未读
        self.messageReadStateRectFrame = CGRectMake(CGRectGetMinX(_imageRectFrame) - config.messageStatusLabelSize.width,
                                                    CGRectGetMaxY(_imageRectFrame) - config.messageStatusLabelSize.height,
                                                    config.messageStatusLabelSize.width,
                                                    config.messageStatusLabelSize.height);
    }
    self.cellHeight = CGRectGetMaxY(_imageRectFrame);
    
}


//获取图片大小
- (CGSize)setImageSizeWithMessageModel:(WBMessageModel *)messageModel {
    
    float kDialogHeaderImageMaxHeight = 200;
    float kDialogHeaderImageMinHeight= [WBChatCellConfig sharedInstance].headerImageSize.height;
    float kDialogHeaderImageMaxWidth = 200;
    float kDialogHeaderImageMinWidth = 80;
    
    CGSize imageSize = CGSizeMake(100, 100);
    
    if (messageModel.thumbImage) {
        imageSize = CGSizeMake(messageModel.thumbImage.size.width, messageModel.thumbImage.size.height);

    }
    
    
    if (imageSize.height > imageSize.width) {
        CGFloat imageWidth = (kDialogHeaderImageMaxHeight / imageSize.height) * imageSize.width;
        if (imageWidth < kDialogHeaderImageMinWidth) {
            imageWidth = kDialogHeaderImageMinWidth;
        }
        imageSize = CGSizeMake(imageWidth,kDialogHeaderImageMaxHeight);
        
    }else{
        CGFloat imageHeight = (imageSize.height / imageSize.width) * kDialogHeaderImageMaxWidth;
        if (imageHeight < kDialogHeaderImageMinHeight) {
            imageHeight = kDialogHeaderImageMinHeight;
        }
        imageSize = CGSizeMake(kDialogHeaderImageMaxWidth, imageHeight);
    }
    
    return imageSize;
}

@end
