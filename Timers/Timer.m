//
//  Timer.m
//  Timers
//
//  Created by Zaur Giyasov on 19/06/2018.
//  Copyright © 2018 Zaur Giyasov. All rights reserved.
//

#import "Timer.h"
#import <UIKit/UIKit.h>

@interface Timer()

@property (nonatomic, strong) dispatch_source_t timerSource;
@property (getter = isObservingMessages) BOOL observingMessages;
@property (nonatomic) NSTimer *myTimer;

@end

@implementation Timer

-(void)run
{
    // Повторяемый таймер который будет вызываться каждую минуту в бэкграунде
    NSLog(@"\nПовторяемый таймер который будет вызываться каждую секунду в бэкграунде\n");
    NSLog(@"##Creating a timer with Grand Central Dispatch");
    
    [self startMessaging];
    int sec = 10;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(sec * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"stop after %d seconds", sec);
        [self cancelTimer];
    });
    
    
    [self stopAfterDelaySeconds:6];
    [self startTimer];
    
    sec = 15;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(sec * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"stop after %d seconds", sec);
        [self stopTimer];
        
    });
    
    sec = 5;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(sec * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"stop after %d seconds", sec);
        [self allTimersSTOP];
    });
    
//    [self allTimersSTOP];
}

-(void)stopAfterDelaySeconds:(int)delaySeconds {
    NSLog(@"planing stop after %d seconds", delaySeconds);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delaySeconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self cancelTimer];
    });
}

- (void)startMessaging
{
    self.observingMessages = YES;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    if (self.timerSource) {
        dispatch_source_set_timer(self.timerSource, dispatch_walltime(NULL, 0), 1ull * NSEC_PER_SEC, 1ull * NSEC_PER_SEC);
        dispatch_source_set_event_handler(self.timerSource, ^{
            if (self.isObservingMessages) {
                [self observeNewMsgs];
            }
        });
        dispatch_resume(self.timerSource);
    }
}


- (void)observeNewMsgs
{
    NSLog(@"JUST TO TEST");
    // Staff code...
}

- (void)cancelTimer
{
    if (self.timerSource) {
        dispatch_source_cancel(self.timerSource);
        self.timerSource = nil;
    }
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

dispatch_source_t CreateTimer(uint64_t interval, uint64_t leeway, dispatch_queue_t queue, dispatch_block_t block)
{
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    if (timer) {
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, interval * NSEC_PER_SEC, leeway * NSEC_PER_SEC);
        dispatch_source_set_event_handler(timer, block);
        dispatch_resume(timer);
    }
    
    return timer;
}

-(void)timerWithDelay {
    
    // Delay 2 seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSLog(@"2 TIME_NOW: %f", CACurrentMediaTime());
        
    });
    NSLog(@"1 TIME_NOW: %f", CACurrentMediaTime());
}

-(void)startTimer{
    [self.myTimer invalidate]; // kill old timer
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(observeNewMsgsTwo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.myTimer forMode:NSDefaultRunLoopMode];
}

-(void)stopTimer{
    [self.myTimer invalidate];
    self.myTimer = nil; //set pointer to nil
}

- (void)observeNewMsgsTwo
{
    NSLog(@"JUST TO TEST 2");
    // Staff code...
}

-(void)allTimersSTOP {
    
    while (self.myTimer) {
        [self stopTimer];
    }
    
    while (self.timerSource) {
        [self cancelTimer];
    }
    
    NSLog(@"All timers stop and kill");
    NSLog(@"But dispatch threads is live (without timers)");
}

/*
 
 void dispatch_after_delay(float delayInSeconds, dispatch_queue_t queue, dispatch_block_t block) {
 dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
 dispatch_after(popTime, queue, block);
 }
 
 void dispatch_after_delay_on_main_queue(float delayInSeconds, dispatch_block_t block) {
 dispatch_queue_t queue = dispatch_get_main_queue();
 dispatch_after_delay(delayInSeconds, queue, block);
 }
 
 void dispatch_async_on_high_priority_queue(dispatch_block_t block) {
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), block);
 }
 
 void dispatch_async_on_background_queue(dispatch_block_t block) {
 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block);
 }
 
 void dispatch_async_on_main_queue(dispatch_block_t block) {
 dispatch_async(dispatch_get_main_queue(), block);
 }
 
 */


@end


