//
//  WBChatKitProtocol.h
//  Pods
//
//  Created by RedRain on 2018/3/14.
//

#ifndef WBChatKitProtocol_h
#define WBChatKitProtocol_h

#import <Foundation/Foundation.h>

@protocol WBChatKitProtocol <NSObject>

- (NSString *)memberNameWithClientID:(NSString *)clientId;

@end

#endif /* WBChatKitProtocol_h */
