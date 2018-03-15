//
//  WBEmojiKeyBoard.m
//  WBChat
//
//  Created by RedRain on 2018/1/24.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBEmotionDisplayBoard.h"
#import "WBEmojiKeyBoardCell.h"
#import "WBEmojiGroupControl.h"


@interface WBEmotionDisplayBoard ()<UICollectionViewDelegate,UICollectionViewDataSource,WBEmojiGroupControlDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray<WBEmotionPageModel *> *dataArray;
@property (nonatomic, assign) UIEdgeInsets sectionInsets;
@property (nonatomic, strong) WBEmojiGroupControl *groupControl;


@end


@implementation WBEmotionDisplayBoard
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark -  Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:(245.0)/255.0f green:245.0/255.0f blue:(247.0)/255.0f alpha:1.0];

        [self addSubview:self.collectionView];
        [self addSubview:self.pageControl];
        [self addSubview:self.groupControl];

        [self.collectionView registerClass:[WBEmojiKeyBoardCell class] forCellWithReuseIdentifier:@"WBEmojiKeyBoardCell"];
        
        CGFloat height = WB_EmojiBoard_Height - 57;
        CGFloat width = WBKeyBoardSCREEN_WIDTH_emoji;
        CGFloat cellHeight = (height - 15) / 3;
        CGFloat cellWidth = ceil((width - 20) / 7);
        CGFloat spaceX = (width - cellWidth * 7) / 2.0;
        CGFloat spaceYTop = 10;
        CGFloat spaceYBottom = (height - cellHeight * 3) - spaceYTop;

        UIEdgeInsets sectionInsets = UIEdgeInsetsMake(spaceYTop, spaceX, spaceYBottom, spaceX);
        self.sectionInsets = sectionInsets;
        
        NSBundle *customBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"WBUI" ofType:@"bundle"]];
        NSString *bundlePath = [customBundle bundlePath];
        NSString *jsonPath = [bundlePath stringByAppendingPathComponent:@"SystemEmoji.json"];
        NSData *data = [NSData dataWithContentsOfFile:jsonPath];

        NSArray *emojiDicArr = [NSJSONSerialization JSONObjectWithData:(NSData *)data options:kNilOptions error:nil];
        
        NSMutableArray* tempArray = [NSMutableArray arrayWithCapacity:21];
        NSUInteger i = 0;
        for (NSDictionary* dic in emojiDicArr) {
            @autoreleasepool{
                WBEmotionPageItemModel* emotionModel  = [[WBEmotionPageItemModel alloc]init];
                emotionModel.type = WBEmotionItemTypeEmoji;
                emotionModel.name = dic[@"credentialName"];
                [tempArray addObject:emotionModel];
                i++;
                
                if (i == 20 || dic == emojiDicArr.lastObject) {
                    WBEmotionPageItemModel* emotionModel  = [[WBEmotionPageItemModel alloc]init];
                    emotionModel.type = WBEmotionItemTypeDelete;
                    [tempArray addObject:emotionModel];
                    
                    
                    WBEmotionPageModel *page = [WBEmotionPageModel new];
                    page.type = WBEmotionPageTypeEmoji;
                    page.cellSize = CGSizeMake(cellWidth, cellHeight);
                    page.pageDataArray = tempArray.mutableCopy;
                    [self.dataArray addObject:page];
                    
                    tempArray = [NSMutableArray arrayWithCapacity:21];
                    i = 0;
                }
            }
        }
        
        [self.collectionView reloadData];
        NSUInteger count = (emojiDicArr.count + 20 - 1) / 20;
        self.pageControl.numberOfPages = count;

        self.groupControl.emojiGroupData = @[self.dataArray.firstObject].mutableCopy;
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    // 顶部直线
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.5 alpha:0.3].CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, WBKeyBoardSCREEN_WIDTH_emoji, 0);
    CGContextStrokePath(context);
}
#pragma mark -  UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    WBEmotionPageModel *group = self.dataArray[section];
    return group.pageDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WBEmotionPageModel *group = self.dataArray[indexPath.section];
    WBEmotionPageItemModel *cellModel = group.pageDataArray[indexPath.row];
    
    UICollectionViewCell *cell = nil;
    switch (cellModel.type) {
        case WBEmotionItemTypeDelete:
        case WBEmotionItemTypeEmoji:{
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WBEmojiKeyBoardCell" forIndexPath:indexPath];
            ((WBEmojiKeyBoardCell *)cell).cellModel = cellModel;
        }
            break;
    }
    
    return cell;
    
}

