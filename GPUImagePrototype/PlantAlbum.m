//
//  PlantAlbum.m
//  GPUImagePrototype
//
//  Created by mac on 30/7/15.
//  Copyright (c) 2015 fanly. All rights reserved.
//

#import "PlantAlbum.h"

#define kAblumName @"ablumName"
#define kAblumCode @"ablumcode"
#define kImages @"images"

@implementation PlantAlbum

@synthesize albumName;
@synthesize albumCode;

@synthesize images;

- (id) init {
    
    self = [super init];
    
    if (self) {
        images = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {

    [aCoder encodeObject:albumName forKey:kAblumName];
    [aCoder encodeObject:albumCode forKey:kAblumCode];
    [aCoder encodeObject:images forKey:kImages];

}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        
        albumName = [aDecoder decodeObjectForKey:kAblumName];
        albumCode = [aDecoder decodeObjectForKey:kAblumCode];
        images = [aDecoder decodeObjectForKey:kImages];
    
    }
    
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    
    PlantAlbum *copy = [[[self class] allocWithZone:zone] init];
    
    copy.albumName = [self.albumName copyWithZone:zone];
    copy.albumCode = [self.albumCode copyWithZone:zone];
    copy.images = [self.images copyWithZone:zone];
    
    return copy;
}

@end
