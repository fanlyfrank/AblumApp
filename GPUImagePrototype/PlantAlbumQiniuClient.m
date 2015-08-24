//
//  PlantAlbumQiniuClient.m
//  GPUImagePrototype
//
//  Created by mac on 21/8/15.
//  Copyright (c) 2015 fanly. All rights reserved.
//

#import <QiniuSDK.h>
#import "PlantAlbumQiniuClient.h"

const static QNUploadManager *upManger;
static NSString  *QINIU_KEY = @"SwUk49vEBkJGOCTS38vWYBIbc7vTDueuyD1IolVk:RdjZlDRKPJ24fXLs2hnFTQ40dpE=:eyJzY29wZSI6InZidXkiLCJkZWFkbGluZSI6MTQ0MDQwNzcxNX0=";

@implementation PlantAlbumQiniuClient

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        if (!upManger) {
            upManger = [[QNUploadManager alloc] init];
        }
        
    }
    
    return self;
}

- (void)saveImage:(UIImage *)image toAlbum:(NSString *)albumCode albumName:(NSString *)albumName withProcessHandler:(void(^)(float percent))handler{
    
    
    QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:nil
                           
                                               progressHandler:^(NSString *key, float percent) {
                                                   handler(percent);
                                               }
                                                        params:nil
                                                      checkCrc:NO
                                            cancellationSignal:nil];
    
    NSData *imgData = UIImagePNGRepresentation(image);

    NSString *imgKey = gen_uuid();
    
    [upManger putData:imgData
                  key:imgKey
                token:QINIU_KEY
             complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                 
                 NSLog(@"key :%@", key);
                 NSLog(@"info :%@", info);
                 NSLog(@"resp :%@", resp);
    
    } option:opt];
}

@end
