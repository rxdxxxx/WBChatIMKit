//
//  WBPlusDisplayBoard.h
//  WBChat
//
//  Created by RedRain on 2018/1/31.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBEmojiGroupControl.h"
#import "WBChatBarConst.h"

@interface WBPlusDisplayBoard : UIView

+ (instancetype)createPlusBoard;

@property (nonatomic, weak) id<WBChatBarViewDelegate> delegate;
@property (nonatomic, weak) id<WBChatBarViewDataSource> dataSource;

- (void)reloadData;

@end
