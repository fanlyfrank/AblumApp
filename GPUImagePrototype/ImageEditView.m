//
//  ImageEditView.m
//  GPUImagePrototype
//
//  Created by mac on 29/7/15.
//  Copyright (c) 2015 fanly. All rights reserved.
//

#import "ImageEditView.h"
#import "NSLayoutConstraint+Util.h"
#import "GPUImage.h"

@interface ImageEditView () <UIScrollViewDelegate, UIAlertViewDelegate> {
    GPUImagePicture *stillImageSource;
    UIImage *originalImg;
}

//subviews
@property (strong, nonatomic) UIScrollView *imageContainer;
@property (strong, nonatomic) UIScrollView *visionEffectContainer;
@property (strong, nonatomic) UIImageView *originalImageView;
@property (strong, nonatomic) NSMutableArray *visionEffectBtns;
@property (strong, nonatomic) UIButton *saveImageBtn;
@property (strong, nonatomic) UIButton *cancleEditBtn;

@end

@implementation ImageEditView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
        
        _imageContainer = [[UIScrollView alloc] init];
        self.imageContainer.translatesAutoresizingMaskIntoConstraints = NO;
        self.imageContainer.maximumZoomScale = 2.0;
        self.imageContainer.minimumZoomScale = .5;
        self.imageContainer.backgroundColor = [UIColor blackColor];
        self.imageContainer.delegate = self;
        
        _visionEffectContainer = [[UIScrollView alloc] init];
        self.visionEffectContainer.translatesAutoresizingMaskIntoConstraints = NO;
        self.visionEffectContainer.backgroundColor = [UIColor grayColor];
        
        _originalImageView = [[UIImageView alloc] init];
        self.originalImageView.contentMode = UIViewContentModeScaleAspectFit;
        
        _visionEffectBtns = [[NSMutableArray alloc] initWithCapacity:4];
        
        for (int i = 0; i < 3; i ++) {
            
            UIButton *btn = [[UIButton alloc] init];
            btn.translatesAutoresizingMaskIntoConstraints = NO;
            btn.tag = i;
            NSString *title;
            
                
            switch (i) {
                case 0:
                    title = @"Sepia";
                    break;
                    
                case 1:
                    title = @"GaussianBlur";
                    break;
                
                case 2:
                    title = @"Hue";
                    break;
                    
                default:
               
                    break;
            }
            
            [btn setTitle:title forState:UIControlStateNormal];
             
            [self.visionEffectBtns addObject:btn];
            [self.visionEffectContainer addSubview:btn];
            
            [btn addTarget:self action:@selector(changeFilter:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        _saveImageBtn = [[UIButton alloc] init];
        self.saveImageBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [self.saveImageBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [self.saveImageBtn setTitle:@"保存" forState:UIControlStateNormal];
        [self.saveImageBtn addTarget:self action:@selector(saveImage:) forControlEvents:UIControlEventTouchUpInside];
        
        _cancleEditBtn = [[UIButton alloc] init];
        self.cancleEditBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [self.cancleEditBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.cancleEditBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.cancleEditBtn addTarget:self action:@selector(cancleEdit:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.imageContainer addSubview:self.originalImageView];
        [self addSubview:self.imageContainer];
        [self addSubview:self.visionEffectContainer];
        [self addSubview:self.saveImageBtn];
        [self addSubview:self.cancleEditBtn];
        
        [NSLayoutConstraint constraintWithItem:self.imageContainer
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1
                                      constant:0
                                        toView:self];
        
        [NSLayoutConstraint constraintWithItem:self.imageContainer
                                     attribute:NSLayoutAttributeLeading
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeLeading
                                    multiplier:1
                                      constant:0
                                        toView:self];
        
        [NSLayoutConstraint constraintWithItem:self.imageContainer
                                     attribute:NSLayoutAttributeTrailing
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeTrailing
                                    multiplier:1
                                      constant:0
                                        toView:self];
        
        
        [NSLayoutConstraint constraintWithItem:self.visionEffectContainer
                                     attribute:NSLayoutAttributeLeading
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeLeading
                                    multiplier:1
                                      constant:0
                                        toView:self];
        
        [NSLayoutConstraint constraintWithItem:self.visionEffectContainer
                                     attribute:NSLayoutAttributeTrailing
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeTrailing
                                    multiplier:1
                                      constant:0
                                        toView:self];
        
        [NSLayoutConstraint constraintWithItem:self.visionEffectContainer
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.imageContainer
                                     attribute:NSLayoutAttributeBottom
                                    multiplier:1
                                      constant:0
                                        toView:self];
        
        [NSLayoutConstraint constraintWithItem:self.visionEffectContainer
                                     attribute:NSLayoutAttributeHeight
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.visionEffectContainer
                                     attribute:NSLayoutAttributeHeight
                                    multiplier:0
                                      constant:60
                                        toView:self.visionEffectContainer];
        
        
        [NSLayoutConstraint constraintWithItem:self.visionEffectContainer
                                     attribute:NSLayoutAttributeBottom
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeBottom
                                    multiplier:1
                                      constant:0
                                        toView:self];
        
        UIButton *firstButton = [self.visionEffectBtns firstObject];
        UIButton *lastButton = [self.visionEffectBtns lastObject];
        
        [NSLayoutConstraint constraintWithItem:self.visionEffectContainer
                                     attribute:NSLayoutAttributeTrailing
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:lastButton
                                     attribute:NSLayoutAttributeTrailing
                                    multiplier:1
                                      constant:5 * 2
                                        toView:self.visionEffectContainer];
        
        [NSLayoutConstraint constraintWithItem:firstButton
                                     attribute:NSLayoutAttributeLeading
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.visionEffectContainer
                                     attribute:NSLayoutAttributeLeading
                                    multiplier:1
                                      constant:5 * 2
                                        toView:self.visionEffectContainer];
        
        [NSLayoutConstraint constraintWithItem:lastButton
                                     attribute:NSLayoutAttributeHeight
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.visionEffectContainer
                                     attribute:NSLayoutAttributeHeight
                                    multiplier:1
                                      constant:0
                                        toView:self.visionEffectContainer];
        
        [NSLayoutConstraint constraintWithItem:lastButton
                                     attribute:NSLayoutAttributeCenterY
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.visionEffectContainer
                                     attribute:NSLayoutAttributeCenterY
                                    multiplier:1
                                      constant:0
                                        toView:self.visionEffectContainer];
        
        for (NSInteger i = [self.visionEffectBtns count] - 1; i > 0; --i) {
            
            [NSLayoutConstraint constraintWithItem:self.visionEffectBtns[i]
                                         attribute:NSLayoutAttributeHeight
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:self.visionEffectBtns[i - 1]
                                         attribute:NSLayoutAttributeHeight
                                        multiplier:1
                                          constant:0
                                            toView:self.visionEffectContainer];
            
            [NSLayoutConstraint constraintWithItem:self.visionEffectBtns[i]
                                         attribute:NSLayoutAttributeBaseline
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:self.visionEffectBtns[i - 1]
                                         attribute:NSLayoutAttributeBaseline
                                        multiplier:1
                                          constant:0
                                            toView:self.visionEffectContainer];
            
            [NSLayoutConstraint constraintWithItem:self.visionEffectBtns[i]
                                         attribute:NSLayoutAttributeLeading
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:self.visionEffectBtns[i - 1]
                                         attribute:NSLayoutAttributeTrailing
                                        multiplier:1
                                          constant:15
                                            toView:self.visionEffectContainer];
        }
        
        
        [NSLayoutConstraint constraintWithItem:self.saveImageBtn
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1
                                      constant:5
                                        toView:self];
        
        [NSLayoutConstraint constraintWithItem:self.saveImageBtn
                                     attribute:NSLayoutAttributeTrailing
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeTrailing
                                    multiplier:1
                                      constant:0
                                        toView:self];
        
        [NSLayoutConstraint constraintWithItem:self.saveImageBtn
                                     attribute:NSLayoutAttributeHeight
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.saveImageBtn
                                     attribute:NSLayoutAttributeHeight
                                    multiplier:0
                                      constant:44
                                        toView:self];
        
         [NSLayoutConstraint constraintWithItem:self.saveImageBtn
                                      attribute:NSLayoutAttributeWidth
                                      relatedBy:NSLayoutRelationEqual
                                         toItem:self.saveImageBtn
                                      attribute:NSLayoutAttributeWidth
                                     multiplier:0
                                       constant:60
                                         toView:self];
        
        
        [NSLayoutConstraint constraintWithItem:self.cancleEditBtn
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeTop
                                    multiplier:1
                                      constant:5
                                        toView:self];
        
        [NSLayoutConstraint constraintWithItem:self.cancleEditBtn
                                     attribute:NSLayoutAttributeLeading
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self
                                     attribute:NSLayoutAttributeLeading
                                    multiplier:1
                                      constant:0
                                        toView:self];
        
        [NSLayoutConstraint constraintWithItem:self.cancleEditBtn
                                     attribute:NSLayoutAttributeHeight
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.cancleEditBtn
                                     attribute:NSLayoutAttributeHeight
                                    multiplier:0
                                      constant:44
                                        toView:self];
        
        [NSLayoutConstraint constraintWithItem:self.cancleEditBtn
                                     attribute:NSLayoutAttributeWidth
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:self.cancleEditBtn
                                     attribute:NSLayoutAttributeWidth
                                    multiplier:0
                                      constant:60
                                        toView:self];


        
        
        //UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        //singleRecognizer.numberOfTapsRequired = 1;
        
        UITapGestureRecognizer *doubleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        doubleRecognizer.numberOfTapsRequired = 2;
        
        //[singleRecognizer requireGestureRecognizerToFail:doubleRecognizer];
        
        //[self addGestureRecognizer:singleRecognizer];
        [self addGestureRecognizer:doubleRecognizer];

        
    }
    
    return self;
}


#pragma mark public methods
- (void)fillEditImage:(UIImage *)image {
    
    self.originalImageView.frame = self.imageContainer.frame;
    self.originalImageView.image = image;
    originalImg = image;
    
}

#pragma mark private method
- (void)doubleTap:(UITapGestureRecognizer *)recognizer {
    self.imageContainer.zoomScale = 1;
}

/*
- (void)singleTap:(UITapGestureRecognizer *)recognizer {
    [self.delgate imageEditViewDidCancleEdit:self];
}*/

- (void)changeFilter:(UIButton *)sender {
    
    stillImageSource = [[GPUImagePicture alloc] initWithImage:originalImg];
    
    
    GPUImageFilter *stillImageFilter;

    switch (sender.tag) {
            
        case 0:
            stillImageFilter = [[GPUImageSepiaFilter alloc] init];
            break;
            
        case 1:
            stillImageFilter = [[GPUImageGaussianBlurFilter alloc] init];
            break;
            
        case 2:
            stillImageFilter = [[GPUImageHueFilter alloc] init];
            break;
            
        default:
            break;
    }
    
    [stillImageSource addTarget:stillImageFilter];
    [stillImageFilter useNextFrameForImageCapture];
    [stillImageSource processImage];
    
   
    self.originalImageView.image = [stillImageFilter imageFromCurrentFramebufferWithOrientation:UIImageOrientationRight];
    
}

- (void)saveImage:(UIButton *)sender {
    [self.delegate imageEditView:self didFinishedEdit:self.originalImageView.image];
}

- (void)cancleEdit:(UIButton *)sender {

    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"好桑心"
                              message:@"确认要放弃？"
                              delegate:self
                              cancelButtonTitle:@"就要放弃"
                              otherButtonTitles:@"再试试", nil];
    
    alertView.delegate = self;
    
    [alertView show];
}

#pragma mark scrollview delegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.originalImageView) {
        CGFloat leftMargin = (scrollView.frame.size.width - self.originalImageView.frame.size.width) * 0.5;
        CGFloat topMargin = (scrollView.frame.size.height - self.originalImageView.frame.size.height) * 0.5;
        scrollView.contentInset = UIEdgeInsetsMake(fmaxf(0, topMargin), fmaxf(0, leftMargin), 0, 0);
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.originalImageView;
}

#pragma mark UIAlertView delegate mehods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
            
        case 0:
            [self.delegate imageEditViewDidCancleEdit:self];
            break;
            
        default:
            break;
    }
}

@end
