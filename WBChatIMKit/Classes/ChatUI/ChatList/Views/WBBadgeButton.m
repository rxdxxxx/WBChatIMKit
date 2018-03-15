//
//  WBBadgeButton.m


#import "WBBadgeButton.h"
#import "UIImage+WBImage.h"
@implementation WBBadgeButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.userInteractionEnabled = NO;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.contentMode = UIViewContentModeScaleAspectFit;
        self.layer.cornerRadius = CGRectGetWidth(frame)/2;
        self.layer.masksToBounds = YES;
        self.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return self;
}
-(void)setBadgeValue:(NSString *)badgeValue {
    _badgeValue = [badgeValue copy];
    
    if (badgeValue && [badgeValue intValue] != 0 ) {
        
        self.hidden = NO;
        NSString *imageName;
        if ([badgeValue integerValue] > 99) {
            badgeValue = @"";
            imageName = @"CloudChatList_badge_dot";
        } else {
            imageName = @"CloudChatList_badge";
        }
        [self setBackgroundImage:[UIImage wb_resourceImageNamed:imageName] forState:UIControlStateNormal];
    
        NSString *text = [NSString stringWithFormat:@"%@",badgeValue];
        [self setTitle:text forState:UIControlStateNormal];
        
    }else {
        
        self.hidden = YES;
    }
}

@end
