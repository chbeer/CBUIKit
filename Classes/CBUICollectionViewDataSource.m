//
//  CBUICollectionViewDataSource.m
//  CBUIKit
//
//  Created by Christian Beer on 05.10.12.
//
//

#import "CBUICollectionViewDataSource.h"

@implementation CBUICollectionViewDataSource

- (instancetype)initWithCollectionView:(UICollectionView*)collectionView
{
    self = [super init];
    if (!self) return nil;
    
    self.collectionView = collectionView;

    self.empty = YES;
    self.loading = NO;
    
    return self;
}


// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    id object = [self objectAtIndexPath:indexPath];
    NSString *reuseIdentifier = self.cellReuseIdentifier;
    
    if ([self.delegate respondsToSelector:@selector(reuseIdentifierForObject:atIndexPath:)]) {
        reuseIdentifier = [self.delegate reuseIdentifierForObject:object atIndexPath:indexPath];
    }
    
    UICollectionViewCell<CBUICollectionViewCell> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    [cell setObject:object];
    
    if ([self.delegate respondsToSelector:@selector(collectionViewDataSource:didCreateCell:withObject:atIndexPath:)]) {
        [self.delegate collectionViewDataSource:self didCreateCell:cell withObject:object atIndexPath:indexPath];
    }
    
    return cell;
}

#pragma mark - To Be Overridden

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

- (id) objectAtIndexPath:(NSIndexPath*)indexPath
{
    return nil;
}

@end
