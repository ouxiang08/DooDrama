//
//  FlieTools.h
//  DooDrama
//
//  Created by apple on 14/10/21.
//  Copyright (c) 2014年 jingjing.jia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileTools : NSObject


+ (NSString *)getDocPath;

+ (BOOL)isExist:(NSString *)path;

@end
