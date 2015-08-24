//
//  SwitchCollectionViewLayout.m
//  GPUImagePrototype
//
//  Created by mac on 4/8/15.
//  Copyright (c) 2015 fanly. All rights reserved.
//

#import "SwitchCollectionViewLayout.h"

@implementation SwitchCollectionViewLayout

#define ACTIVE_DISTANCE 50
#define ZOOM_FACTOR 0.3

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        self.itemSize = CGSizeMake(145, 140);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
        self.minimumLineSpacing = 20;
        
    }
    
    return self;
}


//- (CGSize)collectionViewContentSize {
//    return CGSizeMake(145, 145);
//}



- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    for (UICollectionViewLayoutAttributes *attributes in array) {
        
        if (CGRectIntersectsRect(attributes.frame, rect)) {
        
            CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
            CGFloat normalizedDistance = distance / ACTIVE_DISTANCE;
            
            if (ABS(distance) < ACTIVE_DISTANCE) {
                CGFloat zoom = 1 + ZOOM_FACTOR * (1 - ABS(normalizedDistance));
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
                attributes.zIndex = round(zoom);
            }
        }
    }
    
    return array;
}

@end
