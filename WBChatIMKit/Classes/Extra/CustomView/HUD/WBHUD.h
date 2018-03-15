//
//  WBHUD.h
//  Whiteboard
//
//  Created by RedRain on 2017/11/5.
//  Copyright © 2017年 RedRain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBHUD : NSObject

+ (void)showMessage:(NSString *)message toView:(UIView *)view;
+ (void)hideForView:(UIView *)view;
+ (void)showSuccessMessage:(NSString *)message toView:(UIView *)view;
+ (void)showErrorMessage:(NSString *)message toView:(UIView *)view;
+ (void)progressFromView:(UIView *)view;
@end
