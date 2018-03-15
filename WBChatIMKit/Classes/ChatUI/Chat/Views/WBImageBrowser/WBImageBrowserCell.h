//
//  WBImageBrowserCell.m.h
//  WBChat
//
//  Created by RedRain on 2018/1/16.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBImageBrowserCell : UICollectionViewCell

@property (strong, nonatomic) UIScrollView *imageScrollView;
@property (strong, nonatomic) UIImageView  *imageImageView;

@property (nonatomic, copy) void (^singleTapBlock)(void);

@end
