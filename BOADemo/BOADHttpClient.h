//
//  BOADHttpClient.h
//  BOADemo
//
//  Created by liang chunyan on 14-11-12.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
///类型
typedef NS_ENUM(NSUInteger, ADType) {
    ADTypeBanner = 0,
    ADTypeFullScreen,
    ADTypechaping,
    ADTypeKaiPing,
};

typedef void(^ADResultAction)(NSDictionary *info);
typedef void(^RequestError)();
typedef void(^GetServerSuccess)();

@interface BOADHttpClient : AFHTTPRequestOperationManager

@property (nonatomic, copy) ADResultAction   action;

@property (nonatomic, copy) RequestError     errorAction;

@property (nonatomic, copy) GetServerSuccess serverSuccess;

- (void)getSerVerInfo;
/*!
 *  全局唯一变量
 *
 *  @return
 */
+ (BOADHttpClient *)sharedInstance;

- (NSDictionary *)getUrlByType:(ADType)type;

+ (void)setApiKey:(NSString *)newKey;

@end
