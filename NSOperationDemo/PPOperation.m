//
//  PPOperation.m
//  NSOperationDemo
//
//  Created by pp on 2018/7/5.
//  Copyright © 2018年 webank. All rights reserved.
//

#import "PPOperation.h"

@implementation PPOperation

-(void)main{

    // 支持取消的Operation
    if(self.isCancelled == YES){
        return;
    }

    for (int i = 0; i < 2; i++) {
        [NSThread sleepForTimeInterval:2];
        NSLog(@"3---%@",[NSThread currentThread]); // 打印当前线程
    }
}
@end
