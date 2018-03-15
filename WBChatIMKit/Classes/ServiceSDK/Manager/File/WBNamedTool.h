//
//  WBNamedTool.h
//  WBChat
//
//  Created by RedRain on 2018/2/2.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WBResNamedType) {
    WBResNamedTypeImage,
    WBResNamedTypeImageThumb,
    WBResNamedTypeImageOrigin,
    WBResNamedTypeSound,
    WBResNamedTypeVideo,
    WBResNamedTypeVideoThumb,
    WBResNamedTypeLocation,
    WBResNamedTypeLocationThumb,
    WBResNamedTypeFile
};

@interface WBNamedTool : NSObject

+ (NSString *)namedWithType:(WBResNamedType)type;

@end
