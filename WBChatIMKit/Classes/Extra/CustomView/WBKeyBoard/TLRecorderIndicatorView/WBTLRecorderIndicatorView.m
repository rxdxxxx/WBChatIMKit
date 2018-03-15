//
//  WBTLRecorderIndicatorView.m
//  TLChat
//
//  Created by 李伯坤 on 16/7/12.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "WBTLRecorderIndicatorView.h"
#import "WBTLAudioRecorder.h"
#import "UIView+Frame.h"
#import "UIImage+WBImage.h"

#define     STR_RECORDING       @"手指上滑，取消发送"
#define     STR_CANCEL          @"手指松开，取消发送"
#define     STR_REC_SHORT       @"说话时间太短"

@interface WBTLRecorderIndicatorView ()

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIView *titleBackgroundView;

@property (nonatomic, strong) UIImageView *recImageView;

@property (nonatomic, strong) UIImageView *centerImageView;

@property (nonatomic, strong) UIImageView *volumeImageView;

@end

@implementation WBTLRecorderIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.backgroundView];
        [self addSubview:self.recImageView];
        [self addSubview:self.volumeImageView];
        [self addSubview:self.centerImageView];
        [self addSubview:self.titleBackgroundView];
        [self addSubview:self.titleLabel];
        
        [self p_addMasonry];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self p_addMasonry];
}

- (void)setStatus:(WBTLRecorderStatus)status
{
    if (status == WBTLRecorderStatusWillCancel) {
        [self.centerImageView setHidden:NO];
        [self.centerImageView setImage:[UIImage wb_resourceImageNamed:@"RecordCancel"]];
        [self.titleBackgroundView setHidden:NO];
        [self.recImageView setHidden:YES];
        [self.volumeImageView setHidden:YES];
        [self.titleLabel setText:STR_CANCEL];
        [self.titleLabel sizeToFit];
    }
    else if (status == WBTLRecorderStatusRecording) {
        [self.centerImageView setHidden:YES];
        [self.titleBackgroundView setHidden:YES];
        [self.recImageView setHidden:NO];
        [self.volumeImageView setHidden:NO];
        [self.titleLabel setText:STR_RECORDING];
        [self.titleLabel sizeToFit];
    }
    else if (status == WBTLRecorderStatusTooShort) {
        [self.centerImageView setHidden:NO];
        [self.centerImageView setImage:[UIImage wb_resourceImageNamed:@"RecordCancel"]];
        [self.titleBackgroundView setHidden:YES];
        [self.recImageView setHidden:YES];
        [self.volumeImageView setHidden:YES];
        [self.titleLabel setText:STR_REC_SHORT];
        [self.titleLabel sizeToFit];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (status == WBTLRecorderStatusTooShort) {
                [self removeFromSuperview];
            }
        });
    }
}

- (void)setVolume:(CGFloat)volume
{
    _volume = volume;
    NSInteger picId = 10 * (volume < 0 ? 0 : (volume > 1.0 ? 1.0 : volume));
    picId = picId > 8 ? 8 : picId;
    [self.volumeImageView setImage:[UIImage wb_resourceImageNamed:[NSString stringWithFormat:@"RecordingSignal00%ld", (long)picId]]];
}

#pragma mark - # Private Methods
- (void)p_addMasonry
{
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat selfHeight = self.bounds.size.height;

    self.backgroundView.frame = self.bounds;
    
    
    self.recImageView.frame = CGRectMake(21, 15, 62, 100);
    
   
    self.volumeImageView.frame = CGRectMake(selfWidth - 38 - 21 , 15, 38, 100);
    
 
    self.centerImageView.frame = CGRectMake(0, 0, 100, 100);
    self.centerImageView.center = CGPointMake(selfWidth / 2, selfHeight / 2);
    

    self.titleLabel.center = CGPointMake(selfWidth / 2, selfHeight / 2);
    self.titleLabel.bottom_wb = self.height_wb - 15;
    [self.titleLabel sizeToFit];

    
    self.titleBackgroundView.frame = self.titleLabel.frame;
}

#pragma mark - # Getter
- (UIView *)backgroundView
{
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc] init];
        [_backgroundView setBackgroundColor:[UIColor blackColor]];
        [_backgroundView setAlpha:0.6f];
        [_backgroundView.layer setMasksToBounds:YES];
        [_backgroundView.layer setCornerRadius:5.0f];
    }
    return _backgroundView;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_titleLabel setText:STR_RECORDING];
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UIView *)titleBackgroundView
{
    if (_titleBackgroundView == nil) {
        _titleBackgroundView = [[UIView alloc] init];
        [_titleBackgroundView setHidden:YES];
        [_titleBackgroundView setBackgroundColor:[UIColor redColor]];
        [_titleBackgroundView.layer setMasksToBounds:YES];
        [_titleBackgroundView.layer setCornerRadius:2.0f];
    }
    return _titleBackgroundView;
}

- (UIImageView *)recImageView
{
    if (_recImageView == nil) {
        _recImageView = [[UIImageView alloc] initWithImage:[UIImage wb_resourceImageNamed:@"RecordingBkg"]];
    }
    return _recImageView;
}

- (UIImageView *)centerImageView
{
    if (_centerImageView == nil) {
        _centerImageView = [[UIImageView alloc] init];
        [_centerImageView setHidden:YES];
    }
    return _centerImageView;
}

- (UIImageView *)volumeImageView
{
    if (_volumeImageView == nil) {
        _volumeImageView = [[UIImageView alloc] initWithImage:[UIImage wb_resourceImageNamed:@"RecordingSignal001"]];
    }
    return _volumeImageView;
}

@end