//MARK: UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    WBEmotionPageModel *group = self.dataArray[indexPath.section];
    WBEmotionPageItemModel *cellModel = group.pageDataArray[indexPath.row];
    NSString *text = @"-1";
    if (cellModel.type == WBEmotionItemTypeEmoji) {
        text = cellModel.name;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:WBEmotionDisplayBoardDidSelectEmojiNotifi object:[self viewController] userInfo:@{@"text":text}];
    
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

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WBEmotionPageModel *group = self.dataArray[indexPath.section];
    return group.cellSize;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return self.sectionInsets;
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.dragging) {
        double pageNo = scrollView.contentOffset.x / scrollView.frame.size.width;
        self.pageControl.currentPage = (int)(pageNo + 0.5);
    }
}

#pragma mark -  CustomDelegate
#pragma mark - WBEmojiGroupControlDelegate
- (void)emojiGroupControl:(WBEmojiGroupControl*)emojiGroupControl didSelectedGroup:(id)group{
    
}

- (void)emojiGroupControlEditButtonDown:(WBEmojiGroupControl *)emojiGroupControl{
    
}

- (void)emojiGroupControlEditMyEmojiButtonDown:(WBEmojiGroupControl *)emojiGroupControl{
    
}

- (void)emojiGroupControlSendButtonDown:(WBEmojiGroupControl *)emojiGroupControl{

    [[NSNotificationCenter defaultCenter] postNotificationName:WBEmotionDisplayBoardSendClickNotifi object:[self viewController]];
}

#pragma mark -  Event Response
#pragma mark -  Notification Callback
#pragma mark -  GestureRecognizer Action
#pragma mark -  Btn Click
- (void)pageControlValueChange:(UIPageControl *)sender{
    [self.collectionView setContentOffset:CGPointMake(sender.currentPage * WBKeyBoardSCREEN_WIDTH_emoji, 0) animated:YES];
}

#pragma mark -  Private Methods
- (void)setupUI{
    
}
#pragma mark -  Public Methods
+ (instancetype)createEmojiKeyboard{
    WBEmotionDisplayBoard *view = [[WBEmotionDisplayBoard alloc] initWithFrame:CGRectMake(0, 0, WBKeyBoardSCREEN_WIDTH_emoji, WB_EmojiBoard_Height + WB_IPHONEX_BOTTOM_SPACE_emoji)];
    return view;
}
#pragma mark -  Getters and Setters

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WBKeyBoardSCREEN_WIDTH_emoji, WB_EmojiBoard_Height - 57) collectionViewLayout:layout];
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        [_collectionView setPagingEnabled:YES];
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setScrollsToTop:NO];
    }
    return _collectionView;
}
- (UIPageControl *)pageControl
{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.collectionView.frame.size.height, WBKeyBoardSCREEN_WIDTH_emoji, 20)];

        _pageControl.currentPage = 0;
        [_pageControl setPageIndicatorTintColor:[UIColor colorWithWhite:0.5 alpha:0.3]];
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor grayColor]];
        [_pageControl addTarget:self action:@selector(pageControlValueChange:) forControlEvents:UIControlEventValueChanged];

    }
    return _pageControl;
}

- (WBEmojiGroupControl *)groupControl{
    if (!_groupControl) {
        _groupControl = [[WBEmojiGroupControl alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.pageControl.frame),
                                                                             WBKeyBoardSCREEN_WIDTH_emoji, self.frame.size.height - CGRectGetMaxY(self.pageControl.frame) - WB_IPHONEX_BOTTOM_SPACE_emoji)];
        _groupControl.delegate = self;
    }
    return _groupControl;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray new];
    }
    return _dataArray;
}
@end

