//
//  AlbumViewController.h
//  GPUImagePrototype
//
//  Created by mac on 30/7/15.
//  Copyright (c) 2015 fanly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumViewController : UICollectionViewController

@property (assign, nonatomic) BOOL isForSaveImgSelect;

@property (strong, nonatomic) UIImage *imgForSave;
@end
