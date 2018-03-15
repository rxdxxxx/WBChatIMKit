//
//  AVIMMessage+WBExtension.h


#import <AVOSCloudIM/AVOSCloudIM.h>

@interface AVIMMessage (WBExtension)

- (AVIMTypedMessage *)wb_getValidTypedMessage;
- (BOOL)wb_isValidMessage;

@end
