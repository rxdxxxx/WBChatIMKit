//
//  WBVoicePlayer.m
//  WBChat
//
//  Created by RedRain on 2018/2/24.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBVoicePlayer.h"
#import <AVFoundation/AVFoundation.h>
#import "NSString+OPSize.h"
#import "WBConfig.h"
@interface WBVoicePlayer() <AVAudioPlayerDelegate>

@property (nonatomic, strong) void (^ completeBlock)(BOOL finished);

@property (nonatomic, strong) AVAudioPlayer *player;

@property (nonatomic, strong) NSOperationQueue *audioDataOperationQueue;

@property (nonatomic, copy) NSString *lastUrl;

@end

@implementation WBVoicePlayer
+ (instancetype)player {
    static WBVoicePlayer *_sharedplayer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedplayer = [WBVoicePlayer new];
    });
    
    return _sharedplayer;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proximityStateChanged:) name:UIDeviceProximityStateDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        
    }
    return self;
}

- (void)playVoiceWithPath:(NSString *)path complete:(void (^)(BOOL finished))complete{
    if (path == nil) {
        if (complete) {
            complete(NO);
        }
        self.completeBlock = nil;
        self.lastUrl = nil;
        return;
    }
    
    self.completeBlock = complete;
    self.lastUrl = path;
    
    
    NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        NSData *voiceData = [self audioDataFromURLString:path];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self playAudioWithData:voiceData];
        });
    }];
    blockOperation.name = [self.lastUrl wb_MD5String];
    [self.audioDataOperationQueue addOperation:blockOperation];
}
- (void)playAudioWithData:(NSData *)voiceData {
    if (self.player && self.player.isPlaying) {
        [self stopPlayingAudio];
    }
    
    
    NSError *error;
    self.player = [[AVAudioPlayer alloc] initWithData:voiceData error:&error];
    [self.player setDelegate:self];
    if (error) {
        if (self.completeBlock) {
            self.completeBlock(NO);
        }
        return;
    }
    [self.player play];
}

- (NSData *)audioDataFromURLString:(NSString *)URLString {
    NSData *audioData;
    
    //1.检查URLString是本地文件还是网络文件
    if ([URLString hasPrefix:@"http"] || [URLString hasPrefix:@"https"]) {
        //2.来自网络,先检查本地缓存,缓存key是URLString的MD5编码
        NSString *audioCacheKey = [[URLString wb_MD5String] stringByAppendingPathExtension:@"mp3"];
        
        NSString *mp3Path = [[WBPathManager voicePath] stringByAppendingPathComponent:audioCacheKey];
        if ([[NSFileManager defaultManager] fileExistsAtPath:mp3Path]) {
            audioData = [NSData dataWithContentsOfFile:mp3Path];
        }else{
            audioData = [NSData dataWithContentsOfURL:[NSURL URLWithString:URLString]];
            [audioData writeToFile:mp3Path atomically:YES];
        }
        
    } else {
        audioData = [NSData dataWithContentsOfFile:URLString];
    }
    
    return audioData;
}

- (void)stopPlayingAudio
{
    [self.player stop];
    if (self.completeBlock) {
        self.completeBlock(NO);
    }
    
    self.completeBlock = nil;
    self.lastUrl = nil;
}

- (BOOL)isPlaying
{
    if (self.player) {
        return self.player.isPlaying;
    }
    return NO;
}
- (void)cancelOperation {
    for (NSOperation *operation in self.audioDataOperationQueue.operations) {
        if ([operation.name isEqualToString:[self.lastUrl wb_MD5String]]) {
            [operation cancel];
            break;
        }
    }
}
#pragma mark - Notification
- (void)applicationWillResignActive:(UIApplication *)application {
    [self stopPlayingAudio];
    [self cancelOperation];
}
- (void)proximityStateChanged:(NSNotification *)notification {
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗，以达到省电的目的。
    if ([[UIDevice currentDevice] proximityState] == YES) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    } else {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
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

- (NSOperationQueue *)audioDataOperationQueue {
    if (_audioDataOperationQueue == nil) {
        NSOperationQueue *audioDataOperationQueue  = [[NSOperationQueue alloc] init];
        audioDataOperationQueue.name = @"com.redrain.loadAudioDataQueue";
        _audioDataOperationQueue = audioDataOperationQueue;
    }
    return _audioDataOperationQueue;
}
@end

