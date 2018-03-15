//
//  TLTalkButton.h
//  TLChat
//
//  Created by 李伯坤 on 16/7/11.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#define WBAudioCompleteFinishNotification  @"WBAudioCompleteFinishNotification"

NS_ASSUME_NONNULL_BEGIN
@interface WBTLTalkButton : UIView

@property (nonatomic, strong) NSString *normalTitle;
@property (nonatomic, strong) NSString *cancelTitle;
@property (nonatomic, strong) NSString *highlightTitle;

@property (nonatomic, strong) UIColor *highlightColor;

@property (nonatomic, strong) UILabel *titleLabel;

- (void)setTouchBeginAction:(void (^)(void))touchBegin
      willTouchCancelAction:(void (^)(BOOL cancel))willTouchCancel
             touchEndAction:(void (^)(void))touchEnd
          touchCancelAction:(void (^)(void))touchCancel;

@end
NS_ASSUME_NONNULL_END
