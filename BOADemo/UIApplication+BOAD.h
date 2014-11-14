//
//  UIApplication+BOAD.h
//  BalintimesO2OmobiAd
//
//  Created by yhw on 14-4-4.
//  Copyright (c) 2014年 Balintimes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (BOAD)

//- (UIWindow *)BOAD_topWindow;
- (UIWindow *)BOAD_keyWindow;
- (UIViewController *)BOAD_rootViewController;

@end
