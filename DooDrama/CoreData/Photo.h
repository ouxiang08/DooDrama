//
//  Photo.h
//  DooDrama
//
//  Created by apple on 14/10/21.
//  Copyright (c) 2014年 jingjing.jia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * pname;
@property (nonatomic, retain) NSString * purl;
@property (nonatomic, retain) NSString * ppath;
@property (nonatomic, retain) NSString * pdoc;
@property (nonatomic, retain) NSNumber * pid;
@property (nonatomic, retain) NSNumber * pnum;
@property (nonatomic, retain) NSString * pdesc;
@property (nonatomic, retain) NSNumber * pisupload;

@end
