//
//  WBChatBaseCell.h
//  WBChat
//
//  Created by RedRain on 2018/1/18.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBChatMessageBaseCellModel.h"
#import "UIView+Frame.h"
#import "UIImage+WBImage.h"

@class WBChatMessageBaseCell;

@protocol WBChatMessageCellDelegate <NSObject>

- (void)cell:(WBChatMessageBaseCell *)cell resendMessage:(WBChatMessageBaseCellModel *)cellModel;
- (void)cell:(WBChatMessageBaseCell *)cell tapImageViewModel:(WBChatMessageBaseCellModel *)cellModel;

@end

@interface WBChatMessageBaseCell : UITableViewCell

/**
 父类根据 cellModel 创建对应的子类对象
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView cellModel:(WBChatMessageBaseCellModel *)cellModel;


/**
 子类必须重写 创建cell, cell的复用逻辑已经实现, 使用类名作为唯一标识ID
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) id<WBChatMessageCellDelegate> delegate;

@property (nonatomic, strong) WBChatMessageBaseCellModel *cellModel;


///气泡
@property (nonatomic, strong) UIImageView *bubbleImageView;


///发送的消息的状态
@property (nonatomic, strong) UIImageView *messageStatusImageView;

/**
 *  会话界面消息阅读状态
 */
@property (nonatomic, strong) UILabel *messageReadStateLabel;

/**
 显示的cell的indexPath
 */
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
