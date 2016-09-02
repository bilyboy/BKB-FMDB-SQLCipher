//
//  BKBFMDatabaseQueue.m
//  FMDB-SQLCipher
//
//  Created by Bolu on 16/8/10.
//  Copyright © 2016年 Bolu. All rights reserved.
//

#import "BKBFMDatabaseQueue.h"

@implementation BKBFMDatabaseQueue

- (BOOL)setKey:(NSString*)key
{
    return [_db setKey:key];
}

@end
