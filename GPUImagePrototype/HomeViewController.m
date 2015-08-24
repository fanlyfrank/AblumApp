//
//  HomeViewController.m
//  GPUImagePrototype
//
//  Created by mac on 29/7/15.
//  Copyright (c) 2015 fanly. All rights reserved.
//

#import "HomeViewController.h"
#import "NSLayoutConstraint+Util.h"
#import "ImageEditView.h"
#import "PlantAlbumClient.h"
#import "CreateNewAlbumController.h"
#import "AlbumViewController.h"

@interface HomeViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageEditViewDelegate> {
    UIImageView *originalImageView;
    ImageEditView *editPanel;
    PlantAlbumClient *albumClient;
}

@property (weak, nonatomic) IBOutlet UIButton *takePictureButton;

@property (weak, nonatomic) IBOutlet UIButton *plantAlbumButton;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    albumClient = [[PlantAlbumClient alloc] init];
}

#pragma mark actions
- (IBAction)takePicture:(id)sender {
    
    UIAlertController *actionVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *takePhotoAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self openPhoneCameraOrAlbum:UIImagePickerControllerSourceTypeCamera];
    }];
    
    UIAlertAction *selectExistAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self openPhoneCameraOrAlbum:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    
    [actionVC addAction:selectExistAction];
    [actionVC addAction:takePhotoAction];
    [actionVC addAction:cancleAction];
    
    [self presentViewController:actionVC animated:YES completion:nil];
}


- (IBAction)openAlbum:(id)sender {
    
}

#pragma private methods
- (void)openPhoneCameraOrAlbum:(UIImagePickerControllerSourceType) sourceType {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.delegate = self;
    
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    
    picker.sourceType = sourceType;
  
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)buildImageEditPanel {
    
    if (!editPanel) {
        editPanel = [[ImageEditView alloc] init];
        editPanel.delegate = self;
    }
    
    [self.view addSubview:editPanel];
    
    [NSLayoutConstraint constraintWithItem:editPanel
                                 attribute:NSLayoutAttributeLeading
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeLeading
                                multiplier:1
                                  constant:0
                                    toView:self.view];
    
    [NSLayoutConstraint constraintWithItem:editPanel
                                 attribute:NSLayoutAttributeTrailing
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeTrailing
                                multiplier:1
                                  constant:0
                                    toView:self.view];
    
    [NSLayoutConstraint constraintWithItem:editPanel
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeTop
                                multiplier:1
                                  constant:0
                                    toView:self.view];
    
    [NSLayoutConstraint constraintWithItem:editPanel
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.view
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1
                                  constant:0
                                    toView:self.view];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

/*- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    NSString *msg = nil ;
    
    if(error != NULL) {
        
        msg = @"保存图片失败" ;
        
    } else {
        
        msg = @"保存图片成功" ;
        
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];

    [alert show];
}*/


#pragma mark UIImagePickerController delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    [picker dismissViewControllerAnimated:YES completion:^(){
        if (image) {
            [self buildImageEditPanel];
            [editPanel fillEditImage:image];
        }
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ImageEditView delegate methods
- (void)imageEditView:(ImageEditView *)view didFinishedEdit:(UIImage *)image {
    
    NSMutableDictionary *existAlbums = [albumClient albums];
    
    if (existAlbums.count > 0) {
        
        AlbumViewController *albumViewConroller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([AlbumViewController class])];
        albumViewConroller.isForSaveImgSelect = YES;
        albumViewConroller.imgForSave = image;
        
        [self.navigationController  pushViewController:albumViewConroller animated:YES];
        
    } else {
        
        CreateNewAlbumController *createNewAlbumController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CreateNewAlbumController class])];
        createNewAlbumController.imageToSave = image;
        createNewAlbumController.type = CreateAlbumWithoutImageAndInit;
        
        [self.navigationController pushViewController:createNewAlbumController animated:YES];
    }
    
    [editPanel fillEditImage:nil];
    [editPanel removeFromSuperview];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)imageEditViewDidCancleEdit:(ImageEditView *)view {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [view removeFromSuperview];
}

@end
