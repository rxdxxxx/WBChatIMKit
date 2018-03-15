//
//  WBImageLoad.m
//  WBChat
//
//  Created by RedRain on 2018/2/6.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBImageLoad.h"

@implementation WBImageLoad

- (void)imageView:(UIImageView *)imageView urlString:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage{
    imageView.image = placeholderImage;
}


@end
