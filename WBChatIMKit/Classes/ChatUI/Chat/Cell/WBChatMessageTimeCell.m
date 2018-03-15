//
//  WBChatMessageTimeCell.m
//  WBChat
//
//  Created by RedRain on 2018/3/1.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBChatMessageTimeCell.h"
#import "WBChatMessageTimeCellModel.h"

@interface WBChatMessageTimeCell ()

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, weak) UITableView * tableView;
@end

@implementation WBChatMessageTimeCell


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"WBChatMessageTimeCell";
    WBChatMessageTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[WBChatMessageTimeCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.tableView = tableView;
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.timeLabel];
        
    }
    return self;
}

- (void)setCellModel:(WBChatMessageBaseCellModel *)cellModel{
    [super setCellModel:cellModel];
    WBChatMessageTimeCellModel *fModel = (WBChatMessageTimeCellModel *)cellModel;
    
    self.timeLabel.text = fModel.timeString;
    UIFont *font = [WBChatCellConfig sharedInstance].timeFont;
    CGSize size = [fModel.timeString sizeWithAttributes:@{NSFontAttributeName:font}];
    self.timeLabel.frame = CGRectMake(kWBScreenWidth/2-size.width/2-10 ,15,size.width+20,20);
    
    
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        
        _timeLabel=[[UILabel alloc] init];
        _timeLabel.backgroundColor=[UIColor lightGrayColor];
        _timeLabel.font = [WBChatCellConfig sharedInstance].timeFont;
        _timeLabel.textAlignment=NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.layer.masksToBounds=true;
        _timeLabel.layer.cornerRadius = 4;
    }
    return _timeLabel;
}
@end
