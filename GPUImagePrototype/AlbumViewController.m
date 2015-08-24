//
//  AlbumViewController.m
//  GPUImagePrototype
//
//  Created by mac on 30/7/15.
//  Copyright (c) 2015 fanly. All rights reserved.
//

#import "AlbumViewController.h"
#import "PlantAlbumClient.h"
#import "PlantAlbumCell.h"
#import "AlbumDetailController.h"
#import "CreateNewAlbumController.h"

@interface AlbumViewController () {
    PlantAlbumClient *albumClient;
    NSArray *albums;
}

@end

@implementation AlbumViewController

static NSString * const reuseIdentifier = @"PlantAlbumCell";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    albumClient = [[PlantAlbumClient alloc] init];
    albums = [[albumClient albums] allValues];
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([PlantAlbumCell class]) bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCollectionView:) name:CREATED_ALBUM_NOTIFICATION_KEY object:nil];


}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (self.isForSaveImgSelect) {
        self.navigationItem.title = @"选择要保存的相册";
    }
}

- (void)reloadCollectionView:(NSNotification *)notification {
    albums = [[albumClient albums] allValues];
    [self.collectionView reloadData];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return albums.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PlantAlbumCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    
    PlantAlbum *album = albums[indexPath.row];
    
    NSString *imageName = [album.images lastObject];
    UIImage *img = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/Documents/%@.jpg", NSHomeDirectory(), imageName]];
    //img = [UIImage imageWithCGImage:[img CGImage] scale:1 orientation:UIImageOrientationRight];
    NSData *imgData= UIImageJPEGRepresentation(img, 0.1);
    img =[UIImage imageWithData:imgData];
    
    cell.nameLabel.text = album.albumName;
    cell.imageView.image = img;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PlantAlbum *album = albums[indexPath.row];
    
    if (self.isForSaveImgSelect && self.imgForSave) {
        
        [albumClient saveImage:self.imgForSave toAlbum:album.albumCode albumName:nil completion:^(BOOL finished) {
            
            if (finished) {
                
                albums = [[albumClient albums] allValues];
                [self.collectionView reloadData];
                self.imgForSave = nil;
                self.navigationItem.title = @"相册";
                
            }
        }];
        
        
    } else {
        
        AlbumDetailController *albumDetailConroller = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([AlbumDetailController class])];
        
        albumDetailConroller.albumCode = album.albumCode;
        
        [self.navigationController pushViewController:albumDetailConroller animated:YES];
    }
    
}

- (IBAction)addNewAlbum:(id)sender {
    
    CreateNewAlbumController *createNewAlbumController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([CreateNewAlbumController class])];
    
    if (self.isForSaveImgSelect) {
        createNewAlbumController.type = CreateAlbumWihtImage;
    } else {
        createNewAlbumController.type = CreateAlbumWithoutImage;
    }
    
    [self.navigationController pushViewController:createNewAlbumController animated:YES];
    
}

@end
