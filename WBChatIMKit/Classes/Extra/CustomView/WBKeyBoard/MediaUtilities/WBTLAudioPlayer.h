//
//  TLAudioPlayer.h
//  TLChat
//
//  Created by 李伯坤 on 16/7/12.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WBTLAudioPlayer : NSObject

@property (nonatomic, assign, readonly) BOOL isPlaying;

+ (WBTLAudioPlayer *)sharedAudioPlayer;

- (void)playAudioAtPath:(NSString *)path complete:(void (^)(BOOL finished))complete;

- (void)stopPlayingAudio;

@end
