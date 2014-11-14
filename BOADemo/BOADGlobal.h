//
//  BOADGlobal.h
//  BalintimesO2OmobiAd
//
//  Created by yhw on 14-8-6.
//  Copyright (c) 2014年 Balintimes. All rights reserved.
//

#import <Foundation/Foundation.h>

//!!!打包时候记得修改广告来源!!!
//static NSString * const BOADAdSource = @"AdsBaiDu";// 百度
//static NSString * const BOADAdSource = @"AdsMOGO";// 芒果
static NSString * const BOADAdSource = @"AdsO2OMOBI";// 欧拓

// 来源
static NSString * const BOADAdsO2OMOBI = @"AdsO2OMOBI";// 欧拓

// ========================================================================
static NSString * const BOADServerUrlAddr = @"http://58.67.196.85/api/advert.list";// 服务器地址
static NSString * const BOADServerListAddr = @"http://58.67.196.85/api/server.list";// 服务列表地址
static NSString * const BOADServerListKey = @"BOADServerListKey";// 服务器列表
// ========================================================================

// 广告后台
//static NSString * const BOADServerUrlAddr = @"http://ad.o2omobi.com/";// 正式服务器地址
//static NSString * const BOADServerUrlAddr = @"http://58.67.196.85/";// 测试服务器地址


// 兼容
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0)
#define BOADTextAlignmentCenter NSTextAlignmentCenter
#else
#define BOADTextAlignmentCenter UITextAlignmentCenter
#endif

@interface BOADGlobal : NSObject

@end
