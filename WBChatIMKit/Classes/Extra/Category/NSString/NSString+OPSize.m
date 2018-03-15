//
//  NSString+OPSize.m
//  LCGOptimusPrime
//
//  Created by RedRain on 2017/8/9.
//  Copyright © 2017年 erics. All rights reserved.
//

#import "NSString+OPSize.h"
#import <CommonCrypto/CommonCrypto.h>

#define usualCode @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_"
@implementation NSString (OPSize)
- (CGSize)lcg_sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    
    
}

- (CGSize)lcg_sizeWithFont:(UIFont *)font
{
    return [self lcg_sizeWithFont:font maxW:MAXFLOAT];
}

- (NSString *)lcg_removeWhitespaceAndNewlineCharacterSet{
    NSString* headerData = [self copy];
    headerData = [headerData stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    headerData = [headerData stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    headerData = [headerData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    headerData = [headerData stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    return headerData;
}



- (NSString *)lcg_filterSpecialStr
{
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"-`~!@#$%^&*()+=|{}':',\[].<>/?~！@#￥%……& amp;*（）——+|{}【】‘；：”“’。，、？|_"];
        // `~!@#$%^&*()+=|{}':',\[\].<>/?~！@#￥%……& amp;*（）——+|{}【】‘；：”“’。，、？|-
    NSString * trimmedString = [self stringByTrimmingCharactersInSet:set];
    NSArray * stringArray = [trimmedString componentsSeparatedByString:@"-"];
    NSString * finalTrimmedString = [stringArray componentsJoinedByString:@""];
  
    
    return finalTrimmedString;
    

}

- (BOOL)isLegalExpressCode:(NSString *)expressCode
{
    BOOL _isExpressCode;
    NSCharacterSet * set = [NSCharacterSet  characterSetWithCharactersInString:usualCode];
    
    NSString * filterString = [[expressCode componentsSeparatedByCharactersInSet:set] componentsJoinedByString:@""];
    
    // LYLog(@"filterString == %@",filterString);
    
    
    if (filterString.length >0 ) {
        
        _isExpressCode = NO;
    }else{
        
        _isExpressCode = YES;
    }
    
    
    if ([expressCode containsString:@"http"] ||[expressCode containsString:@"www"]||[expressCode containsString:@"LP"]||[expressCode containsString:@"Lp"]||[expressCode containsString:@"lp"]||[expressCode containsString:@"lP"]||[expressCode containsString:@"https"]) {
        
        _isExpressCode = NO;
    }
    
    return _isExpressCode;
}



- (NSString *)wb_MD5String {
    const char* str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    uint32_t length = (CC_LONG)strlen(str);
    CC_MD5(str, length, result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
    return ret;
}

- (NSMutableAttributedString *)wb_makeSearchString:(NSString *)search color:(UIColor *)color{
    
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:self];
    if (search == nil) {
        
    } else {
        NSRange range = [self rangeOfString:search options:NSCaseInsensitiveSearch];
        if (range.location == NSNotFound) {
            return str;
        }
        [str addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
    return str;
}


@end
