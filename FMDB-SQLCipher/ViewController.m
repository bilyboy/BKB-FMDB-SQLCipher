//
//  ViewController.m
//  FMDB-SQLCipher
//
//  Created by Bolu on 16/8/8.
//  Copyright © 2016年 Bolu. All rights reserved.
//

#import "ViewController.h"
#import "FMDB.h"

@interface ViewController ()

@end

@implementation ViewController

#define DataBasePath [[(NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)) lastObject] stringByAppendingPathComponent:@"db"]
#define DataBaseName  [DataBasePath stringByAppendingPathComponent:@"db.sqlite"]
#define DBKey   @"DBPasswordKey"

NSString *const studentTable = @"studentTable";
NSString *const studentName = @"studentName";
NSString *const studentClass = @"studentClass";
NSString *const studentAddress = @"studentAddress";
NSString *const studentAge = @"studentAge";
NSString * const studentScore = @"studentScore";

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //对于数据库文件不在Documents根目录下的，要先创建数据库文件目录，再创建数据库文件，否则直接创建会在sqlite3_open时报错，不能创建数据库文件
    [self createDirIfNotExist:DataBasePath];
    
    //项目中self.queue可以做成单例
    self.queue = [[BKBFMDatabaseQueue alloc] initWithPath:DataBaseName];
    
    //设置数据库加密key
//    [self.queue setKey:DBKey];

    //创建表
    [self createStudentTable];
    
    //插入数据
//    [self insertStudentData];
    
    //测试FMDB插入数据使用事务与否的耗时
    [self testDBTransaction];
}

//测试FMDB插入数据使用事务与否的耗时
- (void)testDBTransaction
{
    NSDate *date1 = [NSDate date];
    
    //0.453秒
//    for (int i = 0; i < 500; i ++) {
//        [self.queue inDatabase:^(FMDatabase *db) {
//            [self insertItemWithDB:db];
//        }];
//    }
    
    //0.286秒
//    [self.queue inDatabase:^(FMDatabase *db) {
//        for (int i = 0; i < 500; i ++) {
//            [self insertItemWithDB:db];
//        }
//    }];
    
    //0.303秒
//    for (int i = 0 ; i < 500; i ++) {
//        [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
//            [self insertItemWithDB:db];
//        }];
//    }
    
    //0.015秒
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (int i = 0 ; i < 500; i ++) {
            [self insertItemWithDB:db];
        }
    }];

    NSDate *date2 = [NSDate date];
    NSTimeInterval a = [date2 timeIntervalSince1970] - [date1 timeIntervalSince1970];
    NSLog(@"插入500条数据用时%.3f秒",a);
}

//创建数据库文件目录
- (void)createDirIfNotExist:(NSString *)folderPath
{
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir = NO;
    [fm fileExistsAtPath:folderPath isDirectory:(&isDir)];
    if (!isDir)
    {
        [fm createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

#pragma mark - 数据库操作

//创建表
- (BOOL)createStudentTable
{
    __block BOOL resultState = YES;

    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *sqlString = [NSString stringWithFormat:@"CREATE TABLE %@ (%@ TEXT, %@ TEXT DEAFAULT '', %@ INTEGER DEFAULT 0, %@ INTEGER DEFAULT 0,%@ INTEGER DEFAULT 0)",studentTable,studentName,studentClass,studentAddress,studentAge,studentScore];
        resultState = [db executeUpdate:sqlString];
    }];
    
    return resultState;
}

//插入数据
- (BOOL)insertStudentData
{
    __block BOOL resultState = NO;
    
    [self.queue inDatabase:^(FMDatabase *db) {
        [self insertItemWithDB:db];
    }];
    
    return resultState;
}

//插入单条数据
- (BOOL)insertItemWithDB:(FMDatabase *)db
{
    BOOL resultState = NO;
    NSString *sqlStr = [NSString stringWithFormat:@"INSERT INTO %@ VALUES (:%@, :%@, :%@, :%@, :%@)",studentTable,studentName,studentClass,studentAddress,studentAge,studentScore];
    
    NSDictionary *studentDic = [NSDictionary dictionaryWithObjectsAndKeys:@"studentName",studentName,@"studentClass",studentClass,@"studentAddress",studentAddress,@"studentAge",studentAge,@"studentScore",studentScore,  nil];
    resultState = [db executeUpdate:sqlStr withParameterDictionary:studentDic];//这里studentDic是一个student对象的一个字典
    
    return resultState;
}

@end
