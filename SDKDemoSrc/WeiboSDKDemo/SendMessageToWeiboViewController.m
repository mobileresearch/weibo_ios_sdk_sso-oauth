//
//  SendMessageToWeiboViewController.m
//  WeiboSDKDemo
//
//  Created by Wade Cheng on 3/29/13.
//  Copyright (c) 2013 SINA iOS Team. All rights reserved.
//

#import "SendMessageToWeiboViewController.h"

@implementation SendMessageToWeiboViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *ssoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [ssoButton setTitle:@"请求微博认证（SSO授权）" forState:UIControlStateNormal];
    [ssoButton addTarget:self action:@selector(ssoButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    ssoButton.frame = CGRectMake(20, 250, 280, 50);
    [self.view addSubview:ssoButton];
    [self.view addSubview:ssoButton];
    
    [self.shareButton setTitle:@"分享消息到微博" forState:UIControlStateNormal];
    self.titleLabel.text = @"第三方应用主动发送消息给微博";
}

- (void)shareButtonPressed
{
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare]];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
//    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    
    [WeiboSDK sendRequest:request];
}

- (void)ssoButtonPressed
{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"email,direct_messages_write";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

@end
