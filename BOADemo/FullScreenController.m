//
//  FullScreenController.m
//  BOADemo
//
//  Created by liang chunyan on 14-11-14.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "FullScreenController.h"
#import "UIView+AutoLayout.h"

@interface FullScreenController ()<UIWebViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIWebView *mainWebView;
@property (nonatomic, strong) NSURL     *URL;
@property (nonatomic, strong) UIButton  *closeButton;

@property (nonatomic, strong) UITapGestureRecognizer  *tapGes;

//加载网页
- (void)loadURL:(NSURL *)pageURL;
//关闭按钮
- (void)doneButtonClicked:(id)sender;
@end

@implementation FullScreenController
@synthesize mainWebView,URL;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
//    [UIApplication sharedApplication].statusBarHidden = YES;
    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}

- (BOOL)prefersStatusBarHidden
{
//    return NO; //返回NO表示要显示，返回YES将hiden
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    
}

- (void)loadView
{
    [super loadView];
    mainWebView = [[UIWebView alloc] init];
    mainWebView.delegate = self;
    mainWebView.scalesPageToFit = YES;
    mainWebView.opaque = NO;
    mainWebView.scrollView.scrollEnabled = NO;
    [mainWebView addSubview:self.closeButton];
    
    self.tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                          action:@selector(tapAction:)];
    self.tapGes.delegate = self;
    [mainWebView addGestureRecognizer:self.tapGes];
    self.view = mainWebView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadURL:self.URL];
    
//    if(self.type == 0)
//    {
//        __block int timeout = 5; //倒计时时间
//        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
//        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
//        dispatch_source_set_event_handler(_timer, ^{
//            if(timeout<=0){ //倒计时结束，关闭
//                dispatch_source_cancel(_timer);
//                //            dispatch_release(_timer);
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    //设置界面的按钮显示 根据自己需求设置
//                    [self doneButtonClicked:nil];
//                });
//            }else{
//                //            int minutes = timeout / 60;
//                int seconds = timeout % 60;
//                NSString *strTime = [NSString stringWithFormat:@"%.2d",seconds];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    //设置界面的按钮显示 根据自己需求设置
//                    
//                });
//                timeout--;
//                
//            }
//        });
//        dispatch_resume(_timer);
//    }
}

- (void)tapAction:(id)sender
{
    if (self.type == 0)
    {
        return;
    }
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.action)
        {
            if (self.type == 1)
            {
                self.action(self.tapGes);
            }
        }
    }];
}

- (void)loadURL:(NSURL *)pageURL {
    self.closeButton.hidden = YES;
    [mainWebView loadRequest:[NSURLRequest requestWithURL:pageURL]];
}


- (id)initWithAddress:(NSString *)urlString {
    return [self initWithURL:[NSURL URLWithString:urlString]];
}

- (id)initWithURL:(NSURL*)pageURL {
    
    if(self = [super init])
    {
        self.URL = pageURL;
    }
    
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)doneButtonClicked:(id)sender {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000
    [self dismissModalViewControllerAnimated:YES];
#else
    [self dismissViewControllerAnimated:YES completion:NULL];
#endif
}

- (UIButton *)closeButton
{
    if (!_closeButton)
    {
        _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(3, 3, 40, 40)];
        [_closeButton setImage:[UIImage imageNamed:@"icon-close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self
                         action:@selector(doneButtonClicked:)
               forControlEvents:UIControlEventTouchUpInside];
        _closeButton.showsTouchWhenHighlighted = YES;
    }
    return _closeButton;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//    NSLog(@"%@",error);
    [self doneButtonClicked:nil];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self performSelector:@selector(showCloseButton) withObject:nil afterDelay:0.3];
}

- (void)showCloseButton
{
    self.closeButton.hidden = NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer == self.tapGes)
    {
        return YES;
    }
    return NO;
}


@end
