//
//  WBEmojiKeyBoardCell.m
//  WBChat
//
//  Created by RedRain on 2018/1/24.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBEmojiKeyBoardCell.h"
#import "UIImage+WBImage.h"

@interface WBEmojiKeyBoardCell ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *label;
@end

@implementation WBEmojiKeyBoardCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.label];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat iWidth = 32;
    self.imageView.frame = CGRectMake((self.frame.size.width - iWidth) / 2 , (self.frame.size.height - iWidth) / 2, iWidth, iWidth);
    self.label.frame = self.imageView.frame;
    
}

- (void)setCellModel:(WBEmotionPageItemModel *)cellModel{
    _cellModel = cellModel;
    
    
    switch (cellModel.type) {
        case WBEmotionItemTypeDelete:
        {
            
            [self.imageView setHidden:NO];
            [self.label setHidden:YES];
            [self.imageView setImage:[UIImage wb_resourceImageNamed:@"DeleteEmoticonBtn"]];
        }
            break;
        case WBEmotionItemTypeEmoji:
        {
            
            [self.imageView setHidden:YES];
            [self.label setHidden:NO];
            [self.label setText:cellModel.name];
        }
            break;
            
        default:
            break;
    }
}

- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)label
{
    if (_label == nil) {
        _label = [[UILabel alloc] init];
        [_label setFont:[UIFont systemFontOfSize:28.0f]];
        [_label setTextAlignment:NSTextAlignmentCenter];
    }
    return _label;
}

@end
