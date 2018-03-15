//
//  WBEmojiKeyBoard.h
//  WBChat
//
//  Created by RedRain on 2018/1/24.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBEmojiGroupControl.h"

#define WBEmotionDisplayBoardDidSelectEmojiNotifi @"WBEmotionDisplayBoardDidSelectEmojiNotifi"
#define WBEmotionDisplayBoardSendClickNotifi @"WBEmotionDisplayBoardSendClickNotifi"



@interface WBEmotionDisplayBoard : UIView

+ (instancetype)createEmojiKeyboard;

@end
