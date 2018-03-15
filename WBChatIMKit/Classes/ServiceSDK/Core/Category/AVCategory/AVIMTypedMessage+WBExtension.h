//
//  AVIMTypedMessage+WBExtension.h
//  WBChat

#import <AVOSCloudIM/AVOSCloudIM.h>
#import "WBMessageModel.h"
@interface AVIMTypedMessage (WBExtension)

- (void)wb_setAttributesObject:(id)object forKey:(NSString *)key;

- (WBChatMessageType)messageType_wb;

@end
