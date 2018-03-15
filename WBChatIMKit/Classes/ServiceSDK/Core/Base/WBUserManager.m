//
//  WBUserManager.m


#import "WBUserManager.h"
#import "WBCoreConfiguration.h"
#import "WBBackgroundManager.h"

@implementation WBUserManager

WB_SYNTHESIZE_SINGLETON_FOR_CLASS(WBUserManager)

- (instancetype)init
{
    self = [super init];
    if (self) {
        [WBCoreRegister sharedInstance];
        [WBBackgroundManager sharedInstance];
    }
    return self;
}

#pragma mark - DB
- (void)openDB{
    
    if (!self.clientId.length) {
        return;
    }
    
    [[WBDBClient sharedInstance] openDB:self.clientId];
    [[WBDBClient sharedInstance] createTable];
}

- (void)closeDB{
    [[WBDBClient sharedInstance] closeDB];
}


@end
