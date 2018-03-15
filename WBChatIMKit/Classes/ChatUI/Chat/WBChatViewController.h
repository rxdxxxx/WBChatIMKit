//
//  WBChatViewController.h
//  WBChat
//
//  Created by RedRain on 2018/1/16.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBBaseController.h"
#import "WBServiceSDKHeaders.h"
#import "WBChatBarView.h"
#import "WBSelectPhotoTool.h"
#import "WBChatMessageBaseCell.h"

@class WBChatMessageBaseCellModel;
@class WBChatMessageBaseCell;
@protocol WBChatBarViewDelegate;
/******************************************************************************************
 ************************ 子类可能需要可以实现方法, 方便自定义消息等操作   ************************
 *****************************************************************************************/
@protocol WBChatViewControllerSubclassing <NSObject>

@optional

/**
 子类实现的cell
 */
- (UITableViewCell *)wb_controllerTableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 在cell提供给tableView之前, 再次提供给子类修改的机会,
 -tableView:cellForRowAtIndexPath 返回之前
 
 @param cell 即将提供给tableView的cell
 */
- (void)wb_willDisplayMessageCell:(WBChatMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end

/******************************************************************************************
 ************************        WBChatViewController              ************************
 *****************************************************************************************/
@interface WBChatViewController : WBBaseController
<WBChatViewControllerSubclassing,WBChatBarViewDelegate,WBSelectPhotoToolDelegate,
WBChatBarViewDelegate,WBChatBarViewDataSource,WBChatMessageCellDelegate>

/**
 会话对象
 */
@property (nonatomic, strong) AVIMConversation *conversation;

/**
 存放消息列表的数组
 */
@property (nonatomic, strong) NSMutableArray<WBChatMessageBaseCellModel *> *dataArray;


/**
 从最近联系人列表进入到聊天界面

 @param conversation 会话镀锡
 @return 控制器对象
 */
+ (instancetype)createWithConversation:(AVIMConversation *)conversation;



/**
 发送消息.
 此方法的行为:
    1.判断这条消息和上一条消息的关系后(间隔3分钟),决定是否插入时间
    2.tableView滚动到最底部
    3.发送消息后, 根据回执刷新对应的消息

 @param message 消息模型,保存
 */
- (void)sendMessage:(WBMessageModel *)message;

@end


