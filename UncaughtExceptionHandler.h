//
//  UncaughtExceptionHandler.h
//  UncaughtExceptionDemo
//
//  Created by  tomxiang on 15/8/28.
//  Copyright (c) 2015年  tomxiang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PATH [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@interface UncaughtExceptionHandler:NSObject

@end


void InstallUncaughtExceptionHandler(void);


