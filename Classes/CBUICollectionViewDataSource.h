//
//  CBUICollectionViewDataSource.h
//  CBUIKit
//
//  Created by Christian Beer on 05.10.12.
//
//

#import <Foundation/Foundation.h>

@class CBUICollectionViewDataSource;


@protocol CBUICollectionViewDataSourceDelegate <NSObject>

@optional

- (NSString*) reuseIdentifierForObject:(id)object atIndexPath:(NSIndexPath*)indexPath;
- (void) collectionViewDataSource:(CBUICollectionViewDataSource*)dataSource didCreateCell:(UICollectionViewCell*)cell withObject:(id)object atIndexPath:(NSIndexPath*)indexPath;

@end


@protocol CBUICollectionViewCell <NSObject>

- (void) setObject:(id)object;

@end



@interface CBUICollectionViewDataSource : NSObject <UICollectionViewDataSource>

@property (nonatomic, strong)   UICollectionView                            *collectionView;

@property (nonatomic, copy)     NSString                                    *cellReuseIdentifier;
@property (nonatomic, weak)   id<CBUICollectionViewDataSourceDelegate>    delegate;

@property (nonatomic, assign)   BOOL    empty;
@property (nonatomic, assign)   BOOL    loading;


- (instancetype)initWithCollectionView:(UICollectionView*)collectionView NS_DESIGNATED_INITIALIZER;

- (id) objectAtIndexPath:(NSIndexPath*)indexPath;

@end
