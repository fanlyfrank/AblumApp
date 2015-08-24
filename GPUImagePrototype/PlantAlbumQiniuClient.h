//
//  PlantAlbumQiniuClient.h
//  GPUImagePrototype
//
//  Created by mac on 21/8/15.
//  Copyright (c) 2015 fanly. All rights reserved.
//

#import "PlantAlbumClient.h"

@interface PlantAlbumQiniuClient : NSObject

- (void)saveImage:(UIImage *)image toAlbum:(NSString *)albumCode albumName:(NSString *)albumName withProcessHandler:(void(^)(float percent))handler;

@end
