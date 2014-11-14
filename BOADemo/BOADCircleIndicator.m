//
//  BOADCircleIndicator.m
//  BalintimesO2OmobiAd
//
//  Created by Mianji.Gu on 14-10-16.
//  Copyright (c) 2014年 Balintimes. All rights reserved.
//

#import "BOADCircleIndicator.h"

@interface BOADCircleIndicator ()

@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, readwrite) NSTimer *timer;
@property (nonatomic, readwrite) NSInteger currentNumber;
@property (nonatomic, readwrite) BOOL isCounting;

@end

@implementation BOADCircleIndicator

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _isCounting = NO;
        _currentNumber = 5;
        
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _numberLabel.backgroundColor = [UIColor clearColor];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.textColor = [UIColor whiteColor];
        [self addSubview:_numberLabel];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetGrayFillColor(context, 0.4, 0.5);//设置填充颜色
    CGContextSetLineWidth(context, 1.0);//线的宽度
    //填充圆，无边框
    CGContextAddArc(context, CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds), CGRectGetMidX(self.bounds), 0, 2*M_PI, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathFill);//绘制填充
}

- (void)startCounting{
    if (self.isCounting) {
        return;
    }
    
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)self.currentNumber--];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeNumber) userInfo:nil repeats:YES];
}

- (void)changeNumber {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)self.currentNumber--];
    });
    
    if (self.currentNumber == 0) {
        [self stopCounting];
        [self removeFromSuperview];
    }
}

- (void)stopCounting{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)countingNumber:(NSInteger)number{
    self.currentNumber = number;
}
@end
