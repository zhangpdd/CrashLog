//
//  SignalHandler.m
//  UncaughtExceptionDemo
//
//  Created by  tomxiang on 15/8/29.
//  Copyright (c) 2015年  tomxiang. All rights reserved.
//

#import "SignalHandler.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import <UIKit/UIKit.h>
#import "UncaughtExceptionHandler.h"
#import "ExceptionModel.h"

//#if APPTYPE==0
//#import "smarthomeV2-Swift.h"
//#elif APPTYPE==1
//#import "FWFAdd-Swift.h"
//#else
//
//#endif

@interface SignalHandler()<UIAlertViewDelegate>

@end


@implementation SignalHandler

+(void)saveCreash:(NSString *)exceptionInfo
{
    NSString * _libPath  = [PATH stringByAppendingPathComponent:@"/ErrorCrashLog/"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:_libPath]){
        [[NSFileManager defaultManager] createDirectoryAtPath:_libPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //添加时间 为文件名的一部分
//    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
//    NSTimeInterval a=[dat timeIntervalSince1970];
//    NSString *timeString = [NSString stringWithFormat:@"%.f", a];
//    NSString * savePath = [_libPath stringByAppendingFormat:@"/error%@.txt",timeString];
    
    NSString * savePath = [_libPath stringByAppendingFormat:@"/error.txt"];
    
    BOOL sucess = [exceptionInfo writeToFile:savePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"YES sucess:%d",sucess);
    
//    NetvoxUserInfo *user = [NetvoxUserInfo shareInstance];
    NSString *userInfoPath = [_libPath stringByAppendingString:@"/UserInfo.plist"];
//    NSDictionary *userInfoDic = [[NSDictionary alloc] initWithDictionary:@{@"user":user.userName, @"houseIeee":user.currentHouseIeee}];
//    [userInfoDic writeToFile:userInfoPath atomically:YES];
    
    exit(signal);
}


@end


void SignalExceptionHandler(int signal)
{
    NSMutableString *mstr = [[NSMutableString alloc] init];
    [mstr appendString:@"Stack Error Info:\n"];
    void* callstack[128];
    int i, frames = backtrace(callstack, 128);
    char** strs = backtrace_symbols(callstack, frames);
    for (i = 0; i <frames; ++i) {
        [mstr appendFormat:@"%s\n", strs[i]];
    }
    [SignalHandler saveCreash:mstr];
    
}

void InstallSignalHandler(void)
{
    //  OC、siwft 都可以捕获的信号量
    signal(SIGABRT, SignalExceptionHandler);
    signal(SIGSEGV, SignalExceptionHandler);
    signal(SIGBUS, SignalExceptionHandler);
    signal(SIGILL, SignalExceptionHandler);
    
    //  OC 可以捕获的信号量
    signal(SIGHUP, SignalExceptionHandler);
    signal(SIGINT, SignalExceptionHandler);
    signal(SIGQUIT, SignalExceptionHandler);
    signal(SIGFPE, SignalExceptionHandler);
    signal(SIGPIPE, SignalExceptionHandler);
    
    //  siwft 可以捕获的信号量
    signal(SIGTRAP, SignalExceptionHandler);
}

