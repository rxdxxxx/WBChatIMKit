//
//  WBChatListController.h
//  WBChat
//
//  Created by RedRain on 2017/11/17.
//  Copyright © 2017年 RedRain. All rights reserved.
//

#import "WBBaseController.h"
@class WBChatListCellModel;
@interface WBChatListController : WBBaseController
@property (nonatomic, strong) NSMutableArray<WBChatListCellModel *> *dataArray;

@end
