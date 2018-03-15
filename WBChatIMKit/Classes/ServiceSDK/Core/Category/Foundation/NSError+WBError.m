//
//  NSError+WBError.m

#import "NSError+WBError.h"

@implementation NSError (WBError)
+ (instancetype)wb_description:(NSString *)desc{
    desc = desc ? : @"发生了未知的错误";
    return [NSError errorWithDomain:@"WBChatKitErrorDomain"
                               code:0
                           userInfo:@{NSLocalizedDescriptionKey:desc}];
}

- (NSString *)wb_localizedDesc{
    return self.userInfo[NSLocalizedDescriptionKey];
}
@end

