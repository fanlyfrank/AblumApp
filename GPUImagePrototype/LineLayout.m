//
//  LineLayout.m
//  CollectionViewTest
//
//  Created by mac on 4/8/15.
//  Copyright (c) 2015 fanly. All rights reserved.
//

#import "LineLayout.h"

#define ACTIVE_DISTANCE 500
#define ZOOM_FACTOR 0.3

@implementation LineLayout

- (void)prepareLayout {
    self.itemSize = CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.height - 80);
    //self.itemSize = self.collectionView.frame.size;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.minimumLineSpacing = 0;
}

/*- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return NO;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    attributes.size = CGSizeMake(self.collectionView.frame.size.width, self.collectionView.frame.size.width);
    
    return attributes;
}*/

@end
