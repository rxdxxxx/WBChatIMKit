
//
//  TLAudioRecorder.m
//  TLChat
//
//  Created by 李伯坤 on 16/7/11.
//  Copyright © 2016年 李伯坤. All rights reserved.
//

#import "WBTLAudioRecorder.h"
#import <AVFoundation/AVFoundation.h>
#if __has_include(<lame/lame.h>)
#import <lame/lame.h>
#else
#import "lame.h"
#endif
#import "WBPathManager.h"
#define     PATH_RECFILE        [self cafPath]

@interface WBTLAudioRecorder () <AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioRecorder *recorder;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) void (^volumeChangedBlock)(CGFloat valume);
@property (nonatomic, strong) void (^completeBlock)(NSString *path, CGFloat time);
@property (nonatomic, strong) void (^cancelBlock)(void);

@end

@implementation WBTLAudioRecorder

+ (WBTLAudioRecorder *)sharedRecorder
{
    static dispatch_once_t once;
    static WBTLAudioRecorder *audioRecorder;
    dispatch_once(&once, ^{
        audioRecorder = [[WBTLAudioRecorder alloc] init];
    });
    return audioRecorder;
}

- (void)startRecordingWithVolumeChangedBlock:(void (^)(CGFloat volume))volumeChanged
                               completeBlock:(void (^)(NSString *path, CGFloat time))complete
                                 cancelBlock:(void (^)(void))cancel;
{
    self.volumeChangedBlock = volumeChanged;
    self.completeBlock = complete;
    self.cancelBlock = cancel;
    if ([[NSFileManager defaultManager] fileExistsAtPath:PATH_RECFILE]) {
        [[NSFileManager defaultManager] removeItemAtPath:PATH_RECFILE error:nil];
    }
    [self.recorder prepareToRecord];
    [self.recorder record];
    
    if (self.timer && self.timer.isValid) {
        [self.timer invalidate];
    }

    if (self.timer) {
        [self.timer invalidate];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timeCallBack) userInfo:nil repeats:YES];
}
                  
- (void)timeCallBack{
  [self.recorder updateMeters];
  float peakPower = pow(10, (0.05 * [self.recorder peakPowerForChannel:0]));
  if (self && self.volumeChangedBlock) {
      self.volumeChangedBlock(peakPower);
  }
}

- (void)stopRecording
{
    [self.timer invalidate];
    CGFloat time = self.recorder.currentTime;
    [self.recorder stop];
    if (self.completeBlock) {
        NSString *localMp3Path = [self audio_PCMtoMP3];
        self.completeBlock(localMp3Path, time);
        self.completeBlock = nil;
    }
}

- (void)cancelRecording
{
    [self.timer invalidate];
    [self.recorder stop];
    if (self.cancelBlock) {
        self.cancelBlock();
        self.cancelBlock = nil;
    }
}

#pragma mark - # Delegate
//MARK: AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (flag) {
//        NSLog(@"录音成功");
    }
}

#pragma mark - Private

- (NSString *)audio_PCMtoMP3
{
    NSString *cafFilePath = [self cafPath];
    NSString *mp3FilePath = [[self mp3Path] stringByAppendingPathComponent:[self randomMP3FileName]];
    
    ////NSLog(@"MP3转换开始");
    @try {
        int read, write;
        
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 8000.00f);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        //NSLog(@"%@",[exception description]);
        mp3FilePath = nil;
    }
    @finally {
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
        //NSLog(@"MP3转换结束");
        return mp3FilePath;
    }
    
    
}
- (NSString *)cafPath {
    NSString *cafPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tmp.caf"];
    return cafPath;
}

- (NSString *)mp3Path {
    NSString *mp3Path = [WBPathManager voicePath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:mp3Path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:mp3Path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return mp3Path;
}
- (NSString *)randomMP3FileName {
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"record_%.0f.mp3",timeInterval];
    return fileName;
}
#pragma mark - # Getter
- (AVAudioRecorder *)recorder
{
    if (_recorder == nil) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *sessionError;
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        
        if(session == nil){
            return nil;
        }
        else {
            [session setActive:YES error:nil];
        }
        
        
        NSDictionary *settings = @{AVFormatIDKey: @(kAudioFormatLinearPCM),
                                   AVSampleRateKey: @8000.00f,
                                   AVNumberOfChannelsKey: @2,
                                   AVLinearPCMBitDepthKey: @16,
                                   AVLinearPCMIsNonInterleaved: @NO,
                                   AVLinearPCMIsFloatKey: @NO,
                                   AVLinearPCMIsBigEndianKey: @NO};
        
        _recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:self.recFilePath] settings:settings error:NULL];
        _recorder.delegate = self;
        _recorder.meteringEnabled = YES;
    }
    return _recorder;
}

- (NSString *)recFilePath
{
    return PATH_RECFILE;
}

@end
