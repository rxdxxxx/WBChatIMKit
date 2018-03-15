//
//  NSBundle+LCCKExtension.h

#import <Foundation/Foundation.h>

@interface NSBundle (LCCKExtension)

+ (NSBundle *)lcck_bundleForName:(NSString *)bundleName class:(Class)aClass;

@end
