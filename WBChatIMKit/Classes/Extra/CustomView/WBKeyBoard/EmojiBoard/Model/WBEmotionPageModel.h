//
//  WBEmojiKeyBoardCellModel.h
//  WBChat
//
//  Created by RedRain on 2018/1/24.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WBEmotionItemType) {
    WBEmotionItemTypeDelete,
    WBEmotionItemTypeEmoji
};

typedef NS_ENUM(NSUInteger, WBEmotionPageType) {
    WBEmotionPageTypeAdd,
    WBEmotionPageTypeEmoji,
    WBEmotionPageTypeSend,
    WBEmotionPageTypeCollect
};

@interface WBEmotionPageItemModel : NSObject

@property (nonatomic, assign) WBEmotionItemType type;

@property (nonatomic, strong) NSString *name;



@end


@interface WBEmotionPageModel : NSObject

@property (nonatomic, copy) NSString *tabImageName;

@property (nonatomic, assign) WBEmotionPageType type;

@property (nonatomic, assign) CGSize cellSize;

@property (nonatomic, strong) NSMutableArray<WBEmotionPageItemModel *> *pageDataArray;

@end
