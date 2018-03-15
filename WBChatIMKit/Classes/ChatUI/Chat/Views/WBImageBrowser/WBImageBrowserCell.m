//
//  WBImageBrowserCell.m
//  WBChat
//
//  Created by RedRain on 2018/1/16.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBImageBrowserCell.h"

@interface WBImageBrowserCell ()<UIScrollViewDelegate>

@end;

@implementation WBImageBrowserCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageScrollView  = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.imageScrollView.maximumZoomScale = 3.0;
        self.imageScrollView.minimumZoomScale = 1;
        self.imageScrollView.showsHorizontalScrollIndicator = NO;
        self.imageScrollView.showsVerticalScrollIndicator = NO;
        self.imageScrollView.delegate = self;
        [self.contentView addSubview:self.imageScrollView];
        
        self.imageImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.imageImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.imageScrollView addSubview:self.imageImageView];
        
        

        // 添加手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
        [self.imageScrollView addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
        doubleTap.numberOfTapsRequired = 2;
        [self.imageScrollView addGestureRecognizer:doubleTap];
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.imageScrollView.frame = [UIScreen mainScreen].bounds;
    self.imageImageView.frame = [UIScreen mainScreen].bounds;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return scrollView.subviews[0];
}


#pragma mark - Action
- (void)singleTapAction:(UITapGestureRecognizer *)tap {
    
    if (self.singleTapBlock) {
        self.singleTapBlock();
    }

}

- (void)doubleTapAction:(UITapGestureRecognizer *)tap {
    
    CGFloat scale = self.imageScrollView.zoomScale == 1 ? 3 : 1;
    CGRect zoomRect = [self zoomRectForScale:scale withCenter:[tap locationInView:tap.view]];
    [self.imageScrollView zoomToRect:zoomRect animated:YES];
}

#pragma mark - Private Methods
// 双击时的中心点
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    CGRect zoomRect = CGRectZero;
    zoomRect.size.height = self.imageScrollView.frame.size.height / scale;
    zoomRect.size.width  = self.imageScrollView.frame.size.width  / scale;
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}


@end
