//
//  WBTLRecorderIndicatorView.h
//  TLChat
//
//  Created by 李伯坤 on 16/7/12.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WBTLRecorderStatus) {
    WBTLRecorderStatusRecording,
    WBTLRecorderStatusWillCancel,
    WBTLRecorderStatusTooShort,
};

@interface WBTLRecorderIndicatorView : UIView

@property (nonatomic, assign) WBTLRecorderStatus status;

/**
 *  音量大小，取值（0-1）
 */
@property (nonatomic, assign) CGFloat volume;

@end
