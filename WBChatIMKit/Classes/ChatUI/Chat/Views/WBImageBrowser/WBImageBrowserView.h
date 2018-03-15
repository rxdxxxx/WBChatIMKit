//
//  WBImageBrowserView.h
//  WBChat
//
//  Created by RedRain on 2018/1/16.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBImageBrowserView : UIView

+ (instancetype)browserWithImageArray:(NSArray *)imageModelArray;

@property (nonatomic, assign) NSInteger startIndex;

@end
