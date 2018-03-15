//
//  AVIMConversation+WBExtension.h
//  AVOSCloud
//
//  Created by RedRain on 2018/3/14.
//

#import <AVOSCloudIM/AVOSCloudIM.h>
#import "WBIMDefine.h"
@interface AVIMConversation (WBExtension)

/**
 得到会话的类型

 @return 会话类型
 */
- (WBConversationType)wb_conversationType;
@end
