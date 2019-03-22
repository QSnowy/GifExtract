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
#import "SDWebImageGIFCoder.h"
#import "UIAlertController+Simple.h"

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, QSImagePreviewDelegate>

@property (nonatomic, strong) QSImagePreviewView *previewView;
@property (nonatomic, assign) NSUInteger currentIndex;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
}

- (void)setupUI {
    
    QSImagePreviewView *previewView = [[QSImagePreviewView alloc] initWithFrame:self.view.bounds withSources:nil];
    previewView.delegate = self;
    [self.view addSubview:previewView];
    _previewView = previewView;
    
    
}
- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    _previewView.frame = self.view.bounds;
    [_previewView scrollToIndex:_currentIndex animated:YES];
    
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
        pickerVC.delegate = self;
        [self presentViewController:pickerVC animated:YES completion:nil];
        return;
    }
    
    [self showSimpleAlertWithMsg:@"给我相册权限啊。。。"];
    
}
// MARK: - qspreview delegate
- (void)imagePreview:(QSImagePreviewView *)preview didScrollToIndex:(NSInteger)index {
    
    _currentIndex = index;
    
}
// MARK: - ImagePicker Delegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    
    
    // 这个获取到的image是静态图，需要根据它的fileURL获取原始数据
    UIImage *originImg = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if (!originImg){
        [self showSimpleAlertWithMsg:@"图片是空的"];
        return;
    }
    if (@available(iOS 11.0, *)) {
        
        NSURL *imageURL = [info objectForKey:UIImagePickerControllerImageURL];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *animationImg = [[SDWebImageGIFCoder sharedCoder] decodedImageWithData:imageData];
        [_previewView refreshSources:animationImg.images];

        
    } else {
        // Fallback on earlier versions
        NSURL *imageURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [_previewView refreshSources:originImg.images];
    
}

- (void)showSimpleAlertWithMsg:(NSString *)msg {
    
    UIAlertController *alertCtrl = [UIAlertController simpleAlertWithTitle:@"提示" msg:msg];
    [self presentViewController:alertCtrl animated:YES completion:nil];
    
}

@end
