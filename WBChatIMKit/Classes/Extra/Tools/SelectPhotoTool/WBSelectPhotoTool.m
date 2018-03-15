//
//  OPSelectPhotoTool.m
//  WBChat
//
//  Created by RedRain on 2017/8/1.
//  Copyright © 2017年 RedRain. All rights reserved.
//

#import "WBSelectPhotoTool.h"

#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <Photos/Photos.h>


@interface WBSelectPhotoTool ()<UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, weak) UIViewController * showController;
@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
@implementation WBSelectPhotoTool
#pragma mark -  Life Cycle


// 当得到照片后，调用该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    
    __block UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.showController dismissViewControllerAnimated:YES completion:nil];
    
    if ([self.delegate respondsToSelector:@selector(toolWillSelectImage:)]) {
        [self.delegate toolWillSelectImage:self];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        // 转换一下,防止得到的图片过大.
        
        image = [UIImage imageWithData:UIImageJPEGRepresentation(image,0.8)];
        
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if ([self.delegate respondsToSelector:@selector(tool:didSelectImage:)]) {
                [self.delegate tool:self didSelectImage:image];
            }
        });
    });
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: { //!< 拍照
            [self visitCamera];
        }
            break;
            
        case 1: { //!< 相册
            
            [self visitPhotoLibrary];
        }
            break;
    }
}

#pragma mark -  CustomDelegate
#pragma mark -  Event Response
#pragma mark -  Private Methods
- (void)visitPhotoLibrary{
    
    UIImagePickerController *imagePick = [[UIImagePickerController alloc] init];
//    [imagePick.navigationBar setBarTintColor:[UIColor op_navigationBarColor]];
    imagePick.navigationBar.translucent = NO;//透明
    
    imagePick.view.backgroundColor = [UIColor whiteColor];
    imagePick.delegate = self;
    imagePick.allowsEditing = NO;
    imagePick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePick.mediaTypes=[NSArray arrayWithObject:@"public.image"];
    [self.showController presentViewController:imagePick animated:YES completion:nil];
}
- (void)visitCamera {
    
    // 1,判断相机能否使用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [[[UIAlertView alloc] initWithTitle:@"你的设备不具备拍照功能" message:nil delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
        return;
    }
    
    
    // 2.判断相机是否授权
    AVAuthorizationStatus author = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (author == AVAuthorizationStatusRestricted || author == AVAuthorizationStatusDenied) {
        //展示相机权限的提示
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            [[[UIAlertView alloc] initWithTitle:@"无法访问" message:@"相机被禁用，请在iPhone的“设置-隐私-相机”选项中，允许访问你的相机" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
            
        });
        return;
    }
    else if(AVAuthorizationStatusNotDetermined==author)
    {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted)
            {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    
                    UIImagePickerController *imagePick = [[UIImagePickerController alloc]init];
                    imagePick.delegate = self;
                    imagePick.allowsEditing = NO;
                    imagePick.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [self.showController.navigationController presentViewController:imagePick animated:YES completion:nil];
                });
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    [[[UIAlertView alloc] initWithTitle:@"无法访问" message:@"相机被禁用，请在iPhone的“设置-隐私-相机”选项中，允许访问你的相机" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
                    
                });
            }
        }];
    }
    else
    {
        // 3,展示相机
        
        UIImagePickerController *imagePick = [[UIImagePickerController alloc]init];
        imagePick.delegate = self;
        imagePick.allowsEditing = NO;
        imagePick.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.showController.navigationController presentViewController:imagePick animated:YES completion:nil];
    }
}

#pragma mark -  Public Methods

- (void)showSheetInController:(UIViewController *)showController{
    self.showController = showController;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
    [actionSheet showInView:self.showController.view];
}

- (void)visitCameraInController:(UIViewController *)showController{
    self.showController = showController;
    [self visitCamera];
}

- (void)visitPhotoLibraryInController:(UIViewController *)showController{
    self.showController = showController;
    [self visitPhotoLibrary];
}

#pragma mark -  Getters and Setters
@end
#pragma clang diagnostic pop
