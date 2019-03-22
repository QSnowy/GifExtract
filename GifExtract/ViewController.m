//
//  ViewController.m
//  GifExtract
//
//  Created by snow on 2019/3/21.
//  Copyright © 2019年 snow. All rights reserved.
//

#import "ViewController.h"
#import "QSThumbPreviewView.h"
#import "QSImagePreviewView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "SDWebImageGIFCoder.h"
#import "UIAlertController+Simple.h"

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, QSImagePreviewDelegate, QSThumbPreviewDelegate>

@property (nonatomic, strong) QSImagePreviewView *previewView;
@property (nonatomic, strong) QSThumbPreviewView *thumbView;
@property (nonatomic, assign) NSUInteger currentIndex;
@property (weak, nonatomic) IBOutlet UIButton *emptyButton;

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
    
    QSThumbPreviewView *thumbView = [[QSThumbPreviewView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 80, self.view.bounds.size.width, 50) thumbs:nil];
    thumbView.delegate = self;
    [self.view addSubview:thumbView];
    _thumbView = thumbView;
    
    self.emptyButton.hidden = NO;
    [self.view bringSubviewToFront:self.emptyButton];
    
    
}
- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    _previewView.frame = self.view.bounds;
    [_previewView scrollToIndex:_currentIndex animated:YES];
    _thumbView.frame = CGRectMake(0, self.view.bounds.size.height - 80, self.view.bounds.size.width, 60);
    
}

- (IBAction)pickPhotoAction:(UIBarButtonItem *)sender {
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    [self handleAuthStatus:status];
    
}
- (IBAction)pickAction:(id)sender {
    
    [self pickPhotoAction:nil];
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
    _thumbView.currentIndex = index;
    
}

- (void)thumPreview:(QSThumbPreviewView *)view didScrollToIndex:(NSInteger)index {
    
    _currentIndex = index;
    _previewView.currentIndex = index;
    
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
    
    NSURL *imageURL;
    NSData *imageData;
    
    if (@available(iOS 11.0, *)) {
        
        imageURL = [info objectForKey:UIImagePickerControllerImageURL];
        imageData = [NSData dataWithContentsOfURL:imageURL];
        [self handlePickedImageData:imageData];
        
    } else {
        
        // Fallback on earlier versions
        imageURL = [info objectForKey:UIImagePickerControllerReferenceURL];
        PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[imageURL] options:nil];
        
        [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj isKindOfClass:[PHAsset class]]){
                // 解析phasset，拿到image
                PHAsset *asset = (PHAsset *)obj;
                [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                    // 处理图片数据
                    [self handlePickedImageData:imageData];
                }];
            }
        }];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)showSimpleAlertWithMsg:(NSString *)msg {
    
    UIAlertController *alertCtrl = [UIAlertController simpleAlertWithTitle:@"提示" msg:msg];
    [self presentViewController:alertCtrl animated:YES completion:nil];
    
}

- (void)handlePickedImageData:(NSData *)imageData {
    
    UIImage *animationImg = [[SDWebImageGIFCoder sharedCoder] decodedImageWithData:imageData];
    if (animationImg.images.count == 0){
        
        [self showSimpleAlertWithMsg:@"老弟，怎么肥事，这个不是GIF啊！！"];
        [_previewView refreshSources:@[animationImg]];
        [_thumbView refreshThumbs:@[animationImg]];
        
    }else {
        
        [_previewView refreshSources:animationImg.images];
        [_thumbView refreshThumbs:animationImg.images];
    }
    
    self.emptyButton.hidden = YES;

}

@end
