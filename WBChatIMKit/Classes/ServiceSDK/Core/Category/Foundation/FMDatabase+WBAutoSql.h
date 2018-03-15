//
//  FMDatabase+WBAutoSql.h
//  WBChat
//
//  Created by RedRain on 2018/1/17.
//  Copyright © 2018年 RedRain. All rights reserved.
//

#import <FMDB/FMDB.h>

@interface FMDatabase (WBAutoSql)

- (BOOL)creatTableByTableName:(NSString *)tableName Model:(id)model;
- (BOOL)creatTableByTableName:(NSString *)tableName Model:(id)model othersFields:(NSArray<NSDictionary *> *)fieldsArray;

@end
