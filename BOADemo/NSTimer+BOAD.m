//
//  NSTimer+BOAD.m
//  BalintimesO2OmobiAd
//
//  Created by yhw on 14-7-8.
//  Copyright (c) 2014年 Balintimes. All rights reserved.
//

#import "NSTimer+BOAD.h"

@implementation NSTimer (BOAD)

+ (NSTimer *)BOAD_scheduledTimerWithTimeInterval:(NSTimeInterval)ti block:(void(^)())block repeats:(BOOL)yesOrNo {
    return [self scheduledTimerWithTimeInterval:ti target:self selector:@selector(BOAD_block:) userInfo:[block copy] repeats:yesOrNo];
}

+ (void)BOAD_block:(NSTimer *)timer {
    void (^block)() = timer.userInfo;
    if (block) {
        block();
    }
}

@end
