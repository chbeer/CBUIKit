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

- (int) slideshowPagingScrollView:(CBUIImagePagingScrollView*)scrollView imageCountForPage:(NSInteger)pageIndex;
- (UIImage*) slideshowPagingScrollView:(CBUIImagePagingScrollView*)scrollView imageAtIndex:(NSInteger)index forPage:(NSInteger)pageIndex;

@end

@protocol CBUISlideshowImagesPagingScrollViewDelegate <CBUIImagePagingScrollViewDelegate>

@optional

- (void) slideshowPagingScrollView:(CBUISlideshowImagesPagingScrollView *)slideshowScrollView willAnimateToIndex:(NSInteger)index;
- (void) slideshowPagingScrollView:(CBUISlideshowImagesPagingScrollView *)slideshowScrollView didAnimateToIndex:(NSInteger)index;

@end



@interface CBUISlideshowImagesPagingScrollView : CBUIImagePagingScrollView <UIScrollViewDelegate> {
    UIImageView *imageView;

    NSMutableDictionary *imagesCache;
    NSInteger imageIndex;
    
    BOOL animate;
    NSTimer *slideshowTimer;
    NSInteger animationCounter;
}

- (void) animateToImageIndex:(NSInteger)index;

@property (NS_NONATOMIC_IOSONLY, getter=isAnimating, readonly) BOOL animating;
- (IBAction) stop:(id)sender;
- (IBAction) start:(id)sender;
- (IBAction) previousImage:(id)sender;
- (IBAction) nextImage:(id)sender;

@end
