# CINetworking

[![CI Status](https://img.shields.io/travis/czh/CINetWorking.svg?style=flat)](https://travis-ci.org/czh/CINetWorking)
[![Version](https://img.shields.io/cocoapods/v/CINetWorking.svg?style=flat)](https://cocoapods.org/pods/CINetWorking)
[![License](https://img.shields.io/cocoapods/l/CINetWorking.svg?style=flat)](https://cocoapods.org/pods/CINetWorking)
[![Platform](https://img.shields.io/cocoapods/p/CINetWorking.svg?style=flat)](https://cocoapods.org/pods/CINetWorking)

## Features

支持HTTP请求功能
支持会话管理功能，统一配置系列请求
支持缓存策略配置
支持单个HTTP请求定制配置
支持上传下载进度监控
提供网络状态检测功能

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
iOS 8.0 or later
Xcode 10.0 or later

## Installation

CINetWorking is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CINetworking', :git => 'https://gitlab.oneitfarm.com/basemodule-ios/cinetworking.git'

or 
source 'https://gitlab.oneitfarm.com/basemodule-ios/cibasemodulespec.git'
pod 'CINetworking'
```

## how to use

### GET

```objc
// GET 
[[CINetworking sharedInstance] GET:@"http://mock-api.com/ynWRaMg6.mock/get" parameters:nil success:^(id  _Nullable responseObject) {
// 1.当服务器响应Content-Type字段为json相关格式时候，responseObject会自动将服务器返回数据解析为NSDictionary
// 2.其他情况下，responseObject均为NSData
// NSData -> NSDictionary
// NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
} 
failure:^(NSError * _Nonnull error) {
    
}];
```

### POST

```objc
//POST
[[CINetworking sharedInstance] POST:@"/ynWRaMg6.mock/post" parameters:@{
    @"test":@"test"
} success:^(id  _Nullable responseObject) {
    
} failure:^(NSError * _Nonnull error) {
    
}];
```

### 文件上传
```objc 
// 文件上传
UIImage * image = [UIImage imageNamed:@"Image"];
[[CINetworking sharedInstance] uploadFile:@"http://a3.work/open/demo2/index.php" parameters:nil fileParameters:@{
        @"data":UIImagePNGRepresentation(image),// 文件数据
        @"name":@"file",                        // 服务器字段名
        @"fileName":@"test.jpeg",               // 文件名
        @"mimeType":@"image/jpeg",              // mimeType
    } progress:^(NSProgress * _Nonnull progress) {
        NSLog(@"上传进度: %f\n", 1.0 * progress.completedUnitCount / progress.totalUnitCount);
    } success:^(id  _Nullable responseObject) {
        NSLog(@"[TEST upload] successed:\n%@",responseObject);
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"[TEST upload] failed:\n%@",error.description);
    }];
```

### 创建上传任务
```objc
// 上传任务，忽略通用回调, 忽略通用参数，通用header, 支持多文件上传, 需要手动开启
NSMutableURLRequest * request = [[CIHTTPRequestSerializer serializer]multipartFormRequestWithMethod:@"POST" URLString:@"http://dp-5e1306ce8db05.qcloud-prod.oneitfarm.com/main.php/json/upload/uploadFile" parameters:@{
    @"appkey":@"kxjz4mnkw7yacdnopzjprxi6mte8b1vf",
    @"channel":@"15",
    @"type":@"img"
} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    [formData appendPartWithFileData:UIImagePNGRepresentation(image) name:@"file" fileName:@"test.jpeg" mimeType:@"image/jpeg"];
} error:nil];
// 设置header
[request setValue:@"Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJJdGZhcm1QaHBTZGsiLCJpYXQiOjE1NjI5MTYyMzUsIm5iZiI6MTU2MjkxNjIzNSwiZXhwIjoxNTYyOTE2Mjk1LCJhY2NvdW50X2lkIjoiMDMxNzYyOGYwMTYwNDE2NmI1NWFlOGQ3OGVjNmRkNjAiLCJhcHBrZXkiOiI2YTU5ZjEyNjAxMzk0OGQ3OTZlNGI4MDk1NGQ5NzU3YSIsImFwcGlkIjoiZmpvYmM5YjdpOGtha210b3Jld3dxeWVwZzVsNGhtbHAiLCJjaGFubmVsIjoiMiIsInN1Yl9vcmdfa2V5IjoiMCIsInVzZXJfaW5mbyI6W10sImNhbGxfc3RhY2siOltdfQ.HBH_NZ1pTIihioG4HMJBgLpQ0cZB2wMxDV6FzJq1qRY" forHTTPHeaderField:@"Authorization"];
NSURLSessionDataTask * uploadTask = [[CINetworking sharedInstance]uploadTask:request progress:^(NSProgress * _Nonnull progress) {
    
} success:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject) {
    
} failure:^(NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
    
}];
[uploadTask resume];
```

### 文件下载
```objc
// 下载文件
[[CINetworking sharedInstance] downloadFile:@"http://img.wxcha.com/file/201810/23/5e623a6c2f.jpeg" parameters:nil progress:nil success:^(id  _Nullable responseObject) {
    NSData * data = responseObject;
    UIImage * image = [UIImage imageWithData:data];
    UIImageView * imageView = [[UIImageView alloc]initWithImage:image];
    [self.view addSubview:imageView];
} failure:^(NSError * _Nonnull error) {
    
}];
```

### 创建下载任务
```objc
//下载任务, 忽略通用回调, 忽略通用参数，通用header, 需要手动开启
NSURLRequest * downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://img.wxcha.com/file/201810/23/5e623a6c2f.jpeg"]];
NSURLSessionDownloadTask * downloadTask = [[CINetworking sharedInstance]downloadTask:downloadRequest parameters:nil progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
} success:^(NSURLResponse * _Nonnull response, NSURL * _Nonnull filePath) {
    NSLog(@"%@ 下载成功",filePath);
} failure:^(NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
    
}];
[downloadTask resume];
```

### 基础参数设置
```objc
// CINetworking针对普通项目提供便捷性
// 如需自定义请使用CIHttpSessionManager, 该类中success failure回调均包含完整的NSURLSessionDataTask（其中包含NSURLResponse）

// 设置服务器地址
[[CINetworking sharedInstance] setBaseURL:@"http://mock-api.com"];

//  设置编码
[[CINetworking sharedInstance] setEncoding:NSUTF8StringEncoding];

// 设置缓存策略
[[CINetworking sharedInstance] setCachePolicy:NSURLRequestUseProtocolCachePolicy];

// 设置忽略Set-Cookie响应头，默认不忽略
[[CINetworking sharedInstance] setHandleCookies:NO];

// 开启HTTP管道化，默认关闭
[[CINetworking sharedInstance] setUsePipelining:YES];

// 设置超时时间
[[CINetworking sharedInstance] setTimeoutInterval:15];

// 设置允许蜂窝移动网络访问，默认开启
[[CINetworking sharedInstance] setAllowsCellularAccess:YES];

// 设置可接受HTTP Response Status Code, 一般情况无需设置
NSMutableIndexSet * acceptableStatusCodes = [[NSMutableIndexSet alloc]init];
[acceptableStatusCodes addIndex:200];
[[CINetworking sharedInstance] setAcceptableStatusCodes:acceptableStatusCodes];

//设置可接受Content-Type, 一般情况无需设置
[[CINetworking sharedInstance] setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", nil]];
    
// 设置通用请求头
[[CINetworking sharedInstance] setCommonRequestHeaders:@{
    @"username":@"czh",
}];

// 设置通用请求参数
[[CINetworking sharedInstance] setCommonRequestParameters:@{
    @"username":@"czh"
}];

//设置通用成功回调
[[CINetworking sharedInstance] setOnSuccess:^(id  _Nullable responseObject) {
    NSLog(@"onSuccess: %@",responseObject);
}];

//设置通用失败回调
[[CINetworking sharedInstance] setOnFailure:^(NSError * _Nonnull error) {
    NSLog(@"onFailure: %@",error);
}];
```


### 网络状态监控
```objc
// 网络状态监控
self.networkReachabilityManager = [CINetworkReachabilityManager sharedManager];
[self.networkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
    NSLog(@"%ld",(long)status);
}];
[self.networkReachabilityManager startMonitoring];
```

## API Document
如需查看详细API文档，请点击如下链接：
[API Document](./CINetworking.md)
 
## Author

czh, caozhonghao@corp-ci.com

## License

CINetWorking is available under the MIT license. See the LICENSE file for more info.
