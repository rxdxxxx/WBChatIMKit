//
//  WBImageBrowserView.m
//  WBChat
//
//  Created by RedRain on 2018/1/16.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBImageBrowserView.h"
#import "WBImageBrowserCell.h"
#import "WBChatCellConfig.h"
#import "WBConfig.h"
#import "UIImage+WBImage.h"
#define HeightForTopView 45
static  NSString *kWBImageBrowserView = @"kWBImageBrowserView";

@interface WBImageBrowserView () <UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView  *collectionView;
@property (nonatomic, strong) NSArray           *imageModelArray;
@property (nonatomic, strong) UIScrollView      *currentScrollView;

@end

@implementation WBImageBrowserView

#pragma mark - Instant Methods

+ (instancetype)browserWithImageArray:(NSArray *)imageModelArray {
    WBImageBrowserView *pictureBrowserView = [[self alloc] initWithFrame:CGRectMake(0, 0, kWBScreenWidth, kWBScreenHeight)];
    pictureBrowserView.imageModelArray = imageModelArray;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    UIView *windowView = [UIApplication sharedApplication].delegate.window;
    [windowView addSubview:pictureBrowserView];
    
    pictureBrowserView.alpha = 0.0;
    [UIView animateWithDuration:0.4 animations:^{
        pictureBrowserView.alpha = 1.0;
    }];
    
    return pictureBrowserView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
    }
    return self;
}


#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return CGSizeMake(kWBScreenWidth, kWBScreenHeight);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageModelArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(WBImageBrowserCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    cell.imageScrollView.zoomScale = 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WBImageBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kWBImageBrowserView forIndexPath:indexPath];
    
    __weak typeof(self)weakSelf = self;
    cell.singleTapBlock = ^{
        [weakSelf close];
    };
    
    
    
    WBMessageModel *messageModel = self.imageModelArray[indexPath.row];
    
    NSString *imageLocalPath = messageModel.imagePath;
    BOOL isLocalPath = ![imageLocalPath hasPrefix:@"http"];
    UIImage *image = nil;
    if (isLocalPath) {
        NSData *imageData = [NSData dataWithContentsOfFile:imageLocalPath];
        image = [UIImage imageWithData:imageData];
    }
    
    if (image && isLocalPath) {
        cell.imageImageView.image = image;
    }
    else if (imageLocalPath.length && messageModel.thumbImage){
        [[WBChatCellConfig sharedInstance].imageLoad imageView:cell.imageImageView
                                                     urlString:imageLocalPath
                                              placeholderImage:messageModel.thumbImage];
    }
    else if (messageModel.thumbImage) {
        cell.imageImageView.image = messageModel.thumbImage;
    }
    else{
        cell.imageImageView.image = [UIImage wb_resourceImageNamed:@"Placeholder_Image"];
    }
    
    
    return cell;
}


#pragma mark - Private Methods
- (void)close{
    self.alpha = 1.0;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0.0;
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}



#pragma mark - Setter
- (void)setStartIndex:(NSInteger)startIndex {
    [self.collectionView setContentOffset:CGPointMake((startIndex - 1) * kWBScreenWidth, 0)];
}


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;   // item横向间距
        layout.minimumLineSpacing = 0;   // item竖向间距
        
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWBScreenWidth, kWBScreenHeight) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[WBImageBrowserCell class] forCellWithReuseIdentifier:kWBImageBrowserView];

    }
    return _collectionView;
}

@end
