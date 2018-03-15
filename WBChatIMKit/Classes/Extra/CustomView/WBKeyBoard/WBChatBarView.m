//
//  WBKeyBoard.m
//  WBChat
//
//  Created by RedRain on 2018/1/20.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBChatBarView.h"
#import "WBTLTalkButton.h"
#import "UIImage+WBImage.h"
#import "UIView+Frame.h"
#import "UIView+NextResponder.h"
#import "WBKeyBoardTextView.h"
#import "WBEmotionDisplayBoard.h"
#import "WBPlusDisplayBoard.h"

#define     WBKeyBoardRGBAColor(r, g, b, a)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]

#define     WBKeyBoardSCREEN_SIZE                 [UIScreen mainScreen].bounds.size
#define     WBKeyBoardSCREEN_WIDTH                WBKeyBoardSCREEN_SIZE.width
#define     WBiOSVersion_ky      ([[UIDevice currentDevice].systemVersion doubleValue])
#define     WBNavigationBarHeight_ky    (WBiOSVersion_ky >= 7.0 ? 64 : 44)

#define     WB_IS_IPHONE_X_ky (fabs((double)[[ UIScreen mainScreen ] bounds ].size.height - ( double )812)==0)

#define     WB_IPHONEX_TOP_SPACE_ky ((WB_IS_IPHONE_X_ky)?24:0)

#define     WB_IPHONEX_BOTTOM_SPACE_ky ((WB_IS_IPHONE_X_ky)?34:0)

#define     WB_NavHeight_ky (64+WB_IPHONEX_TOP_SPACE_ky)

#define     WB_TabBarHeight_ky (49+WB_IPHONEX_BOTTOM_SPACE_ky)

@interface WBChatBarView ()<UITextViewDelegate>
{
    UIImage *kVoiceImage;
    UIImage *kVoiceImageHL;
    UIImage *kEmojiImage;
    UIImage *kEmojiImageHL;
    UIImage *kMoreImage;
    UIImage *kMoreImageHL;
    UIImage *kKeyboardImage;
    UIImage *kKeyboardImageHL;
}

@property (nonatomic, strong) UIButton *modeButton;

@property (nonatomic, strong) UIButton *voiceButton;

@property (nonatomic, strong) WBKeyBoardTextView *textView;

@property (nonatomic, strong) WBTLTalkButton *talkButton;

@property (nonatomic, strong) UIButton *emojiButton;

@property (nonatomic, strong) UIButton *moreButton;

// 用来做为表情键盘和plus键盘期间的响应者,使得textVoice中的textView可以在重回第一响应者时得到控制
@property (nonatomic, strong) UITextView *switchTextView;


@property (nonatomic, strong) WBEmotionDisplayBoard *emojiBoard;
@property (nonatomic, strong) WBPlusDisplayBoard *moreBoard;


@end



@implementation WBChatBarView
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -  life cycle
- (instancetype)initWithFrame:(CGRect)frame{
    
        self = [super initWithFrame:frame];
        if (self) {
            self.backgroundColor = WBKeyBoardRGBAColor(245.0, 245.0, 247.0, 1.0);

            [self p_initImage];
            
            [self addSubview:self.modeButton];
            [self addSubview:self.voiceButton];
            [self addSubview:self.textView];
            [self addSubview:self.talkButton];
            [self addSubview:self.emojiButton];
            [self addSubview:self.moreButton];

            // 生成子控件
            [self wb_reloadSubviewsFrame];
            [self addNotificationForSocial];
        }
        
        return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self wb_reloadSubviewsFrame];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.5 alpha:0.3].CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, WBKeyBoardSCREEN_WIDTH, 0);
    CGContextStrokePath(context);
}

