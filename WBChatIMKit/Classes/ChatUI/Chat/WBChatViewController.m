//
//  WBChatViewController.m
//  WBChat
//
//  Created by RedRain on 2018/1/16.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBChatViewController.h"
#import "UITableView+WBScrollToIndexPath.h"
#import "WBChatMessageTimeCellModel.h"
#import "UIScrollView+WBRefresh.h"
#import "WBImageBrowserView.h"
#import "WBChatViewController+Extension.h"

@interface WBChatViewController ()
@property (nonatomic, strong) WBChatBarView *chatBar;
@property (nonatomic, strong) WBSelectPhotoTool *photoTool;
@property (nonatomic, strong) WBImageBrowserView *pictureBrowserView;

@property (nonatomic, strong) NSMutableDictionary *wbAchieveMsgDic;

@end

@implementation WBChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    
    [self loadMoreMessage];
    [self.tableView wb_scrollToBottomAnimated:NO];
    

    __weak typeof(self)weakSelf = self;
    [self.tableView wb_addRefreshHeaderViewWithBlock:^{
        [weakSelf loadMoreMessage];

    }];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[WBChatKit sharedInstance] readConversation:self.conversation];
    WBChatInfoModel *infoModel = [[WBChatKit sharedInstance] chatInfoWithID:self.conversation.conversationId];
    self.chatBar.chatText = infoModel.draft;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    [[WBChatKit sharedInstance] readConversation:self.conversation];
    [[WBChatKit sharedInstance] saveConversation:self.conversation.conversationId draft:self.chatBar.chatText];
    
}



- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
}

#pragma mark -  Life Cycle
#pragma mark -  UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WBChatMessageBaseCellModel *cellModel = self.dataArray[indexPath.row];
    WBChatMessageBaseCell *cell = nil;
    // 1.已经实现的消息类型
    if (self.wbAchieveMsgDic[@(cellModel.messageModel.messageType)]) {
        cell = [WBChatMessageBaseCell cellWithTableView:tableView cellModel:cellModel];
    }
    
    // 2.未知的消息类型
    else{
        if ([self respondsToSelector:@selector(wb_controllerTableView:cellForRowAtIndexPath:)]) {
            cell = (WBChatMessageBaseCell *)[self wb_controllerTableView:tableView cellForRowAtIndexPath:indexPath];
        }
    }
    
    // 3.无法处理的消息
    if (cell == nil) {
        cell = [WBChatMessageBaseCell cellWithTableView:tableView cellModel:cellModel];
    }
    cell.delegate = self;
    
    
    // 4.在提供给tableView之前, 再次提供给子类修改的机会
    if ([self respondsToSelector:@selector(wb_willDisplayMessageCell:atIndexPath:)]) {
        [self wb_willDisplayMessageCell:cell atIndexPath:indexPath];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WBChatMessageBaseCellModel *cellModel = self.dataArray[indexPath.row];
    return cellModel.cellHeight;
}

#pragma mark -  UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    
    [self.chatBar stateToInit];
    
    if ([[UIMenuController sharedMenuController] isMenuVisible]) {
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    }
}

#pragma mark -  CustomDelegate
#pragma mark - WBChatMessageCellDelegate cell处理的回调
- (void)cell:(WBChatMessageBaseCell *)cell tapImageViewModel:(WBChatMessageBaseCellModel *)cellModel{
    
    NSMutableArray *imageMessageArray = [NSMutableArray array];
    for (WBChatMessageBaseCellModel *cellModel in self.dataArray) {
        if (cellModel.cellType == WBChatMessageTypeImage) {
            [imageMessageArray addObject:cellModel.messageModel];
        }
    }
    
    WBImageBrowserView *pictureBrowserView = [WBImageBrowserView browserWithImageArray:imageMessageArray];
    pictureBrowserView.startIndex = [imageMessageArray indexOfObject:cellModel.messageModel] + 1;  //开始索引
}

- (void)cell:(WBChatMessageBaseCell *)cell resendMessage:(WBChatMessageBaseCellModel *)cellModel{
    [self.dataArray removeObject:cellModel];
    [self sendMessage:cellModel.messageModel];
}

