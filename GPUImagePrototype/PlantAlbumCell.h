//
//  PlantAlbumCell.h
//  GPUImagePrototype
//
//  Created by mac on 31/7/15.
//  Copyright (c) 2015 fanly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlantAlbum.h"

@interface PlantAlbumCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


- (void)fillPlantAlbum:(PlantAlbum *)album;

@end
