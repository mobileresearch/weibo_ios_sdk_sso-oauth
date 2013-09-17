//
//  SendMessageToWeiboViewController.m
//  WeiboSDKDemo
//
//  Created by Wade Cheng on 3/29/13.
//  Copyright (c) 2013 SINA iOS Team. All rights reserved.
//

#import "SendMessageToWeiboViewController.h"
#import "AppDelegate.h"

@implementation SendMessageToWeiboViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *ssoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [ssoButton setTitle:@"请求微博认证（SSO授权）" forState:UIControlStateNormal];
    [ssoButton addTarget:self action:@selector(ssoButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    ssoButton.frame = CGRectMake(20, 250, 280, 50);
    [self.view addSubview:ssoButton];

    UIButton *inviteFriendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [inviteFriendButton setTitle:@"邀请好友" forState:UIControlStateNormal];
    [inviteFriendButton addTarget:self action:@selector(inviteFriendButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    inviteFriendButton.frame = CGRectMake(20, 370, 280, 50);
    [self.view addSubview:inviteFriendButton];
    
    UIButton *ssoOutButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [ssoOutButton setTitle:@"登出" forState:UIControlStateNormal];
    [ssoOutButton addTarget:self action:@selector(ssoOutButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    ssoOutButton.frame = CGRectMake(20, 300, 280, 50);
    [self.view addSubview:ssoOutButton];
    
    
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
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
}

- (void)ssoOutButtonPressed
{
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    [WeiboSDK logOutWithToken:myDelegate.wbtoken delegate:self];
}

- (void)inviteFriendButtonPressed
{
    NSString *title = @"请输入被邀请人的UID";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    [alert show];
    [alert release];
    
}

-(void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITextField *textField=[alertView textFieldAtIndex:0];
    
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSLog(@"%@",myDelegate.wbtoken);
    [WeiboSDK inviteFriend:@"testinvite" withUid:[textField text] withToken:myDelegate.wbtoken delegate:self];
}

- (void)didReceiveWeiboSDKResponse:(id)JsonObject err:(NSError *)error;
{
    NSString *title = nil;
    UIAlertView *alert = nil;
    if (!error)
    {
        title = @"收到网络回调";
        alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:[NSString stringWithFormat:@"%@",JsonObject]
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    }
    else
    {
        title = @"网络异常";
        alert = [[UIAlertView alloc] initWithTitle:title
                                           message:[NSString stringWithFormat:@"err:%@\n%@",error,JsonObject]
                                          delegate:nil
                                 cancelButtonTitle:@"确定"
                                 otherButtonTitles:nil];
    }
    [alert show];
    [alert release];
}
@end
