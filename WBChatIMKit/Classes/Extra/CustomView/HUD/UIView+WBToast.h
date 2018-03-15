/***************************************************************************
 
UIView+Toast.h
Toast

Copyright (c) 2014 Charles Scalesse.
 
Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:
 
The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.
 
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
***************************************************************************/

#import <UIKit/UIKit.h>

extern NSString * const CSToastPositionTop;
extern NSString * const CSToastPositionCenter;
extern NSString * const CSToastPositionBottom;

@interface UIView (WBToast)

// each makeToast method creates a view and displays it as toast
- (void)wb_makeToast:(NSString *)message;
- (void)wb_makeToast:(NSString *)message duration:(NSTimeInterval)interval position:(id)position;
- (void)wb_makeToast:(NSString *)message duration:(NSTimeInterval)interval position:(id)position image:(UIImage *)image;
- (void)wb_makeToast:(NSString *)message duration:(NSTimeInterval)interval position:(id)position title:(NSString *)title;
- (void)wb_makeToast:(NSString *)message duration:(NSTimeInterval)interval position:(id)position title:(NSString *)title image:(UIImage *)image;

// displays toast with an activity spinner
- (void)wb_makeToastActivity;
- (void)wb_makeToastActivity:(id)position;
- (void)wb_hideToastActivity;

// the showToast methods display any view as toast
- (void)wb_showToast:(UIView *)toast;
- (void)wb_showToast:(UIView *)toast duration:(NSTimeInterval)interval position:(id)point;
- (void)wb_showToast:(UIView *)toast duration:(NSTimeInterval)interval position:(id)point
      tapCallback:(void(^)(void))tapCallback;



/*
 
 -(IBAction)buttonPressed:(UIButton *)button {
 
 switch (button.tag) {
 
 case 0: {
 // Make toast
 [self.view makeToast:@"This is a piece of toast."];
 break;
 }
 
 case 1: {
 // Make toast with a title
 [self.view makeToast:@"This is a piece of toast with a title."
 duration:3.0
 position:CSToastPositionTop
 title:@"Toast Title"];
 
 break;
 }
 
 case 2: {
 // Make toast with an image
 [self.view makeToast:@"This is a piece of toast with an image."
 duration:3.0
 position:CSToastPositionCenter
 image:[UIImage imageNamed:@"toast.png"]];
 break;
 }
 
 case 3: {
 // Make toast with an image & title
 [self.view makeToast:@"This is a piece of toast with a title & image"
 duration:3.0
 position:CSToastPositionBottom
 title:@"Toast Title"
 image:[UIImage imageNamed:@"toast.png"]];
 break;
 }
 
 case 4: {
 // Show a custom view as toast
 UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 400)];
 [customView setAutoresizingMask:(UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin)]; // autoresizing masks are respected on custom views
 [customView setBackgroundColor:[UIColor orangeColor]];
 
 [self.view showToast:customView
 duration:2.0
 position:CSToastPositionCenter];
 
 break;
 }
 
 case 5: {
 // Show an imageView as toast, on center at point (110,110)
 UIImageView *toastView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toast.png"]];
 
 [self.view showToast:toastView
 duration:2.0
 position:[NSValue valueWithCGPoint:CGPointMake(110, 110)]]; // wrap CGPoint in an NSValue object
 
 break;
 }
 
 case 6: {
 if (!_isShowingActivity) {
 [_activityButton setTitle:@"Hide Activity" forState:UIControlStateNormal];
 [self.view makeToastActivity];
 } else {
 [_activityButton setTitle:@"Show Activity" forState:UIControlStateNormal];
 [self.view hideToastActivity];
 }
 _isShowingActivity = !_isShowingActivity;
 break;
 }
 
 default: break;
 
 }
 
 }

 */


@end
