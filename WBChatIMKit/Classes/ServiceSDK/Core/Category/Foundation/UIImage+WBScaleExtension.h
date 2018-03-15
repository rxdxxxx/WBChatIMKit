//
//  UIImage+LCCKExtension.h
//  LeanCloudChatKit-iOS
//
//  v0.8.5 Created by ElonChan on 16/5/7.
//  Copyright © 2016年 LeanCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WBScaleExtension)

- (UIImage *)wb_imageByScalingAspectFill;
/*!
 * @attention This will invoke `CGSize kMaxImageViewSize = {.width = 200, .height = 200};`.
 */
- (UIImage *)wb_imageByScalingAspectFillWithOriginSize:(CGSize)originSize;

- (UIImage *)wb_imageByScalingAspectFillWithOriginSize:(CGSize)originSize
                                               limitSize:(CGSize)limitSize;


- (UIImage *)wb_scalingPatternImageToSize:(CGSize)size;


- (NSData *)wb_compressWithMaxKBytes:(NSUInteger)maxLength;
@end
