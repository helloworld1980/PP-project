//
//  YTKKeyValueStore.m
//  demo
//
//  Created by liman on 1/5/16.
//  Copyright © 2016 liman. All rights reserved.
//

#import "YTKKeyValueStore.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabaseQueue.h"
#import "MJExtension.h"

#ifdef DEBUG
#define debugLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define debugLog(FORMAT, ...) nil
#endif

#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@implementation YTKKeyValueItem

- (NSString *)description
{
    return [NSString stringWithFormat:@"\nitemId = %@, \nitemObject = %@, \ncreatedTime = %@", _itemId, _itemObject, _createdTime];
}

@end

@interface YTKKeyValueStore()

@property (strong, nonatomic) FMDatabaseQueue * dbQueue;
@property (strong, nonatomic) NSDateFormatter * dateFormatter;//liman

@end

@implementation YTKKeyValueStore

static NSString *const DEFAULT_DB_NAME = @"database.sqlite";

static NSString *const CREATE_TABLE_SQL =
@"CREATE TABLE IF NOT EXISTS %@ ( \
id TEXT NOT NULL, \
json TEXT NOT NULL, \
createdTime TEXT NOT NULL, \
PRIMARY KEY(id)) \
";

static NSString *const UPDATE_ITEM_SQL = @"REPLACE INTO %@ (id, json, createdTime) values (?, ?, ?)";

static NSString *const QUERY_ITEM_SQL = @"SELECT json, createdTime from %@ where id = ? Limit 1";

static NSString *const SELECT_ALL_SQL = @"SELECT * from %@";

static NSString *const COUNT_ALL_SQL = @"SELECT count(*) as num from %@";

static NSString *const CLEAR_ALL_SQL = @"DELETE from %@";

static NSString *const DELETE_ITEM_SQL = @"DELETE from %@ where id = ?";

static NSString *const DELETE_ITEMS_SQL = @"DELETE from %@ where id in ( %@ )";

static NSString *const DELETE_ITEMS_WITH_PREFIX_SQL = @"DELETE from %@ where id like ? ";

static NSString *const DROP_TABLE_SQL = @"DROP TABLE %@";

//liman
+ (instancetype)sharedInstance
{
    static YTKKeyValueStore *__singletion = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        __singletion = [[self alloc] init];
    });
    
    return __singletion;
}


+ (BOOL)checkTableName:(NSString *)tableName
{
    if (tableName == nil || tableName.length == 0 || [tableName rangeOfString:@" "].location != NSNotFound) {
        debugLog(@"ERROR, table name: %@ format error.", tableName);
        return NO;
    }
    return YES;
}

- (id)init
{
    //liman
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [self initDBWithName:DEFAULT_DB_NAME];
}

- (id)initDBWithName:(NSString *)dbName
{
    self = [super init];
    if (self) {
        NSString * dbPath = [PATH_OF_DOCUMENT stringByAppendingPathComponent:dbName];
        debugLog(@"dbPath = %@", dbPath);
        if (_dbQueue) {
            [self close];
        }
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    }
    return self;
}

- (id)initWithDBWithPath:(NSString *)dbPath
{
    self = [super init];
    if (self) {
        debugLog(@"dbPath = %@", dbPath);
        if (_dbQueue) {
            [self close];
        }
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
    }
    return self;
}

- (void)createTableWithName:(NSString *)tableName
{
    if ([YTKKeyValueStore checkTableName:tableName] == NO) {
        return;
    }
    NSString * sql = [NSString stringWithFormat:CREATE_TABLE_SQL, tableName];
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql];
    }];
    if (!result) {
        debugLog(@"ERROR, failed to create table: %@", tableName);
    }
}

- (BOOL)isTableExists:(NSString *)tableName
{
    if ([YTKKeyValueStore checkTableName:tableName] == NO) {
        return NO;
    }
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db tableExists:tableName];
    }];
    if (!result) {
        debugLog(@"WARNING, table: %@ not exists in current DB", tableName);
    }
    return result;
}

- (void)clearTable:(NSString *)tableName
{
    if ([YTKKeyValueStore checkTableName:tableName] == NO) {
        return;
    }
    NSString * sql = [NSString stringWithFormat:CLEAR_ALL_SQL, tableName];
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql];
    }];
    if (!result) {
        debugLog(@"ERROR, failed to clear table: %@", tableName);
    }
}

