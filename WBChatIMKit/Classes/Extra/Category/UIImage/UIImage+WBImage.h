//
//  UIImage+WBImage.h
//  WBChat
//
//  Created by RedRain on 2018/1/19.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WBImage)

/**
 获取到用户默认头像
 */
+ (UIImage *)wb_userHeaderPlaceholderImage;

/**
 根据图片名称, 去WBUI.bundle中获取图片
 */
+ (UIImage *)wb_resourceImageNamed:(NSString *)name;

@end
