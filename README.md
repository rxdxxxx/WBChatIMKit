# WBChatIMKit

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

- iOS 8.0 or later
- Xcode 7.3 or later


## 简介

### 安装

在Podfile文件中添加下面👇这行代码.

```ruby
pod 'WBChatIMKit'
```

### 初始化
首先需要在LeanCloud注册自己的应用,得到对应的 `AppId` 和 `clientKey ` 后在程序中设置好自己的应用id.

```
#import <WBChatIMKit/WBChatIMKit.h>

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    [WBChatKit setAppId:@"AppId"
              clientKey:@"clientKey"];
    return YES;
}
```

### 连接服务器
SDK初始化成功后, 就可以用某一身份连接服务器. 实例代码如下.

```
[[WBChatKit sharedInstance] openWithClientId:@"10000"
                                     success:^(NSString * _Nonnull clientId)
 {
     NSLog(@"链接成功");
     
 } error:^(NSError * _Nonnull error) {
     NSLog(@"链接失败: %@",
           error.description);
 }];


```

### 展示会话列表

本项目提供了`会话列表页面`. 可以直接使用 `WBChatListController` 也可以继承这个类实现自己的逻辑.

```

WBChatListController *vc = [[WBChatListController alloc]init];
    
UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];

[self presentViewController:nav animated:YES completion:nil];

```

第一次登陆是没有会话信息的, 你可以给任意ID发送一条消息,就可以在会话列表中看到这条记录了.

##### 发送一条消息:

```
WBMessageModel *text = [WBMessageModel createWithText:[NSDate new].description];
    
[[WBChatKit sharedInstance] sendTargetUserId:@"30000"
                                     message:text
                                     success:^(WBMessageModel * _Nonnull aMessage)
{
     NSLog(@"消息发送成功");

} error:^(WBMessageModel * _Nonnull aMessage, NSError * _Nonnull error) {

     NSLog(error.description);

}];

```

##### 会话列表页面具体效果


正常效果 |  删除会话
--- | ----
![会话列表页面具体效果](https://upload-images.jianshu.io/upload_images/317370-cf9c241dd1db23e9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240) |  ![会话列表页面删除](https://upload-images.jianshu.io/upload_images/317370-d081f7f7d6f151f2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 会话页面
本项目提供了`会话页面`. 可以直接使用 `WBChatViewController ` 也可以继承这个类实现自己的逻辑.

在`WBChatListController`的方法中已经实现页面的跳转.

```
// WBChatListController
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    WBChatListCellModel *cellModle = self.dataArray[indexPath.row];
    
    WBChatViewController *vc = [WBChatViewController createWithConversation:cellModle.dataModel.conversation];
    vc.title = cellModle.title;
    [self.navigationController pushViewController:vc animated:YES];
}

```

##### 会话页面具体效果
会话正常效果 |  emoji键盘 | 更多
--- | ---- | ---
![会话页面具体效果](https://upload-images.jianshu.io/upload_images/317370-f13f603d624d76b2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240) |  ![会话页面emoji键盘效果](https://upload-images.jianshu.io/upload_images/317370-2ffa840703709e43.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240) | ![会话页面更多具体效果](https://upload-images.jianshu.io/upload_images/317370-59869b07649407ba.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


### 断开连接

断开连接后,就不会再收到这个账号的消息了.

```
- (IBAction)logOut{
    [[WBChatKit sharedInstance] closeWithCallback:^(BOOL succeeded, NSError * _Nonnull error) {
        if (succeeded) {
            NSLog(@"退出成功");
        }else{
            NSLog(@"退出失败");
        }
    }];
}

```

## 其他
更多细节介绍请查看 [这里]()


## 依赖库

- 'FMDB'
- 'AVOSCloud'
- 'AVOSCloudIM'

## 参考资源

- [TLChat](https://github.com/tbl00c/TLChat)
- [ChatKit-OC](https://raw.githubusercontent.com/leancloud/ChatKit-OC)
- [WBImageBrowser](https://github.com/DYLAN-LWB/WBImageBrowser)


## Author

Ding RedRain, 447154278@qq.com

## License

WBChatIMKit is available under the MIT license. See the LICENSE file for more info.

