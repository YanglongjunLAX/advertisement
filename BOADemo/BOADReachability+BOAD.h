//
//  BOADReachability+BOAD.h
//  BalintimesO2OmobiAd
//
//  Created by yhw on 14-3-25.
//  Copyright (c) 2014年 Balintimes. All rights reserved.
//

#import "BOADReachability.h"
#import <UIKit/UIKit.h>

@interface BOADReachability (BOAD)

+ (BOOL)BOAD_isReachability;// 网络是否可访问
+ (BOOL)BOAD_isWiFi;// 网络可访问，检测是否是WiFi
+ (BOOL)BOAD_isWWAN;// 网络可访问，检测是否是WWAN
+ (NSString *)BOAD_networkType;// 网络类型
+ (NSString *)BOAD_statusBarNetworkType;// 状态栏网络类型

@end
