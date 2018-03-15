//
//  WBEmojiGroupCell.m
//  TLChat
//
//  Created by 李伯坤 on 16/2/19.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "WBEmojiGroupCell.h"
#import "WBEmotionPageModel.h"
#import "UIImage+WBImage.h"
@interface WBEmojiGroupCell ()

@property (nonatomic, strong) UIImageView *groupIconView;

@end

@implementation WBEmojiGroupCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor clearColor]];
        UIView *selectedView = [[UIView alloc] init];
        selectedView.backgroundColor = [UIColor colorWithRed:(245.0)/255.0f green:245.0/255.0f blue:(247.0)/255.0f alpha:1.0];

        [self setSelectedBackgroundView:selectedView];
        
        [self.contentView addSubview:self.groupIconView];
        
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat WH = 30;
    self.groupIconView.frame = CGRectMake((self.frame.size.width - WH) / 2, (self.frame.size.height - WH) / 2, WH, WH);
}
- (void)setEmojiGroup:(WBEmotionPageModel *)emojiGroup
{
    _emojiGroup = emojiGroup;
    
    self.groupIconView.image = [UIImage wb_resourceImageNamed:emojiGroup.tabImageName];
}

#pragma mark - # Private Methods



- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.5 alpha:0.3].CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.frame.size.width - 0.5, 5);
    CGContextAddLineToPoint(context, self.frame.size.width - 0.5, self.frame.size.height - 5);
    CGContextStrokePath(context);
}

#pragma mark - Getter -
- (UIImageView *)groupIconView
{
    if (_groupIconView == nil) {
        _groupIconView = [[UIImageView alloc] init];
    }
    return _groupIconView;
}

@end