- (void)putObject:(id)object withId:(NSString *)objectId intoTable:(NSString *)tableName
{
    if (object == nil) {
        debugLog(@"error, object is nil");
        return;
    }
    
    if ([YTKKeyValueStore checkTableName:tableName] == NO) {
        return;
    }
    
    //liman
    if (![self isTableExists:tableName]) {
        [self createTableWithName:tableName];
    }
    
    NSError * error;
    NSData * data = [NSJSONSerialization dataWithJSONObject:object options:0 error:&error];
    if (error) {
        debugLog(@"ERROR, faild to get json data");
        return;
    }
    NSString * jsonString = [[NSString alloc] initWithData:data encoding:(NSUTF8StringEncoding)];
//    NSDate * createdTime = [NSDate date];
    NSString * createdTime = [_dateFormatter stringFromDate:[NSDate date]];
    NSString * sql = [NSString stringWithFormat:UPDATE_ITEM_SQL, tableName];
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql, objectId, jsonString, createdTime];
    }];
    if (!result) {
        debugLog(@"ERROR, failed to insert/replace into table: %@", tableName);
    }
}

- (id)getObjectById:(NSString *)objectId fromTable:(NSString *)tableName
{
    YTKKeyValueItem * item = [self getYTKKeyValueItemById:objectId fromTable:tableName];
    if (item) {
        return item.itemObject;
    } else {
        return nil;
    }
}

- (YTKKeyValueItem *)getYTKKeyValueItemById:(NSString *)objectId fromTable:(NSString *)tableName
{
    if ([YTKKeyValueStore checkTableName:tableName] == NO) {
        return nil;
    }
    
    NSString * sql = [NSString stringWithFormat:QUERY_ITEM_SQL, tableName];
//    __block NSString * json = nil;
    __block id json = nil;
    __block NSDate * createdTime = nil;

    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * rs = [db executeQuery:sql, objectId];
        if ([rs next]) {
//            json = [rs stringForColumn:@"json"];
            json = [rs objectForColumnName:@"json"];
//            createdTime = [rs dateForColumn:@"createdTime"];
            createdTime = [_dateFormatter dateFromString:[rs stringForColumn:@"createdTime"]];
        }
        [rs close];
    }];
    
    if (json)
    {
        if ([json isKindOfClass:[NSString class]])
        {
            NSError * error;
            id result = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
                                                        options:(NSJSONReadingAllowFragments) error:&error];
            if (error) {
                debugLog(@"ERROR, faild to parse to json");
                return nil;
            }
            YTKKeyValueItem * item = [[YTKKeyValueItem alloc] init];
            item.itemId = objectId;
            item.itemObject = result;
            item.createdTime = createdTime;
            return item;
        }
        else
        {
            if ([UIImage imageWithData:json])
            {
                //图片data
                YTKKeyValueItem * item = [[YTKKeyValueItem alloc] init];
                item.itemId = objectId;
                item.itemObject = [UIImage imageWithData:json];
                item.createdTime = createdTime;
                return item;
            }
            else
            {
                //data数组 (暂时只支持:图片data数组)
                YTKKeyValueItem * item = [[YTKKeyValueItem alloc] init];
                item.itemId = objectId;
                item.itemObject = [self getImagesById:objectId fromTable:tableName];
                item.createdTime = createdTime;
                return item;
            }
        }
        
    }
    else
    {
        return nil;
    }
}

- (void)putString:(NSString *)string withId:(NSString *)stringId intoTable:(NSString *)tableName
{
    if (string == nil) {
        debugLog(@"error, string is nil");
        return;
    }
    
    [self putObject:@[string] withId:stringId intoTable:tableName];
}

- (NSString *)getStringById:(NSString *)stringId fromTable:(NSString *)tableName
{
    NSArray * array = [self getObjectById:stringId fromTable:tableName];
    if (array && [array isKindOfClass:[NSArray class]]) {
        return array[0];
    }
    return nil;
}

- (void)putNumber:(NSNumber *)number withId:(NSString *)numberId intoTable:(NSString *)tableName
{
    if (number == nil) {
        debugLog(@"error, number is nil");
        return;
    }
    
    [self putObject:@[number] withId:numberId intoTable:tableName];
}

