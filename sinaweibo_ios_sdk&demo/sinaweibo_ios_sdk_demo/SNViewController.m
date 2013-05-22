//
//  SNViewController.m
//  sinaweibo_ios_sdk_demo
//
//  Created by Wade Cheng on 4/23/12.
//  Copyright (c) 2012 SINA. All rights reserved.
//

#import "SNViewController.h"
#import "SNAppDelegate.h"

@interface SNViewController ()

@end

@implementation SNViewController

- (void)dealloc
{
    [userInfo release], userInfo = nil;
    [statuses release], statuses = nil;
    [postStatusText release], postStatusText = nil;
    [postImageStatusText release], postImageStatusText = nil;
    [super dealloc];
}

- (SinaWeibo *)sinaweibo
{
    SNAppDelegate *delegate = (SNAppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}

- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
}

- (void)storeAuthData
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)resetButtons
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    BOOL authValid = sinaweibo.isAuthValid;

    loginButton.enabled = !authValid;
    logoutButton.enabled = authValid;
    userInfoButton.enabled = authValid;
    timelineButton.enabled = authValid;
    postStatusButton.enabled = authValid;
    postImageStatusButton.enabled = authValid;
    
    if (authValid)
    {
        [logoutButton setTitle:[NSString stringWithFormat:@"logout uid=%@", sinaweibo.userID] forState:UIControlStateNormal];
        if (userInfo)
        {
            [userInfoButton setTitle:[userInfo objectForKey:@"screen_name"] forState:UIControlStateNormal];
        }
        if (statuses)
        {
            if (statuses.count > 0)
            {
                [timelineButton setTitle:[[statuses objectAtIndex:0] objectForKey:@"text"] forState:UIControlStateNormal];
            }
            else
            {
                [timelineButton setTitle:@"no status" forState:UIControlStateNormal];
            }
        }
    }
    else
    {
        [logoutButton setTitle:@"logout" forState:UIControlStateNormal];
        [userInfoButton setTitle:@"get user info" forState:UIControlStateNormal];
        [timelineButton setTitle:@"get timeline" forState:UIControlStateNormal];
    }
}

- (UIButton *)buttonWithFrame:(CGRect)frame action:(SEL)action
{
    UIImage *buttonBackgroundImage = [[UIImage imageNamed:@"button_background.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    UIImage *disabledButtonBackgroundImage = [[UIImage imageNamed:@"button_background_disabled.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setBackgroundImage:buttonBackgroundImage forState:UIControlStateNormal];
    [button setBackgroundImage:disabledButtonBackgroundImage forState:UIControlStateDisabled];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    return button;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    logoImageView.frame = CGRectMake(50, 40, 73, 30);
    [self.view addSubview:logoImageView];
    [logoImageView release];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"iOS SDK DEMO";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.frame = CGRectMake(140, 40, 140, 30);
    [self.view addSubview:titleLabel];
    [titleLabel release];
    
    NSString *login = [NSString stringWithFormat:@"login - appKey=%@", kAppKey];
    loginButton = [self buttonWithFrame:CGRectMake(20, 100, 280, 40) action:@selector(loginButtonPressed)];
    [loginButton setTitle:login forState:UIControlStateNormal];
    
    logoutButton = [self buttonWithFrame:CGRectMake(20, 150, 280, 40) action:@selector(logoutButtonPressed)];
    [logoutButton setTitle:@"logout" forState:UIControlStateNormal];
    [logoutButton setTitle:@"logout" forState:UIControlStateDisabled];
    
    userInfoButton = [self buttonWithFrame:CGRectMake(20, 200, 280, 40) action:@selector(userInfoButtonPressed)];
    [userInfoButton setTitle:@"get user info" forState:UIControlStateNormal];
    [userInfoButton setTitle:@"get user info" forState:UIControlStateDisabled];
    
    timelineButton = [self buttonWithFrame:CGRectMake(20, 250, 280, 40) action:@selector(timelineButtonPressed)];
    [timelineButton setTitle:@"get timeline" forState:UIControlStateNormal];
    [timelineButton setTitle:@"get timeline" forState:UIControlStateDisabled];
    
    postStatusButton = [self buttonWithFrame:CGRectMake(20, 300, 280, 40) action:@selector(postStatusButtonPressed)];
    [postStatusButton setTitle:@"post status" forState:UIControlStateNormal];
    
    postImageStatusButton = [self buttonWithFrame:CGRectMake(20, 350, 280, 40) action:@selector(postImageStatusButtonPressed)];
    [postImageStatusButton setTitle:@"post status with image" forState:UIControlStateNormal];
    
    [self resetButtons];
}

- (void)loginButtonPressed
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    NSLog(@"%@", [keyWindow subviews]);
    
    
    [userInfo release], userInfo = nil;
    [statuses release], statuses = nil;
    
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo logIn];
}

