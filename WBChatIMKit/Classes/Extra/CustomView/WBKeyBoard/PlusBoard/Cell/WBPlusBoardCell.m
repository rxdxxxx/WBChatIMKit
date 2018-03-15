//
//  WBPlusBoardCell.m
//  WBChat
//
//  Created by RedRain on 2018/1/31.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBPlusBoardCell.h"

@interface WBPlusBoardCell ()
@end

@implementation WBPlusBoardCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.iconTitleLabel];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat iWidth = 40;
    self.iconImageView.frame = CGRectMake((self.frame.size.width - iWidth) / 2 , (self.frame.size.height - iWidth) / 2 - 8, iWidth, iWidth);
    
    
    CGRect titleRect = CGRectMake(CGRectGetMinX(self.iconImageView.frame), CGRectGetMaxY(self.iconImageView.frame) + 4, CGRectGetWidth(self.iconImageView.frame), 20);
    self.iconTitleLabel.frame = titleRect;
    
}

- (UIImageView *)iconImageView
{
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] init];
    }
    return _iconImageView;
}

- (UILabel *)iconTitleLabel
{
    if (_iconTitleLabel == nil) {
        _iconTitleLabel = [[UILabel alloc] init];
        [_iconTitleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_iconTitleLabel setTextAlignment:NSTextAlignmentCenter];
        _iconTitleLabel.textColor = [UIColor grayColor];
    }
    return _iconTitleLabel;
}
@end
