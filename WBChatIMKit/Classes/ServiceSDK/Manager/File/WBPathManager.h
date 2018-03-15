//
//  WBPathManager.h
//  WBChat
//
//  Created by RedRain on 2018/2/2.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBCoreConfiguration.h"

@interface WBPathManager : NSObject

+ (NSString *)imagePath;

+ (NSString *)voicePath;

+ (NSString *)videoPath;

+ (NSString *)filePath;

+ (NSString *)userResourcePath;

+ (NSString *)userPath;

+ (NSString *)libraryPath;

@end
