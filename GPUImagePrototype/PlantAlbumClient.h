//
//  PlantAlbumClient.h
//  GPUImagePrototype
//
//  Created by mac on 30/7/15.
//  Copyright (c) 2015 fanly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PlantAlbum.h"
/*
 * name, user define
 * code, system generate
 */

@interface PlantAlbumClient : NSObject

- (void)saveImage:(UIImage *)image toAlbum:(NSString *)albumCode albumName:(NSString *)albumName;

- (void)saveImage:(UIImage *)image toAlbum:(NSString *)albumCode albumName:(NSString *)albumName completion:(void (^) (BOOL finished))completion;

- (void)deleteImageWithName:(NSString *)imageName andAlbumCode:(NSString *)albumCode;

- (NSArray *)imagesFromAlbum:(NSString *)albumCode;

- (NSMutableDictionary *)albums;

- (void)buildAlbumWith:(NSString *)name;

- (void)removeAlbumWiht:(NSString *)code;

- (PlantAlbum *)albumWithCode:(NSString *)albumCode;

- (NSString *)saveImageAndGetName:(UIImage *)image;

NSString * gen_uuid();

- (NSString *)dataFilePath;

@end
