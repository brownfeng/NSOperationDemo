//
//  ViewController.m
//  NSOperationDemo
//
//  Created by pp on 2018/7/5.
//  Copyright © 2018年 webank. All rights reserved.
//

#import "ViewController.h"
#import "PPOperation.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController
/**
 1. start---<NSThread: 0x600000471100>{number = 3, name = (null)}
 2. 0---<NSThread: 0x600000471100>{number = 3, name = (null)}
 3. 1---<NSThread: 0x600000471100>{number = 3, name = (null)}
 4. end--- <NSThread: 0x600000471100>{number = 3, name = (null)}
 */
- (void)operationStartDemo1 {
    [NSThread detachNewThreadWithBlock:^{
        NSLog(@"start---%@", [NSThread currentThread]);
        // 1.创建 NSInvocationOperation 对象
        NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];
        // 2.调用 start 方法开始执行操作
        [op start];
        NSLog(@"end--- %@", [NSThread currentThread]);
    }];

}

- (void)task1 {
    for (int i = 0; i < 2; i++) {
        [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
        NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
    }
}
/**
 1. start---<NSThread: 0x604000071440>{number = 1, name = main}
 2. 1---<NSThread: 0x604000071440>{number = 1, name = main}
 3. 2---<NSThread: 0x604000071440>{number = 1, name = main}
 4. end--- <NSThread: 0x604000071440>{number = 1, name = main}
 */
- (void)operationStartDemo2 {
    NSLog(@"start---%@", [NSThread currentThread]);

    // 1.创建 NSInvocationOperation 对象
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task2) object:nil];

    // 2.调用 start 方法开始执行操作
    [op start];
    NSLog(@"end--- %@", [NSThread currentThread]);
}

- (void)task2 {
    for (int i = 0; i < 2; i++) {
        [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
        NSLog(@"%d---%@", i,[NSThread currentThread]); // 打印当前线程
    }
}


/**
 1. start---<NSThread: 0x600000070d00>{number = 1, name = main}
 2. 0---<NSThread: 0x600000070d00>{number = 1, name = main}
 3. 1---<NSThread: 0x600000070d00>{number = 1, name = main}
 4. end--- <NSThread: 0x600000070d00>{number = 1, name = main}
 */
- (void)operationStartDemo3 {
    NSLog(@"start---%@", [NSThread currentThread]);
    // 1.创建blockOperation
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"%d---%@", i,[NSThread currentThread]); // 打印当前线程
        }
    }];
    // 2.调用 start 方法开始执行操作
    [op start];
    NSLog(@"end--- %@", [NSThread currentThread]);
}

/**
 1. start---<NSThread: 0x60400006c480>{number = 1, name = main}
 2. 4---<NSThread: 0x60400027b500>{number = 4, name = (null)}
 3. 2---<NSThread: 0x60400006c480>{number = 1, name = main}
 4. 1---<NSThread: 0x60400027b5c0>{number = 5, name = (null)}
 5. 3---<NSThread: 0x60000026d280>{number = 3, name = (null)}
 6. 1---<NSThread: 0x60400027b5c0>{number = 5, name = (null)}
 7. 2---<NSThread: 0x60400006c480>{number = 1, name = main}
 8. 4---<NSThread: 0x60400027b500>{number = 4, name = (null)}
 9. 3---<NSThread: 0x60000026d280>{number = 3, name = (null)}
 10 end--- <NSThread: 0x60400006c480>{number = 1, name = main}
 */
- (void)blockOperationAddOperationDemo {
    NSLog(@"start---%@", [NSThread currentThread]);
    // 1.创建blockOperation
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]); // 打印当前线程
        }
    }];

    // 2.添加额外的操作
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"2---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"3---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];
    [op addExecutionBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"4---%@", [NSThread currentThread]); // 打印当前线程
        }
    }];

    // 2.调用 start 方法开始执行操作
    [op start];
    NSLog(@"end--- %@", [NSThread currentThread]);
}

-(void)customOperation {
    PPOperation *op = [PPOperation new];
    [op start];
}


/**
 1. start---<NSThread: 0x604000065d00>{number = 1, name = main}
 2. end---<NSThread: 0x604000065d00>{number = 1, name = main}
 3. 1---<NSThread: 0x600000072c40>{number = 3, name = (null)}
 4. 1---<NSThread: 0x600000072c40>{number = 3, name = (null)}
 5. operation end --- <NSThread: 0x6040002750c0>{number = 4, name = (null)}
 */
-(void)NSOperationCompletion1{
    NSLog(@"start---%@", [NSThread currentThread]);
    NSOperationQueue *oq = [NSOperationQueue new];
    [oq setMaxConcurrentOperationCount:1];
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]); // 打印当前线程
        }
    }];
    [op setCompletionBlock:^{
        NSLog(@"operation end --- %@",[NSThread currentThread]); // 打印当前线程
    }];

    [oq addOperation:op];
    NSLog(@"end---%@", [NSThread currentThread]);
}