#pragma mark - WBChatBarViewDataSource 聊天框的回调
- (NSArray<NSDictionary *> *)plusBoardItemInfos:(WBChatBarView *)keyBoardView{
    return @[PlusBoardItemDicInfo([UIImage wb_resourceImageNamed:@"chat_bar_icons_pic"],@"相册",@(WBPlusBoardButtonTypePhotoAlbum)),
             PlusBoardItemDicInfo([UIImage wb_resourceImageNamed:@"chat_bar_icons_camera"],@"相机",@(WBPlusBoardButtonTypeCamera))];
    
    //    PlusBoardItemDicInfo([UIImage wb_resourceImageNamed:@"chat_bar_icons_location"],@"位置",@(WBPlusBoardButtonTypeLocation))
}

#pragma mark - WBChatBarViewDelegate 聊天框的回调
- (void)chatBar:(WBChatBarView *)chatBar didSelectItemInfo:(NSDictionary *)itemInfo{
    switch ([itemInfo[kPlusBoardType] integerValue]) {
        case WBPlusBoardButtonTypePhotoAlbum:{
            [self.photoTool visitPhotoLibraryInController:self];
        }
            break;
        case WBPlusBoardButtonTypeCamera:{
            [self.photoTool visitCameraInController:self];
        }
            break;
        case WBPlusBoardButtonTypeLocation:{
            
        }
            break;
            
        default:
            break;
    }
}

- (void)chatBar:(WBChatBarView *)keyBoardView sendText:(NSString *)sendText{
    if (sendText.length > 0) {
        
        WBMessageModel *message = [WBMessageModel createWithText:sendText];
        [self sendMessage:message];
    }
}
- (void)chatBar:(WBChatBarView *)keyBoardView recoderAudioPath:(NSString *)audioPath duration:(NSNumber *)duration{
    
    WBMessageModel *message = [WBMessageModel createWithAudioPath:audioPath duration:duration];
    [self sendMessage:message];
}

#pragma mark - WBSelectPhotoToolDelegate 选择图片或者拍照的回调

- (void)toolWillSelectImage:(WBSelectPhotoTool *)tool{
    
}

- (void)tool:(WBSelectPhotoTool *)tool didSelectImage:(UIImage *)image{
    WBMessageModel *message = [WBMessageModel createWithImage:image];
    [self sendMessage:message];
}

#pragma mark -  Event Response
#pragma mark -  Notification Callback

/**
 *  键盘即将显示的时候调用
 */
- (void)keyboardWillShow:(NSNotification *)note {
    
    // 1.取出键盘弹出的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    
    // 2.执行动画4
    [UIView animateWithDuration:duration animations:^{
        CGFloat navHeight = 0;
        // 导航栏透明
        if(self.navigationController.navigationBar.translucent == YES){
            navHeight = WB_NavHeight;
        }
        //3,缩小tableView的高度
        self.tableView.height_wb = self.chatBar.top_wb - navHeight;
        
        // 4,让tableView偏移到最底部.
        [self scrollBackToMessageBottom];
        
    } ];
    
    
}

/**
 *  键盘即将退出的时候调用
 */
- (void)keyboardWillHide:(NSNotification *)note {
    
    // 1.取出键盘弹出的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 2.执行动画
    [UIView animateWithDuration:duration animations:^{
        CGFloat navHeight = 0;
        // 导航栏透明
        if(self.navigationController.navigationBar.translucent == YES){
            navHeight = WB_NavHeight;
        }
        
        //3,缩小tableView的高度
        self.tableView.height_wb = self.chatBar.top_wb - navHeight;
        
    }];
    
}