- (void)wb_reloadSubviewsFrame{
    
    self.moreButton.frame = CGRectMake(0, 0, 0, self.height_wb);
    
    
    self.voiceButton.frame = CGRectMake(1,self.modeButton.right_wb + 1,
                                        38, self.frame.size.height);
    

    
    
    
    self.moreButton.top_wb = self.voiceButton.top_wb;
    self.moreButton.width_wb = self.voiceButton.width_wb;
    self.moreButton.height_wb = self.voiceButton.height_wb;
    self.moreButton.right_wb = self.right_wb - 1;

    
    self.emojiButton.top_wb = self.voiceButton.top_wb;
    self.emojiButton.width_wb = self.voiceButton.width_wb;
    self.emojiButton.height_wb = self.voiceButton.height_wb;
    self.emojiButton.right_wb = self.moreButton.left_wb;
    
    
    
    
    self.textView.frame = CGRectMake(self.voiceButton.right_wb + 4,7,
                                     self.width_wb - (3 * self.voiceButton.width_wb) - 9, self.height_wb - 14);
    
    
    self.talkButton.center = self.textView.center;
    self.talkButton.size_wb = self.textView.size_wb;

}


#pragma mark -  UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self setActivity:YES];
    if (self.status != WBChatBarStatusKeyboard) {
        
        
        if (self.status == WBChatBarStatusEmoji) {
            
            [self.emojiButton setImage:kEmojiImage forState:UIControlStateNormal];
            [self.emojiButton setImage:kEmojiImageHL forState:UIControlStateHighlighted];
        }
        else if (self.status == WBChatBarStatusMore) {
            
            [self.moreButton setImage:kMoreImage forState:UIControlStateNormal];
            [self.moreButton setImage:kMoreImageHL forState:UIControlStateHighlighted];
        }
        self.status = WBChatBarStatusKeyboard;
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]){
        [self sendCurrentText];
        return NO;
    }
    else if (textView.text.length > 0 && [text isEqualToString:@""]) {       // delete

    }
    
    return YES;
}


#pragma mark -  CustomDelegate
#pragma mark -  Event Response
#pragma mark -  Notification Callback

/**
 * 键盘的frame发生改变时调用（显示、隐藏等）
 */
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    // 判断一下,输入框是否在当前显示的控制器中.
    if(!(self.lcg_viewController.navigationController.viewControllers.lastObject == self.lcg_viewController)){
        return;
    }
    
    // 如果正在切换键盘，就不要执行后面的代码
//    if (self.switchingKeybaord) return;
    
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    // double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘的frame
    CGRect beginkeyboardF = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

    BOOL animate = NO;
    // 显示键盘
    if (beginkeyboardF.origin.y > keyboardF.origin.y) {
        animate = YES;
    }
    // 收起键盘
    else{
        animate = NO;
    }
    
    
    [CATransaction begin];
    [CATransaction setDisableActions:!animate];
    
    // 导航栏透明
    CGFloat navHeight = 0;
    if(self.lcg_viewController.navigationController.navigationBar.translucent == YES){
        navHeight = WB_NavHeight_ky;
    }
    
    // 工具条的Y值 == 键盘的Y值 - 工具条的高度
    if (keyboardF.origin.y >= ([[UIScreen mainScreen] bounds].size.height)) { // 键盘的Y值已经远远超过了屏幕的高度
        self.top_wb = keyboardF.origin.y - self.height_wb - WB_NavHeight_ky - WB_IPHONEX_BOTTOM_SPACE_ky + navHeight;
    } else {
        
        self.top_wb = keyboardF.origin.y - self.height_wb - WB_NavHeight_ky + navHeight;
    }
    [CATransaction commit];

}
//获取上一级响应者
- (UIViewController *)viewController
{
    UIResponder *next = self.nextResponder;
    while (next != nil) {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    }
    return nil;
}

- (void)receiveEmojiInfo:(NSNotification *)notification{
    if (notification.object == [self viewController]){
        NSString *text = notification.userInfo[@"text"];
        // delete
        if ([text isEqualToString:@"-1"]) {
            [self.textView deleteBackward];
        }else{
            [self.textView insertText:text];
        }
        
    }
}
- (void)receiveKeyBoardSendClick:(NSNotification *)notification{
    if (notification.object == [self viewController]){
        [self sendCurrentText];
    }
}

- (void)audioCompleteFinishNotification:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    if ([self.delegate respondsToSelector:@selector(chatBar:recoderAudioPath:duration:)]) {
        [self.delegate chatBar:self recoderAudioPath:userInfo[@"path"] duration:userInfo[@"duration"]];
    }
}

