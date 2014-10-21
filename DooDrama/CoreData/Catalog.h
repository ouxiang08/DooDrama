//
//  Catalog.h
//  DooDrama
//
//  Created by apple on 14/10/21.
//  Copyright (c) 2014年 jingjing.jia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Catalog : NSManagedObject

@property (nonatomic, retain) NSNumber * cid;
@property (nonatomic, retain) NSString * cname;
@property (nonatomic, retain) NSString * cpath;
@property (nonatomic, retain) NSNumber * pid;
@property (nonatomic, retain) NSString * cdesc;

@end
