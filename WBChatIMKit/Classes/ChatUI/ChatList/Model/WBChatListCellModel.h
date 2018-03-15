//
//  WBChatListCellModel.h
//  WBChat
//
//  Created by RedRain on 2017/12/11.
//  Copyright © 2017年 RedRain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBConfig.h"

@interface WBChatListCellModel : NSObject

@property (nonatomic, assign) CGRect chatUserHeaderViewF;
@property (nonatomic, assign) CGRect chatTitleF;
@property (nonatomic, assign) CGRect chatMessageF;
@property (nonatomic, assign) CGRect chatTimeF;
@property (nonatomic, assign) CGRect cutLineF;
@property (nonatomic, assign) CGRect unreadBadgeBtnF;



@property (nonatomic, copy) NSAttributedString *lastMessageString;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) WBChatListModel *dataModel;

@end
