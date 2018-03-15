//
//  WBChatMessageVoiceCellModel.m
//  WBChat
//
//  Created by RedRain on 2018/2/6.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBChatMessageVoiceCellModel.h"
#import "NSString+OPSize.h"
#import "UIImage+WBImage.h"

@implementation WBChatMessageVoiceCellModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.cellType = WBChatMessageTypeAudio;
        
    }
    return self;
}

- (void)setMessageModel:(WBMessageModel *)messageModel{
    [super setMessageModel:messageModel];
    
    
    
    WBChatCellConfig *config = [WBChatCellConfig sharedInstance];
    CGFloat headerMarginSpace = config.headerMarginSpace;
    CGSize headerSize = config.headerImageSize;
    CGFloat headerBubbleSpace = config.headerBubbleSpace;
    CGSize waveSize = config.voiceWaveSize;
//    CGFloat normalSpace = config.normalSpace;

    
    CGFloat MAX_MESSAGE_WIDTH = kWBScreenWidth * 0.58;
    CGFloat width = 60 + (messageModel.voiceDuration.floatValue > 20 ? 1.0 : messageModel.voiceDuration.floatValue / 20.0)  * (MAX_MESSAGE_WIDTH - 60);
    CGFloat height = headerSize.height;
    width = MIN(width, kWBScreenWidth * 0.75);
    CGSize voiceSize = CGSizeMake(width, height);
    
    CGFloat timeWidth = 2 + [[NSString stringWithFormat:@"%.0f'",messageModel.voiceDuration.floatValue] lcg_sizeWithFont:[UIFont systemFontOfSize:14]].width;
    
    //区分收到的消息及发送的消息
    if (messageModel.content.ioType == AVIMMessageIOTypeIn) {
        // 气泡
        _voiceBubbleFrame = CGRectMake(headerMarginSpace + headerSize.width + headerBubbleSpace, headerMarginSpace, voiceSize.width, voiceSize.height);
        
        // 波浪
        _voiceWaveImageFrame = CGRectMake(headerBubbleSpace,(height - waveSize.height) / 2,
                                          waveSize.width, waveSize.height);
        
        // 时间
        _voiceTimeNumLabelFrame = CGRectMake(voiceSize.width - headerBubbleSpace - timeWidth, (height - waveSize.height) / 2,
                                             timeWidth, waveSize.height);
        
        
    } else {
        // 气泡
        _voiceBubbleFrame = CGRectMake(kWBScreenWidth - headerMarginSpace - headerSize.width - headerBubbleSpace - voiceSize.width, headerMarginSpace, voiceSize.width, voiceSize.height);
        
        // 波浪
        _voiceWaveImageFrame = CGRectMake(voiceSize.width - headerBubbleSpace - waveSize.width,
                                          (height - waveSize.height) / 2,
                                          waveSize.width, waveSize.height);
        
        // 时间
        _voiceTimeNumLabelFrame = CGRectMake(headerBubbleSpace, (height - waveSize.height) / 2,
                                             timeWidth, waveSize.height);
        


        // 发送消息状态frame
        self.messageStatusRectFrame = CGRectMake(_voiceBubbleFrame.origin.x - config.messageStatusIconToBubble - config.messageStatusIconSize.width,
                                                 _voiceBubbleFrame.origin.y + (_voiceBubbleFrame.size.height - config.messageStatusIconSize.width)/2,
                                                 config.messageStatusIconSize.width,
                                                 config.messageStatusIconSize.height);

        // 发送消息已读未读
        self.messageReadStateRectFrame = CGRectMake(CGRectGetMinX(_voiceBubbleFrame) - config.messageStatusLabelSize.width,
                                                    CGRectGetMaxY(_voiceBubbleFrame) - config.messageStatusLabelSize.height,
                                                    config.messageStatusLabelSize.width,
                                                    config.messageStatusLabelSize.height);
    }
    self.cellHeight = CGRectGetMaxY(_voiceBubbleFrame);
    
}


- (UIImageView *)messageVoiceAnimationImageViewWithBubbleMessageType:(BOOL)owner {
    UIImageView *messageVoiceAniamtionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    NSString *imageSepatorName;
    if(owner){
        imageSepatorName = @"Sender";
    }else{
        imageSepatorName = @"Receiver";
    }
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:4];
    for (NSInteger i = 0; i < 4; i ++) {
        NSString *imageName = [imageSepatorName stringByAppendingFormat:@"VoiceNodePlaying00%ld", (long)i];
        UIImage *image = [UIImage wb_resourceImageNamed:imageName];
        if (image)
            [images addObject:image];
    }
    
    messageVoiceAniamtionImageView.image = ({
        NSString *imageName = [imageSepatorName stringByAppendingString:@"VoiceNodePlaying"];
        UIImage *image = [UIImage wb_resourceImageNamed:imageName];
        image;});
    messageVoiceAniamtionImageView.animationImages = images;
    messageVoiceAniamtionImageView.animationDuration = 1.0;
    [messageVoiceAniamtionImageView stopAnimating];
    return messageVoiceAniamtionImageView;
}

@end
