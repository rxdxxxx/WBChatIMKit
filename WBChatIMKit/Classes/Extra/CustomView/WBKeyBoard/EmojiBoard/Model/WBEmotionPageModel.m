//
//  WBEmojiKeyBoardCellModel.m
//  WBChat
//
//  Created by RedRain on 2018/1/24.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBEmotionPageModel.h"

@implementation WBEmotionPageItemModel

@end

@implementation WBEmotionPageModel

- (NSString *)tabImageName{
    switch (self.type) {
        case WBEmotionPageTypeEmoji:
            return @"EmotionsEmojiHL";
            break;
            
        default:
            return _tabImageName;
            break;
    }
}

@end
