//
//  PlantAlbum.h
//  GPUImagePrototype
//
//  Created by mac on 30/7/15.
//  Copyright (c) 2015 fanly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlantAlbum : NSObject <NSCoding, NSCopying>

@property (copy, nonatomic) NSString *albumName;
@property (copy, nonatomic) NSString *albumCode;

@property (copy, nonatomic) NSMutableArray *images;

@end
