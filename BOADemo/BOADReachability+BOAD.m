//
//  BOADReachability+BOAD.m
//  BalintimesO2OmobiAd
//
//  Created by yhw on 14-3-25.
//  Copyright (c) 2014年 Balintimes. All rights reserved.
//

#import "BOADReachability+BOAD.h"

@implementation BOADReachability (BOAD)

+ (BOOL)BOAD_isReachability {
    return ([[BOADReachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}

+ (BOOL)BOAD_isWiFi {
    return [[self class] BOAD_isReachability] && ([[BOADReachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}

+ (BOOL)BOAD_isWWAN {
    return [[BOADReachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWWAN;
}

+ (NSString *)BOAD_networkType {
    if ([self BOAD_isWiFi]) {
        return @"WiFi";
    } else if (![self BOAD_isWiFi]) {
        return @"WWAN";
    } else {
        return @"UNKNOWN";
    }
}

+ (NSString *)BOAD_statusBarNetworkType {
	NSArray *subviews = [[[[UIApplication sharedApplication] valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
	NSNumber *dataNetworkItemView = nil;

	for (id subview in subviews) {
		if ([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
			dataNetworkItemView = subview;
			break;
		}
	}

	switch ([[dataNetworkItemView valueForKey:@"dataNetworkType"] integerValue]) {
		case 0:
            //			NSLog(@"No wifi or cellular");
			break;

		case 1:
            //			NSLog(@"2G");
			return @"2G";
			break;

		case 2:
            //			NSLog(@"3G");
			return @"3G";
			break;

		case 3:
            //			NSLog(@"4G");
            return @"4G";
			break;

		case 4:
            //			NSLog(@"LTE");
			return @"LTE";
			break;
            
		case 5:
            //			NSLog(@"Wifi");
			return @"WiFi";
			break;
            
		default:
			break;
	}
	return [self BOAD_networkType];
}

@end
