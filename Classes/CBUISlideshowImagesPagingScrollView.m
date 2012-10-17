//
//  CBUISlideshowImagesPagingScrollView.m
//  ArabianRaces2
//
//  Created by Christian Beer on 20.01.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import "CBUISlideshowImagesPagingScrollView.h"


@implementation CBUISlideshowImagesPagingScrollView

- (void) setupView {
    [super setupView];
    
    imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageView.alpha = 0.0;
    imageView.contentMode = UIViewContentModeCenter;
    imageView.clipsToBounds = YES;
    [self addSubview:imageView];
    
    animationCounter = 0;
    slideshowTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self 
                                                    selector:@selector(eventuallyAnimateToNextImage:) 
                                                    userInfo:nil
                                                     repeats:YES];
    
    animate = YES;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    imageView.frame = self.bounds;
}


- (void) reloadData {
    
     imagesCache = nil;
    imageIndex = 0;
    
    [super reloadData];    
}

- (int) imageCount {
    if (_currentPage < 0) {
        return 0;
    }
    
    return [(id<CBUISlideshowImagesPagingScrollViewDataSource>)dataSource slideshowPagingScrollView:self 
                                                                                  imageCountForPage:_currentPage];
}
- (UIImage*) imageForIndex:(int)index {
    if (!imagesCache) {
        imagesCache = [[NSMutableDictionary alloc] init];
    }
    NSNumber *key = [NSNumber numberWithInt:index];
    UIImage *image = [imagesCache objectForKey:key];
    if (!image) {
        if ([dataSource respondsToSelector:@selector(slideshowPagingScrollView:imageAtIndex:forPage:)]) {
            image = [(id<CBUISlideshowImagesPagingScrollViewDataSource>)dataSource slideshowPagingScrollView:self
                                                                                                imageAtIndex:index
                                                                                                     forPage:_currentPage];
        }
        if (image) {
            [imagesCache setObject:image forKey:key];
        }
    }
    return image;
}

- (void) flushCache {
    [super flushCache];
    imagesCache = nil;
}

#pragma mark -

- (BOOL) isAnimating {
    return animate;
}
- (IBAction) stop:(id)sender {
    animate = NO;
    imagesCache = nil;
    imageView.alpha = 0.0;
}
- (IBAction) start:(id)sender {
    animationCounter = 0;
    animate = YES;
}
- (IBAction) previousImage:(id)sender {
    BOOL tmpAnimate = animate;
    animate = NO;
    
    if (imageIndex > 0) {
        [self animateToImageIndex:imageIndex - 1];
    }
    
    animate = tmpAnimate;
    animationCounter = 0;
    
    [sender setEnabled:imageIndex > 0];
}
- (IBAction) nextImage:(id)sender {
    BOOL tmpAnimate = animate;
    animate = NO;
    
    if (imageIndex + 1 < [self imageCount]) {
        [self animateToImageIndex:imageIndex + 1];
    }

    animate = tmpAnimate;
    animationCounter = 0;
    
    [sender setEnabled:imageIndex + 1 < [self imageCount]];
}

#pragma mark -

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    _imageViews[1].image = imageView.image;
    imageView.alpha = 0.0;
    
    if ([_internalDelegate respondsToSelector:@selector(slideshowPagingScrollView:didAnimateToIndex:)]) {
        [(id<CBUISlideshowImagesPagingScrollViewDelegate>)_internalDelegate slideshowPagingScrollView:self
                                                                                    didAnimateToIndex:imageIndex];
    } 

    animationCounter = 0;
}


- (void) animateToImageIndex:(int)newImageIndex {
    if (newImageIndex < 0 || newImageIndex >= [self imageCount]) return;
    
    if ([_internalDelegate respondsToSelector:@selector(slideshowPagingScrollView:willAnimateToIndex:)]) {
        [(id<CBUISlideshowImagesPagingScrollViewDelegate>)_internalDelegate slideshowPagingScrollView:self
                                                                                   willAnimateToIndex:newImageIndex];
    } 
    
    imageView.alpha = 0.0;
    imageView.frame = _imageViews[1].frame;
    imageView.image = [self imageForIndex:newImageIndex];
    [self bringSubviewToFront:imageView];
    
    [UIView beginAnimations:@"fade" context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    imageView.alpha = 1.0;
    [UIView commitAnimations];
    
    imageIndex = newImageIndex;
}
- (void) animateToNextImage:(NSTimer*)timer {
    int imageCount = [self imageCount];
    if (imageCount == 0) return;
    [self animateToImageIndex:(imageIndex + 1) % imageCount];
}

- (void) eventuallyAnimateToNextImage:(NSTimer*)timer {
    if (animate && animationCounter > 3) {
        [self animateToNextImage:timer];
        animationCounter = 0;
    } else {
        animationCounter++;
    }
}

#pragma mark UISlideshowDelegate

- (void) setCurrentPage:(int)page {
    BOOL tmpAnimate = animate;
    animate = NO;
    
    imageIndex = 0;
    imageView.alpha = 0.0;
    
    [super setCurrentPage:page];
    
    animationCounter = 0;
    animate = tmpAnimate;
}

static BOOL tmpScrollAnimate;
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    tmpScrollAnimate = animate;
    animate = NO;
    animationCounter = 0;
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    animate = tmpScrollAnimate;
    animationCounter = 0;
}

#pragma mark changeImage

- (void) setImageIndex:(int)pageIndex {
    [super setImageIndex:pageIndex];
    
    imageIndex = 0;
    imageView.alpha = 0.0;

    animationCounter = 0;
    
    [self start:self];
}

@end
