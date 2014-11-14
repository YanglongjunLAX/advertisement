//
//  BOADPlatform.h
//  BalintimesO2OmobiAd
//
//  Created by yhw on 14-4-11.
//  Copyright (c) 2014年 Balintimes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

typedef void(^BOADAwardPointsBlock)(NSUInteger points);// 奖励通知

@interface BOADPlatform : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *appScrect;
@property (nonatomic, copy) NSString *sdkVersion;
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, assign) CGFloat latitude;

//!!!不适合全局!!!不推荐使用!!!
@property (nonatomic, copy) BOADAwardPointsBlock awardPointsBlock DEPRECATED_ATTRIBUTE;// 奖励通知

@property (nonatomic, copy) NSDictionary *extraData;// 额外数据

@end
