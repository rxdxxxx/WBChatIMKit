//
//  TLAudioPlayer.m
//  TLChat
//
//  Created by 李伯坤 on 16/7/12.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "WBTLAudioPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface WBTLAudioPlayer() <AVAudioPlayerDelegate>

@property (nonatomic, strong) void (^ completeBlock)(BOOL finished);

@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation WBTLAudioPlayer

+ (WBTLAudioPlayer *)sharedAudioPlayer
{
    static WBTLAudioPlayer *audioPlayer;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        audioPlayer = [[WBTLAudioPlayer alloc] init];
    });
    return audioPlayer;
}

- (void)playAudioAtPath:(NSString *)path complete:(void (^)(BOOL finished))complete;
{
    if (self.player && self.player.isPlaying) {
        [self stopPlayingAudio];
    }
    self.completeBlock = complete;
    NSError *error;
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];
    [self.player setDelegate:self];
    if (error) {
        if (complete) {
            complete(NO);
        }
        return;
    }
    [self.player play];
}

- (void)stopPlayingAudio
{
    [self.player stop];
    if (self.completeBlock) {
        self.completeBlock(NO);
    }
}

- (BOOL)isPlaying
{
    if (self.player) {
        return self.player.isPlaying;
    }
    return NO;
}

#pragma mark - # Delegate
//MARK: AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (self.completeBlock) {
        self.completeBlock(YES);
        self.completeBlock = nil;
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    if (self.completeBlock) {
        self.completeBlock(NO);
        self.completeBlock = nil;
    }
}

@end
