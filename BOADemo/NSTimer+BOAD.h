//
//  NSTimer+BOAD.h
//  BalintimesO2OmobiAd
//
//  Created by yhw on 14-7-8.
//  Copyright (c) 2014年 Balintimes. All rights reserved.
//

#import <Foundation/Foundation.h>

// 处理NSTimer的retain cycle问题
@interface NSTimer (BOAD)

+ (NSTimer *)BOAD_scheduledTimerWithTimeInterval:(NSTimeInterval)ti block:(void(^)())block repeats:(BOOL)yesOrNo;// 使用NSTimer的userInfo传递block

@end
