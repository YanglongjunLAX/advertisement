//
//  FullScreenController.h
//  BOADemo
//
//  Created by liang chunyan on 14-11-14.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^tapAction)(id sender);

@interface FullScreenController : UIViewController

@property (nonatomic, copy) tapAction action;

//0 开屏，  1全屏
@property (nonatomic, assign) NSUInteger type;

//构造函数
- (id)initWithAddress:(NSString*)urlString;
- (id)initWithURL:(NSURL*)URL;

@end
