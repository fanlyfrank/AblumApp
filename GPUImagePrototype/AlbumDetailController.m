//
//  AlbumDetailController.m
//  GPUImagePrototype
//
//  Created by mac on 31/7/15.
//  Copyright (c) 2015 fanly. All rights reserved.
//

#import "AlbumDetailController.h"
#import "PlantAlbumClient.h"
#import "PlantAlbumCell.h"
#import "LineLayout.h"
#import "PlantAlbumQiniuClient.h"

@interface AlbumDetailController () <UICollectionViewDelegateFlowLayout> {
    PlantAlbumClient *albumClient;
    PlantAlbum *album;
    BOOL isBigImgShow;
    LineLayout *lineLayout;
    UICollectionViewLayout *flowLayout;
    PlantAlbumQiniuClient *qiniuClient;
}

@end

@implementation AlbumDetailController

static NSString * const reuseIdentifier = @"PlantAlbumCell";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    albumClient = [[PlantAlbumClient alloc] init];
    qiniuClient = [[PlantAlbumQiniuClient alloc] init];
    album = [[albumClient albums] objectForKey:self.albumCode];
    lineLayout = [[LineLayout alloc] init];
    flowLayout = self.collectionView.collectionViewLayout;
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([PlantAlbumCell class]) bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
    
    isBigImgShow = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"故事分享"
                                              style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(genImgStory:)];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return album.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PlantAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    
    NSString *imageName = album.images[indexPath.row];
    UIImage *img = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/Documents/%@.jpg", NSHomeDirectory(), imageName]];
    //img = [UIImage imageWithCGImage:[img CGImage] scale:1 orientation:UIImageOrientationRight];
    
    if (!isBigImgShow) {
        NSData *imgData= UIImageJPEGRepresentation(img, 0.1);
        img =[UIImage imageWithData:imgData];
    }
    
    cell.imageView.image = img;
    cell.nameLabel.text = [NSString stringWithFormat:@"图片%ld", indexPath.row + 1];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    isBigImgShow = !isBigImgShow;
    if (isBigImgShow) {
        [collectionView setCollectionViewLayout:lineLayout animated:YES];
    } else {
        [collectionView setCollectionViewLayout:flowLayout animated:YES];
    }
}


- (void)genImgStory:(UIBarButtonItem *)sender {
    NSString *imageName = album.images[0];
    UIImage *img = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/Documents/%@.jpg", NSHomeDirectory(), imageName]];
    
    UIAlertController *processVC = [UIAlertController alertControllerWithTitle:@"上传进度" message:@"卖萌" preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:processVC animated:YES completion:nil];
    
    [qiniuClient saveImage:img toAlbum:nil albumName:nil withProcessHandler:^(float percent) {
       
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            NSString *title = [NSString stringWithFormat:@"uploaded %f", percent];
            
            processVC.message = title;
            
            if (percent > 0.99) {
                [processVC dismissViewControllerAnimated:YES completion:nil];
            }

        });
        
    }];
}

@end