- (void)receiveNewMessgae:(NSNotification *)noti{
    AVIMConversation *conv = noti.userInfo[WBMessageConversationKey];
    AVIMTypedMessage *tMsg = noti.userInfo[WBMessageMessageKey];
    
    if (![conv.conversationId isEqualToString:self.conversation.conversationId]) {
        return;
    }
    
    
    if (tMsg)
    {
        // 把收到的消息加入列表,并刷新
        do_dispatch_async_mainQueue(^{
            BOOL isBottom = [self isTableViewBottomVisible];
            
            WBMessageModel *message = [WBMessageModel createWithTypedMessage:tMsg];
            [self appendAMessageToTableView:message];
            
            if (isBottom) {
                // 此处动画,需要是NO,不然tableView会乱蹦.导致不能显示到最后一行.
                [self.tableView wb_scrollToBottomAnimated:NO];
            }
            
            BOOL isActive = [UIApplication sharedApplication].applicationState == UIApplicationStateActive;
            // 栈顶的控制器, 是不是当前控制器.
            if (isActive && self == self.navigationController.topViewController){
                // 清除未读记录信息
                [[WBChatKit sharedInstance] readConversation:self.conversation];
            }
        });
        
    }
    
}
#pragma mark -  GestureRecognizer Action
#pragma mark -  Btn Click
#pragma mark -  Private Methods
- (void)scrollBackToMessageBottom{
    [self.tableView wb_scrollToBottomAnimated:NO];
}

- (void)setupUI{
    self.view.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.00];

    
    CGFloat navHeight = 0;
    // 导航栏透明
    if(self.navigationController.navigationBar.translucent == YES){
        navHeight = WB_NavHeight;
    }
    self.tableView.top_wb = navHeight;

    [self.view addSubview:self.tableView];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    WBChatBarView *keyBoard = [[WBChatBarView alloc] initWithFrame:CGRectMake(0, kWBScreenHeight + navHeight - 48 - WB_NavHeight - WB_IPHONEX_BOTTOM_SPACE,
                                                                              kWBScreenWidth, 48)];
    [self.view addSubview:keyBoard];
    self.chatBar = keyBoard;
    self.chatBar.delegate = self;
    self.chatBar.dataSource = self;
    
    //3,缩小tableView的高度
    self.tableView.height_wb = self.chatBar.top_wb;
    self.tableView.height_wb -= navHeight;
    
    
    [WBNotificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [WBNotificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [WBNotificationCenter addObserver:self selector:@selector(receiveNewMessgae:) name:WBMessageNewReceiveNotification object:nil];
    
    
}
#pragma mark -  Public Methods
+ (instancetype)createWithConversation:(AVIMConversation *)conversation{
    WBChatViewController *vc = [WBChatViewController new];
    vc.conversation = conversation;
    return vc;
}
- (void)sendMessage:(WBMessageModel *)message{
    
    [self appendAMessageToTableView:message];
    
    
    // 2.1 滚动tableVeiw的代码放在了消息状态变化的通知里面了.不然此处会发生体验不好.
    [self.tableView wb_scrollToBottomAnimated:NO];
    
    
    [[WBChatKit sharedInstance] sendTargetConversation:self.conversation
                                               message:message
                                               success:^(WBMessageModel * _Nonnull aMessage)
     {
         [self refershAMessageState:aMessage];
         
     } error:^(WBMessageModel * _Nonnull aMessage, NSError * _Nonnull error) {
         [self refershAMessageState:aMessage];
         
     }];
}
#pragma mark -  Getters and Setters
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}

- (WBSelectPhotoTool *)photoTool{
    if (!_photoTool) {
        _photoTool = [WBSelectPhotoTool new];
        _photoTool.delegate = self;
    }
    return _photoTool;
}
- (NSMutableDictionary *)wbAchieveMsgDic{
    if (!_wbAchieveMsgDic) {
        _wbAchieveMsgDic = [NSMutableDictionary new];
        NSArray *achieveMsgTypes = @[@(WBChatMessageTypeText),
                                    @(WBChatMessageTypeImage),
                                    @(WBChatMessageTypeAudio),
                                    @(WBChatMessageTypeTime),
                                    @(WBChatMessageTypeRecalled)];
        
        // 把WB已经实现的消息类型进行缓存,方便调用子类的方法
        for (NSNumber *number in achieveMsgTypes) {
            [_wbAchieveMsgDic setObject:number forKey:number.stringValue];
        }
    }
    return _wbAchieveMsgDic;
}
@end
