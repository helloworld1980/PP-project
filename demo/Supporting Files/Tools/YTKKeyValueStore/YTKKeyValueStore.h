//
//  YTKKeyValueStore.h
//  demo
//
//  Created by liman on 1/5/16.
//  Copyright © 2016 liman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YTKKeyValueItem : NSObject

@property (strong, nonatomic) NSString *itemId;
@property (strong, nonatomic) id itemObject;
@property (strong, nonatomic) NSDate *createdTime;

@end


@interface YTKKeyValueStore : NSObject

//liman
+ (instancetype)sharedInstance;

- (id)initDBWithName:(NSString *)dbName;

- (id)initWithDBWithPath:(NSString *)dbPath;

- (void)createTableWithName:(NSString *)tableName;

- (BOOL)isTableExists:(NSString *)tableName;

- (void)clearTable:(NSString *)tableName;

- (void)close;

///************************ Put&Get methods *****************************************

- (void)putObject:(id)object withId:(NSString *)objectId intoTable:(NSString *)tableName;

- (id)getObjectById:(NSString *)objectId fromTable:(NSString *)tableName;

- (YTKKeyValueItem *)getYTKKeyValueItemById:(NSString *)objectId fromTable:(NSString *)tableName;

- (void)putString:(NSString *)string withId:(NSString *)stringId intoTable:(NSString *)tableName;

- (NSString *)getStringById:(NSString *)stringId fromTable:(NSString *)tableName;

- (void)putNumber:(NSNumber *)number withId:(NSString *)numberId intoTable:(NSString *)tableName;

- (NSNumber *)getNumberById:(NSString *)numberId fromTable:(NSString *)tableName;

- (NSArray *)getAllItemsFromTable:(NSString *)tableName;

- (NSUInteger)getCountFromTable:(NSString *)tableName;

- (void)deleteObjectById:(NSString *)objectId fromTable:(NSString *)tableName;

- (void)deleteObjectsByIdArray:(NSArray *)objectIdArray fromTable:(NSString *)tableName;

- (void)deleteObjectsByIdPrefix:(NSString *)objectIdPrefix fromTable:(NSString *)tableName;


///***************************************** liman *****************************************

- (void)putModel:(id)model withId:(NSString *)modelId intoTable:(NSString *)tableName;

- (id)getModelById:(NSString *)modelId fromTable:(NSString *)tableName modelClass:(Class)ModelClass;

- (void)putModels:(NSArray *)models withId:(NSString *)modelsId intoTable:(NSString *)tableName;

- (NSArray *)getModelsById:(NSString *)modelsId fromTable:(NSString *)tableName modelClass:(Class)ModelClass;

///***************************************** liman *****************************************

- (void)putData:(NSData *)data withId:(NSString *)dataId intoTable:(NSString *)tableName;

- (NSData *)getDataById:(NSString *)dataId fromTable:(NSString *)tableName;

- (void)putImage:(UIImage *)image withId:(NSString *)imageId intoTable:(NSString *)tableName;

- (UIImage *)getImageById:(NSString *)imageId fromTable:(NSString *)tableName;

- (void)putDataArr:(NSArray *)dataArr withId:(NSString *)dataArrId intoTable:(NSString *)tableName;

- (NSArray *)getDataArrById:(NSString *)dataArrId fromTable:(NSString *)tableName;

- (void)putImages:(NSArray *)images withId:(NSString *)imagesId intoTable:(NSString *)tableName;

- (NSArray *)getImagesById:(NSString *)imagesId fromTable:(NSString *)tableName;

- (void)dropTable:(NSString *)tableName;

- (void)deleteDatabase:(NSString *)dbName;

///***************************************** liman *****************************************

/**
 *  返回随机主键Id
 */
- (NSString *)putData:(NSData *)data intoTable:(NSString *)tableName;
/**
 *  返回随机主键Id
 */
- (NSString *)putImage:(UIImage *)image intoTable:(NSString *)tableName;
/**
 *  返回随机主键Id
 */
- (NSString *)putDataArr:(NSArray *)dataArr intoTable:(NSString *)tableName;
/**
 *  返回随机主键Id
 */
- (NSString *)putImages:(NSArray *)images intoTable:(NSString *)tableName;

@end
