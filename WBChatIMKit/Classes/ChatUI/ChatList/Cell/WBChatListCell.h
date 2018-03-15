//
//  WBChatListCell.h
//  WBChat
//
//  Created by RedRain on 2017/12/11.
//  Copyright © 2017年 RedRain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBChatListCellModel.h"

@interface WBChatListCell : UITableViewCell

@property (nonatomic, strong) WBChatListCellModel *cellModel;

/**
 创建cell, cell的复用逻辑已经实现, 使用类名作为唯一标识ID
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;


/**
 cell的高度
 */
+ (CGFloat)cellHeight;

@end
