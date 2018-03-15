//
//  WBVoicePlayer.h
//  WBChat
//
//  Created by RedRain on 2018/2/24.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBVoicePlayer : NSObject
+ (instancetype)player;

- (void)playVoiceWithPath:(NSString *)path complete:(void (^)(BOOL finished))complete;

- (void)stopPlayingAudio;
@end
