//
//  WBChatMessageVoiceCellModel.h
//  WBChat
//
//  Created by RedRain on 2018/2/6.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBChatMessageBaseCellModel.h"

typedef NS_ENUM(NSUInteger, WBVoiceCellState) {
    WBVoiceCellStateNormal,
    WBVoiceCellStatePlaying,
    WBVoiceCellStateDownloading
};

@interface WBChatMessageVoiceCellModel : WBChatMessageBaseCellModel

@property (nonatomic, assign) CGRect voiceWaveImageFrame;
@property (nonatomic, assign) CGRect voiceTimeNumLabelFrame;
@property (nonatomic, assign) CGRect voiceBubbleFrame;

@property (nonatomic, assign) WBVoiceCellState voiceState; // 语音播放的状态

- (UIImageView *)messageVoiceAnimationImageViewWithBubbleMessageType:(BOOL)owner;
@end
