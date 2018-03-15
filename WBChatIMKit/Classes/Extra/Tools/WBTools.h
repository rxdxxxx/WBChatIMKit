//
//  OPUITools.h
//  LCGOptimusPrime
//
//  Created by RedRain on 2017/7/28.
//  Copyright © 2017年 erics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBTools : NSObject
+ (void)view:(UIView *)view setupShadowColor:(UIColor *)color offset:(CGSize)offset;


/**
 压缩Image到接近指定的值附近
 */
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;


/**
 压缩Image到指定kb附近, 返回base64编码后的String

 @param image 原始图片
 @param size 压缩到的大小kb
 @return base64字符串
 */
+ (NSString *)base64StringWithCompressImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;

/**
 给一个View绘制虚线的边框
 */
+ (void)drawLineDashPatterForView:(UIView *)view;

/**
 *  描述：利用正则判断手机号格式是否正确
 *
 *  @param mobile 需要判断的手机号
 *
 *  @return 返回是否正确
 */
+ (BOOL) isValidateMobile:(NSString *)mobile;

/**
 *  正则判断密码：密码只能为8-16 位数字，字母及常用符号组成
 *
 *  @param password 密码字符串
 *
 *  @return 是否正确
 */
+(BOOL)isValidatePassWord:(NSString *)password;

/**
 *  描述：利用正则判断验证码格式是否正确
 *
 *  @param authCode 需要判断的字符串
 *
 *  @return 返回是否正确
 */

+ (BOOL)isValidateAuthCode:(NSString *)authCode;

/**
 描述：利用正则判断邮箱格式是否正确
 参数：需要判断的字符串
 **/
+(BOOL)isValidateEmail:(NSString *)email;



/**
 验证身份证号码
 */
+ (BOOL)isValidateIDCard:(NSString *)identityString;


/**
 打电话

 @param phoneNum 电话号
 */
+ (void)callPhoneByStr:(NSString *)phoneNum;

/**
 粗略的验证银行卡号
 */
+ (BOOL)IsBankCardRoughly:(NSString *)cardNumber;

/**
 细致规则验证银行账号
 */
+ (BOOL) IsBankCard:(NSString *)cardNumber;


/**
 字符串转拼音

 @param word 需要被转换的字符串
 @return 转换后的拼音
 */
+ (NSString *)transformChinese:(NSString *)word;

@end
