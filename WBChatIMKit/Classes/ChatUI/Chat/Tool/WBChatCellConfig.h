//
//  WBChatCellConfig.h
//  WBChat
//
//  Created by RedRain on 2018/1/19.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBConst.h"
#import "WBImageLoad.h"

@interface WBChatCellConfig : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) WBImageLoad *imageLoad;
@property (nonatomic, strong) UIImage *placeholdHeaderImage;

@property (nonatomic, assign) CGFloat normalSpace; ///< 控件间的距离 默认: 5


@property (nonatomic, assign) CGSize headerImageSize; ///<  头像大小: 默认:{50,50}
@property (nonatomic, assign) CGFloat headerMarginSpace; ///< 头像距离屏幕边界的距离: 默认:15
@property (nonatomic, assign) CGFloat headerBubbleSpace; ///< 头像和气泡的距离 默认: 12


@property (nonatomic, assign) CGSize userNameSize; ///< 展示的用户名称 默认: {200,15}

@property (nonatomic, assign) CGSize messageStatusIconSize; ///< 消息的状态图片 默认: {20,20}
@property (nonatomic, assign) CGFloat messageStatusIconToBubble; ///< 状态图片和气泡的距离 默认: 5

@property (nonatomic, assign) CGSize messageStatusLabelSize; ///< 消息的状态文字 默认: {40,20}
@property (nonatomic, assign) CGFloat messageStatusLabelToBubble; ///< 消息的状态文字和气泡的距离 默认: 5

@property (nonatomic, strong) UIFont *timeFont; // 默认使用字体: 12


// 文字消息相关
@property (nonatomic, strong) UIFont *textFont; // 默认使用字体: 17
@property (nonatomic, assign) UIEdgeInsets textbubbleContentInset; ///< 文本气泡内部文字距离气泡边界的距离
@property (nonatomic, assign) CGFloat bubbleClosedAngleWidth; ///< 气泡前面尖角的宽度 默认: 5
@property (nonatomic, assign) CGFloat textMaxWidth; ///< 文本的最大宽度

// 图片消息相关
@property (nonatomic, assign) CGSize imageProgressSize;

// 语音相关
@property (nonatomic, assign) CGSize voiceWaveSize;

@end
