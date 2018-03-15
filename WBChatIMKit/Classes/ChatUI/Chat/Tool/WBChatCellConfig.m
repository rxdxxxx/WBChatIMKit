//
//  WBChatCellConfig.m
//  WBChat
//
//  Created by RedRain on 2018/1/19.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBChatCellConfig.h"
#import "UIImage+WBImage.h"

@implementation WBChatCellConfig

+ (instancetype)sharedInstance {
    static WBChatCellConfig *_sharedWBChatCellConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedWBChatCellConfig = [[WBChatCellConfig alloc] init];
    });
    
    return _sharedWBChatCellConfig;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.imageLoad = [[WBImageLoad alloc] init];
        self.placeholdHeaderImage = [UIImage wb_resourceImageNamed:@"header_male"];
        
        self.headerImageSize = CGSizeMake(43, 43);
        self.headerMarginSpace = 15;
        self.headerBubbleSpace = 12;
        self.textbubbleContentInset = UIEdgeInsetsMake(13, 6, 13, 6);
        self.bubbleClosedAngleWidth = 5;
        self.userNameSize = CGSizeMake(200, 15);
        self.timeFont = [UIFont systemFontOfSize:12];
        self.textFont = [UIFont systemFontOfSize:15];
        
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        self.textMaxWidth = ((screenWidth < 375) ? 190  : ceil(screenWidth - 2 * 50 - 5 - 2 * 13));

        self.normalSpace = 5;
        self.messageStatusIconSize = CGSizeMake(20, 20);
        self.messageStatusIconToBubble = 5;
        
        self.messageStatusLabelSize = CGSizeMake(40, 20);
        self.messageStatusLabelToBubble = 5;
        
        
        self.imageProgressSize = CGSizeMake(20, 20);
        
        self.voiceWaveSize = CGSizeMake(16, 16);
    }
    return self;
}

@end
