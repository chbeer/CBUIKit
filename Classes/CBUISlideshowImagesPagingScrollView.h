//
//  CBUISlideshowImagesPagingScrollView.h
//  ArabianRaces2
//
//  Created by Christian Beer on 20.01.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBUIImagePagingScrollView.h"

@class CBUISlideshowImagesPagingScrollView;

@protocol CBUISlideshowImagesPagingScrollViewDataSource <NSObject>

- (int) slideshowPagingScrollView:(CBUIImagePagingScrollView*)scrollView imageCountForPage:(int)pageIndex;
- (UIImage*) slideshowPagingScrollView:(CBUIImagePagingScrollView*)scrollView imageAtIndex:(int)index forPage:(int)pageIndex;

@end

@protocol CBUISlideshowImagesPagingScrollViewDelegate <CBUIImagePagingScrollViewDelegate>

@optional

- (void) slideshowPagingScrollView:(CBUISlideshowImagesPagingScrollView *)slideshowScrollView willAnimateToIndex:(int)index;
- (void) slideshowPagingScrollView:(CBUISlideshowImagesPagingScrollView *)slideshowScrollView didAnimateToIndex:(int)index;

@end



@interface CBUISlideshowImagesPagingScrollView : CBUIImagePagingScrollView <UIScrollViewDelegate> {
    UIImageView *imageView;

    NSMutableDictionary *imagesCache;
    int imageIndex;
    
    BOOL animate;
    NSTimer *slideshowTimer;
    int animationCounter;
}

- (void) animateToImageIndex:(int)index;

- (BOOL) isAnimating;
- (IBAction) stop:(id)sender;
- (IBAction) start:(id)sender;
- (IBAction) previousImage:(id)sender;
- (IBAction) nextImage:(id)sender;

@end
