//
//  ViewController.m
//  BOADemo
//
//  Created by liang chunyan on 14-11-12.
//  Copyright (c) 2014年 BaiLing-ShanBo. All rights reserved.
//

#import "ViewController.h"
#import "BOADHttpClient.h"
#import "NSString+BOAD.h"
#import "UIView+AutoLayout.h"
#import "SVModalWebViewController.h"
#import <MessageUI/MFMessageComposeViewController.h>
#import "SVProgressHUD.h"
#import "FullScreenController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,
UIWebViewDelegate,UIGestureRecognizerDelegate,MFMessageComposeViewControllerDelegate>

@property (nonatomic, strong) NSArray  *dataList;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSDictionary *adInfo;

@property (nonatomic, strong) UIWebView    *webView;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, assign) NSUInteger  type;

@property (nonatomic, strong) UIButton    *closeButton;

@property (nonatomic, strong) UIView  *keepOutView;

- (void)configTableView;
//
- (void)loadRequest:(NSString *)path;

//
- (void)tapAction:(id)sender;

///发送短信
- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients;
//显示错误信息
- (void)showAlertView:(NSString *)message;
- (void)clickButtonAction:(UIButton *)button;
- (void)configWebViewConstraintByType:(NSUInteger)type;
@end

@implementation ViewController

- (id)init
{
    self = [super init];
    if (self)
    {
        self.type = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configTableView];
    self.title = @"Test Demo";
    [BOADHttpClient sharedInstance].serverSuccess = ^()
    {
        [[BOADHttpClient sharedInstance] getUrlByType:3];
        self.type = 3;
    };
    [[BOADHttpClient sharedInstance] getSerVerInfo];
    __weak __typeof(self)weakSelf = self;
    [BOADHttpClient sharedInstance].action = ^(NSDictionary* info)
    {
        
        weakSelf.adInfo = info;
        if (weakSelf.type == 3 || weakSelf.type == 1)
        {
//            dispatch_async(dispatch_get_main_queue(), ^{
                FullScreenController *vc = [[FullScreenController alloc] initWithAddress:info[@"request_url"]];
                
                vc.action = ^(id sender)
                {
                    [weakSelf tapAction:sender];
                };
                if (weakSelf.type == 3)
                {
                    vc.type = 0;
                }
                else
                {
                    vc.type = 1;
                }
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
                [weakSelf.navigationController presentViewController:nav animated:YES completion:^{
                    
                }];
                
//            });
        }
        else
        {
            [self loadRequest:info[@"request_url"]];
        }
    };
    [BOADHttpClient sharedInstance].errorAction = ^()
    {
        [self.webView autoRemoveConstraintsAffectingView];
        [self.webView removeFromSuperview];
        self.webView = nil;
        [self.keepOutView removeFromSuperview
         ];
    };
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
}

- (void)loadRequest:(NSString *)path
{
    self.webView.hidden = NO;
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark - getters
- (NSArray *)dataList
{
    if (!_dataList)
    {
        _dataList = @[
                      @"banner",
                      @"全屏",
                      @"插屏",
                      @"开屏",
                      ];
    }
    return _dataList;
}

- (UIWebView *)webView
{
    if (!_webView)
    {
        _webView = [[UIWebView alloc] init];
        _webView.scalesPageToFit = YES;
        _webView.allowsInlineMediaPlayback = YES;
        _webView.mediaPlaybackRequiresUserAction = NO;
        _webView.opaque = NO;
        _webView.backgroundColor = [UIColor clearColor];
        _webView.delegate = self;
        _webView.scrollView.scrollEnabled = NO;
        self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        self.tap.delegate = self;
        [_webView addGestureRecognizer:self.tap];
        [_webView addSubview:self.closeButton];
    }
    return _webView;
}

- (UIButton *)closeButton
{
    if (!_closeButton)
    {
        _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(3, 3, 40, 40)];
        [_closeButton setImage:[UIImage imageNamed:@"icon-close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self
                         action:@selector(clickButtonAction:)
               forControlEvents:UIControlEventTouchUpInside];
        _closeButton.showsTouchWhenHighlighted = YES;
    }
    return _closeButton;
}

- (UIView *)keepOutView
{
    if (!_keepOutView)
    {
        _keepOutView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _keepOutView.backgroundColor = [UIColor colorWithWhite:1 alpha:.6];
        _keepOutView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _keepOutView;
}

- (void)tapAction:(id)sender
{
    [self.webView removeFromSuperview];
    self.webView = nil;
    [self.keepOutView removeFromSuperview];
    NSInteger cliclk_Action = [self.adInfo[@"click_action"] integerValue];
    switch (cliclk_Action)
    {
        case 0://预留
            break;
        case 1://预留
            break;
        case 2://应用内打开浏览器
        {
            SVModalWebViewController  *webViewController = [[SVModalWebViewController alloc] initWithAddress:self.adInfo[@"redirect_url"]];
            [self.navigationController presentViewController:webViewController animated:YES completion:^{
                
            }];
            break;
        }
        case 3://打开第三方浏览器
        {
            NSURL *url = [NSURL URLWithString:self.adInfo[@"redirect_url"]];
            [[UIApplication sharedApplication] openURL:url];
            break;
        }
        case 4://下载
        {
            NSURL *url = [NSURL URLWithString:self.adInfo[@"redirect_url"]];
            [[UIApplication sharedApplication] openURL:url];
            break;
        }
        case 5://拨打电话
        {
            if (self.adInfo[@"phone"] != nil)
            {
                NSString *string = [NSString stringWithFormat:@"tel://%@",self.adInfo[@"phone"]];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
            }
            break;
        }
        case 6://发送短信
        {
            NSArray  *peopleArray = @[self.adInfo[@"phone"],];
            NSString *message     = self.adInfo[@"message"];
            [self sendSMS:message recipientList:peopleArray];
            break;
        }
        case 7://打开地图
        {
            NSURL *url = [NSURL URLWithString:self.adInfo[@"map_address"]];
            [[UIApplication sharedApplication] openURL:url];
            break;
        }
        default:
            break;
    }
}

- (void)configTableView
{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifi = @"celliden";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifi];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifi];
        cell.textLabel.font = [UIFont systemFontOfSize:20];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    cell.textLabel.text = self.dataList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //
    switch (indexPath.row)
    {
        case 0:
//            [self.view addSubview:self.webView];
            break;
        case 1:
//            [self.navigationController.view addSubview:self.webView];
            break;
        case 2:
//            [self.view addSubview:self.webView];
            break;
        case 3:
            break;
        default:
            break;
    }
    self.type = indexPath.row;
    if (self.type == 0 || self.type == 2)
    {
        [self configWebViewConstraintByType:indexPath.row];
    }
//    [SVProgressHUD show];
    [[BOADHttpClient sharedInstance] getUrlByType:indexPath.row];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self performSelector:@selector(showCloseButton) withObject:nil afterDelay:0.3f];
    if (self.type == 2)
    {
        [self.view insertSubview:self.keepOutView belowSubview:self.webView];
    }
}

