//
//  WBEmojiGroupControl.h

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WBGroupControlSendButtonStatus) {
    WBGroupControlSendButtonStatusGray,
    WBGroupControlSendButtonStatusBlue,
    WBGroupControlSendButtonStatusNone,
};
#define     WBKeyBoardSCREEN_SIZE_emoji                 [UIScreen mainScreen].bounds.size
#define     WBKeyBoardSCREEN_WIDTH_emoji                WBKeyBoardSCREEN_SIZE_emoji.width
#define     WBiOSVersion_emoji      ([[UIDevice currentDevice].systemVersion doubleValue])
#define     WBNavigationBarHeight_emoji    (WBiOSVersion_emoji >= 7.0 ? 64 : 44)
#define     WB_IS_IPHONE_X_emoji (fabs((double)[[ UIScreen mainScreen ] bounds ].size.height - ( double )812)==0)
#define     WB_IPHONEX_TOP_SPACE_emoji ((WB_IS_IPHONE_X_emoji)?24:0)
#define     WB_IPHONEX_BOTTOM_SPACE_emoji ((WB_IS_IPHONE_X_emoji)?34:0)
#define     WB_NavHeight_emoji (64+WB_IPHONEX_TOP_SPACE_emoji)
#define     WB_TabBarHeight_emoji (49+WB_IPHONEX_BOTTOM_SPACE_emoji)
#define     WB_EmojiBoard_Height (216)
@class WBEmojiGroupControl;
@protocol WBEmojiGroupControlDelegate <NSObject>

- (void)emojiGroupControl:(WBEmojiGroupControl*)emojiGroupControl didSelectedGroup:(id)group;

- (void)emojiGroupControlEditButtonDown:(WBEmojiGroupControl *)emojiGroupControl;

- (void)emojiGroupControlEditMyEmojiButtonDown:(WBEmojiGroupControl *)emojiGroupControl;

- (void)emojiGroupControlSendButtonDown:(WBEmojiGroupControl *)emojiGroupControl;

@end

@interface WBEmojiGroupControl : UIView

@property (nonatomic, assign) WBGroupControlSendButtonStatus sendButtonStatus;

@property (nonatomic, strong) NSMutableArray *emojiGroupData;

@property (nonatomic, assign) id<WBEmojiGroupControlDelegate>delegate;

- (void)selectEmojiGroupAtIndex:(NSInteger)index;

@end