#pragma mark -  GestureRecognizer Action
#pragma mark -  Btn Click
- (void)voiceButtonDown{
    [self.textView resignFirstResponder];
    [self.switchTextView resignFirstResponder];

    
    // 开始文字输入
    if (self.status == WBChatBarStatusVoice) {

        
        [self.voiceButton setImage:kVoiceImage forState:UIControlStateNormal];
        [self.voiceButton setImage:kVoiceImageHL forState:UIControlStateHighlighted];

        
        [self.textView becomeFirstResponder];
        [self.textView setHidden:NO];
        [self.talkButton setHidden:YES];
        self.textView.inputView = nil;
        self.status = WBChatBarStatusKeyboard;
    }
    else {
        
        if (self.status == WBChatBarStatusKeyboard) {
            [self.textView resignFirstResponder];
        }
        else if (self.status == WBChatBarStatusEmoji) {
            
            [self.emojiButton setImage:kEmojiImage forState:UIControlStateNormal];
            [self.emojiButton setImage:kEmojiImageHL forState:UIControlStateHighlighted];
        }
        else if (self.status == WBChatBarStatusMore){
            [self.moreButton setImage:kMoreImage forState:UIControlStateNormal];
            [self.moreButton setImage:kMoreImageHL forState:UIControlStateHighlighted];
        }
        
        [self.talkButton setHidden:NO];
        [self.textView setHidden:YES];
        [self.voiceButton setImage:kKeyboardImage forState:UIControlStateNormal];
        [self.voiceButton setImage:kKeyboardImageHL forState:UIControlStateHighlighted];
        self.status = WBChatBarStatusVoice;
    }
}


- (void)emojiButtonDown
{
    // 开始文字输入
    if (self.status == WBChatBarStatusEmoji) {
        
        
        [self.emojiButton setImage:kEmojiImage forState:UIControlStateNormal];
        [self.emojiButton setImage:kEmojiImageHL forState:UIControlStateHighlighted];
        
        self.textView.inputView = nil;
        [self.textView endEditing:YES];
        [self.textView becomeFirstResponder];
        self.status = WBChatBarStatusKeyboard;
    }
    else {
        
        if (self.status == WBChatBarStatusVoice) {
            
            
            [self.voiceButton setImage:kVoiceImage forState:UIControlStateNormal];
            [self.voiceButton setImage:kVoiceImageHL forState:UIControlStateHighlighted];
            
            [self.talkButton setHidden:YES];
            [self.textView setHidden:NO];
        }
        else if (self.status == WBChatBarStatusMore) {
            
            [self.moreButton setImage:kMoreImage forState:UIControlStateNormal];
            [self.moreButton setImage:kMoreImageHL forState:UIControlStateHighlighted];
            
        }
        
        
        [self setActivity:NO];

        [self changeKeyboardWithView:self.emojiBoard nextState:WBChatBarStatusEmoji] ;

        [self.emojiButton setImage:kKeyboardImage forState:UIControlStateNormal];
        [self.emojiButton setImage:kKeyboardImageHL forState:UIControlStateHighlighted];
        self.status = WBChatBarStatusEmoji;
    }
}

- (void)moreButtonDown
{
    // 开始文字输入
    if (self.status == WBChatBarStatusMore) {
        
        [self.moreButton setImage:kMoreImage forState:UIControlStateNormal];
        [self.moreButton setImage:kMoreImageHL forState:UIControlStateHighlighted];
        
        [self.textView endEditing:YES];
        self.textView.inputView = nil;
        [self.textView becomeFirstResponder];
        self.status = WBChatBarStatusKeyboard;
    }
    else {
        if (self.status == WBChatBarStatusVoice) {
            
            [self.voiceButton setImage:kVoiceImage forState:UIControlStateNormal];
            [self.voiceButton setImage:kVoiceImageHL forState:UIControlStateHighlighted];
            
            [self.talkButton setHidden:YES];
            [self.textView setHidden:NO];
        }
        else if (self.status == WBChatBarStatusEmoji) {
            
            [self.emojiButton setImage:kEmojiImage forState:UIControlStateNormal];
            [self.emojiButton setImage:kEmojiImageHL forState:UIControlStateHighlighted];
        }
        
        [self setActivity:NO];
        [self changeKeyboardWithView:self.moreBoard nextState:WBChatBarStatusMore];
        [self.moreBoard reloadData];
        self.status = WBChatBarStatusMore;
    }
}

