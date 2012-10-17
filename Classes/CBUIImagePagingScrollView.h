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

- (int) pagingScrollViewNumberOfPages:(CBUIImagePagingScrollView*)scrollView;
- (UIImage*) pagingScrollView:(CBUIImagePagingScrollView*)scrollView imageForPage:(int)pageIndex;

@end

@protocol CBUIImagePagingScrollViewDelegate <NSObject>

- (void) pagingScrollView:(CBUIImagePagingScrollView*)scrollView didChangePageToIndex:(int)index;

@end

@interface CBUIImagePagingScrollView : UIScrollView <UIScrollViewDelegate> {
    IBOutlet id<CBUIImagePagingScrollViewDataSource> dataSource;
    id<CBUIImagePagingScrollViewDelegate> _internalDelegate;
    
    UIImageView *_imageViews[3];
    
    int _numberOfPages;
    int _currentPage;
    
    NSMutableDictionary *_imageCache;
}

@property (nonatomic, strong) id<CBUIImagePagingScrollViewDataSource> dataSource;

- (void) arrangePageViews;

- (void) setPagingDelegate:(id <CBUIImagePagingScrollViewDelegate>)delegate;
- (id<CBUIImagePagingScrollViewDelegate>) pagingDelegate;

- (void) reloadData;
- (void) scrollToPageWithIndex:(NSUInteger)pageIndex;

- (int) numberOfPages;
- (int) imageIndex;

- (UIImage*) imageForPageIndex:(int)index;

// private

- (void) setupView;

- (void) flushCache;

- (CGRect) frameForImageViewAtIndex:(int)index;
- (void) setCurrentPage:(int)page;
- (void) setImageIndex:(int)pageIndex;

@end
