//
//  WBChatMessageTextCell.m
//  WBChat
//
//  Created by RedRain on 2018/1/19.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBChatMessageTextCell.h"
#import "WBChatMessageTextCellModel.h"
@interface WBChatMessageTextCell ()<UIGestureRecognizerDelegate>
///会话文本内容
@property (nonatomic, strong)UILabel *mLabel;

@property (nonatomic, strong) UIScrollView *textContentScrollView;

@property (nonatomic, strong) UIMenuController *menuController;

@end

@implementation WBChatMessageTextCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"WBChatMessageTextCell";
    WBChatMessageTextCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[WBChatMessageTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.mLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)backTapClick:(UITapGestureRecognizer *)tap{
    
}

#pragma mark -  Getters and Getters
- (void)setCellModel:(WBChatMessageTextCellModel *)cellModel{
    [super setCellModel:cellModel];
    
    
    [UIView setAnimationsEnabled:NO];
    
    self.bubbleImageView.frame = cellModel.textWithBubbleRectFrame;
    self.mLabel.frame=cellModel.textRectFrame;
    [UIView setAnimationsEnabled:YES];
    

    
    
    if(cellModel.messageModel.content.ioType == AVIMMessageIOTypeIn){
        self.mLabel.textColor=[UIColor blackColor];
    }
    else{
        self.mLabel.textColor=[UIColor whiteColor];
    }
    self.mLabel.text = cellModel.content;
    
    
}

#pragma mark - getters and setters
-(UILabel *)mLabel{
    if(nil==_mLabel)
    {
        _mLabel=[[UILabel alloc] initWithFrame:CGRectZero];
        _mLabel.font = [WBChatCellConfig sharedInstance].textFont;
        _mLabel.numberOfLines = 0;
        _mLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _mLabel;
}

- (UIScrollView *)textContentScrollView {
    if (!_textContentScrollView) {
        //3.设置滚动视图
        _textContentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWBScreenWidth, kWBScreenWidth)];
        _textContentScrollView.backgroundColor = [UIColor whiteColor];
        _textContentScrollView.showsHorizontalScrollIndicator = NO;
        _textContentScrollView.showsVerticalScrollIndicator = YES;
        _textContentScrollView.bounces = YES;
        UITapGestureRecognizer *backTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backTapClick:)];
        [_textContentScrollView addGestureRecognizer:backTap];
        
    }
    return _textContentScrollView;
}

@end
