//
//  AVIMConversation+WBExtension.m
//  AVOSCloud
//
//  Created by RedRain on 2018/3/14.
//

#import "AVIMConversation+WBExtension.h"


@implementation AVIMConversation (WBExtension)
- (WBConversationType)wb_conversationType{
    NSNumber *type = self.attributes[WBIM_CONVERSATION_TYPE];
    return type ? type.integerValue : WBConversationTypeSingle;
}
@end
