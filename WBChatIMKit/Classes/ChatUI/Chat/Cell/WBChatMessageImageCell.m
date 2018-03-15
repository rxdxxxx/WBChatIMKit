//
//  WBChatMessageImageCell.m
//  WBChat
//
//  Created by RedRain on 2018/2/5.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBChatMessageImageCell.h"
#import "WBChatMessageImageCellModel.h"
#import "WBShowBigImageTool.h"

@interface WBChatMessageImageCell()

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) UIImageView *dialogCellImageView;
@property (nonatomic, strong) UILabel *picProcessLabel;
@property (nonatomic, strong) UIImageView *picProcessImageView;
@property (nonatomic, strong) CALayer *cutMaskBorderLayer;

@property (nonatomic, weak) WBMessageModel * tempChatModel;

@end
@implementation WBChatMessageImageCell
#pragma mark -  Life Cycle

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"WBChatMessageImageCell";
    WBChatMessageImageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[WBChatMessageImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.tableView = tableView;
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.dialogCellImageView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageAction:)];
        self.dialogCellImageView.userInteractionEnabled = YES;
        [self.dialogCellImageView addGestureRecognizer:tapGesture];
        
        [self.dialogCellImageView addSubview:self.picProcessImageView];
        [self.dialogCellImageView addSubview:self.picProcessLabel];

        [WBNotificationCenter addObserver:self selector:@selector(uploadFileProgressNotify:) name:WBIMNotificationMessageUploadProgress object:nil];

    }
    return self;
}


#pragma mark -  UITableViewDelegate
#pragma mark -  CustomDelegate
#pragma mark -  Event Response
#pragma mark -  Notification Callback
- (void)uploadFileProgressNotify:(NSNotification *)notifi{
    NSDictionary *userInfo = notifi.userInfo;
    WBMessageModel *message = userInfo[@"message"];
    if ([self.tableView.visibleCells containsObject:self] && self.cellModel.messageModel == message) {
        NSNumber *progress = userInfo[@"progress"];
        self.picProcessLabel.text = [NSString stringWithFormat:@"%.0f%%",progress.floatValue];
    }
}
#pragma mark -  GestureRecognizer Action
- (void)tapImageAction:(UITapGestureRecognizer *)tap{
    if([self.delegate respondsToSelector:@selector(cell:tapImageViewModel:)]){
        [self.delegate cell:self tapImageViewModel:self.cellModel];
    }
//    CGRect coverFrame = [self.dialogCellImageView convertRect:self.dialogCellImageView.bounds toView:nil];
//    [WBShowBigImageTool showWithImage:self.dialogCellImageView.image orgFrame:coverFrame];
}
#pragma mark -  Btn Click
#pragma mark -  Private Methods
- (void)setupUI{
    
}
#pragma mark -  Public Methods
#pragma mark -  Getters and Setters

- (void)setCellModel:(WBChatMessageBaseCellModel *)cellModel{
    [super setCellModel:cellModel];
    
    //1.设置图片显示位置及图片
    WBChatMessageImageCellModel *imageFrameModel = (WBChatMessageImageCellModel *)cellModel;
    
    self.dialogCellImageView.frame = imageFrameModel.imageRectFrame;
    self.tempChatModel = imageFrameModel.messageModel;

    
    NSString *imageLocalPath = imageFrameModel.messageModel.imagePath;
    BOOL isLocalPath = ![imageLocalPath hasPrefix:@"http"];
    UIImage *image = nil;
    if (isLocalPath) {
        NSData *imageData = [NSData dataWithContentsOfFile:imageLocalPath];
        image = [UIImage imageWithData:imageData];
    }
    
    if (image && isLocalPath) {
        self.dialogCellImageView.image = image;
    }
    else if (imageLocalPath.length && self.tempChatModel.thumbImage){
        [[WBChatCellConfig sharedInstance].imageLoad imageView:self.dialogCellImageView
                                                     urlString:imageLocalPath
                                              placeholderImage:self.tempChatModel.thumbImage];
    }
    else if (self.tempChatModel.thumbImage) {
        self.dialogCellImageView.image = self.tempChatModel.thumbImage;
    }
    else{
        self.dialogCellImageView.image = [UIImage wb_resourceImageNamed:@"Placeholder_Image"];
    }
    
    
    //apply mask to image layer
    self.cutMaskBorderLayer.frame = self.dialogCellImageView.bounds;
    self.cutMaskBorderLayer.contents = (__bridge id)self.bubbleImageView.image.CGImage;
    self.dialogCellImageView.layer.mask = self.cutMaskBorderLayer;
    
    //2.给图片添加气泡的形状
    self.bubbleImageView.frame = self.dialogCellImageView.frame;
    
    //3.给图片添加进度显示效果--添加进度圈及进度百分比
    if (self.tempChatModel.status == AVIMMessageStatusSending) {
        self.picProcessImageView.hidden = NO;
        self.picProcessLabel.hidden = NO;
        self.picProcessImageView.frame = imageFrameModel.imageProcessRectFrame;
        self.picProcessLabel.frame = imageFrameModel.labelProcessRectFrame;
    } else {
        self.picProcessLabel.hidden = YES;
        self.picProcessImageView.hidden = YES;
    }
}


#pragma mark - Getter
- (CALayer *)cutMaskBorderLayer{
    if (!_cutMaskBorderLayer) {
        _cutMaskBorderLayer = [CALayer layer];
        _cutMaskBorderLayer.contentsCenter = CGRectMake(0.5, 0.8, 0.1, 0.1);
        _cutMaskBorderLayer.contentsScale = 2;
        
    }
    return _cutMaskBorderLayer;
}


- (UIImageView *)dialogCellImageView {
    if (!_dialogCellImageView) {
        _dialogCellImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _dialogCellImageView.userInteractionEnabled = NO;
        _dialogCellImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _dialogCellImageView;
}

- (UILabel *)picProcessLabel {
    if (_picProcessLabel == nil) {
        _picProcessLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _picProcessLabel.textColor = [UIColor whiteColor];
        _picProcessLabel.textAlignment = NSTextAlignmentCenter;
        _picProcessLabel.font = [UIFont systemFontOfSize:15];
        _picProcessLabel.text = [NSString stringWithFormat:@"%.0f%%",0.00];
    }
    return _picProcessLabel;
}

- (UIImageView *)picProcessImageView {
    if (_picProcessImageView == nil) {
        _picProcessImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refresh_icon"]];
    }
    // 1,图片旋转
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithInt:0];
    animation.toValue = [NSNumber numberWithInt:2*M_PI];
    animation.duration = 1;
    animation.autoreverses = NO ;
    animation.repeatCount = INT16_MAX;
    animation.removedOnCompletion = NO;
    [_picProcessImageView.layer addAnimation:animation forKey:@"rotateAnimation"];
    return _picProcessImageView;
}
@end
