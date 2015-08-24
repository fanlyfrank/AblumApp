//
//  PlantAlbumClient.m
//  GPUImagePrototype
//
//  Created by mac on 30/7/15.
//  Copyright (c) 2015 fanly. All rights reserved.
//
#import "PlantAlbumClient.h"
#import "PlantAlbum.h"

#define kAlbumKey @"ablumKey"

@interface PlantAlbumClient ()

@end

@implementation PlantAlbumClient

- (id)init
{
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

#pragma mark public methods
- (void)saveImage:(UIImage *)image toAlbum:(NSString *)albumCode albumName:(NSString *)albumName{
    
    NSMutableDictionary *albumDic = [self buildSaveObjectWith:image albumName:albumName albumCode:albumCode];
    
    [self archiveDataToFile:albumDic];
    
}

- (void)saveImage:(UIImage *)image toAlbum:(NSString *)albumCode albumName:(NSString *)albumName completion:(void (^) (BOOL finished))completion {
    
    NSMutableDictionary *albumDic = [self buildSaveObjectWith:image albumName:albumName albumCode:albumCode];
    
    BOOL success = [self archiveDataToFile:albumDic];
    
    completion(success);
    
}

- (void)deleteImageWithName:(NSString *)imageName andAlbumCode:(NSString *)albumCode {
    
    PlantAlbum *albumForUpdate;
    
    NSMutableDictionary *albums = [self albums];
    
    albumForUpdate = [albums objectForKey:albumCode];
    [albumForUpdate.images removeObject:imageName];
    
    //delete photo in file system
    NSString *deleteImgPaht = [NSString stringWithFormat:@"%@/Documents/%@.jpg", NSHomeDirectory(), imageName];
    
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    
#ifdef DEBUG
    
    NSError *error;
    [defaultManager removeItemAtPath:deleteImgPaht error:&error];
    if (error) {
        NSLog(@"delete file error: %@", error);
    }
    
#else
    
    [defaultManager removeItemAtPath:deleteImgPaht error:nil];

#endif
    
    [albums setObject:albumForUpdate forKey:albumCode];
    
    [self archiveDataToFile:albums];
    
}

- (NSArray *)imagesFromAlbum:(NSString *)albumCode {
    
    NSArray *result;
    
    PlantAlbum *album = [self albumWithCode:albumCode];
    
    result = album.images;
    
    return result;
}

- (NSMutableDictionary *)albums {
    
    NSMutableDictionary *result;
    
    result = [self unarchiveDataFromFile];
    
    return result;
}

- (void)buildAlbumWith:(NSString *)name {
    
    NSMutableDictionary *existAlbums = [self albums];
    
    if (!existAlbums) {
        existAlbums = [[NSMutableDictionary alloc] initWithCapacity:1];
    }
    
    PlantAlbum *newOne = [[PlantAlbum alloc] init];
    newOne.albumName = name;
    newOne.albumCode = gen_uuid();
    
    [existAlbums setObject:newOne forKey:newOne.albumCode];
    
    [self archiveDataToFile:existAlbums];
}

- (void)removeAlbumWiht:(NSString *)code {
    
}

- (PlantAlbum *)albumWithCode:(NSString *)albumCode {
    return [[self albums] objectForKey:albumCode];
}

- (NSString *)saveImageAndGetName:(UIImage *)image {
    
    NSString *result = gen_uuid();
    
    NSString *file = [NSString stringWithFormat:@"%@/Documents/%@.jpg", NSHomeDirectory(), result];
    
    [UIImageJPEGRepresentation(image, 0) writeToFile:file atomically:YES];
    return result;
}

NSString * gen_uuid()
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString *)uuid_string_ref];
    CFRelease(uuid_string_ref);
    return uuid;
}

- (NSString *)dataFilePath {
    
    NSURL *filePath = [[[NSFileManager defaultManager]
                        URLsForDirectory:NSDocumentDirectory
                        inDomains:NSUserDomainMask] lastObject];
    
    NSString *path = [filePath.path stringByAppendingPathComponent:@"album.plist"];
 
    return path;
}

#pragma mark private method
- (BOOL)archiveDataToFile:(NSMutableDictionary *)albumDic {
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    
    [archiver encodeObject:albumDic forKey:kAlbumKey];
    [archiver finishEncoding];
    
    NSString *filePath = [self dataFilePath];
    
#ifdef DEBUG
    
    NSError *error;
    BOOL success = [data writeToFile:filePath options:0 error:&error];
    if (!success) {
        NSLog(@"success %@", error);
    }
    
#else
    
    [data writeToFile:filePath atomically:YES];
    
#endif
    
    return success;
}

- (NSMutableDictionary *)unarchiveDataFromFile {
    
    NSMutableDictionary *result;
 
    NSMutableData *data = [[NSMutableData alloc] initWithContentsOfFile:[self dataFilePath]];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    result = [unarchiver decodeObjectForKey:kAlbumKey];
    [unarchiver finishDecoding];
    
    return result;
}

- (NSMutableDictionary *)buildSaveObjectWith:(UIImage *)image
                                   albumName:(NSString *)albumName
                                   albumCode:(NSString *)albumCode {
    
    NSData *imgData= UIImageJPEGRepresentation(image, 0);
    image =[UIImage imageWithData:imgData];
    
    
    PlantAlbum *album;
    
    NSMutableDictionary *albumDic;
    if (albumCode) {
        
        albumDic = [self albums];
        
        album = [self albumWithCode:albumCode];
        
        
    } else {
        
        albumDic = [self albums];
        if (!albumDic) {
            albumDic = [[NSMutableDictionary alloc] initWithCapacity:1];
        }
        
        album = [[PlantAlbum alloc] init];
        
        album.albumName = albumName;
        album.albumCode = gen_uuid();
        
    }
    
    [album.images addObject:[self saveImageAndGetName:image]];
    [albumDic setObject:album forKey:album.albumCode];
    
    return albumDic;
}



@end
