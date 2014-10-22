//
//  NSDataController.m
//  CoreDataDemo
//
//  Created by apple on 14-9-29.
//  Copyright (c) 2014年 jingjing.jia. All rights reserved.
//

#import "CoreDataManager.h"
#import "AppDelegate.h"


@implementation CoreDataManager

- (NSManagedObjectContext *)managedObjectContext
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return appDelegate.managedObjectContext;
}

- (NSEntityDescription *)entity{

    if (_entityName == nil) {
        return nil;
    }
    return [NSEntityDescription entityForName:_entityName inManagedObjectContext:[self managedObjectContext]];
}


- (BOOL)insert
{
    if (_managedObject == nil) {
        return NO;
    }
    [[self managedObjectContext] insertObject:_managedObject];
    NSError *error = nil;
    [[self managedObjectContext] save:&error];
    if (error) {
        NSLog(@"error:%@, %@",error.localizedDescription,error.userInfo);
        return NO;
    }
    return YES;
}

- (BOOL)deletes{

    if (_managedObject == nil) {
        return NO;
    }
    [[self managedObjectContext] deleteObject:_managedObject];
    NSError *error = nil;
    [[self managedObjectContext] save:&error];
    if (error) {
        NSLog(@"error:%@, %@",error.localizedDescription,error.userInfo);
        return NO;
    }
    return YES;
}

- (BOOL)remove
{
    NSArray *objects = [self query];
    if (objects == nil) {
        return NO;
    }
    
    NSError *error = nil;
    for (NSManagedObject *obj in objects) {
        [[self managedObjectContext] deleteObject:obj];
    }
    
    [[self managedObjectContext] save:&error];
    if (error) {
        NSLog(@"error:%@, %@",error.localizedDescription,error.userInfo);
        return NO;
    }
    return YES;
}

- (BOOL)update{

    NSError *error = nil;
    BOOL result = [self.managedObjectContext save:&error];
    if (error) {
        NSLog(@"save core data error: %@, %@", error.localizedDescription, error.userInfo);
        abort();
    }
    return result;
}

- (NSArray *)query{

    return [self queryWithLimit:0];
}

- (NSArray *)queryWithLimit:(NSUInteger)limit{

    return  [self queryWithLimit:limit andOffset:0];
}

- (NSArray *)queryWithLimit:(NSUInteger)limit andOffset:(NSUInteger)offset
{

    NSEntityDescription *entity = [self entity];
    if (entity == nil) {
        return nil;
    }
    
    NSFetchRequest *fetRequest = [[NSFetchRequest alloc] init];
    [fetRequest setEntity:entity];
    [fetRequest setReturnsDistinctResults:NO];
    
    if (_predicate) {
        [fetRequest setPredicate:_predicate];
    }
    
    if (limit > 0) {
        [fetRequest setFetchLimit:limit];
    }
    
    [fetRequest setFetchOffset:offset];
    
    if (_sortDescs && _sortDescs.count) {
        [fetRequest setSortDescriptors:_sortDescs];
    }
    
    NSError *error = nil;
    NSArray *objects = [[self managedObjectContext] executeFetchRequest:fetRequest error:&error];
    
    if (error) {
        NSLog(@"error:%@, %@",error.localizedDescription,error.userInfo);
        return nil;
    }
    
    return objects;
}

@end
