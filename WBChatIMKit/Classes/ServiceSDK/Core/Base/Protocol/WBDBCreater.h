//
//  OPDBCreater.h

#import <Foundation/Foundation.h>

@protocol WBDBCreater <NSObject>

@required
// 初次创建数据库表
- (BOOL)createDBTable;

@optional
- (BOOL)expandDBTable:(int)oldVersion;

@end
