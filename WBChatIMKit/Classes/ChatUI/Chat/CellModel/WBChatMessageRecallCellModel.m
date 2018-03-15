//
//  WBChatMessageRecallCellModel.m
//  AVOSCloud
//
//  Created by RedRain on 2018/3/14.
//

#import "WBChatMessageRecallCellModel.h"

@implementation WBChatMessageRecallCellModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cellType = WBChatMessageTypeRecalled;
        self.cellHeight = 36;
        self.hintString = @"此消息已被撤回.";
    }
    return self;
}
@end