- (NSNumber *)getNumberById:(NSString *)numberId fromTable:(NSString *)tableName
{
    NSArray * array = [self getObjectById:numberId fromTable:tableName];
    if (array && [array isKindOfClass:[NSArray class]]) {
        return array[0];
    }
    return nil;
}

- (NSArray *)getAllItemsFromTable:(NSString *)tableName
{
    if ([YTKKeyValueStore checkTableName:tableName] == NO) {
        return nil;
    }
    
    NSString * sql = [NSString stringWithFormat:SELECT_ALL_SQL, tableName];
    __block NSMutableArray * result = [NSMutableArray array];
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * rs = [db executeQuery:sql];
        while ([rs next]) {
            YTKKeyValueItem * item = [[YTKKeyValueItem alloc] init];
            item.itemId = [rs stringForColumn:@"id"];
//            item.itemObject = [rs stringForColumn:@"json"];
            item.itemObject = [rs objectForColumnName:@"json"];
//            item.createdTime = [rs dateForColumn:@"createdTime"];
            item.createdTime = [_dateFormatter dateFromString:[rs stringForColumn:@"createdTime"]];
            [result addObject:item];
        }
        [rs close];
    }];
    

    for (YTKKeyValueItem * item in result) {
        
        if ([item.itemObject isKindOfClass:[NSString class]])
        {
            NSError * error = nil;
            id object = [NSJSONSerialization JSONObjectWithData:[item.itemObject dataUsingEncoding:NSUTF8StringEncoding]
                                                        options:(NSJSONReadingAllowFragments) error:&error];
            if (error) {
                debugLog(@"ERROR, faild to parse to json.");
            } else {
                item.itemObject = object;
            }
        }
        else
        {
            if ([UIImage imageWithData:item.itemObject])
            {
                //图片data
                item.itemObject = [UIImage imageWithData:item.itemObject];
            }
            else
            {
                //data数组 (暂时只支持:图片data数组)
                item.itemObject = [self getImagesById:item.itemId fromTable:tableName];
            }
        }
    }
    
    return result;
}

- (NSUInteger)getCountFromTable:(NSString *)tableName
{
    if ([YTKKeyValueStore checkTableName:tableName] == NO) {
        return 0;
    }
    NSString * sql = [NSString stringWithFormat:COUNT_ALL_SQL, tableName];
    __block NSInteger num = 0;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * rs = [db executeQuery:sql];
        if ([rs next]) {
            num = [rs unsignedLongLongIntForColumn:@"num"];
        }
        [rs close];
    }];
    return num;
}

- (void)deleteObjectById:(NSString *)objectId fromTable:(NSString *)tableName
{
    if ([YTKKeyValueStore checkTableName:tableName] == NO) {
        return;
    }
    NSString * sql = [NSString stringWithFormat:DELETE_ITEM_SQL, tableName];
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql, objectId];
    }];
    if (!result) {
        debugLog(@"ERROR, failed to delete item from table: %@", tableName);
    }
}

- (void)deleteObjectsByIdArray:(NSArray *)objectIdArray fromTable:(NSString *)tableName
{
    if ([YTKKeyValueStore checkTableName:tableName] == NO) {
        return;
    }
    NSMutableString *stringBuilder = [NSMutableString string];
    for (id objectId in objectIdArray) {
        NSString *item = [NSString stringWithFormat:@" '%@' ", objectId];
        if (stringBuilder.length == 0) {
            [stringBuilder appendString:item];
        } else {
            [stringBuilder appendString:@","];
            [stringBuilder appendString:item];
        }
    }
    NSString *sql = [NSString stringWithFormat:DELETE_ITEMS_SQL, tableName, stringBuilder];
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql];
    }];
    if (!result) {
        debugLog(@"ERROR, failed to delete items by ids from table: %@", tableName);
    }
}

- (void)deleteObjectsByIdPrefix:(NSString *)objectIdPrefix fromTable:(NSString *)tableName
{
    if ([YTKKeyValueStore checkTableName:tableName] == NO) {
        return;
    }
    NSString *sql = [NSString stringWithFormat:DELETE_ITEMS_WITH_PREFIX_SQL, tableName];
    NSString *prefixArgument = [NSString stringWithFormat:@"%@%%", objectIdPrefix];
    __block BOOL result;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql, prefixArgument];
    }];
    if (!result) {
        debugLog(@"ERROR, failed to delete items by id prefix from table: %@", tableName);
    }
}

