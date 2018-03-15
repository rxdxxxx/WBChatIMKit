//
//  WBHUD.m
//  Whiteboard
//
//  Created by RedRain on 2017/11/5.
//  Copyright © 2017年 RedRain. All rights reserved.
//

#import "WBHUD.h"
#import "UIView+WBToast.h"

@implementation WBHUD

+ (void)showMessage:(NSString *)message toView:(UIView *)view{
    [view wb_makeToastActivity];
    [view wb_makeToast:message duration:3 position:CSToastPositionCenter];
}

+ (void)hideForView:(UIView *)view{
    [view wb_hideToastActivity];
}

+ (void)createCustomHUDFromView:(UIView *)view{
    
    

}

+ (void)showSuccessMessage:(NSString *)message toView:(UIView *)view{
    
    [view wb_hideToastActivity];
    [view wb_makeToast:message duration:3 position:CSToastPositionCenter];

    
}
+ (void)showErrorMessage:(NSString *)message toView:(UIView *)view{
    [self hideForView:view];
    [view wb_makeToast:message duration:3 position:CSToastPositionCenter];
}

+ (void)progressFromView:(UIView *)view{
    [view wb_makeToastActivity];
}


@end
