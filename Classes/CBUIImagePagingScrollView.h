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
- (UIImage*) pagingScrollView:(CBUIImagePagingScrollView*)scrollView imageForPage:(NSInteger)pageIndex;

@end

@protocol CBUIImagePagingScrollViewDelegate <NSObject>

- (void) pagingScrollView:(CBUIImagePagingScrollView*)scrollView didChangePageToIndex:(NSInteger)index;

@end

@interface CBUIImagePagingScrollView : UIScrollView <UIScrollViewDelegate> {
    IBOutlet id<CBUIImagePagingScrollViewDataSource> dataSource;
    id<CBUIImagePagingScrollViewDelegate> _internalDelegate;
    
    UIImageView *_imageViews[3];
    
    NSInteger _numberOfPages;
    NSInteger _currentPage;
    
    NSMutableDictionary *_imageCache;
}

@property (nonatomic, strong) id<CBUIImagePagingScrollViewDataSource> dataSource;

- (void) arrangePageViews;

@property (NS_NONATOMIC_IOSONLY, strong) id<CBUIImagePagingScrollViewDelegate> pagingDelegate;

- (void) reloadData;
- (void) scrollToPageWithIndex:(NSUInteger)pageIndex;

@property (NS_NONATOMIC_IOSONLY, readonly) NSInteger numberOfPages;
@property (NS_NONATOMIC_IOSONLY) NSInteger imageIndex;

- (UIImage*) imageForPageIndex:(NSInteger)index;

// private

- (void) setupView;

- (void) flushCache;

- (CGRect) frameForImageViewAtIndex:(NSInteger)index;
- (void) setCurrentPage:(NSInteger)page;

@end
