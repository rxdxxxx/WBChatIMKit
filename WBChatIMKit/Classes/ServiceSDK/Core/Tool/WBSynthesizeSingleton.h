//
//  WBSynthesizeSingleton.h

#if __has_feature(objc_arc)

#define WB_SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(classname) \
\
+ (classname * _Nullable)sharedInstance;

#define WB_SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)sharedInstance \
{ \
    static dispatch_once_t pred; \
    dispatch_once(&pred, ^{ shared##classname = [[classname alloc] init]; }); \
    return shared##classname; \
}

#else

#define WB_SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(classname) \
\
+ (classname *)sharedInstance;

#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
\
static classname *shared##classname = nil; \
\
+ (classname *)sharedInstance \
{ \
    static dispatch_once_t pred; \
    dispatch_once(&pred, ^{ shared##classname = [[classname alloc] init]; }); \
    return shared##classname; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
    return self; \
} \
\
- (id)retain \
{ \
    return self; \
} \
\
- (NSUInteger)retainCount \
{ \
    return NSUIntegerMax; \
} \
\
- (oneway void)release \
{ \
} \
\
- (id)autorelease \
{ \
    return self; \
}

#endif
