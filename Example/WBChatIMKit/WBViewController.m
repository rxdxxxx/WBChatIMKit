//
//  WBViewController.m
//  WBChatIMKit
//
//  Created by Ding RedRain on 03/13/2018.
//  Copyright (c) 2018 Ding RedRain. All rights reserved.
//

#import "WBViewController.h"
#import <WBChatIMKit/WBChatIMKit.h>
#import "WBChatKitDelegateObj.h"
@interface WBViewController ()

@end

@implementation WBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [WBChatKit sharedInstance].delegate = [WBChatKitDelegateObj sharedManager];
    
    [self loginTom:nil];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createAndSend:(id)sender {
    WBMessageModel *text = [WBMessageModel createWithText:[NSDate new].description];
    
    // 请查看这个方法的具体实现 !!!
    [[WBChatKit sharedInstance] sendTargetUserId:@"Jerry"
                                         message:text
                                         success:^(WBMessageModel * _Nonnull aMessage)
    {
        [self.view wb_makeToast:@"消息发送成功"];

    } error:^(WBMessageModel * _Nonnull aMessage, NSError * _Nonnull error) {
        [self.view wb_makeToast:error.description];

    }];
    
}

- (IBAction)pushRecentConnecter:(id)sender {
    WBChatListController *vc = [[WBChatListController alloc]init];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
    
}



- (IBAction)logOut{
    [[WBChatKit sharedInstance] closeWithCallback:^(BOOL succeeded, NSError * _Nonnull error) {
        if (succeeded) {
            WBLog(@"退出成功");
            [self.view wb_makeToast:@"退出成功"];
        }else{
            
            WBLog(@"退出失败");
            [self.view wb_makeToast:@"退出失败"];
        }
    }];
}

- (IBAction)loginTom:(id)sender {
    [self loginWithID:@"Tom"];

}

- (IBAction)loginJerry:(id)sender {
    [self loginWithID:@"Jerry"];
}

- (void)loginWithID:(NSString *)userId{
    
    [[WBChatKit sharedInstance] openWithClientId:userId
                                         success:^(NSString * _Nonnull clientId)
     {
         WBLog(@"链接成功");
         [self.view wb_makeToast:@"链接成功"];
         
     } error:^(NSError * _Nonnull error) {
         WBLog(@"链接失败: %@",
               error.description);
         [self.view wb_makeToast:@"链接失败"];
     }];
}

@end
