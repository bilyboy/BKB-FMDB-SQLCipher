//
//  BKBFMDatabaseQueue.h
//  FMDB-SQLCipher
//
//  Created by Bolu on 16/8/10.
//  Copyright © 2016年 Bolu. All rights reserved.
//

#import <FMDB/FMDB.h>

@interface BKBFMDatabaseQueue : FMDatabaseQueue

/**
 *  设置数据库加密key
 *
 *  @param key 加密key
 *
 *  @return 加密是否成功
 */
- (BOOL)setKey:(NSString*)key;

@end
