//
//  AVIMMessage+WBExtension.m

#import "AVIMMessage+WBExtension.h"
#import "NSBundle+LCCKExtension.h"
#import "WBIMDefine.h"
#import "WBServiceSDKHeaders.h"


@implementation AVIMMessage (WBExtension)

- (BOOL)wb_isValidMessage {
    id messageToCheck = (id)self;
    if (!messageToCheck || messageToCheck == [NSNull null]) {
        return NO;
    }
    return YES;
}

- (AVIMTypedMessage *)wb_getValidTypedMessage {
    if (!self.wb_isValidMessage) {
        return nil;
    }
    if ([self isKindOfClass:[AVIMTypedMessage class]]) {
        return (AVIMTypedMessage *)self;
    }
    NSString *messageText;
    NSDictionary *attr;
    if ([[self class] isSubclassOfClass:[AVIMMessage class]]) {
        //当存在无法识别的自定义消息，SDK会返回 AVIMMessage 类型
        AVIMMessage *message = self;
        NSString *jsonString = message.content;
        NSDictionary *json = [jsonString wb_JSONValue];
        do {
            NSString *customMessageDegradeKey = [json valueForKey:@"_lctext"];
            if (customMessageDegradeKey.length > 0) {
                messageText = customMessageDegradeKey;
                break;
            }
            attr = [json valueForKey:@"_lcattrs"];
            NSString *customMessageAttrDegradeKey = [attr valueForKey:WBIMCustomMessageDegradeKey];
            if (customMessageAttrDegradeKey.length > 0) {
                messageText = customMessageAttrDegradeKey;
                break;
            }
            messageText = WBIMLocalizedStrings(@"unknownMessage");
            break;
        } while (NO);
    }
    AVIMTextMessage *typedMessage = [AVIMTextMessage messageWithText:messageText attributes:attr];
    [typedMessage setValue:self.conversationId forKey:@"conversationId"];
    [typedMessage setValue:self.messageId forKey:@"messageId"];
    [typedMessage setValue:@(self.sendTimestamp) forKey:@"sendTimestamp"];
    [typedMessage setValue:self.clientId forKey:@"clientId"];
    
    [typedMessage wb_setAttributesObject:@(YES) forKey:WBIMCustomMessageIsCustomKey];
    return typedMessage;
}
@end
