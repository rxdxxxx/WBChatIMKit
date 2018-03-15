//
//  WBKeyBoard.h
//  WBChat
//
//  Created by RedRain on 2018/1/20.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBChatBarConst.h"

@interface WBChatBarView : UIView

@property (nonatomic, assign) WBChatBarStatus status;

@property (nonatomic, assign) BOOL activity;

@property (nonatomic, weak) id<WBChatBarViewDelegate> delegate;
@property (nonatomic, weak) id<WBChatBarViewDataSource> dataSource;

@property (nonatomic, copy) NSString *chatText;


- (void)stateToInit;

@end
