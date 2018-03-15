//
//  OPTerminateHandler.h

#import <Foundation/Foundation.h>

@protocol WBTerminateHandler <NSObject>

@required
- (void)onApplicationWillTerminateTask;

@end