#pragma mark -  Private Methods
- (void)sendCurrentText
{
    if (self.textView.text.length > 0) {     // send Text
        if (_delegate && [_delegate respondsToSelector:@selector(chatBar:sendText:)]) {
            [_delegate chatBar:self sendText:self.textView.text];
        }
    }
    [self.textView setText:@""];
}
- (void)changeKeyboardWithView:(UIView *)view  nextState:(WBChatBarStatus)nextStatus{
    
    //  self.switchTextView.inputView == nil : 使用的是系统自带的键盘
    if (self.switchTextView.inputView == view) {
        view = nil;
    }
    self.switchTextView.inputView = view;
    
    // 退出键盘
    [self.switchTextView endEditing:YES];
    [self.textView endEditing:YES];
    
    
    // 弹出键盘
    if (view == nil) {
        [self.textView becomeFirstResponder];
    }else {
        self.switchTextView.text = self.textView.text;
        [self.switchTextView becomeFirstResponder];
    }
    
}
- (void)setActivity:(BOOL)activity
{
    _activity = activity;
    if (activity) {
        [self.textView setTextColor:[UIColor blackColor]];
        
        // 把之前的键盘设置为nil, 即系统键盘,恢复原状
        self.switchTextView.inputView = nil;
    }
    else {
        [self.textView setTextColor:[UIColor grayColor]];
    }
    
}

- (void)addNotificationForSocial{
    // 键盘通知
    // 键盘的frame发生改变时发出的通知（位置和尺寸）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveEmojiInfo:) name:WBEmotionDisplayBoardDidSelectEmojiNotifi object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveKeyBoardSendClick:) name:WBEmotionDisplayBoardSendClickNotifi object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioCompleteFinishNotification:) name:WBAudioCompleteFinishNotification object:nil];

}
- (void)p_initImage
{
    kVoiceImage = [UIImage wb_resourceImageNamed:@"ToolViewInputVoice"];
    kVoiceImageHL = [UIImage wb_resourceImageNamed:@"ToolViewInputVoiceHL"];
    kEmojiImage = [UIImage wb_resourceImageNamed:@"ToolViewEmotion"];
    kEmojiImageHL = [UIImage wb_resourceImageNamed:@"ToolViewEmotionHL"];
    kMoreImage = [UIImage wb_resourceImageNamed:@"TypeSelectorBtn_Black"];
    kMoreImageHL = [UIImage wb_resourceImageNamed:@"TypeSelectorBtnHL_Black"];
    kKeyboardImage = [UIImage wb_resourceImageNamed:@"ToolViewKeyboard"];
    kKeyboardImageHL = [UIImage wb_resourceImageNamed:@"ToolViewKeyboardHL"];
}
- (void)setupSubviews{
    
}
#pragma mark -  Public Methods
- (void)stateToInit{
    
    [self.moreButton setImage:kMoreImage forState:UIControlStateNormal];
    [self.moreButton setImage:kMoreImageHL forState:UIControlStateHighlighted];
    
    [self.emojiButton setImage:kEmojiImage forState:UIControlStateNormal];
    [self.emojiButton setImage:kEmojiImageHL forState:UIControlStateHighlighted];
    
    self.status = WBChatBarStatusKeyboard;

    self.textView.inputView = nil;
    self.switchTextView.inputView = nil;
}


#pragma mark -  Getters and Setters
- (void)setChatText:(NSString *)chatText{
    self.textView.text = chatText;
}
- (NSString *)chatText{
    return self.textView.text;
}

- (void)setDelegate:(id<WBChatBarViewDelegate>)delegate{
    _delegate = delegate;
    self.moreBoard.delegate = delegate;
}
- (void)setDataSource:(id<WBChatBarViewDataSource>)dataSource{
    _dataSource = dataSource;
    self.moreBoard.dataSource = dataSource;
}

#pragma mark - Getter
- (UIButton *)modeButton
{
    if (_modeButton == nil) {
        _modeButton = [[UIButton alloc] init];
        [_modeButton setImage:[UIImage wb_resourceImageNamed:@"Mode_texttolist"] forState:(UIControlStateNormal)];
        [_modeButton setImage:[UIImage wb_resourceImageNamed:@"Mode_texttolistHL"] forState:(UIControlStateHighlighted)];
//        [_modeButton addTarget:self action:@selector(modeButtonDown) forControlEvents:UIControlEventTouchUpInside];

    }
    return _modeButton;
}

