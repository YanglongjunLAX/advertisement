//
//  BOADPlatform.m
//  BalintimesO2OmobiAd
//
//  Created by yhw on 14-4-11.
//  Copyright (c) 2014年 Balintimes. All rights reserved.
//

#import "BOADPlatform.h"

@implementation BOADPlatform

+ (instancetype)sharedInstance {
    static id _instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

@end
