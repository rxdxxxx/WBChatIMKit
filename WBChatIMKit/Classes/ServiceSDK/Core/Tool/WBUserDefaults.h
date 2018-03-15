//
//  WBUserDefaults.h

#import <Foundation/Foundation.h>

@interface WBUserDefaults : NSObject

/**
 是否可以使用摇一摇显示VC信息
 */
+ (void)saveShakeState:(BOOL)isShaked;
+ (BOOL)getShakeState;

@end
