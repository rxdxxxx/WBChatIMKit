//
//  WBChatMessageVoiceCell.m
//  WBChat
//
//  Created by RedRain on 2018/2/6.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBChatMessageVoiceCell.h"
#import "WBChatMessageVoiceCellModel.h"
#import "WBVoicePlayer.h"

@interface WBChatMessageVoiceCell ()
@property (nonatomic, strong) WBMessageModel *currentChatModel;
@property (nonatomic, strong) UIImageView *voiceWaveImageView;
@property (nonatomic, strong) UILabel *voiceTimeNumLabel;
@property (nonatomic, weak) UITableView * tableView;
@end

@implementation WBChatMessageVoiceCell
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"WBChatMessageVoiceCell";
    WBChatMessageVoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[WBChatMessageVoiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.tableView = tableView;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.bubbleImageView addSubview:self.voiceWaveImageView];
        [self.bubbleImageView addSubview:self.voiceTimeNumLabel];
        
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(voicePlay:)];
        [self.bubbleImageView addGestureRecognizer:tapGesture];
    }
    return self;
}


#pragma mark - Tap Action
- (void)voicePlay:(UITapGestureRecognizer *)tap{
    WBChatMessageVoiceCellModel *voiceCellFrameModel = (WBChatMessageVoiceCellModel *)self.cellModel;
    if (voiceCellFrameModel.voiceState == WBVoiceCellStatePlaying) {
        [[WBVoicePlayer player] stopPlayingAudio];
        [self.voiceWaveImageView stopAnimating];
        return;
    }
    
    voiceCellFrameModel.voiceState = WBVoiceCellStatePlaying;
    [self.voiceWaveImageView startAnimating];
    [[WBVoicePlayer player] playVoiceWithPath:self.currentChatModel.audioPath complete:^(BOOL finished) {
        WBChatMessageVoiceCellModel *cellModel = (WBChatMessageVoiceCellModel *)voiceCellFrameModel;
        cellModel.voiceState = WBVoiceCellStateNormal;
        
        
        NSArray *visibleCells = [self.tableView visibleCells];
        for (id cell in visibleCells) {
            if ([cell isKindOfClass:[WBChatMessageBaseCell class]]) {
                if ([[(WBChatMessageBaseCell *)cell cellModel].messageModel.content.messageId isEqualToString:cellModel.messageModel.content.messageId]) {
                    [cell setCellModel:voiceCellFrameModel];
                    return;
                }
            }
        }
    }];
}

#pragma mark - Setter
- (void)setCellModel:(WBChatMessageBaseCellModel *)cellModel{
    [super setCellModel:cellModel];
    
    WBChatMessageVoiceCellModel *voiceCellFrameModel = (WBChatMessageVoiceCellModel *)self.cellModel;
    
    self.currentChatModel = voiceCellFrameModel.messageModel;
    
    
    self.bubbleImageView.frame = voiceCellFrameModel.voiceBubbleFrame;
    
    
    AVIMAudioMessage *audioM = (AVIMAudioMessage*)voiceCellFrameModel.messageModel.content;
    self.voiceTimeNumLabel.text = [NSString stringWithFormat:@"%.0f'",voiceCellFrameModel.messageModel.voiceDuration.floatValue];
    self.voiceTimeNumLabel.frame = voiceCellFrameModel.voiceTimeNumLabelFrame;
    self.voiceTimeNumLabel.textColor = audioM.ioType == AVIMMessageIOTypeIn ? [UIColor blackColor] : [UIColor whiteColor];
    
    UIImageView *waveImageView = [voiceCellFrameModel messageVoiceAnimationImageViewWithBubbleMessageType:(audioM.ioType != AVIMMessageIOTypeIn)];
    [self.voiceWaveImageView removeFromSuperview];
    [self.bubbleImageView addSubview:waveImageView];
    waveImageView.frame = voiceCellFrameModel.voiceWaveImageFrame;
    self.voiceWaveImageView = waveImageView;
    
    // 是否执行动画
    voiceCellFrameModel.voiceState == WBVoiceCellStatePlaying ? [self.voiceWaveImageView startAnimating] : [self.voiceWaveImageView stopAnimating];
    
}



///声音波动图
- (UIImageView *)voiceWaveImageView {
    if (!_voiceWaveImageView) {
        _voiceWaveImageView = [[UIImageView alloc] init];
        _voiceWaveImageView.backgroundColor = [UIColor clearColor];
        _voiceWaveImageView.userInteractionEnabled = YES;
    }
    return _voiceWaveImageView;
}
///声音时长
- (UILabel *)voiceTimeNumLabel {
    if (!_voiceTimeNumLabel) {
        _voiceTimeNumLabel = [[UILabel alloc] init];
        _voiceTimeNumLabel.font = [UIFont systemFontOfSize:14];
        _voiceTimeNumLabel.textColor = [UIColor blackColor];
        _voiceTimeNumLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _voiceTimeNumLabel;
}
@end

