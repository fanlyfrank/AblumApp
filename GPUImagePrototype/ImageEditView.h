//
//  ImageEditView.h
//  GPUImagePrototype
//
//  Created by mac on 29/7/15.
//  Copyright (c) 2015 fanly. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageEditView;

@protocol ImageEditViewDelegate <NSObject>

@required
- (void)imageEditViewDidCancleEdit:(ImageEditView *)view;
- (void)imageEditView:(ImageEditView *)view didFinishedEdit:(UIImage *)image;

@end

@interface ImageEditView : UIView

@property (assign, nonatomic) id <ImageEditViewDelegate> delegate;

- (void)fillEditImage:(UIImage *)image;

@end
