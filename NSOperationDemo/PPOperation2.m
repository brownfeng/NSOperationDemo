//
//  PPOperation2.m
//  NSOperationDemo
//
//  Created by pp on 2018/7/6.
//  Copyright © 2018年 webank. All rights reserved.
//

#import "PPOperation2.h"
@interface PPOperation2()
// 声明属性(父类虽然有, 但是最后重新声明)
@property (assign, nonatomic, getter = isExecuting) BOOL executing;
@property (assign, nonatomic, getter = isFinished) BOOL finished;
@end

@implementation PPOperation2

// 手动合成两个实例变量 _executing, _finished, 因为父类设置成ReadOnly
@synthesize executing = _executing;
@synthesize finished = _finished;

- (id)init {
    self = [super init];
    if (self) {
        _executing = NO;
        _finished  = NO;
    }
    return self;
}

- (BOOL)isConcurrent {
    return YES;
}

// finished 和 excuting 的 setter 需要通过KVO对外通知.
- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

/**
 我们这里实现控制逻辑与业务逻辑的分离.
 在start方法执行时, 也就是具体的业务代码`main`执行之前, 我们判断isCancelled方法,如果成功执行, 我们将executing设置成YES(内部包含KVO相关内容)
 */
-(void)start{
    if (self.isCancelled) {
        self.finished = YES;
        return;
    }

    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    self.executing = YES;
}

/**
 具体的业务执行内容, 如果业务逻辑执行
 */
- (void)main {
    NSLog(@"Start executing %@, mainThread: %@, currentThread: %@", NSStringFromSelector(_cmd), [NSThread mainThread], [NSThread currentThread]);

    for (int i = 0; i < 2; i++) {
        // 在一次循环之前检查, 检查是否被取消
        if (self.isCancelled) {
            self.executing = NO;
            self.finished = YES;
            return;
        }

        [NSThread sleepForTimeInterval:2];
        NSLog(@"业务逻辑执行---%@",[NSThread currentThread]); // 打印当前线程
    }

    // 在所有任务完成以后. 设置NSOperation状态
    self.executing = NO;
    self.finished = YES;
    NSLog(@"Finish executing %@", NSStringFromSelector(_cmd));
}
@end
