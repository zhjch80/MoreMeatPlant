// AFNetworking.h
//
// Copyright (c) 2013 AFNetworking (http://afnetworking.com/)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <Foundation/Foundation.h>
#import <Availability.h>

#ifndef _AFNETWORKING_
    #define _AFNETWORKING_

    #import "AFURLRequestSerialization.h"
    #import "AFURLResponseSerialization.h"
    #import "AFSecurityPolicy.h"
    #import "AFNetworkReachabilityManager.h"

    #import "AFURLConnectionOperation.h"
    #import "AFHTTPRequestOperation.h"
    #import "AFHTTPRequestOperationManager.h"

#if ( ( defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED >= 1090) || \
      ( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000 ) )
    #import "AFURLSessionManager.h"
    #import "AFHTTPSessionManager.h"
#endif

#endif /* _AFNETWORKING_ */



/*
 常见问题：
 1. AFNetworking作用都有哪些？
 NSURLConnection 提供了+sendAsynchronousRequest:queue:completionHandler: 和+sendAsynchronousRequest:queue:completionHandler: ，但是AFNetworking提供了更好的功能
 ＊AFURLConnectionOperation和它的子类继承NSOperation的，允许请求被取消，暂停/恢复和由NSOperationQueue进行管理。
 ＊AFURLConnectionOperation也可以让你轻松得完成上传和下载，处理验证，监控上传和下载进度，控制的缓存。
 ＊AFHTTPRequestOperation和它得子类可以基于http状态和内容列下来区分是否成功请求了
 ＊AFNetworking可以将远程媒体数据类型（NSData）转化为可用的格式，比如如JSON，XML，图像和plist。
 ＊AFHTTPClient提供了一个方便的网络交互接口，包括默认头，身份验证，是否连接到网络，批量处理操作，查询字符串参数序列化，已经多种表单请求
 ＊的UIImageView+ AFNetworking增加了一个方便的方法来异步加载图像。
 
 2. AFNetworking是否支持缓存？
 可以，NSURLCache及其子类提供了很多高级接口用于处理缓存
 如果你想将缓存存储再磁盘，推荐使用SDURLCache
 
 3.如何使用AFNetworking上传一个文件？
 NSData *imageData = UIImagePNGRepresentation(image);
 NSURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:@"/upload" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData> formData) {
 [formData appendPartWithFileData:imageData mimeType:@"image/png" name:@"avatar"];
 }];
 
 
 4.如何使用AFNetworking下载一个文件？
 先创建一个AFURLConnectionOperation对象，然后再使用它的属性outputStream进行处理
 operation.outputStream = [NSOutputStream outputStreamToFileAtPath:@"download.zip" append:NO];
 
 5.如何解决：SystemConfiguration framework not found in project
 请导入：
 #import <SystemConfiguration/SystemConfiguration.h>
 #import <MobileCoreServices/MobileCoreServices.h>
 
 6.当应用程序退出时，如何保持持续的请求？
 AFURLConnectionOperation有一个叫setShouldExecuteAsBackgroundTaskWithExpirationHandler:的方法用于处理在应用程序进入后台后，进行持续的请求
 [self setShouldExecuteAsBackgroundTaskWithExpirationHandler:^{
 }];
 */


