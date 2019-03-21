//
//  ViewController.m
//  GifExtract
//
//  Created by snow on 2019/3/21.
//  Copyright © 2019年 snow. All rights reserved.
//

#import "ViewController.h"
#import "QSImagePreviewView.h"
#import <Photos/Photos.h>
#import "UIAlertController+Simple.h"

@interface ViewController () <UIImagePickerControllerDelegate>

@property (nonatomic, strong) QSImagePreviewView *previewView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    
    QSImagePreviewView *previewView = [[QSImagePreviewView alloc] initWithFrame:self.view.bounds withSources:nil];
    [self.view addSubview:previewView];
    _previewView = previewView;
    
    
}
- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    _previewView.frame = self.view.bounds;
}


- (IBAction)pickPhotoAction:(UIBarButtonItem *)sender {
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    [self handleAuthStatus:status];
    
}

- (void)handleAuthStatus:(PHAuthorizationStatus)status {
    
    if (status == PHAuthorizationStatusNotDetermined || status == PHAuthorizationStatusRestricted){
        
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            [self handleAuthStatus:status];
        }];
        return;

    }else if (status == PHAuthorizationStatusAuthorized){
        
        BOOL photoLibAvailable = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        if (!photoLibAvailable){
            [self showSimpleAlertWithMsg:@"设备没有相册功能呢"];
            return;
        }
        
        UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
        [self presentViewController:pickerVC animated:YES completion:nil];
        return;
    }
    
    [self showSimpleAlertWithMsg:@"给我相册权限啊。。。"];
    
    
    
}

// MARK: - ImagePicker Delegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    
    
    UIImage *originImg = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (!originImg){
        [self showSimpleAlertWithMsg:@"图片是空的"];
        return;
    }
    
    [_previewView refreshSources:@[originImg]];
    
    
}

- (void)showSimpleAlertWithMsg:(NSString *)msg {
    
    UIAlertController *alertCtrl = [UIAlertController simpleAlertWithTitle:@"提示" msg:msg];
    [self presentViewController:alertCtrl animated:YES completion:nil];
    
}

@end
