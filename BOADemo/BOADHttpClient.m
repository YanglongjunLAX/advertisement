//
//  BOADHttpClient.m
//  BOADemo
//
//  Created by liang chunyan on 14-11-12.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "BOADHttpClient.h"
#import "BOADSdk.h"
#import "NSString+BOAD.h"
#import "SVProgressHUD.h"

#define kForHost       @"http://58.67.196.85"
#define kForPath       @"/api/api.list"

#define kForDefaultKey    @"BOADApiTestKey"

static NSString *api_key = @"224dea2a00d611e48d4c000c2943dacd";

@interface BOADHttpClient()
@property (nonatomic, strong) NSArray *serverInfoList;
@property (nonatomic, strong) NSDictionary *hostInfo;
@end

@implementation BOADHttpClient

+ (BOADHttpClient *)sharedInstance
{
    static BOADHttpClient *_httpClient = nil;
    if (_httpClient == nil)
    {
        _httpClient = [[BOADHttpClient alloc] init];
        if (_httpClient)
        {
            [_httpClient getSerVerInfo];
            
            NSString *string = [[NSUserDefaults standardUserDefaults] stringForKey:kForDefaultKey];
            
//            NSLog(@"%@",string);
            api_key = string;
            
        }
    }
    return _httpClient;
}

- (void)getSerVerInfo
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kForHost, kForPath]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:[NSString stringWithFormat:@"utf-8"] forHTTPHeaderField:@"Accept-Charset"];
    [request setValue:[NSString stringWithFormat:@"0"] forHTTPHeaderField:@"Content-length"];
    [request setHTTPMethod:@"GET"];
    request.timeoutInterval = 10.0;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        //获取服务器列表
        self.serverInfoList = json[@"servers"];
        if (self.serverInfoList)
        {
            if (self.serverSuccess)
            {
                self.serverSuccess();
            }
        }
    }];
}

- (NSDictionary *)getUrlByType:(ADType)type
{
    BOADSdk  *sdk = [[BOADSdk alloc] init];
    CGSize size = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 50);
    switch (type)
    {
        case ADTypeBanner:
            size = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 50);
            sdk.show_type_value = 100;
            break;
        case ADTypechaping:
            sdk.show_type_value = 5;
//            size = [UIScreen mainScreen].bounds.size;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                size = CGSizeMake(300, 250);//??
            } else {
                size = CGSizeMake(600, 500);
            }
            break;
        case ADTypeFullScreen:
            size = [UIScreen mainScreen].bounds.size;
            sdk.show_type_value = 4;
            break;
        case ADTypeKaiPing:
            sdk.show_type_value = 6;
            size = [UIScreen mainScreen].bounds.size;
            break;
        default:
            break;
    }
    //随机选择一个服务器
    int index = arc4random() % self.serverInfoList.count;
    self.hostInfo = self.serverInfoList[index];
    
    NSString *advert_size = [NSString stringWithFormat:@"%lu*%lu", (unsigned long)size.width, (unsigned long)size.height];
    sdk.advert_size = advert_size;
    sdk.api_key = api_key;
    
    NSString *parmMD5    = [[sdk baseParametersString] BOAD_md5];
    NSString *saltString = [NSString stringWithFormat:@"%@%@",parmMD5,self.hostInfo[@"salt"]];
    NSString *rMD5       = [saltString BOAD_md5];
    sdk.sig = rMD5;
    
    NSString *wSigUrl = [NSString stringWithFormat:@"%@&sig=%@",[sdk baseParametersString],rMD5];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@?%@", self.hostInfo[@"host"], self.hostInfo[@"path"],wSigUrl]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setValue:[NSString stringWithFormat:@"utf-8"] forHTTPHeaderField:@"Accept-Charset"];
    [request setValue:[NSString stringWithFormat:@"0"] forHTTPHeaderField:@"Content-length"];
    [request setHTTPMethod:@"GET"];
    request.timeoutInterval = 10.0;
    __block NSDictionary *json = nil;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError *error;
        if (data == nil)
        {
            [SVProgressHUD showErrorWithStatus:@"没有请求到数据"];
        }
        else
        {
            json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            if ([json[@"code"] integerValue] == 0)
            {
                [SVProgressHUD showErrorWithStatus:json[@"msg"]];
                if (self.errorAction)
                {
                    self.errorAction();
                }
            }
            else if ([json[@"code"] integerValue] == 200)
            {
                if (self.action)
                {
                    self.action(json[@"adverts"][0]);
                }
            }
        }
    }];
    return json;
}


+ (void)setApiKey:(NSString *)newKey
{
    api_key = newKey;
}

@end
