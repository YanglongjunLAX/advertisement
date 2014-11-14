//
//  UIDevice+BOAD.h
//  BalintimesO2OmobiAd
//
//  Created by yhw on 14-3-25.
//  Copyright (c) 2014年 Balintimes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (BOAD)

- (NSString *)BOAD_model;// device model
- (NSString *)BOAD_macAddress;// mac address
- (NSString *)BOAD_ipAddress;// ip address
- (NSString *)BOAD_uuid;// uuid

@end
