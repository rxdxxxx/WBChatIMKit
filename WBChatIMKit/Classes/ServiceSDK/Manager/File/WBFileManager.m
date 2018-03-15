//
//  WBFileManager.m
//  WBChat
//
//  Created by RedRain on 2018/2/2.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBFileManager.h"

@implementation WBFileManager

+ (BOOL)saveImageData:(NSData *)data toImagePath:(NSString *)imagePath{
    BOOL ret = YES;
    ret = [self createFileWithPath:imagePath];
    if (ret) {
        ret = [data writeToFile:imagePath atomically:YES];
    }
    return ret;
}


+ (BOOL)createFileWithPath:(NSString*)filePath{
    
    // 1. 先判断文件路径文件是否存在
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        return YES;
    }
    
    
    // 2.先创建对应目录
    BOOL result = YES;
    NSString *finalPath = [filePath stringByDeletingLastPathComponent];
    result = [[NSFileManager defaultManager] createDirectoryAtPath:finalPath withIntermediateDirectories:YES attributes:nil error:nil];
    if(!result){
        return result;
    }
    
    // 3.创建对应的文件对象
    result = [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    return result;
}

@end
