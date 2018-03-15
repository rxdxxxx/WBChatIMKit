//
//  TLEmojiGroupControl.m

#import "WBEmojiGroupControl.h"
#import "WBEmojiGroupCell.h"
#import "UIImage+WBImage.h"
#import "WBEmotionPageModel.h"

#define     WIDTH_EMOJIGROUP_CELL       46
#define     WIDTH_SENDBUTTON            60

@interface WBEmojiGroupControl () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSIndexPath *curIndexPath;

@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIButton *sendButton;

@end

@implementation WBEmojiGroupControl

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.addButton];
        [self addSubview:self.collectionView];
        [self addSubview:self.sendButton];
        [self p_addMasonry];
        
        [self.collectionView registerClass:[WBEmojiGroupCell class] forCellWithReuseIdentifier:@"WBEmojiGroupCell"];
        self.sendButtonStatus = WBGroupControlSendButtonStatusNone;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TabBarObserverTextView:) name:UITextViewTextDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TabBarObserverTextView:) name:UITextViewTextDidBeginEditingNotification object:nil];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.sendButton.frame = CGRectMake(WBKeyBoardSCREEN_SIZE_emoji.width - WIDTH_SENDBUTTON, 0, WIDTH_SENDBUTTON, self.frame.size.height);
    self.addButton.frame = CGRectMake(0, 0, WIDTH_EMOJIGROUP_CELL, self.frame.size.height);
    self.collectionView.frame = CGRectMake(WIDTH_EMOJIGROUP_CELL, 0,
                                           WBKeyBoardSCREEN_SIZE_emoji.width - WIDTH_SENDBUTTON - WIDTH_EMOJIGROUP_CELL , self.frame.size.height);
    
}
- (void)setSendButtonStatus:(WBGroupControlSendButtonStatus)sendButtonStatus
{
    _sendButtonStatus = sendButtonStatus;

    
    if (sendButtonStatus == WBGroupControlSendButtonStatusBlue) {
        [_sendButton setBackgroundImage:[UIImage wb_resourceImageNamed:@"EmotionsSendBtnBlue"] forState:UIControlStateNormal];
        [_sendButton setBackgroundImage:[UIImage wb_resourceImageNamed:@"EmotionsSendBtnBlueHL"] forState:UIControlStateHighlighted];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else if (sendButtonStatus == WBGroupControlSendButtonStatusGray) {
        [_sendButton setBackgroundImage:[UIImage wb_resourceImageNamed:@"EmotionsSendBtnGrey"] forState:UIControlStateNormal];
        [_sendButton setBackgroundImage:[UIImage wb_resourceImageNamed:@"EmotionsSendBtnGrey"] forState:UIControlStateHighlighted];
        [_sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

- (void)setEmojiGroupData:(NSMutableArray *)emojiGroupData
{
    if (_emojiGroupData == emojiGroupData || [_emojiGroupData isEqualToArray:emojiGroupData]) {
        return;
    }
    _emojiGroupData = emojiGroupData;
    [self.collectionView reloadData];
    if (emojiGroupData && emojiGroupData.count > 0) {
        [self setCurIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
}

- (void)selectEmojiGroupAtIndex:(NSInteger)index
{
    if (index < self.emojiGroupData.count) {
        _curIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [self.collectionView selectItemAtIndexPath:_curIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        CGFloat width = WIDTH_EMOJIGROUP_CELL;
        CGFloat x = width * index;
        if (x < self.collectionView.contentOffset.x) {
            [self.collectionView setContentOffset:CGPointMake(x, 0) animated:YES];
        }
        else if (x + width > self.collectionView.contentOffset.x + self.collectionView.frame.size.width) {
            [self.collectionView setContentOffset:CGPointMake(x + width - self.collectionView.frame.size.width, 0) animated:YES];
        }
    }
}

- (void)setCurIndexPath:(NSIndexPath *)curIndexPath
{
    if (curIndexPath.row < self.emojiGroupData.count) {
        [self.collectionView scrollToItemAtIndexPath:curIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        [self.collectionView selectItemAtIndexPath:curIndexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        if (_curIndexPath && _curIndexPath.section == curIndexPath.section && _curIndexPath.row == curIndexPath.row) {
            return;
        }
        
        CGFloat width = WIDTH_EMOJIGROUP_CELL;
        CGFloat x = width * curIndexPath.row;
        if (x < self.collectionView.contentOffset.x) {
            [self.collectionView setContentOffset:CGPointMake(x, 0) animated:YES];
        }
        else if (x + width > self.collectionView.contentOffset.x + self.collectionView.frame.size.width) {
            [self.collectionView setContentOffset:CGPointMake(x + width - self.collectionView.frame.size.width, 0) animated:YES];
        }
        
        _curIndexPath = curIndexPath;
        if (_delegate && [_delegate respondsToSelector:@selector(emojiGroupControl:didSelectedGroup:)]) {
            id group = [self.emojiGroupData objectAtIndex:curIndexPath.row];
            [_delegate emojiGroupControl:self didSelectedGroup:group];
        }
    }
}

#pragma mark - # Delegate
//MARK: UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.emojiGroupData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WBEmojiGroupCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WBEmojiGroupCell" forIndexPath:indexPath];
    id group = [self.emojiGroupData objectAtIndex:indexPath.row];
    [cell setEmojiGroup:group];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(WIDTH_EMOJIGROUP_CELL, self.frame.size.height);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == self.emojiGroupData.count - 1) {
        return CGSizeMake(WIDTH_EMOJIGROUP_CELL * 2, self.frame.size.height);
    }
    return CGSizeZero;
}


//MARK: UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WBEmotionPageModel *group = [self.emojiGroupData objectAtIndex:indexPath.row];
    if (group.type == WBEmotionPageTypeEmoji) {
        //???: 存在冲突：用户选中cellA,再此方法中立马调用方法选中cellB时，所有cell都不会被选中
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self setCurIndexPath:_curIndexPath];
        });
        [self p_eidtMyEmojiButtonDown];
    }
    else {
        [self setCurIndexPath:indexPath];
    }
}

#pragma mark - # Event Response
- (void)emojiAddButtonDown
{
    if (_delegate && [_delegate respondsToSelector:@selector(emojiGroupControlEditButtonDown:)]) {
        [_delegate emojiGroupControlEditButtonDown:self];
    }
}

- (void)sendButtonDown
{
    if (self.sendButtonStatus == WBGroupControlSendButtonStatusBlue) {
        [self setSendButtonStatus:(WBGroupControlSendButtonStatusGray)];

        if (_delegate && [_delegate respondsToSelector:@selector(emojiGroupControlSendButtonDown:)]) {
            [_delegate emojiGroupControlSendButtonDown:self];
        }
    }
}

- (void)TabBarObserverTextView:(NSNotification *)notification{
    
    UITextView* textView = notification.object;
    if (textView.text.length) {
        [self setSendButtonStatus:(WBGroupControlSendButtonStatusBlue)];
    }else{
        [self setSendButtonStatus:(WBGroupControlSendButtonStatusGray)];
    }
    
    
}


#pragma mark - # Private Methods
- (void)p_addMasonry
{
    
}

- (void)p_eidtMyEmojiButtonDown
{
    if (_delegate && [_delegate respondsToSelector:@selector(emojiGroupControlEditMyEmojiButtonDown:)]) {
        [_delegate emojiGroupControlEditMyEmojiButtonDown:self];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.5 alpha:0.3].CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, WIDTH_EMOJIGROUP_CELL, 5);
    CGContextAddLineToPoint(context, WIDTH_EMOJIGROUP_CELL, self.frame.size.height - 5);
    CGContextStrokePath(context);
}

#pragma mark - # Getter
- (UIButton *)addButton
{
    if (_addButton == nil) {
        _addButton = [[UIButton alloc] init];
        [_addButton setImage:[UIImage wb_resourceImageNamed:@"Card_AddIcon"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(emojiAddButtonDown) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [layout setMinimumLineSpacing:0];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setScrollsToTop:NO];
    }
    return _collectionView;
}

- (UIButton *)sendButton
{
    if (_sendButton == nil) {
        _sendButton = [[UIButton alloc] init];
        [_sendButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
        [_sendButton setTitle:@"  发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_sendButton setBackgroundColor:[UIColor clearColor]];
        [_sendButton setBackgroundImage:[UIImage wb_resourceImageNamed:@"EmotionsSendBtnGrey"] forState:UIControlStateNormal];
        [_sendButton setBackgroundImage:[UIImage wb_resourceImageNamed:@"EmotionsSendBtnGrey"] forState:UIControlStateHighlighted];
        [_sendButton addTarget:self action:@selector(sendButtonDown) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

@end
