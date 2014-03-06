//
//  CBUIImagePagingScrollView.h
//  ArabianRaces2
//
//  Created by Christian Beer on 17.12.10.
//  Copyright 2010 Christian Beer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBUIImagePagingScrollView;

@protocol CBUIImagePagingScrollViewDataSource <NSObject>

- (NSUInteger) pagingScrollViewNumberOfPages:(CBUIImagePagingScrollView*)scrollView;
- (UIImage*) pagingScrollView:(CBUIImagePagingScrollView*)scrollView imageForPage:(NSUInteger)pageIndex;

@end

@protocol CBUIImagePagingScrollViewDelegate <NSObject>

- (void) pagingScrollView:(CBUIImagePagingScrollView*)scrollView didChangePageToIndex:(NSUInteger)index;

@end

@interface CBUIImagePagingScrollView : UIScrollView <UIScrollViewDelegate> {
    IBOutlet id<CBUIImagePagingScrollViewDataSource> dataSource;
    id<CBUIImagePagingScrollViewDelegate> _internalDelegate;
    
    UIImageView *_imageViews[3];
    
    NSUInteger _numberOfPages;
    NSInteger _currentPage;
    
    NSMutableDictionary *_imageCache;
}

@property (nonatomic, strong) id<CBUIImagePagingScrollViewDataSource> dataSource;

- (void) arrangePageViews;

- (void) setPagingDelegate:(id <CBUIImagePagingScrollViewDelegate>)delegate;
- (id<CBUIImagePagingScrollViewDelegate>) pagingDelegate;

- (void) reloadData;
- (void) scrollToPageWithIndex:(NSUInteger)pageIndex;

- (NSUInteger) numberOfPages;
- (NSInteger) imageIndex;

- (UIImage*) imageForPageIndex:(NSUInteger)index;

// private

- (void) setupView;

- (void) flushCache;

- (CGRect) frameForImageViewAtIndex:(NSUInteger)index;
- (void) setCurrentPage:(NSUInteger)page;
- (void) setImageIndex:(NSUInteger)pageIndex;

@end
