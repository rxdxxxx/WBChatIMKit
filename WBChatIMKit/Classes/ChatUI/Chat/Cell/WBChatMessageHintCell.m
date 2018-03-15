//
//  WBChatMessageHintCell.m
//  AVOSCloud
//
//  Created by RedRain on 2018/3/14.
//

#import "WBChatMessageHintCell.h"
#import "WBChatMessageRecallCellModel.h"
@interface WBChatMessageHintCell ()

@property (nonatomic, strong) UILabel *hintLabel;

@end
@implementation WBChatMessageHintCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"WBChatMessageHintCell";
    WBChatMessageHintCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[WBChatMessageHintCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.hintLabel];
        
    }
    return self;
}

- (void)setCellModel:(WBChatMessageBaseCellModel *)cellModel{
    [super setCellModel:cellModel];
    
    NSString *hintString = @"此版本暂时不支持此类消息.";
    
    if ([cellModel isKindOfClass:WBChatMessageRecallCellModel.class]) {
        WBChatMessageRecallCellModel *fModel = (WBChatMessageRecallCellModel *)cellModel;
        hintString = fModel.hintString;
    }
    
    
    self.hintLabel.text = hintString;
    UIFont *font = [WBChatCellConfig sharedInstance].timeFont;
    CGSize size = [hintString sizeWithAttributes:@{NSFontAttributeName:font}];
    self.hintLabel.frame = CGRectMake(kWBScreenWidth/2-size.width/2-10 ,15,size.width+20,20);
    
    
}

- (UILabel *)hintLabel{
    if (!_hintLabel) {
        
        _hintLabel=[[UILabel alloc] init];
        _hintLabel.backgroundColor=[UIColor lightGrayColor];
        _hintLabel.font = [WBChatCellConfig sharedInstance].timeFont;
        _hintLabel.textAlignment=NSTextAlignmentCenter;
        _hintLabel.textColor = [UIColor whiteColor];
        _hintLabel.layer.masksToBounds=true;
        _hintLabel.layer.cornerRadius = 4;
    }
    return _hintLabel;
}

@end
