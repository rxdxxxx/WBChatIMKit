//
//  NSObject+WBExtension.m


#import "NSObject+WBExtension.h"

@implementation NSObject (WBExtension)

- (NSDictionary *)wb_JSONValue {
    if (!self) { return nil; }
    id result = nil;
    NSError* error = nil;
    if ([self isKindOfClass:[NSString class]]) {
        if ([(NSString *)self length] == 0) { return nil; }
        NSData *dataToBeParsed = [(NSString *)self dataUsingEncoding:NSUTF8StringEncoding];
        result = [NSJSONSerialization JSONObjectWithData:dataToBeParsed options:kNilOptions error:&error];
    } else {
        result = [NSJSONSerialization JSONObjectWithData:(NSData *)self options:kNilOptions error:&error];
    }
    if (![result isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return result;
}

@end
