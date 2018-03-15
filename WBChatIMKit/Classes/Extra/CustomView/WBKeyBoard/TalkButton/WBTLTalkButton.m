
//
//  TLTalkButton.m
//  TLChat
//
//  Created by 李伯坤 on 16/7/11.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "WBTLTalkButton.h"
#import "WBTLRecorderIndicatorView.h"
#import "WBTLAudioPlayer.h"
#import "WBTLAudioRecorder.h"
#import "UIView+Frame.h"

#define     WBTalkButtonSCREEN_SIZE                 [UIScreen mainScreen].bounds.size
#define     WBTalkButtonSCREEN_WIDTH                WBKeyBoardSCREEN_SIZE.width

@interface WBTLTalkButton ()

@property (nonatomic, strong) void (^touchBegin)(void);
@property (nonatomic, strong) void (^touchMove)(BOOL cancel);
@property (nonatomic, strong) void (^touchCancel)(void);
@property (nonatomic, strong) void (^touchEnd)(void);

@property (nonatomic, strong) WBTLRecorderIndicatorView *recorderIndicatorView;;

@end

@implementation WBTLTalkButton

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setNormalTitle:@"按住 说话"];
        [self setHighlightTitle:@"松开 结束"];
        [self setCancelTitle:@"送开 取消"];
        [self setHighlightColor:[UIColor colorWithWhite:0.0 alpha:0.1]];
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:4.0f];
        [self.layer setBorderWidth:([[UIScreen mainScreen] scale] > 0.0 ? 1.0 / [[UIScreen mainScreen] scale] : 1.0)];
        [self.layer setBorderColor:[UIColor colorWithWhite:0.0 alpha:0.3].CGColor];
        
        [self addSubview:self.titleLabel];
        
        [self.recorderIndicatorView setStatus:WBTLRecorderStatusRecording];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self reloadSubviewFrame];
}

- (void)reloadSubviewFrame{
    
    self.titleLabel.frame = self.bounds;
    
    self.recorderIndicatorView.center = CGPointMake(WBTalkButtonSCREEN_SIZE.width / 2, WBTalkButtonSCREEN_SIZE.height / 2);
}

#pragma mark - # Public Methods
- (void)setTouchBeginAction:(void (^)(void))touchBegin
      willTouchCancelAction:(void (^)(BOOL))willTouchCancel
             touchEndAction:(void (^)(void))touchEnd
          touchCancelAction:(void (^)(void))touchCancel
{
    self.touchBegin = touchBegin;
    self.touchMove = willTouchCancel;
    self.touchCancel= touchCancel;
    self.touchEnd = touchEnd;
}

#pragma mark - # Event Response
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self setBackgroundColor:self.highlightColor];
    [self.titleLabel setText:self.highlightTitle];
    

    
    if (self.touchBegin) {
        // 先停止播放
        if ([WBTLAudioPlayer sharedAudioPlayer].isPlaying) {
            [[WBTLAudioPlayer sharedAudioPlayer] stopPlayingAudio];
        }
        
        if (self.recorderIndicatorView.superview == nil) {
            [[UIApplication sharedApplication].keyWindow addSubview:self.recorderIndicatorView];
            [self reloadSubviewFrame];
        }
        
        [self.recorderIndicatorView setStatus:WBTLRecorderStatusRecording];
    
        
        __block NSInteger time_count = 0;
        [[WBTLAudioRecorder sharedRecorder] startRecordingWithVolumeChangedBlock:^(CGFloat volume) {
            time_count ++;
            if (time_count == 2) {

            }
            [self.recorderIndicatorView setVolume:volume];
        } completeBlock:^(NSString *filePath, CGFloat time) {
            if (time < 1.0) {
                [self.recorderIndicatorView setStatus:WBTLRecorderStatusTooShort];
                return;
            }
            [self.recorderIndicatorView removeFromSuperview];
            if (filePath) {
                [[NSNotificationCenter defaultCenter] postNotificationName:WBAudioCompleteFinishNotification object:nil userInfo:@{@"path":filePath,
                                                                                                                                   @"duration":@(time)
                                                                                                                                   }];
            }
            
        } cancelBlock:^{
            [self.recorderIndicatorView removeFromSuperview];
        }];
        
        
        
        self.touchBegin();
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.touchMove) {
        CGPoint curPoint = [[touches anyObject] locationInView:self];
        BOOL moveIn = curPoint.x >= 0 && curPoint.x <= self.frame.size.width && curPoint.y >= 0 && curPoint.y <= self.frame.size.height;
        [self.titleLabel setText:(moveIn ? self.highlightTitle : self.cancelTitle)];
        
        [self reloadSubviewFrame];
        [self.recorderIndicatorView setStatus:!moveIn ? WBTLRecorderStatusWillCancel : WBTLRecorderStatusRecording];

        self.touchMove(!moveIn);
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setText:self.normalTitle];
    CGPoint curPoint = [[touches anyObject] locationInView:self];
    BOOL moveIn = curPoint.x >= 0 && curPoint.x <= self.frame.size.width && curPoint.y >= 0 && curPoint.y <= self.frame.size.height;
    if (moveIn && self.touchEnd) {
        [[WBTLAudioRecorder sharedRecorder] stopRecording];

        self.touchEnd();
    }
    else if (!moveIn && self.touchCancel) {
        [[WBTLAudioRecorder sharedRecorder] cancelRecording];

        self.touchCancel();
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setText:self.normalTitle];
    if (self.touchCancel) {

        [[WBTLAudioRecorder sharedRecorder] cancelRecording];

        self.touchCancel();
    }
}

#pragma mark - # Private Methods 


#pragma mark - # Getter
- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
        [_titleLabel setTextColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setText:self.normalTitle];
    }
    return _titleLabel;
}
- (WBTLRecorderIndicatorView *)recorderIndicatorView
{
    if (_recorderIndicatorView == nil) {
        _recorderIndicatorView = [[WBTLRecorderIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    }
    return _recorderIndicatorView;
}
@end
