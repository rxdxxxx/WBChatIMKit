//
//  WBKeyBoardTextView.m
//  WBChat
//
//  Created by RedRain on 2018/1/22.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "WBKeyBoardTextView.h"

@implementation WBKeyBoardTextView


- (void)setContentOffset:(CGPoint)s{
    
    if(self.tracking || self.decelerating){
        //initiated by user...
        
        UIEdgeInsets insets = self.contentInset;
        insets.bottom = 0;
        insets.top = 0;
        self.contentInset = insets;
        
    } else {
        
        float bottomOffset = (self.contentSize.height - self.frame.size.height + self.contentInset.bottom);
        if(s.y < bottomOffset && self.scrollEnabled){
            UIEdgeInsets insets = self.contentInset;
            insets.bottom = 8;
            insets.top = 0;
            self.contentInset = insets;
        }
    }
    
    // Fix "overscrolling" bug
    if (s.y > self.contentSize.height - self.frame.size.height && !self.decelerating && !self.tracking && !self.dragging){
        s = CGPointMake(s.x, self.contentSize.height - self.frame.size.height);
    }
    
    [super setContentOffset:s];
}
@end