- (UIButton *)voiceButton
{
    if (_voiceButton == nil) {
        _voiceButton = [[UIButton alloc] init];
        
        [_voiceButton setImage:kVoiceImage forState:(UIControlStateNormal)];
        [_voiceButton setImage:kVoiceImageHL forState:(UIControlStateHighlighted)];
        [_voiceButton addTarget:self action:@selector(voiceButtonDown) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceButton;
}

- (WBKeyBoardTextView *)textView
{
    if (_textView == nil) {
        _textView = [[WBKeyBoardTextView alloc] init];
        [_textView setFont:[UIFont systemFontOfSize:16.0f]];
    
        [_textView.layer setMasksToBounds:YES];
        [_textView.layer setBorderWidth:([[UIScreen mainScreen] scale] > 0.0 ? 1.0 / [[UIScreen mainScreen] scale] : 1.0)];
        [_textView.layer setBorderColor:[UIColor colorWithWhite:0.0 alpha:0.3].CGColor];
        [_textView.layer setCornerRadius:4.0f];
        
        // Initialization code
        _textView.returnKeyType = UIReturnKeySend;
        _textView.enablesReturnKeyAutomatically = YES;// 没有文字,键盘的send按钮disabile
        _textView.autocorrectionType = UITextAutocorrectionTypeNo; // 自动纠错
        _textView.autocapitalizationType = UITextAutocapitalizationTypeNone; // 自动首字母大写
        
        [_textView setDelegate:self];
        [_textView setScrollsToTop:NO];
    }
    return _textView;
}

- (WBTLTalkButton *)talkButton
{
    if (_talkButton == nil) {
        _talkButton = [[WBTLTalkButton alloc] init];
        [_talkButton setHidden:YES];
//        __weak typeof(self) weakSelf = self;
        [_talkButton setTouchBeginAction:^{
//            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(chatBarStartRecording:)]) {
//                [weakSelf.delegate chatBarStartRecording:weakSelf];
//            }
        } willTouchCancelAction:^(BOOL cancel) {
//            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(chatBarWillCancelRecording:cancel:)]) {
//                [weakSelf.delegate chatBarWillCancelRecording:weakSelf cancel:cancel];
//            }
        } touchEndAction:^{
//            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(chatBarFinishedRecoding:)]) {
//                [weakSelf.delegate chatBarFinishedRecoding:weakSelf];
//            }
        } touchCancelAction:^{
//            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(chatBarDidCancelRecording:)]) {
//                [weakSelf.delegate chatBarDidCancelRecording:weakSelf];
//            }
        }];
    }
    return _talkButton;
}

- (UIButton *)emojiButton
{
    if (_emojiButton == nil) {
        _emojiButton = [[UIButton alloc] init];
        
        [_emojiButton setImage:kEmojiImage forState:(UIControlStateNormal)];
        [_emojiButton setImage:kEmojiImageHL forState:(UIControlStateHighlighted)];
        [_emojiButton addTarget:self action:@selector(emojiButtonDown) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emojiButton;
}

- (UIButton *)moreButton
{
    if (_moreButton == nil) {
        _moreButton = [[UIButton alloc] init];
        [_moreButton setImage:kMoreImage forState:(UIControlStateNormal)];
        [_moreButton setImage:kMoreImageHL forState:(UIControlStateHighlighted)];
        [_moreButton addTarget:self action:@selector(moreButtonDown) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

- (UITextView *)switchTextView {
    if (_switchTextView == nil) {
        
        // 这个输入框是作为中间状态的切换使用,不显示在页面上.
        _switchTextView = [[UITextView alloc]init];
        [self addSubview:_switchTextView];
    }
    return _switchTextView;
}
- (WBEmotionDisplayBoard *)emojiBoard{
    if (!_emojiBoard) {
        _emojiBoard = [WBEmotionDisplayBoard createEmojiKeyboard];
    }
    return _emojiBoard;
}
- (WBPlusDisplayBoard *)moreBoard{
    if (!_moreBoard) {
        _moreBoard = [WBPlusDisplayBoard createPlusBoard];
    }
    return _moreBoard;
    
}
@end
