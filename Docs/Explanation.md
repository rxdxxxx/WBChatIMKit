# 更多细节

## 1.根据`ClientId`获取`memberName`

项目中区分用户是使用`ClientId`, 使用`ClientId`可以提供UI对应的名称.

ChatKit需要使用者提供一些信息,即可以实现代理`WBChatKitProtocol`,提供给`[WBChatKit sharedInstance].delegate`

项目中使用如下: 

- WBChatListCellModel.m

```
- (void)handleTitle:(WBChatListModel *)dataModel{
    WBConversationType type = dataModel.conversation.wb_conversationType;
    if (type == WBConversationTypeSingle) {
        NSArray *member = dataModel.conversation.members;
        // 如果实现了代理, 那么使用代理返回的数据
        if ([[WBChatKit sharedInstance].delegate respondsToSelector:@selector(memberNameWithClientID:)]) {
            NSString *otherObjectId = member.firstObject;
            if ([otherObjectId isEqualToString:[WBUserManager sharedInstance].clientId]) {
                otherObjectId = member.lastObject;
            }
            
            NSString *memberName = [[WBChatKit sharedInstance].delegate memberNameWithClientID:otherObjectId];
            self.title = memberName;
        }else{
            self.title = dataModel.conversation.name;
        }
        
    }else{
        self.title = dataModel.conversation.name;
    }
}

```


## 2.会话页面消息的配置 `WBChatCellConfig`

- WBChatCellConfig 单例的属性
	- WBImageLoad *imageLoad; 图片加载逻辑
	- UIImage *placeholdHeaderImage; 头像占位图
	- UIImage *placeholdImage; 图片占位图


### 2.1 `WBImageLoad *imageLoad` 图片加载逻辑

在`WBChatViewController`中, 图片消息可以加载Http资源, 是使用`WBChatCellConfig`中``WBImageLoad *imageLoad``

`- (void)imageView:(UIImageView *)imageView
        urlString:(NSString *)urlString
 placeholderImage:(UIImage *)placeholderImage;`
 
 当用户自己实现时, 可以继承`WBImageLoad` 重写此方法, 然后重新设置`WBChatCellConfig `单例的`imageLoad`属性. 然后使用自定义的加载逻辑.例如使用`	SDWebImage`
 
- `#import "UIImageView+WebCache.h"`

```
- (void)imageView:(UIImageView *)imageView urlString:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage{
[imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:placeholderImage];
}
 
```
 
###  2.2 头像占位图的使用

```
self.chatHeaderView.image = [WBChatCellConfig sharedInstance].placeholdHeaderImage;

```

### 2.3 图片占位图的使用

- WBChatMessageImageCell 的 `- (void)setCellModel:(WBChatMessageBaseCellModel *)cellModel
` 

```
NSString *imageLocalPath = imageFrameModel.messageModel.imagePath;
BOOL isLocalPath = ![imageLocalPath hasPrefix:@"http"];
UIImage *image = nil;
if (isLocalPath) {
    NSData *imageData = [NSData dataWithContentsOfFile:imageLocalPath];
    image = [UIImage imageWithData:imageData];
}
    
if (image && isLocalPath) {
    self.dialogCellImageView.image = image;
}
else if (imageLocalPath.length && self.tempChatModel.thumbImage){
    [[WBChatCellConfig sharedInstance].imageLoad imageView:self.dialogCellImageView
                                                 urlString:imageLocalPath
                                          placeholderImage:self.tempChatModel.thumbImage];
}
else if (self.tempChatModel.thumbImage) {
    self.dialogCellImageView.image = self.tempChatModel.thumbImage;
}
else{
    self.dialogCellImageView.image = [WBChatCellConfig sharedInstance].placeholdImage;
}
    
```


### 2.4 其他属性

`WBChatCellConfig` 单例的其他属性是控制消息控件的`frame`, 根据实际情况用户可以自己调整.