- (void)close
{
    [_dbQueue close];
    _dbQueue = nil;
}


///***************************************** liman *****************************************

- (void)putModel:(id)model withId:(NSString *)modelId intoTable:(NSString *)tableName
{
    if (!model) {
        debugLog(@"ERROR 1, table: %@", tableName);
        return;
    }
    
    NSDictionary *dict = [model mj_keyValues];
    
    if (!dict) {
        debugLog(@"ERROR 2, table: %@", tableName);
        return;
    }
    if (![dict isKindOfClass:[NSDictionary class]]) {
        debugLog(@"ERROR 3, table: %@", tableName);
        return;
    }
    
    [self putObject:dict withId:modelId intoTable:tableName];
}

- (id)getModelById:(NSString *)modelId fromTable:(NSString *)tableName modelClass:(Class)ModelClass
{
    id result = [self getObjectById:modelId fromTable:tableName];
    
    if (!result) {
        debugLog(@"ERROR 4, table: %@", tableName);
        return nil;
    }
    if (![result isKindOfClass:[NSDictionary class]]) {
        debugLog(@"ERROR 5, table: %@", tableName);
        return nil;
    }
    
    return [ModelClass mj_objectWithKeyValues:result];
}

- (void)putModels:(NSArray *)models withId:(NSString *)modelsId intoTable:(NSString *)tableName
{
    if (!models) {
        debugLog(@"ERROR 6, table: %@", tableName);
        return;
    }
    
    NSArray *arr = [NSObject mj_keyValuesArrayWithObjectArray:models];
    
    if (!arr) {
        debugLog(@"ERROR 7, table: %@", tableName);
        return;
    }
    if (![arr isKindOfClass:[NSArray class]]) {
        debugLog(@"ERROR 8, table: %@", tableName);
        return;
    }
    
    [self putObject:arr withId:modelsId intoTable:tableName];
}

- (NSArray *)getModelsById:(NSString *)modelsId fromTable:(NSString *)tableName modelClass:(Class)ModelClass
{
    id result = [self getObjectById:modelsId fromTable:tableName];
    
    if (!result) {
        debugLog(@"ERROR 9, table: %@", tableName);
        return nil;
    }
    if (![result isKindOfClass:[NSArray class]]) {
        debugLog(@"ERROR 10, table: %@", tableName);
        return nil;
    }
    
    return [ModelClass mj_objectArrayWithKeyValuesArray:result];
}

///***************************************** liman *****************************************

- (void)putData:(NSData *)data withId:(NSString *)dataId intoTable:(NSString *)tableName
{
    if (data == nil) {
        debugLog(@"error, data is nil");
        return;
    }
    
    if ([YTKKeyValueStore checkTableName:tableName] == NO) {
        return;
    }
    
    //liman
    if (![self isTableExists:tableName]) {
        [self createTableWithName:tableName];
    }
    
//    NSDate * createdTime = [NSDate date];
    NSString * createdTime = [_dateFormatter stringFromDate:[NSDate date]];
    NSString * sql = [NSString stringWithFormat:UPDATE_ITEM_SQL, tableName];
    __block BOOL result;
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql, dataId, data, createdTime];
    }];
    
    if (!result) {
        debugLog(@"ERROR, failed to insert/replace into table: %@", tableName);
    }
}

- (NSData *)getDataById:(NSString *)dataId fromTable:(NSString *)tableName
{
    if ([YTKKeyValueStore checkTableName:tableName] == NO) {
        return nil;
    }
    
    NSString * sql = [NSString stringWithFormat:QUERY_ITEM_SQL, tableName];
    __block NSData * data = nil;
    __block NSDate * createdTime = nil;
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * rs = [db executeQuery:sql, dataId];
        if ([rs next]) {
            data = [rs dataForColumn:@"json"];
//            createdTime = [rs dateForColumn:@"createdTime"];
            createdTime = [_dateFormatter dateFromString:[rs stringForColumn:@"createdTime"]];
        }
        [rs close];
    }];
    
    return data;
}

