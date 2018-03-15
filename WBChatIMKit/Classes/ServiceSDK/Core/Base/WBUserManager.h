//
//  WBUserManager.h

#import <Foundation/Foundation.h>
#import "WBSynthesizeSingleton.h"

@interface WBUserManager : NSObject

WB_SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(WBUserManager)

@property (nonatomic, copy) NSString * _Nullable clientId;


/**
 打开数据库
 */
- (void)openDB;


/**
 关闭数据库
 */
- (void)closeDB;

@end
