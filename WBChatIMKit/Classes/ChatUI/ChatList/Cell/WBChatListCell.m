//
//  WBChatListCell.m
//  WBChat
//
//  Created by RedRain on 2017/12/11.
//  Copyright © 2017年 RedRain. All rights reserved.
//

#import "WBChatListCell.h"
#import "WBBadgeButton.h"
#import "WBChatCellConfig.h"

@interface WBChatListCell ()

@property (nonatomic, strong) UIImageView *chatHeaderView; ///< 会话的头像
@property (nonatomic, strong) UILabel *chatTitleLabel; ///< 会话的名称
@property (nonatomic, strong) UILabel *chatMessageLabel; ///< 最后一天聊天记录
@property (nonatomic, strong) UILabel *chatTimeLabel; ///< 时间
@property (nonatomic, strong) UIView *cutLineView; ///< 分割线
@property (nonatomic, strong) WBBadgeButton *unreadBadgeBtn;

@end

@implementation WBChatListCell
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"WBChatListCell";
    WBChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[WBChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.chatHeaderView];
        [self.contentView addSubview:self.chatTitleLabel];
        [self.contentView addSubview:self.chatMessageLabel];
        [self.contentView addSubview:self.chatTimeLabel];
        [self.contentView addSubview:self.cutLineView];
        [self.contentView addSubview:self.unreadBadgeBtn];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark -  Life Cycle
#pragma mark -  UITableViewDelegate
#pragma mark -  CustomDelegate
#pragma mark -  Event Response
#pragma mark -  Notification Callback
#pragma mark -  GestureRecognizer Action
#pragma mark -  Btn Click
#pragma mark -  Private Methods
- (void)setupUI{
    
}
- (void)setupHeaderImageView{
    WBConversationType type = self.cellModel.dataModel.conversation.wb_conversationType;
    if (type == WBConversationTypeSingle) {
        NSArray *member = self.cellModel.dataModel.conversation.members;
        // 如果实现了代理, 那么使用代理返回的数据
        if ([[WBChatKit sharedInstance].delegate respondsToSelector:@selector(imageView:clientID:placeholdImage:)]) {
            NSString *otherObjectId = member.firstObject;
            if ([otherObjectId isEqualToString:[WBUserManager sharedInstance].clientId]) {
                otherObjectId = member.lastObject;
            }
            
            [[WBChatKit sharedInstance].delegate imageView:self.chatHeaderView
                                                  clientID:otherObjectId
                                            placeholdImage:[WBChatCellConfig sharedInstance].placeholdHeaderImage];
            
        }else{
            self.chatHeaderView.image = [WBChatCellConfig sharedInstance].placeholdHeaderImage;
        }
        
    }
    
    // 非单人会话,使用conversationId查询图片
    else{
        if ([[WBChatKit sharedInstance].delegate respondsToSelector:@selector(imageView:conversationId:placeholdImage:)]) {
            
            [[WBChatKit sharedInstance].delegate imageView:self.chatHeaderView
                                            conversationId:self.cellModel.dataModel.conversation.conversationId
                                            placeholdImage:[WBChatCellConfig sharedInstance].placeholdHeaderImage];
            
        }else{
            self.chatHeaderView.image = [WBChatCellConfig sharedInstance].placeholdHeaderImage;
            
        }
    }
}

#pragma mark -  Public Methods
+ (CGFloat)cellHeight{
    return 70;
}
#pragma mark -  Getters and Setters
- (void)setCellModel:(WBChatListCellModel *)cellModel{
    _cellModel = cellModel;
    
    self.chatHeaderView.frame = cellModel.chatUserHeaderViewF;
    [self setupHeaderImageView];
    
    
    self.chatTitleLabel.frame = cellModel.chatTitleF;
    self.chatTitleLabel.text = cellModel.dataModel.conversation.name;
    
    self.chatTimeLabel.frame = cellModel.chatTimeF;
    NSString *timeString = cellModel.dataModel.conversation.lastMessageAt.wb_chatListTimeString;
    if (timeString.length == 0) {
        timeString = cellModel.dataModel.conversation.updateAt.wb_chatListTimeString;
    }
    self.chatTimeLabel.text = timeString;
    
    // 5.设置未读数
    self.unreadBadgeBtn.badgeValue = @(cellModel.dataModel.unreadCount).stringValue;
    self.unreadBadgeBtn.frame = cellModel.unreadBadgeBtnF;
    
    self.chatMessageLabel.frame = cellModel.chatMessageF;
    self.chatMessageLabel.attributedText = cellModel.lastMessageString;
    
    self.cutLineView.frame = cellModel.cutLineF;
}



- (UIImageView *)chatHeaderView{
    if (!_chatHeaderView) {
        _chatHeaderView = [[UIImageView alloc]init];
        _chatHeaderView.layer.cornerRadius = 5;
        _chatHeaderView.layer.masksToBounds = YES;
    }
    return _chatHeaderView;
}

- (UILabel *)chatTitleLabel{
    if (!_chatTitleLabel) {
        _chatTitleLabel = [[UILabel alloc]init];
        _chatTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _chatTitleLabel.font = [UIFont systemFontOfSize:16];
        _chatTitleLabel.textColor = [UIColor blackColor];
    }
    return _chatTitleLabel;
}
- (UILabel *)chatMessageLabel{
    if (!_chatMessageLabel) {
        _chatMessageLabel = [[UILabel alloc]init];
        _chatMessageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _chatMessageLabel.font = [UIFont systemFontOfSize:14];
        _chatMessageLabel.textColor = [UIColor lightGrayColor];
    }
    return _chatMessageLabel;
}
- (UILabel *)chatTimeLabel{
    if (!_chatTimeLabel) {
        _chatTimeLabel = [[UILabel alloc]init];
        _chatTimeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _chatTimeLabel.font = [UIFont systemFontOfSize:12];
        _chatTimeLabel.textColor = [UIColor lightGrayColor];
        _chatTimeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _chatTimeLabel;
}
- (UIView *)cutLineView{
    if (!_cutLineView) {
        _cutLineView = [[UIView alloc]init];
        _cutLineView.translatesAutoresizingMaskIntoConstraints = NO;
        _cutLineView.backgroundColor = [UIColor lightGrayColor];
        _cutLineView.alpha = 0.5;
    }
    return _cutLineView;
}

- (WBBadgeButton *)unreadBadgeBtn{
    if (!_unreadBadgeBtn) {
        _unreadBadgeBtn = [[WBBadgeButton alloc]init];
    }
    return _unreadBadgeBtn;
}
@end

