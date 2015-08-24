//
//  CreateNewAlbumController.h
//  GPUImagePrototype
//
//  Created by mac on 30/7/15.
//  Copyright (c) 2015 fanly. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CREATED_ALBUM_NOTIFICATION_KEY @"CreatedAlbumNotification"

typedef NS_ENUM(NSInteger, CreateAlbumType) {
    CreateAlbumWithoutImage,
    CreateAlbumWihtImage,
    CreateAlbumWithoutImageAndInit
};

@interface CreateNewAlbumController : UIViewController

@property (strong, nonatomic) UIImage *imageToSave;
@property (assign, nonatomic) CreateAlbumType type;

@end
