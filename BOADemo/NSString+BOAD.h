//
//  NSString+BOAD.h
//  BalintimesO2OmobiAd
//
//  Created by yhw on 14-4-11.
//  Copyright (c) 2014年 Balintimes. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BOAD)

- (NSString *)BOAD_urlDecode;

- (NSString *)BOAD_urlEncode;

- (NSString *)BOAD_md5;

- (NSString*)BOAD_sha1;

- (NSString *)BOAD_base64;

@end
