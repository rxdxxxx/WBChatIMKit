//
//  WBConfig.pch
//  Whiteboard
//
//  Created by RedRain on 2017/11/5.
//  Copyright © 2017年 RedRain. All rights reserved.
//

#ifndef WBConfig_pch
#define WBConfig_pch

// 第三方库, 要放在最上面
#import "WBHUD.h"

#if __has_include(<AVOSCloud/AVOSCloud.h>)
#import <AVOSCloud/AVOSCloud.h>
#else
#import "AVOSCloud.h"
#endif

#if __has_include(<AVOSCloudIM/AVOSCloudIM.h>)
#import <AVOSCloudIM/AVOSCloudIM.h>
#else
#import "AVOSCloudIM.h"
#endif

// 分类
#import "WBConst.h"

#import "UIView+Frame.h"
#import "NSString+OPSize.h"
#import "UIView+NextResponder.h"
#import "NSDate+Extension.h"


// 工具类
#import "WBTools.h"

#import "WBServiceSDKHeaders.h"



#endif /* WBConfig_pch */
