//
//  WBShowBigImageView.m
//  WBChat
//
//  Created by RedRain on 2018/3/1.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBShowBigImageTool.h"
@interface WBShowBigImageTool ()
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGRect tempFrame;
@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UIImageView *actionImageView;

@end


@implementation WBShowBigImageTool

+ (instancetype)sharedInstance {
    static WBShowBigImageTool *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [WBShowBigImageTool new];
    });
    
    return _sharedInstance;
}


+ (void)showWithImage:(UIImage *)image orgFrame:(CGRect)orgFrame{
    WBShowBigImageTool *view = [WBShowBigImageTool sharedInstance];
    view.tempFrame = orgFrame;
    view.image = image;
    [view showPic];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)showPic{
    [UIApplication sharedApplication].statusBarHidden = YES;

    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _backView.backgroundColor = [UIColor blackColor];
    [_backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTapAction)]];
    [[UIApplication sharedApplication].keyWindow addSubview:_backView];
    
    _actionImageView = [[UIImageView alloc] initWithImage:self.image];
    _actionImageView.frame = self.tempFrame;
    _actionImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [[UIApplication sharedApplication].keyWindow addSubview:_actionImageView];
    [UIView animateWithDuration:.3 animations:^{
        CGFloat fixelW = CGImageGetWidth(self.actionImageView.image.CGImage);
        CGFloat fixelH = CGImageGetHeight(self.actionImageView.image.CGImage);
        self.actionImageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, fixelH * [UIScreen mainScreen].bounds.size.width / fixelW);
        self.actionImageView.center = self.backView.center;
    }];
}

- (void)backTapAction{
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIView animateWithDuration:.2 animations:^{
        self.actionImageView.frame = self.tempFrame;
        self.backView.alpha = .3;
    } completion:^(BOOL finished) {
        [self.backView removeFromSuperview];
        [self.actionImageView removeFromSuperview];
    }];
}

@end
