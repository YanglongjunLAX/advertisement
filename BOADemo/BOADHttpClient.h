//
//  BOADHttpClient.h
//  BOADemo
//
//  Created by liang chunyan on 14-11-12.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/*!
 *  广告类型
 */
typedef NS_ENUM(NSUInteger, ADType){
    /*!
     *  banaer
     */
    ADTypeBanner = 0,
    /*!
     *  全屏
     */
    ADTypeFullScreen,
    /*!
     *  插屏
     */
    ADTypechaping,
    /*!
     *  开屏
     */
    ADTypeKaiPing,
};

typedef void(^ADResultAction)(NSDictionary *info);
typedef void(^RequestError)();
typedef void(^GetServerSuccess)();

@interface BOADHttpClient : NSObject
/*!
 *  根据广告类型请求广告成功
 */
@property (nonatomic, copy) ADResultAction   action;
/*!
 *  请求广告出错
 */
@property (nonatomic, copy) RequestError     errorAction;
/*!
 *  请求服务器列表成功
 */
@property (nonatomic, copy) GetServerSuccess serverSuccess;
/*!
 *  请求服务器列表
 */
- (void)getSerVerInfo;
/*!
 *  全局唯一变量
 *
 *  @return
 */
+ (BOADHttpClient *)sharedInstance;
/*!
 *  根据广告类型获取广告信息
 *
 *  @param type 广告类型
 *
 *  @return 广告信息
 */
- (NSDictionary *)getUrlByType:(ADType)type;
/*!
 *  设置apikey
 *  setting 输入新key 调用
 *  @param newKey newkey
 */
+ (void)setApiKey:(NSString *)newKey;

@end
