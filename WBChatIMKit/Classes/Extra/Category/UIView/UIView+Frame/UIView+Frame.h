/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>

CGPoint CGRectGetCenter(CGRect rect);
CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);

@interface UIView (ViewFrameGeometry)

@property CGPoint origin_wb;
@property CGSize size_wb;

@property (readonly) CGPoint bottomLeft_wb;
@property (readonly) CGPoint bottomRight_wb;
@property (readonly) CGPoint topRight_wb;

@property(nonatomic,assign)CGFloat width_wb;
@property(nonatomic,assign)CGFloat height_wb;

@property CGFloat top_wb;
@property CGFloat left_wb;

@property CGFloat bottom_wb;
@property CGFloat right_wb;

//中心点的x与y
@property (nonatomic, assign) CGFloat centerX_wb;
@property (nonatomic, assign) CGFloat centerY_wb;



- (void) moveBy_wb: (CGPoint) delta;
- (void) scaleBy_wb: (CGFloat) scaleFactor;
- (void) fitInSize_wb: (CGSize) aSize;

- (void) wb_addRorationAnimaitonInLayer;
@end