- (void)showCloseButton
{
    self.closeButton.hidden = NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@",error);
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
//    self.webView.hidden = YES;
    [self.webView removeFromSuperview];
    self.webView = nil;
    [self.keepOutView removeFromSuperview];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
- (UIRectEdge)edgesForExtendedLayout
{
    return UIRectEdgeLeft | UIRectEdgeRight | UIRectEdgeBottom;
}
#endif

- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
        controller.body       = bodyOfMessage;
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [self.navigationController presentViewController:controller animated:YES completion:^{
        }];
    }
}
//代理，防止手势和UIWebView手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if (gestureRecognizer == self.tap)
    {
        return YES;
    }
    return NO;
}

- (void)showAlertView:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)configWebViewConstraintByType:(NSUInteger)type
{
    self.webView.hidden = YES;
    [self.webView autoRemoveConstraintsAffectingView];
    switch (type)
    {
        case 0:
        {
            [self.view addSubview:self.webView];
//            self.closeButton.hidden = YES;
            [self.webView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0];
            [self.webView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0];
            [self.webView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0];
            [self.webView autoSetDimension:ALDimensionHeight toSize:50.0f];
            break;
        }
        case 1:
        {
            [self.navigationController.view addSubview:self.webView];
            self.closeButton.hidden = YES;
            [self.webView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0];
            [self.webView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0];
            [self.webView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0];
            [self.webView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0];
            break;
        }
        case 2:
        {
            [self.view addSubview:self.webView];
            self.closeButton.hidden = YES;
            CGFloat W = (CGRectGetWidth(self.view.bounds) - 300)*0.5;
            CGFloat h = (CGRectGetHeight(self.view.bounds) - 250) * 0.5;
            
            if (!(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone))
            {
                W = (CGRectGetWidth(self.view.bounds) - 600)*0.5;
                h = (CGRectGetHeight(self.view.bounds) - 500) * 0.5;
            }
            
            [self.webView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:W];
            [self.webView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:W];
            [self.webView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:h];
            [self.webView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:h];
            break;
        }
        case 3:
        {
            [self.view.window addSubview:self.webView];
            //            self.closeButton.hidden = YES;
            [self.webView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0];
            [self.webView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0];
            [self.webView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0];
            [self.webView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0];
            break;
        }
        default:
            break;
    }
}

- (void)clickButtonAction:(UIButton *)button
{
    [self.webView autoRemoveConstraintsAffectingView];
    [self.webView removeFromSuperview];
    self.webView = nil;
    [self.keepOutView removeFromSuperview];
}

//发送短信代理
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    switch (result) {
        case MessageComposeResultCancelled:
        {
            //click cancel button
            NSLog(@"%@",@"关闭了短信发送");
        }
            break;
        case MessageComposeResultFailed:// send failed
        {
            [self showAlertView:@"发信发送失败"];
        }
            break;
            
        case MessageComposeResultSent:
        {
            //do something
        }
            break;
        default:
            break;
    } 
    
}


@end