- (void)logoutButtonPressed
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo logOut];
}

- (void)userInfoButtonPressed
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo requestWithURL:@"users/show.json"
                       params:[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]
                   httpMethod:@"GET"
                     delegate:self];
}

- (void)timelineButtonPressed
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    [sinaweibo requestWithURL:@"statuses/user_timeline.json"
                       params:[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]
                   httpMethod:@"GET"
                     delegate:self];
}

static int post_status_times = 0;
- (void)postStatusButtonPressed
{
    if (!postStatusText)
    {
        post_status_times ++;
        [postStatusText release], postStatusText = nil;
        postStatusText = [[NSString alloc] initWithFormat:@"test post status : %i %@", post_status_times, [NSDate date]];
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:[NSString stringWithFormat:@"Will post status with text \"%@\"", postStatusText]
                                                       delegate:self cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK", nil];
    alertView.tag = 0;
    [alertView show];
    [alertView release];
}

static int post_image_status_times = 0;
- (void)postImageStatusButtonPressed
{
    if (!postImageStatusText)
    {
        post_image_status_times ++;
        [postImageStatusText release], postImageStatusText = nil;
        postImageStatusText = [[NSString alloc] initWithFormat:@"test post image status : %i %@", post_image_status_times, [NSDate date]];
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                        message:[NSString stringWithFormat:@"Will post image status with text \"%@\"", postImageStatusText]
                                                       delegate:self cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK", nil];
    alertView.tag = 1;
    [alertView show];
    [alertView release];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        if (alertView.tag == 0)
        {
            // post status
            SinaWeibo *sinaweibo = [self sinaweibo];
            [sinaweibo requestWithURL:@"statuses/update.json"
                               params:[NSMutableDictionary dictionaryWithObjectsAndKeys:postStatusText, @"status", nil]
                           httpMethod:@"POST"
                             delegate:self];
            
        }
        else if (alertView.tag == 1)
        {
            // post image status
            SinaWeibo *sinaweibo = [self sinaweibo];
            
            [sinaweibo requestWithURL:@"statuses/upload.json"
                               params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       postImageStatusText, @"status",
                                       [UIImage imageNamed:@"logo.png"], @"pic", nil]
                           httpMethod:@"POST"
                             delegate:self];
            
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - SinaWeibo Delegate

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);
    
    [self resetButtons];
    [self storeAuthData];
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogOut");
    [self removeAuthData];
    [self resetButtons];
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboLogInDidCancel");
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    NSLog(@"sinaweibo logInDidFailWithError %@", error);
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    NSLog(@"sinaweiboAccessTokenInvalidOrExpired %@", error);
    [self removeAuthData];
    [self resetButtons];
}

#pragma mark - SinaWeiboRequest Delegate 

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    if ([request.url hasSuffix:@"users/show.json"])
    {
        [userInfo release], userInfo = nil;
    }
    else if ([request.url hasSuffix:@"statuses/user_timeline.json"])
    {
        [statuses release], statuses = nil;
    }
    else if ([request.url hasSuffix:@"statuses/update.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post status \"%@\" failed!", postStatusText]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
        
        NSLog(@"Post status failed with error : %@", error);
    }
    else if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post image status \"%@\" failed!", postImageStatusText]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
        
        NSLog(@"Post image status failed with error : %@", error);
    }
    
    
    [self resetButtons];
}

- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([request.url hasSuffix:@"users/show.json"])
    {
        [userInfo release];
        userInfo = [result retain];
    }
    else if ([request.url hasSuffix:@"statuses/user_timeline.json"])
    {
        [statuses release];
        statuses = [[result objectForKey:@"statuses"] retain];
    }
    else if ([request.url hasSuffix:@"statuses/update.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post status \"%@\" succeed!", [result objectForKey:@"text"]]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];

        [postStatusText release], postStatusText = nil;
    }
    else if ([request.url hasSuffix:@"statuses/upload.json"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                            message:[NSString stringWithFormat:@"Post image status \"%@\" succeed!", [result objectForKey:@"text"]]
                                                           delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alertView show];
        [alertView release];
        
        [postImageStatusText release], postImageStatusText = nil;
    }
    
    [self resetButtons];
}

@end