/**
 1. start---<NSThread: 0x604000071e40>{number = 1, name = main}
 2. 1---<NSThread: 0x604000071e40>{number = 1, name = main}
 3. 1---<NSThread: 0x604000071e40>{number = 1, name = main}
 4. end---<NSThread: 0x604000071e40>{number = 1, name = main}
 5. operation end --- <NSThread: 0x60000046c480>{number = 3, name = (null)}
 */
-(void)NSOperationCompletion2{
    NSLog(@"start---%@", [NSThread currentThread]);
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]); // 打印当前线程
        }
    }];
    [op setCompletionBlock:^{
        NSLog(@"operation end --- %@",[NSThread currentThread]); // 打印当前线程
    }];
    [op start];
    NSLog(@"end---%@", [NSThread currentThread]);
}


/**
 1. start---<NSThread: 0x600000262840>{number = 1, name = main}
 2. end---<NSThread: 0x600000262840>{number = 1, name = main}
 3. 1---<NSThread: 0x600000661ec0>{number = 3, name = (null)}
 4. 4---<NSThread: 0x604000267800>{number = 5, name = (null)}
 5. 3---<NSThread: 0x6000006620c0>{number = 4, name = (null)}
 6. 2---<NSThread: 0x604000267b80>{number = 6, name = (null)}
 7. 4---<NSThread: 0x604000267800>{number = 5, name = (null)}
 8. 1---<NSThread: 0x600000661ec0>{number = 3, name = (null)}
 9. 3---<NSThread: 0x6000006620c0>{number = 4, name = (null)}
 10 2---<NSThread: 0x604000267b80>{number = 6, name = (null)}
 */
-(void)operationQueueDemo1{
    NSOperationQueue *oq = [[NSOperationQueue alloc]init];
    NSLog(@"start---%@", [NSThread currentThread]);
    [oq setMaxConcurrentOperationCount:1];
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]); // 打印当前线程
        }
    }];
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task1) object:nil];
    PPOperation *op3 = [PPOperation new];
    [oq addOperation:op1];
    [oq addOperation:op2];
    [oq addOperation:op3];
    [oq addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"4---%@",[NSThread currentThread]); // 打印当前线程
        }
    }];
    NSLog(@"end---%@", [NSThread currentThread]);
}

/**
 1. start---<NSThread: 0x600000074c00>{number = 1, name = main}
 2. end---<NSThread: 0x600000074c00>{number = 1, name = main}
 3. 4---<NSThread: 0x600000464880>{number = 3, name = (null)}
 4. 4---<NSThread: 0x600000464880>{number = 3, name = (null)}

 */
-(void)operationQueueDemo2{
    NSOperationQueue *oq = [[NSOperationQueue alloc]init];
    NSLog(@"start---%@", [NSThread currentThread]);
    [oq addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"4---%@",[NSThread currentThread]); // 打印当前线程
        }
    }];
    NSLog(@"end---%@", [NSThread currentThread]);
}

/**
 1. start---<NSThread: 0x600000071a00>{number = 1, name = main}
 2. end---<NSThread: 0x600000071a00>{number = 1, name = main}
 3. 1---<NSThread: 0x60000046d6c0>{number = 3, name = (null)}
 4. 1---<NSThread: 0x60000046d6c0>{number = 3, name = (null)}
 5. 2---<NSThread: 0x60000027ea40>{number = 4, name = (null)}
 6. 2---<NSThread: 0x60000027ea40>{number = 4, name = (null)}
 */
-(void)operationQueueDemo3{
    NSOperationQueue *oq = [[NSOperationQueue alloc]init];
    NSLog(@"start---%@", [NSThread currentThread]);

    // 设置Queue是串行队列
    [oq setMaxConcurrentOperationCount:1];
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]); // 打印当前线程
        }
    }];
    [oq addOperation:op1];
    [oq addOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]); // 打印当前线程
        }
    }];
    NSLog(@"end---%@", [NSThread currentThread]);
}

-(void)operationDependency1{
    NSOperationQueue *oq = [[NSOperationQueue alloc]init];
    NSLog(@"start---%@", [NSThread currentThread]);

    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]); // 打印当前线程
        }
    }];

    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]); // 打印当前线程
        }
    }];

    [op2 addDependency:op1];
    NSLog(@"end 1---%@", [NSThread currentThread]);
    [op1 start];
    NSLog(@"end 2---%@", [NSThread currentThread]);
    [op2 start];
    NSLog(@"end 3---%@", [NSThread currentThread]);
}