- (void)putImage:(UIImage *)image withId:(NSString *)imageId intoTable:(NSString *)tableName
{
    if (image == nil) {
        debugLog(@"error, image is nil");
        return;
    }
    
    [self putData:UIImagePNGRepresentation(image) withId:imageId intoTable:tableName];
}

- (UIImage *)getImageById:(NSString *)imageId fromTable:(NSString *)tableName
{
    NSData *data = [self getDataById:imageId fromTable:tableName];
    if (data) {
        return [UIImage imageWithData:data];
    }
    
    return nil;
}

- (void)putDataArr:(NSArray *)dataArr withId:(NSString *)dataArrId intoTable:(NSString *)tableName
{
    if (dataArr == nil) {
        debugLog(@"error, data array is nil");
        return;
    }
    
    [self putData:[NSKeyedArchiver archivedDataWithRootObject:dataArr] withId:dataArrId intoTable:tableName];
}

- (NSArray *)getDataArrById:(NSString *)dataArrId fromTable:(NSString *)tableName
{
    NSData *data = [self getDataById:dataArrId fromTable:tableName];
    if (data) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return nil;
}

- (void)putImages:(NSArray *)images withId:(NSString *)imagesId intoTable:(NSString *)tableName
{
    if (images == nil) {
        debugLog(@"error, images is nil");
        return;
    }
    
    NSMutableArray *dataArr = [NSMutableArray array];
    for (UIImage *image in images) {
        NSData *data = UIImagePNGRepresentation(image);
        
        if (data)
        {
            [dataArr addObject:data];
        }
        else
        {
            [dataArr addObject:[NSNull null]];
        }
    }
    
    [self putDataArr:dataArr withId:imagesId intoTable:tableName];
}

- (NSArray *)getImagesById:(NSString *)imagesId fromTable:(NSString *)tableName
{
    NSArray *dataArr = [self getDataArrById:imagesId fromTable:tableName];
    
    NSMutableArray *images = [NSMutableArray array];
    for (NSData *data in dataArr) {
        UIImage *image = [UIImage imageWithData:data];
        
        if (image)
        {
            [images addObject:image];
        }
        else
        {
            [images addObject:[NSNull null]];
        }
    }
    
    return images;
}

- (void)dropTable:(NSString *)tableName
{
    if ([YTKKeyValueStore checkTableName:tableName] == NO) {
        return;
    }
    
    NSString * sql = [NSString stringWithFormat:DROP_TABLE_SQL, tableName];
    __block BOOL result;
    
    [_dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:sql];
    }];
    
    if (!result) {
        debugLog(@"ERROR, failed to drop table: %@", tableName);
    }
}

- (void)deleteDatabase:(NSString *)dbName
{
    if (!dbName) {
        dbName = DEFAULT_DB_NAME;
    }
    
    NSString *path = [PATH_OF_DOCUMENT stringByAppendingPathComponent:dbName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}

///***************************************** liman *****************************************

/**
 *  返回随机主键Id
 */
- (NSString *)putData:(NSData *)data intoTable:(NSString *)tableName
{
    int random = arc4random();
    NSString *Id = [NSString stringWithFormat:@"%d", abs(random)];
    
    [self putData:data withId:Id intoTable:tableName];
    
    return Id;
}
/**
 *  返回随机主键Id
 */
- (NSString *)putImage:(UIImage *)image intoTable:(NSString *)tableName
{
    int random = arc4random();
    NSString *Id = [NSString stringWithFormat:@"%d", abs(random)];
    
    [self putImage:image withId:Id intoTable:tableName];
    
    return Id;
}
/**
 *  返回随机主键Id
 */
- (NSString *)putDataArr:(NSArray *)dataArr intoTable:(NSString *)tableName
{
    int random = arc4random();
    NSString *Id = [NSString stringWithFormat:@"%d", abs(random)];
    
    [self putDataArr:dataArr withId:Id intoTable:tableName];
    
    return Id;
}
/**
 *  返回随机主键Id
 */
- (NSString *)putImages:(NSArray *)images intoTable:(NSString *)tableName
{
    int random = arc4random();
    NSString *Id = [NSString stringWithFormat:@"%d", abs(random)];
    
    [self putImages:images withId:Id intoTable:tableName];
    
    return Id;
}

@end
