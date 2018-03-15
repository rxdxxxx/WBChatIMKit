//
//  WBCoreRegister.m

#import "WBCoreRegister.h"
#import "WBDBClient.h"
#import "WBManagerHeaders.h"

@implementation WBCoreRegister

WB_SYNTHESIZE_SINGLETON_FOR_CLASS(WBCoreRegister)

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        // 创建表
        [self registerCreater];
        
        // 程序终止后需要处理的事项
        [self registerTerminateHandler];
    }
    return self;
}


- (void)registerCreater{
    [[WBDBClient sharedInstance] registerDBCreater:[WBChatListManager sharedInstance]];
    [[WBDBClient sharedInstance] registerDBCreater:[WBChatManager sharedInstance]];
}

- (void)registerTerminateHandler{
    
    
}

@end
