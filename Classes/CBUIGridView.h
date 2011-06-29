//
//  CBAQGridView.h
//
//  Created by Christian Beer on 21.01.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBUIGridView;

@protocol CBGridViewCell <NSObject>
- (void) setObject:(id)object;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
@end

@interface CBGridViewCell : UIView <CBGridViewCell> {
    IBOutlet UIView *backgroundView;
    IBOutlet UIView *selectedBackgroundView;
}
@end



@protocol CBGridViewDataSource <NSObject>

@required

- (NSUInteger) numberOfItemsInGridView:(CBUIGridView *)gridView;
- (id) gridView:(CBUIGridView*)gridView objectAtIndex:(NSUInteger)index;
- (UIView<CBGridViewCell>*)gridView:(CBUIGridView*)aGridView cellForItemAtIndex:(NSUInteger)index;

@end


@protocol CBGridViewDelegate <NSObject>

@required

- (CGFloat) gridView:(CBUIGridView*)gridView heightForCellWithObject:(id)object;
- (CGFloat) gridView:(CBUIGridView*)gridView widthForCellWithObject:(id)object;

@optional

- (Class) gridView:(CBUIGridView*)gridView cellClassForObject:(id)object;
- (void) gridView:(CBUIGridView *)gridView didSelectItemAtIndex: (NSUInteger) index;
- (CGRect) gridView:(CBUIGridView *)gridView adjustCellFrame:(CGRect)frame;

@end


@interface CBUIGridView : UIView <UIScrollViewDelegate> {
    id<CBGridViewDataSource> dataSource;
    id<CBGridViewDelegate> delegate;
    
    UIScrollView *scrollView;
    
    CGFloat spacing;
    int selectedViewTag;
}

@property (nonatomic, assign) id<CBGridViewDataSource> dataSource;
@property (nonatomic, assign) id<CBGridViewDelegate> delegate;

@property (nonatomic, assign) CGFloat spacing;

@property (nonatomic, readonly) int selectedViewTag;

- (void) selectViewWithTag:(int)tag;

- (void) reloadData;
- (void) selectObjectAtIndex:(int)index;

- (BOOL) isVertical;

@end
