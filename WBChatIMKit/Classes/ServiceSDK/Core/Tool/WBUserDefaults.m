//
//  WBUserDefaults.m
#import "WBUserDefaults.h"

#define kWBShakeState                   @"kWBShakeState"

#define WBStandardUserDefaults ([NSUserDefaults standardUserDefaults])

@implementation WBUserDefaults

/**
 是否可以使用摇一摇显示VC信息
 */
+ (void)saveShakeState:(BOOL)isShaked{
    [WBStandardUserDefaults setBool:isShaked forKey:kWBShakeState];
}
+ (BOOL)getShakeState{
   return [WBStandardUserDefaults boolForKey:kWBShakeState];
}

@end
