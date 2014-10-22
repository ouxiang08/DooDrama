//
//  NSDataController.h
//  CoreDataDemo
//
//  Created by apple on 14-9-29.
//  Copyright (c) 2014年 jingjing.jia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define kPhotoEntityName @"Photo"
#define kCatelogEntityName @"Caltelog"


@interface CoreDataManager : NSObject

@property (retain, nonatomic) NSString *entityName;
@property (retain, nonatomic) NSPredicate *predicate;
@property (retain, nonatomic) NSManagedObject *managedObject;
@property (retain, nonatomic) NSArray *sortDescs;

- (BOOL)insert;

- (BOOL)deletes;

- (BOOL)remove;

- (NSArray *)query;

- (NSArray *)queryWithLimit:(NSUInteger)limit;

- (NSArray *)queryWithLimit:(NSUInteger)limit andOffset:(NSUInteger)offset;

- (BOOL)update;

- (NSManagedObjectContext *)managedObjectContext;

@end
