//
//  WBPlusDisplayBoard.m
//  WBChat
//
//  Created by RedRain on 2018/1/31.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBPlusDisplayBoard.h"
#import "WBPlusBoardCell.h"

#define     WB_SPACE_TOP        15
#define     WB_WIDTH_CELL       60

@interface WBPlusDisplayBoard ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) UIEdgeInsets sectionInsets;

@end

@implementation WBPlusDisplayBoard
#pragma mark -  Life Cycle
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:(245.0)/255.0f green:245.0/255.0f blue:(247.0)/255.0f alpha:1.0];
        [self addSubview:self.collectionView];
        [self addSubview:self.pageControl];
        
        [self.collectionView registerClass:[WBPlusBoardCell class] forCellWithReuseIdentifier:@"WBPlusBoardCell"];

        
        CGFloat height = WB_EmojiBoard_Height - 57;
        CGFloat width = WBKeyBoardSCREEN_WIDTH_emoji;
        CGFloat cellHeight = (height - 15) / 3;
        CGFloat cellWidth = ceil((width - 20) / 7);
        CGFloat spaceX = (width - cellWidth * 7) / 2.0;
        CGFloat spaceYTop = 10;
        CGFloat spaceYBottom = (height - cellHeight * 3) - spaceYTop;
        
        UIEdgeInsets sectionInsets = UIEdgeInsetsMake(spaceYTop, spaceX, spaceYBottom, spaceX);
        self.sectionInsets = sectionInsets;
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

#pragma mark -  UITableViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if( [self.dataSource respondsToSelector:@selector(plusBoardItemInfos:)]){
        return [[self.dataSource plusBoardItemInfos:(WBChatBarView *)self.superview] count];
    }else{
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *infoA = [self.dataSource plusBoardItemInfos:(WBChatBarView *)self.superview];
    NSDictionary *info = infoA[indexPath.row];
    
    WBPlusBoardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WBPlusBoardCell" forIndexPath:indexPath];
    cell.iconImageView.image = info[kPlusBoardIcon];
    cell.iconTitleLabel.text = info[kPlusBoardTitle];
    return cell;
    
}

//MARK: UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.delegate respondsToSelector:@selector(chatBar:didSelectItemInfo:)]) {
        NSArray *infoA = [self.dataSource plusBoardItemInfos:(WBChatBarView *)self.superview];
        NSDictionary *info = infoA[indexPath.row];
        [self.delegate chatBar:(WBChatBarView *)self.superview didSelectItemInfo:info];
    }
}


#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.dragging) {
        double pageNo = scrollView.contentOffset.x / scrollView.frame.size.width;
        self.pageControl.currentPage = (int)(pageNo + 0.5);
    }
}
#pragma mark -  CustomDelegate
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
#pragma mark -  Public Methods
+ (instancetype)createPlusBoard{
    
    WBPlusDisplayBoard *view = [[WBPlusDisplayBoard alloc] initWithFrame:CGRectMake(0, 0, WBKeyBoardSCREEN_WIDTH_emoji, WB_EmojiBoard_Height + WB_IPHONEX_BOTTOM_SPACE_emoji)];
    return view;
}
- (void)reloadData{
    [self.collectionView reloadData];
}
#pragma mark -  Getters and Setters
- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        layout.itemSize = CGSizeMake(WB_WIDTH_CELL, (WB_EmojiBoard_Height - WB_SPACE_TOP - 30) / 2 * 0.93);
        CGFloat space = (WBKeyBoardSCREEN_WIDTH_emoji - WB_WIDTH_CELL * self.pageItemCount / 2) / (self.pageItemCount / 2 + 1);
        layout.sectionInset = UIEdgeInsetsMake(WB_SPACE_TOP, space, 0, space);
        layout.minimumLineSpacing = (WBKeyBoardSCREEN_WIDTH_emoji - WB_WIDTH_CELL * self.pageItemCount / 2) / (self.pageItemCount / 2 + 1);
        layout.minimumInteritemSpacing = (WBKeyBoardSCREEN_WIDTH_emoji - WB_SPACE_TOP) / 2 * 0.07;
        
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, WBKeyBoardSCREEN_WIDTH_emoji, WB_EmojiBoard_Height - 20) collectionViewLayout:layout];
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
- (NSInteger)pageItemCount
{
    return (int)(WBKeyBoardSCREEN_WIDTH_emoji / (WB_WIDTH_CELL * 1.3)) * 2;
}
@end
