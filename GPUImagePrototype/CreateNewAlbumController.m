//
//  CreateNewAlbumController.m
//  GPUImagePrototype
//
//  Created by mac on 30/7/15.
//  Copyright (c) 2015 fanly. All rights reserved.
//

#import "CreateNewAlbumController.h"
#import "AlbumViewController.h"
#import "PlantAlbumClient.h"
#import "PlantAlbum.h"

@interface CreateNewAlbumController ()
@property (strong, nonatomic) PlantAlbumClient *albumClient;
@property (weak, nonatomic) IBOutlet UITextField *albumNameLable;
@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@end

@implementation CreateNewAlbumController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _albumClient = [[PlantAlbumClient alloc] init];
    
    NSString *title;
    
    switch (self.type) {
            
        case CreateAlbumWihtImage:
            title = @"新建相册，刚才的图片会保存在该相册中！";
            break;
            
        case CreateAlbumWithoutImage:
            title = @"新建一个相册！";
            break;
            
        case CreateAlbumWithoutImageAndInit:
            title = @"亲，您还没有相册，请创建一个，刚才的图片会保存在创建的相册中!";
            break;
        
        default:
            break;
    }
    
    self.titleLable.text = title;
}

- (IBAction)createAlbum:(id)sender {
    
    NSString *albumName = self.albumNameLable.text;
    
    if (albumName.length > 0) {
        
        if (self.imageToSave) {
            
            [self.albumClient saveImage:self.imageToSave toAlbum:nil albumName:albumName completion:^(BOOL finished) {
                
                if (finished) {
                    [self.navigationController popViewControllerAnimated:NO];
                    AlbumViewController *albumViewConroller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([AlbumViewController class])];
                    [self.navigationController  pushViewController:albumViewConroller animated:YES];

                }
                
            }];
            
        } else {
            
            [self.albumClient buildAlbumWith:albumName];
            
            [self.navigationController popViewControllerAnimated:NO];
        }
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:CREATED_ALBUM_NOTIFICATION_KEY object:nil];
        
    } else {
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"亲，这是警告！" message:@"名字是空的，弄啥嘞！" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *alert = [UIAlertAction actionWithTitle:@"知道了！" style:UIAlertActionStyleCancel handler:nil];
        
        [alertVC addAction:alert];
        
        [self presentViewController:alertVC animated:YES completion:nil];
    
    }
    
}

@end
