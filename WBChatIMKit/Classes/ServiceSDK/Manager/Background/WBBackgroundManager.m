//
//  WBBackgroundManager.m
//  WBChat
//
//  Created by RedRain on 2018/1/16.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBBackgroundManager.h"

@implementation WBBackgroundManager
WB_SYNTHESIZE_SINGLETON_FOR_CLASS(WBBackgroundManager)

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self notificationName:WBIMNotificationConnectivityUpdated action:@selector(connectivityUpdated)];
    }
    return self;
}

- (void)notificationName:(NSString *)name action:(SEL)action{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:action name:name object:nil];
}

- (void)pushNotificationName:(NSString *)name{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:nil];
}

#pragma mark - Notification Action
- (void)connectivityUpdated{
    
    if ([WBChatKit sharedInstance].connectStatus == AVIMClientStatusOpened) {
        
//        [[WBChatListManager sharedInstance] fetchAllConversationsFromServer:^(NSArray<AVIMConversation *> * _Nullable conersations,
//                                                                              NSError * _Nullable error)
//        {
//            if (error == nil) {
//            }
//        }];
    }
}

@end
