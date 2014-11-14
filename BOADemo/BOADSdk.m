//
//  BOADSdk.m
//  BOADemo
//
//  Created by liang chunyan on 14-11-12.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "BOADSdk.h"
#import "UIDevice+BOAD.h"
#import "BOADOpenUDID.h"
#import "BOADReachability+BOAD.h"
#import "BOADPlatform.h"
#import <objc/message.h>
#import "BOADGlobal.h"
#import "NSString+BOAD.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@implementation BOADSdk

- (id)init {
    if (self = [super init]) {
        _api_key = [BOADPlatform sharedInstance].appId;
        _date_creation = [NSString stringWithFormat:@"%@", @((long long)([[NSDate date] timeIntervalSince1970] * 1000))];
        _advert_source = BOADAdSource;
        _imei = @"863985021738818";
        _ifa = @"";
        _ifa = @"2e3r4t5y5";
//        Class clazz = NSClassFromString(@"ASIdentifierManager");
//        if (clazz) {// more safety way
//            _ifa = objc_msgSend(objc_msgSend(objc_msgSend(clazz, NSSelectorFromString(@"sharedManager")), NSSelectorFromString(@"advertisingIdentifier")), NSSelectorFromString(@"UUIDString")) ?: @"";// maybe a litter dangerous
//        }
        _mac_address = [[UIDevice currentDevice] BOAD_macAddress] ?: @"";
        _ip_address = [[UIDevice currentDevice] BOAD_ipAddress] ?: @"";
        _platform = @"ios";
        _sdk_version = [BOADPlatform sharedInstance].sdkVersion ?: @"3.0.0";
        _device_brand = @"apple";
        _os_version = [[UIDevice currentDevice] systemVersion] ?: @"";
//        _latitude = [BOADPlatform sharedInstance].latitude;
//        _longitude = [BOADPlatform sharedInstance].longitude;
        _latitude   = 0.0;
        _longitude  = 0.0;
        _imsi = @"46001";
        _openudid = [BOADOpenUDID value] ?: @"";
        _net = [BOADReachability BOAD_statusBarNetworkType] ?: @"";
        _device_width = [UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].scale;
        _device_height = [UIScreen mainScreen].bounds.size.height * [UIScreen mainScreen].scale;
        _language = [NSLocale preferredLanguages].count > 0 ? [NSLocale preferredLanguages][0] : @"";
        _country_code = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode] ?: @"";
        _timezone = [[NSTimeZone localTimeZone] name] ?: @"";
        _model = [[UIDevice currentDevice] BOAD_model] ?: @"";
        CTTelephonyNetworkInfo *netInfo = [[CTTelephonyNetworkInfo alloc]init];
        CTCarrier *carrier = [netInfo subscriberCellularProvider];
        _mcc =  [carrier mobileCountryCode] ? : @"";
        _mnc =  [carrier mobileNetworkCode] ? : @"";
    }
    return self;
}

- (NSString *)baseParametersString {
    NSString *baseParametersString = [NSString stringWithFormat:@"api_key=%@&show_type_value=%d&date_creation=%@&advert_size=%@&ad_source=%@&imei=%@&mac_address=%@&ip_address=%@&platform=%@&sdk_version=%@&device_brand=%@&os_version=%@&latitude=%f&longitude=%f&imsi=%@&openudid=%@&net=%@&device_width=%d&device_height=%d&language=%@&country_code=%@&timezone=%@&model=%@&ifa=%@", [_api_key BOAD_urlEncode],(int)_show_type_value, [_date_creation BOAD_urlEncode], [_advert_size BOAD_urlEncode], [_advert_source BOAD_urlEncode], [_imei BOAD_urlEncode], [_mac_address BOAD_urlEncode], [_ip_address BOAD_urlEncode], [_platform BOAD_urlEncode], [_sdk_version BOAD_urlEncode], [_device_brand BOAD_urlEncode], [_os_version BOAD_urlEncode], _latitude, _longitude, [_imsi BOAD_urlEncode], [_openudid BOAD_urlEncode], [_net BOAD_urlEncode], [[NSNumber numberWithFloat: _device_width] intValue], [[NSNumber numberWithFloat:_device_height] intValue], [_language BOAD_urlEncode], [_country_code BOAD_urlEncode], [_timezone BOAD_urlEncode], [_model BOAD_urlEncode], [_ifa BOAD_urlEncode]];
    return baseParametersString;
}

@end