//
//  WBPathManager.m
//  WBChat
//
//  Created by RedRain on 2018/2/2.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBPathManager.h"
#import "WBUserManager.h"

#define kWBResourcePathName @"resource"
#define kWBImagePathName @"images"
#define kWBVoicePathName @"voices"
#define kWBVideoPathName @"videos"
#define kWBFilePathName @"files"

@implementation WBPathManager

+ (NSString *)imagePath{
    return [[self userResourcePath] stringByAppendingPathComponent:kWBImagePathName];
}

+ (NSString *)voicePath{
    return [[self userResourcePath] stringByAppendingPathComponent:kWBVoicePathName];
}

+ (NSString *)videoPath{
    return [[self userResourcePath] stringByAppendingPathComponent:kWBVideoPathName];
}

+ (NSString *)filePath{
    return [[self userResourcePath] stringByAppendingPathComponent:kWBFilePathName];
}

+ (NSString *)userResourcePath{
    return [[self userPath] stringByAppendingPathComponent:kWBResourcePathName];
}

+ (NSString *)userPath{
    return [[self appFinderPath] stringByAppendingPathComponent:[WBUserManager sharedInstance].clientId];
}

+ (NSString *)appFinderPath{
    return [[self libraryPath] stringByAppendingPathComponent:@"WBChatKit"];
}

+ (NSString *)libraryPath{
    return NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
}

@end
