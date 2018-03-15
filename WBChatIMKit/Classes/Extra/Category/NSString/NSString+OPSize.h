//
//  NSString+OPSize.h
//  LCGOptimusPrime
//
//  Created by RedRain on 2017/8/9.
//  Copyright © 2017年 erics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (OPSize)
- (CGSize)lcg_sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW;
- (CGSize)lcg_sizeWithFont:(UIFont *)font;


/**
 去除字符串收尾空格,以及回车换行符

 @return 处理后的字符串
 */
- (NSString *)lcg_removeWhitespaceAndNewlineCharacterSet;

/**
 排除自身特殊字符

 @return 处理后的字符串
 */
- (NSString *)lcg_filterSpecialStr;


- (BOOL)isLegalExpressCode:(NSString *)expressCode;

- (NSString *)wb_MD5String;

- (NSMutableAttributedString *)wb_makeSearchString:(NSString *)search color:(UIColor *)color;
@end
