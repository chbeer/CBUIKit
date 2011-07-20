//
//  CBAQGridView.h
//
//  Created by Christian Beer on 21.01.11.
//  Copyright 2011 Christian Beer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBUIGridView;

@protocol CBUIGridViewCell <NSObject>
- (void) setObject:(id)object;
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
@end

@interface CBUIGridViewCell : UIView <CBUIGridViewCell> {
    IBOutlet UIView *backgroundView;
    IBOutlet UIView *selectedBackgroundView;
}
@end



@protocol CBUIGridViewDataSource <NSObject>

@required

- (NSUInteger) numberOfItemsInGridView:(CBUIGridView *)gridView;
- (id) gridView:(CBUIGridView*)gridView objectAtIndex:(NSUInteger)index;
- (UIView<CBUIGridViewCell>*)gridView:(CBUIGridView*)aGridView cellForItemAtIndex:(NSUInteger)index;

@end


@protocol CBUIGridViewDelegate <NSObject>

@required

- (CGFloat) gridView:(CBUIGridView*)gridView heightForCellWithObject:(id)object;
- (CGFloat) gridView:(CBUIGridView*)gridView widthForCellWithObject:(id)object;

@optional

- (Class) gridView:(CBUIGridView*)gridView cellClassForObject:(id)object;
- (void) gridView:(CBUIGridView *)gridView didSelectItemAtIndex: (NSUInteger) index;
- (CGRect) gridView:(CBUIGridView *)gridView adjustCellFrame:(CGRect)frame;

@end


@interface CBUIGridView : UIView <UIScrollViewDelegate> {
    id<CBUIGridViewDataSource> dataSource;
    id<CBUIGridViewDelegate> delegate;
    
    UIScrollView *scrollView;
    
    CGFloat spacing;
    int selectedViewTag;
}

@property (nonatomic, assign) IBOutlet id<CBUIGridViewDataSource> dataSource;
@property (nonatomic, assign) IBOutlet id<CBUIGridViewDelegate> delegate;

@property (nonatomic, assign) CGFloat spacing;

@property (nonatomic, readonly) int selectedViewTag;

- (void) selectViewWithTag:(int)tag;

- (void) reloadData;
- (void) selectObjectAtIndex:(int)index;

- (BOOL) isVertical;

@end
