//
//  BOADSdk.h
//  BOADemo
//
//  Created by liang chunyan on 14-11-12.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

// 广告
@interface BOADSdk : NSObject

@property (nonatomic, assign) NSInteger show_type_value;// 请求广告类型(100: banner 4:全屏广告 5: 插屏 6: 开屏 7: 闪拍)
@property (nonatomic, copy) NSString *advert_size;// 容器尺寸
@property (nonatomic, copy) NSString *sig;// MD5 校验和
@property (nonatomic, copy) NSString *ifa;
@property (nonatomic, copy) NSString *api_key;// Api key
@property (nonatomic, copy) NSString *date_creation;// 请求的时间戳(unix time)
@property (nonatomic, copy) NSString *advert_source;// 请求来源标识
@property (nonatomic, copy) NSString *imei;
@property (nonatomic, copy) NSString *mac_address;// mac地址
@property (nonatomic, copy) NSString *ip_address;// ip地址
@property (nonatomic, copy) NSString *platform;// 平台
@property (nonatomic, copy) NSString *sdk_version;// sdk版本
@property (nonatomic, copy) NSString *device_brand;// 设备品牌
@property (nonatomic, copy) NSString *os_version;// 操作系统版本
@property (nonatomic, assign) CGFloat latitude;// 纬度
@property (nonatomic, assign) CGFloat longitude;// 经度
@property (nonatomic, copy) NSString *imsi;
@property (nonatomic, copy) NSString *openudid;// open udid
@property (nonatomic, copy) NSString *net;// 上网方式
@property (nonatomic, assign) CGFloat device_width;// 设备屏幕宽度
@property (nonatomic, assign) CGFloat device_height;// 设备屏幕高度
@property (nonatomic, copy) NSString *language;// 语言
@property (nonatomic, copy) NSString *country_code;// 国家代码
@property (nonatomic, copy) NSString *timezone;// 时区
@property (nonatomic, copy) NSString *model;// 设备型号
@property (nonatomic, copy) NSString *mcc;
@property (nonatomic, copy) NSString *mnc;
- (NSString *)baseParametersString;
@end