/**
 2018-07-05 17:25:54.129570+0800 NSOperationDemo[22605:1156299] start---<NSThread: 0x60400007dc80>{number = 1, name = main}
 2018-07-05 17:25:54.130242+0800 NSOperationDemo[22605:1156299] end---<NSThread: 0x60400007dc80>{number = 1, name = main}
 2018-07-05 17:26:06.135597+0800 NSOperationDemo[22605:1156399] 1---<NSThread: 0x60400027c180>{number = 3, name = (null)}
 2018-07-05 17:26:08.137346+0800 NSOperationDemo[22605:1156399] 1---<NSThread: 0x60400027c180>{number = 3, name = (null)}
 2018-07-05 17:26:10.137834+0800 NSOperationDemo[22605:1156749] 2---<NSThread: 0x600000463e40>{number = 4, name = (null)}
 2018-07-05 17:26:12.138668+0800 NSOperationDemo[22605:1156749] 2---<NSThread: 0x600000463e40>{number = 4, name = (null)}
 */
-(void)operationDependency2{
    NSOperationQueue *oq = [[NSOperationQueue alloc]init];
    [oq setMaxConcurrentOperationCount:1];
    NSLog(@"start---%@", [NSThread currentThread]);

    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]); // 打印当前线程
        }
    }];

    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]); // 打印当前线程
        }
    }];

    [op2 addDependency:op1];
    NSLog(@"!!!!: %@", op2.dependencies);
    [oq addOperation:op2];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [oq addOperation:op1];
    });
    NSLog(@"end---%@", [NSThread currentThread]);
}


/**
 2018-07-05 17:54:27.764623+0800 NSOperationDemo[23666:1216301] start---<NSThread: 0x600000079400>{number = 1, name = main}
 2018-07-05 17:54:27.765324+0800 NSOperationDemo[23666:1216301] end---<NSThread: 0x600000079400>{number = 1, name = main}
 2018-07-05 17:54:29.770351+0800 NSOperationDemo[23666:1216417] 1---<NSThread: 0x60000046a780>{number = 3, name = (null)}
 2018-07-05 17:54:29.770354+0800 NSOperationDemo[23666:1216421] 2---<NSThread: 0x60000046a900>{number = 4, name = (null)}
 2018-07-05 17:54:31.771559+0800 NSOperationDemo[23666:1216421] 2---<NSThread: 0x60000046a900>{number = 4, name = (null)}
 2018-07-05 17:54:31.771560+0800 NSOperationDemo[23666:1216417] 1---<NSThread: 0x60000046a780>{number = 3, name = (null)}
 */
-(void)operationPriority1{
    NSOperationQueue *oq = [[NSOperationQueue alloc]init];
    [oq setMaxConcurrentOperationCount:3];
    NSLog(@"start---%@", [NSThread currentThread]);

    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"1---%@",[NSThread currentThread]); // 打印当前线程
        }
    }];

    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        for (int i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
            NSLog(@"2---%@",[NSThread currentThread]); // 打印当前线程
        }
    }];

    [op1 setQueuePriority:NSOperationQueuePriorityVeryHigh];
    [op2 setQueuePriority:NSOperationQueuePriorityVeryLow];
    [oq addOperation:op2];
    [oq addOperation:op1];

    NSLog(@"end---%@", [NSThread currentThread]);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [oq addOperation:op1];
        [oq addOperationWithBlock:^{
            for (int i = 0; i < 2; i++) {
                [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
                NSLog(@"3---%@",[NSThread currentThread]); // 打印当前线程
            }
        }];
    });
}

-(void)downloadImage{
    //1. 创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    __block UIImage *image1 = NULL;
    //2. 创建第1个下载Operation
    NSBlockOperation *download1 = [NSBlockOperation blockOperationWithBlock:^{
        NSURL *url = [NSURL URLWithString:@"http://img.pconline.com.cn/images/photoblog/9/9/8/1/9981681/200910/11/1255259355826.jpg"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        image1 = [UIImage imageWithData:data];
    }];
    __block UIImage *image2 = NULL;
    //3. 创建第2个下载Operation
    NSBlockOperation *download2 = [NSBlockOperation blockOperationWithBlock:^{
        NSURL *url = [NSURL URLWithString:@"http://pic38.nipic.com/20140228/5571398_215900721128_2.jpg"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        image2 = [UIImage imageWithData:data];
    }];

    // 4. 创建下载完成以后的绘图操作
    NSBlockOperation *combine = [NSBlockOperation blockOperationWithBlock:^{
        UIGraphicsBeginImageContext(CGSizeMake(100, 100));
        [image1 drawInRect:CGRectMake(0, 0, 50, 100)];
        image1 = nil;
        [image2 drawInRect:CGRectMake(50, 0, 50, 100)];
        image2 = nil;

        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.imageView.image = image;
        }];
    }];

    // 5. 设置绘图操作依赖两个下载操作
    [combine addDependency:download1];
    [combine addDependency:download2];
    // 6. 开始执行任务
    [queue addOperation:download1];
    [queue addOperation:download2];
    [queue addOperation:combine];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self downloadImage];
}

@end
