//
//  WBFileManager.h
//  WBChat
//
//  Created by RedRain on 2018/2/2.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WBCoreConfiguration.h"

@interface WBFileManager : NSObject

+ (BOOL)saveImageData:(NSData *)data toImagePath:(NSString *)imagePath;

@end
