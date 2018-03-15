//
//  OPDBClient.h

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>
#import <FMDB/FMDB.h>
#import "WBSynthesizeSingleton.h"
#import "WBCoreConfiguration.h"

#define WBDBClientSqlQueue [WBDBClient sharedInstance].sqliteQueue

NS_ASSUME_NONNULL_BEGIN
@interface WBDBClient : NSObject
@property (nonatomic, strong) dispatch_queue_t sqliteQueue;

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;


@property (nonatomic, strong) NSMutableArray *dbCreaters;           // OPDBCreater
@property (nonatomic, strong) NSMutableArray *terminateHandlers;    // OPTerminateHandler

// 创建单利
WB_SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(WBDBClient);


#pragma mark - About DB

- (void)openDB:(NSString *)userId;

- (void)closeDB;


#pragma mark - Start
- (void)createTable;
- (void)extendTable:(int)version;

- (void)registerDBCreater:(id<WBDBCreater>)creater;
- (void)registerTerminateHandler:(id)handler;

-(void)doTerminateHandlerTask;
@end

NS_ASSUME_NONNULL_END
