## 概述 ##

  此版本微博SDK实现了Oauth2.0认证登录功能，将较复杂的认证签名过程隐藏起来，并将OPEN api的调用进一步包装，
方便第三方应用登录、访问。

## 名词解释 ##
 * __app_key__: 微博开放平台上申请第三方应用时分配的app_key
 * __app_secret__: 微博开放平台上申请第三方应用时分配的app_secret
 * __app_redirect_uri__: 第三方应用申请完成后，自定义的回调页地址。
 * __access_token__: 表明用户的身份，用于微博OPEN API的调用。
 * __expiration_time__: 过期时间，用于判断token值是否过期。
 
  *注：app_redirect_uri，即第三方应用登录回调页，可在微博开放平台上找到，具体路径:开放平台->我的应用->应用信息->高级信息->OAuth2.0授权设置->授权回调页；若显示未填写，请设置此属性，否则将造成SDK登陆时错误。*

## 常见问题回答 ##
https://github.com/mobileresearch/weibo_ios_sdk_sso-oauth/wiki/%E5%B8%B8%E8%A7%81%E9%97%AE%E9%A2%98%E5%9B%9E%E7%AD%94

## demo使用 ##
1. 将整个目录下载拷贝至自己的工作空间中；
2. 打开Xcode，左侧点击右键，选择<em>Add Files to "your_workspace"</em>，选中<em>weibo_sdk_oauth/demo/sinaweibo_sdk_oauth_demo.xcodeproj</em>，确认添加;
3. 此时直接编译将出错，因为未声明app_key等三个常量，Xcode中修改<em>sinaweibo_sdk_oauth_demo/SNAppDelegate.h</em>文件，将`//#define kAppKey     @"your app_key"`等三行的注释去掉，并根据自己应用的属性给kAppKey等常量赋值；
4. 编译并在模拟器上运行；
5. demo只有一个页面，包括登录/退出/获取用户信息/发表状态等按钮；运行后需要先登录才能进行其他操作。

## 添加SDK至自己工程中 ##
第三方应用使用SDK需要完成DEMO中包含的基本工作。创建自己的工程，并将*weibo_sdk_oAuth/src*目录下*JSONKit*和*SinaWeibo*两个文件夹拷贝至自己工程目录中并添加至工程。

>__实现Oauth2.0认证登录需实现__
 1. 定义app_key，app_secret，app_direct_uri三变量，初始化SinaWeibo对象时使用；
 2. 参照demo实现SinaWeiboDelegate协议，实现后类的对象在初始化SinaWeibo对象时使用；
 3. 创建SinaWeibo对象并初始化，调用`[SinaWeibo login]`登录，并在实现的SinaWeiboDelegate中监听登录结果；
 4. 退出时调用`[SinaWeibo logout]`，同样在实现的SinaWeiboDelegate中监听退出结果，其操作可参考DEMO中的实现。  
  
>   

>__OPEN API的调用__
 1. 实现SinaWeiboRequestDelegate协议；
 2. 调用SinaWeibo中`- (SinaWeiboRequest *)requestWithURL:.. params:.. httpMethod:.. delegate:..`方法实现OPEN API的调用，调用前需初始化url(OPEN API url，以获取用户信息为例，下同，赋值为`@"users/show.json"`)，
params(调用接口参数，初始化为`[NSMutableDictionary dictionaryWithObject:sinaweibo.userID forKey:@"uid"]`)，httpMethod(http类型，赋值为`@"GET"`)，_delegate(SinaWeiboRequestDelegate对象)；
 3. 调用完成后SDK将访问结果通过SinaWeiboRequestDelegate对象返回给第三方应用，`- (void)request:.. didFailWithError:..`接收失败信息，`- (void)request:.. didFinishLoadingWithResult:..`接收成功的访问结果。


## 适用范围 ##
使用此SDK需满足以下条件:
+ IOS平台
+ 在新浪微博开放平台注册并创建应用
+ 已定义本应用的授权回调页

注: 关于授权回调页对移动客户端应用来说对用户是不可见的，所以定义为何种形式都将不影响，但是没有定义将无法使用SDK认证登录。
