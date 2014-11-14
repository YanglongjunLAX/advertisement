//
//  UIApplication+BOAD.m
//  BalintimesO2OmobiAd
//
//  Created by yhw on 14-4-4.
//  Copyright (c) 2014年 Balintimes. All rights reserved.
//

#import "UIApplication+BOAD.h"

@implementation UIApplication (BOAD)

//- (UIWindow *)BOAD_topWindow {
//    UIWindow *keyWindow = [[[UIApplication sharedApplication].windows sortedArrayUsingComparator:^NSComparisonResult(UIWindow *win1, UIWindow *win2) {
//        return win1.windowLevel - win2.windowLevel;
//    }] lastObject];
//    if (!keyWindow) {
//        keyWindow = [UIApplication sharedApplication].keyWindow;
//    }
//    return keyWindow;
//}

- (UIWindow *)BOAD_keyWindow {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    if (!keyWindow) {
        keyWindow = [[[UIApplication sharedApplication].windows sortedArrayUsingComparator:^NSComparisonResult(UIWindow *win1, UIWindow *win2) {
            return win1.windowLevel - win2.windowLevel;
        }] lastObject];
    }
    return keyWindow;
}

- (UIViewController *)BOAD_rootViewController {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (!rootViewController) {
        for (UIWindow *window in [UIApplication sharedApplication].windows) {
            if (window.rootViewController) {
                rootViewController = window.rootViewController;
                break;
            }
        }
    }
    return rootViewController;
}

@end
