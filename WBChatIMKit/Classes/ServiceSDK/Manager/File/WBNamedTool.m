//
//  WBNamedTool.m
//  WBChat
//
//  Created by RedRain on 2018/2/2.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBNamedTool.h"

@implementation WBNamedTool

+ (NSString *)namedWithType:(WBResNamedType)type{
    NSString *leadingString = [self UUID];
    switch (type) {
        case WBResNamedTypeImage:{
            return [leadingString stringByAppendingString:@"_Image.jpg"];
        }
            break;
        case WBResNamedTypeImageThumb:{
            return [leadingString stringByAppendingString:@"_ImageThumb.jpg"];
        }
            break;
        case WBResNamedTypeImageOrigin:{
            return [leadingString stringByAppendingString:@"_ImageOrigin.jpg"];
        }

        default:
            return leadingString;
            break;
    }
}
+ (NSString *)UUID{
    return [[NSUUID UUID] UUIDString];
}
@end
