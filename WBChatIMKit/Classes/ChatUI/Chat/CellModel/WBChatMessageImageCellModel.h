//
//  WBChatMessageImageCellModel.h
//  WBChat
//
//  Created by RedRain on 2018/2/5.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBChatMessageBaseCellModel.h"

@interface WBChatMessageImageCellModel : WBChatMessageBaseCellModel

//图片cell frame
@property (nonatomic, assign) CGRect imageRectFrame;
//进度圈的位置
@property (nonatomic, assign) CGRect imageProcessRectFrame;
//进度百分比的位置
@property (nonatomic, assign) CGRect labelProcessRectFrame;

@property (nonatomic, assign) CGFloat imageUploadProcess;
@end
