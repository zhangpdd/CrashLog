//
//  UncaughtExceptionHandler.m
//  UncaughtExceptionDemo
//
//  Created by  tomxiang on 15/8/28.
//  Copyright (c) 2015年  tomxiang. All rights reserved.
//

#import "UncaughtExceptionHandler.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
#import <UIKit/UIKit.h>
#import "ExceptionModel.h"


#if APPTYPE==0
#import "smarthomeV2-Swift.h"
#elif APPTYPE==1
#import "FWFAdd-Swift.h"
#else

#endif

@implementation UncaughtExceptionHandler

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
    
    //上传崩溃日志时，需要当前的用户 网关Ieee
    NetvoxUserInfo *user = [NetvoxUserInfo shareInstance];
    
    NSString *userInfoPath = [_libPath stringByAppendingString:@"/UserInfo.plist"];
    NSDictionary *userInfoDic = @{@"user":user.userName, @"houseIeee":user.currentHouseIeee};
    [userInfoDic writeToFile:userInfoPath atomically:YES];
    
}

@end




void HandleException(NSException *exception)
{
    // 异常的堆栈信息
    NSArray *stackArray = [exception callStackSymbols];
    
    // 出现异常的原因
    NSString *reason = [exception reason];
    
    // 异常名称
    NSString *name = [exception name];
    
    NSString *exceptionInfo = [NSString stringWithFormat:@"Exception reason：%@\nException name：%@\nException stack：%@",name, reason, stackArray];
    
//    NSLog(@"%@", exceptionInfo);

    [UncaughtExceptionHandler saveCreash:exceptionInfo];
    
}


void InstallUncaughtExceptionHandler(void)
{
    NSSetUncaughtExceptionHandler(&HandleException);
}

