//
//  FMDatabase+WBAutoSql.m
//  WBChat
//
//  Created by RedRain on 2018/1/17.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import "FMDatabase+WBAutoSql.h"
#import <objc/runtime.h>

@implementation FMDatabase (WBAutoSql)


/**
 根据model，新建表格
 */
- (BOOL)creatTableByTableName:(NSString *)tableName Model:(id)model
{
    
    return [self creatTableByTableName:tableName Model:model othersFields:nil];
    
}

- (BOOL)creatTableByTableName:(NSString *)tableName Model:(id)model othersFields:(NSArray<NSDictionary *> *)fieldsArray
{
    NSArray * attrArray = [self getAllProperties:model];
    //创建表格
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    for (id value in attrArray) {
        [dic setObject:@"TEXT" forKey:value];
    }
    
    if (fieldsArray != nil) {
        for (NSDictionary *field in fieldsArray) {
            NSString *key = field.allKeys.firstObject;
            id value = field[key];
            if (key && value) {
                [dic setObject:value forKey:key];
            }
        }
    }
    
    BOOL result = [self createDatabaseTales:tableName field:dic];
    
    return result;
}


//获取本类所有属性
- (NSArray *)getAllProperties:(id)model
{
    u_int count;
    
    objc_property_t *properties  =class_copyPropertyList([model class], &count);
    
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count ; i++)
    {
        const char* propertyName =property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    
    free(properties);
    
    return propertiesArray;
}

// 创建数据库表格
- (BOOL)createDatabaseTales:(NSString *)tableName field:(NSDictionary *)field{
    
    NSMutableString *sql = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (keyId integer  PRIMARY KEY AUTOINCREMENT",tableName];
    
    NSArray *arr = [field allKeys];
    
    for (NSInteger i = 0; i < arr.count; i++) {
        
        if (i == arr.count-1) {
            NSString *value = [field valueForKey:arr[i]];
            
            NSString *str = [NSString stringWithFormat:@",%@ %@)",arr[i],value];
            
            [sql appendString:str];
            
        }else{
            
            NSString *value = [field valueForKey:arr[i]];
            
            NSString *str = [NSString stringWithFormat:@",%@ %@",arr[i],value];
            [sql appendString:str];
        }
    }
    if (self.open) {
        BOOL b =[self executeUpdate:sql];
        
        if (b) {
            
            return YES;
        }
    }
    
    //OPLog(@"表格创建失败");
    
    return NO;
}
@end
