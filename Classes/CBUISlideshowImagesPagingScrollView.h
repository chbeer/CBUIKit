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

- (NSUInteger) slideshowPagingScrollView:(CBUIImagePagingScrollView*)scrollView imageCountForPage:(NSUInteger)pageIndex;
- (UIImage*) slideshowPagingScrollView:(CBUIImagePagingScrollView*)scrollView imageAtIndex:(NSUInteger)index forPage:(NSUInteger)pageIndex;

@end

@protocol CBUISlideshowImagesPagingScrollViewDelegate <CBUIImagePagingScrollViewDelegate>

@optional

- (void) slideshowPagingScrollView:(CBUISlideshowImagesPagingScrollView *)slideshowScrollView willAnimateToIndex:(NSUInteger)index;
- (void) slideshowPagingScrollView:(CBUISlideshowImagesPagingScrollView *)slideshowScrollView didAnimateToIndex:(NSUInteger)index;

@end



@interface CBUISlideshowImagesPagingScrollView : CBUIImagePagingScrollView <UIScrollViewDelegate> {
    UIImageView *imageView;

    NSMutableDictionary *imagesCache;
    NSUInteger imageIndex;
    
    BOOL animate;
    NSTimer *slideshowTimer;
    NSUInteger animationCounter;
}

- (void) animateToImageIndex:(NSInteger)index;

- (BOOL) isAnimating;
- (IBAction) stop:(id)sender;
- (IBAction) start:(id)sender;
- (IBAction) previousImage:(id)sender;
- (IBAction) nextImage:(id)sender;

@end
