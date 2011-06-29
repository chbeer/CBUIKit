//
//  CBUIImagePagingScrollView.m
//  ArabianRaces2
//
//  Created by Christian Beer on 17.12.10.
//  Copyright 2010 Christian Beer. All rights reserved.
//

#import "CBUIImagePagingScrollView.h"

#import "CBUIGlobal.h"

@interface CBUIImagePagingScrollView ()

- (void) setupView;
- (void) flushCache;

@end



@implementation CBUIImagePagingScrollView

@dynamic dataSource;

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    [self setupView];
    
    return self;
}
- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (!self) return nil;
    
    [self setupView];
    
    return self;
}

- (void) setupView {
    self.pagingEnabled = YES;
    [super setDelegate:self];
    self.scrollEnabled = YES;
    self.pagingEnabled = YES;
    self.bounces = YES;
    self.showsVerticalScrollIndicator = self.showsHorizontalScrollIndicator = NO;
    self.canCancelContentTouches = YES;
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    
    for (int index = 0; index < 3; index++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:[self frameForImageViewAtIndex:index - 1]];
        imageView.contentMode = UIViewContentModeCenter;
        imageView.clipsToBounds = YES;
        _imageViews[index] = imageView;
        [self addSubview:imageView];
        [imageView release];
    }
    
    _currentPage = -1;
    
    _imageCache = [[NSMutableDictionary alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(didReceiveMemoryWarning:)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:UIApplicationDidReceiveMemoryWarningNotification
                                                  object:nil];
    
    [_imageCache release], _imageCache = nil;
    
    [super dealloc];
}

- (void) arrangePageViews {
    for (int index = -1; index <= 1; index++) {
        int imageIndex = _currentPage + index;
        if (imageIndex >= 0 && imageIndex < _numberOfPages) {
            _imageViews[index + 1].frame = [self frameForImageViewAtIndex:imageIndex];
        }
    }
    self.contentSize = CGSizeMake(self.bounds.size.width * _numberOfPages, self.bounds.size.height);
    self.contentOffset = CGPointMake(self.bounds.size.width * _currentPage, 0.0);
}

- (void) reloadData {
    _numberOfPages = [dataSource pagingScrollViewNumberOfPages:self];
    [self arrangePageViews];
    
    int page = _currentPage;
    _currentPage = -1;
    
    if (page == -1 && _numberOfPages > 0) page = 0;
    [self setImageIndex:page];
}

- (void) scrollToPageWithIndex:(NSUInteger)pageIndex {
    [self setImageIndex:pageIndex];
}

#pragma mark Accessors

- (id<CBUIImagePagingScrollViewDataSource>) dataSource {
    return dataSource; 
}
- (void) setDataSource: (id<CBUIImagePagingScrollViewDataSource>) aDataSource {
    if (dataSource != aDataSource) {
        dataSource = aDataSource;
                
        [self flushCache];
        [self reloadData];
    }
}

- (void) setImageIndex:(int)pageIndex {
    if (_currentPage == pageIndex) return;

    [self setContentOffset:CGPointMake(pageIndex * self.bounds.size.width, 0) 
                  animated:NO];
    
    /*if ([_internalDelegate respondsToSelector:@selector(pagingScrollView:didChangePageToIndex:)]) {
        [_internalDelegate pagingScrollView:self didChangePageToIndex:pageIndex];
    }
    
    _currentPage = pageIndex;*/
}
- (int) imageIndex {
    return _currentPage;
}

- (int) numberOfPages {
    return _numberOfPages;
}

- (CGRect) frameForImageViewAtIndex:(int)index {
    CGFloat pageWidth = self.bounds.size.width;
    CGFloat pageHeight = self.bounds.size.height;
    CGRect frame = CGRectMake(pageWidth * index, 0, pageWidth, pageHeight);
    return frame;
}

- (UIImage*) imageForPageIndex:(int)index {
    NSNumber *key = [NSNumber numberWithInt:index];
    UIImage *image = [_imageCache objectForKey:key];
    if (!image) {
        image = [dataSource pagingScrollView:self imageForPage:index];
        if (image) {
            [_imageCache setObject:image 
                            forKey:key];
        }
    }
    
    return image;
}
- (void) flushCache {
    [_imageCache removeAllObjects];
}

#pragma mark UIScrollViewDelegate

- (void) setCurrentPage:(int)page {
    DLog(@"page: %d (%d)", page, _currentPage);
    
    int distance = abs(page - _currentPage);
    
    if (distance == 1 && _currentPage != -1) {
        if (page > _currentPage) {
            UIImageView *temp = _imageViews[0];
            _imageViews[0] = _imageViews[1];
            _imageViews[1] = _imageViews[2];
            _imageViews[2] = temp;
            
            if (page + 1 < _numberOfPages) {
                _imageViews[2].image = [self imageForPageIndex:page + 1];
                _imageViews[2].hidden = NO;
            } else {
                _imageViews[2].hidden = YES;
            }
        } else if (page < _currentPage) {
            UIImageView *temp = _imageViews[2];
            _imageViews[2] = _imageViews[1];
            _imageViews[1] = _imageViews[0];
            _imageViews[0] = temp;
            
            if (page > 0) {
                _imageViews[0].image = [self imageForPageIndex:page - 1];
                _imageViews[0].hidden = NO;
            } else {
                _imageViews[0].hidden = YES;
            }
        }
        _imageViews[1].hidden = NO;
        
    } else {
        for (int index = -1; index < 2; index++) {
            int imageIndex = page + index;
            int viewIndex = index + 1;
            if (imageIndex >= 0 && imageIndex < _numberOfPages) {
                UIImage *image = [self imageForPageIndex:imageIndex];
                
                NSLog(@"> image for index %d : %@", viewIndex, image);
                
                _imageViews[viewIndex].image = image;
                _imageViews[viewIndex].frame = [self frameForImageViewAtIndex:imageIndex];
                _imageViews[viewIndex].hidden = NO;
            } else {
                _imageViews[viewIndex].image = nil;
                _imageViews[viewIndex].hidden = YES;
            }
        }
    }

    for (int i = -1; i < 2; i++) {
        _imageViews[i + 1].frame = [self frameForImageViewAtIndex:page + i];
    }
    
    if ([_internalDelegate respondsToSelector:@selector(pagingScrollView:didChangePageToIndex:)]) {
        [_internalDelegate pagingScrollView:self didChangePageToIndex:page];
    }
    
    _currentPage = page;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    int page = round(self.contentOffset.x / self.bounds.size.width);
    if (page < 0 || page > _numberOfPages || page == _currentPage) return;
    
    [self setCurrentPage:page];
}


#pragma mark Notifications

- (void) didReceiveMemoryWarning:(NSNotification*)notification {
    DLog(@"Did receive memory warning");
    [self flushCache];
}

#pragma mark Delegate Access

- (void) setPagingDelegate:(id <CBUIImagePagingScrollViewDelegate>)delegate {
    _internalDelegate = delegate;
}
- (id<CBUIImagePagingScrollViewDelegate>) pagingDelegate {
    return _internalDelegate;
}

@end
