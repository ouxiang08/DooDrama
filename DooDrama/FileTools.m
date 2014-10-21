//
//  FlieTools.m
//  DooDrama
//
//  Created by apple on 14/10/21.
//  Copyright (c) 2014年 jingjing.jia. All rights reserved.
//

#import "FileTools.h"

@implementation FileTools

+ (NSString *)getDocPath{

     return [NSHomeDirectory() stringByAppendingPathComponent: @"Documents"];
}

+ (BOOL)isExist:(NSString *)path{

    return  [[NSFileManager defaultManager] fileExistsAtPath:path];
    
}

@end
