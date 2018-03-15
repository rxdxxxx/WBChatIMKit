//
//  OPClient.m

#import "WBDBClient.h"
#import "WBCoreConfiguration.h"


@implementation WBDBClient

WB_SYNTHESIZE_SINGLETON_FOR_CLASS(WBDBClient);

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _dbCreaters = [[NSMutableArray alloc] init];
        _terminateHandlers = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (dispatch_queue_t)sqliteQueue{
    if (!_sqliteQueue) {
        _sqliteQueue = dispatch_queue_create("com.WBChatKit.sqliteQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _sqliteQueue;
}

#pragma mark - Register

- (void)registerDBCreater:(id)creater {
    if ([_dbCreaters containsObject:creater]){
        return;
    }
    
    [_dbCreaters addObject:creater];
}

- (void)createTable {
    for (id<WBDBCreater> creater in _dbCreaters){
        [creater createDBTable];
    }
}

- (void)extendTable:(int)version {
    for (id<WBDBCreater> creater in _dbCreaters){
        [creater expandDBTable:version];
    }
}





#pragma mark - onApplicationWillTerminate

- (void)registerTerminateHandler:(id)handler{
    
    if ([_terminateHandlers containsObject:handler])
        return;
    [_terminateHandlers addObject:handler];
}

-(void)doTerminateHandlerTask{
    
    for (id<WBTerminateHandler> handler in _terminateHandlers)
        if ([handler respondsToSelector:@selector(onApplicationWillTerminateTask)]) {
            [handler onApplicationWillTerminateTask];
        }
}


#pragma mark - DB

- (void)openDB:(NSString *)userId{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *appFinder = [documentDirectory stringByAppendingString:@"/WBChatKit"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:appFinder]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:appFinder
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:nil];
        NSURL *url = [NSURL fileURLWithPath:appFinder];
        [self addSkipBackupAttributeToItemAtURL:url];//用户文件夹防止备份到iCloud
    }
    
    // 对应子用户的文件夹
    NSString *userPathDirectory = [appFinder stringByAppendingPathComponent:userId];
    if (![[NSFileManager defaultManager] fileExistsAtPath:userPathDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:userPathDirectory
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:nil];
        NSURL *url = [NSURL fileURLWithPath:userPathDirectory];
        [self addSkipBackupAttributeToItemAtURL:url];//用户文件夹防止备份到iCloud
    }
    NSString *dbFile = [userPathDirectory stringByAppendingPathComponent:@"Sqlite.db"];
    self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbFile];
}

- (void)closeDB{
    [self.dbQueue close];
}


- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        //OPLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}


@end
