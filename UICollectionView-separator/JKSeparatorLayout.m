//
//  JKSeparatorLayout.m
//  UICollectionView-separator
//
//  Created by Jaanus Kase on 12.04.14.
//  Copyright (c) 2014 Jaanus Kase. All rights reserved.
//

#import "JKSeparatorLayout.h"



static CGFloat separatorHeight = 64;



NSString *const SeparatorViewKind = @"SeparatorViewKind";



@implementation JKSeparatorLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
	// Grab computed attributes from parent
	NSMutableArray *attributes = [NSMutableArray arrayWithArray:[super layoutAttributesForElementsInRect:rect]];
	
	// Possible attributes for separator
	UICollectionViewLayoutAttributes *separatorAttributes = nil;

	// Keep track of some index paths and add missing ones after the loop
	NSMutableSet *seenIndexPaths = [NSMutableSet set];
	NSMutableSet *expectedIndexPaths = [NSMutableSet setWithSet:[self indexPathsForItemsInRect:rect]];

	for (UICollectionViewLayoutAttributes *attr in attributes) {
		
		[seenIndexPaths addObject:attr.indexPath];
		
		// If there should be a separator above this item, then create its layout attributes
		if ([attr.indexPath compare:[self.separatorLayoutDelegate indexPathForSeparator]] == NSOrderedSame) {
			separatorAttributes = [self layoutAttributesForSupplementaryViewOfKind:SeparatorViewKind atIndexPath:attr.indexPath];
            
            CGRect separatorFrame = attr.frame;
            separatorFrame.size.height = separatorHeight;
            separatorAttributes.frame = separatorFrame;

		}
		
		attr.frame = [self adjustedFrameForAttributes:attr];
		
	}
	
	if (separatorAttributes) {
		[attributes addObject:separatorAttributes];
	}
	
	[expectedIndexPaths minusSet:seenIndexPaths];
	
	// If there are some index paths that were not covered by the loop, we must add their attributes
	// because the FlowLayout thought they were in a different rect
	for (NSIndexPath *missingPath in expectedIndexPaths) {
		UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:missingPath];
		if (attr) {
			[attributes addObject:attr];
		}
	}
	
	return attributes;
}

- (CGRect)adjustedFrameForAttributes:(UICollectionViewLayoutAttributes *)attributes
{
	CGRect f = attributes.frame;
	NSIndexPath *separatorIndexPath = [self.separatorLayoutDelegate indexPathForSeparator];

	// If there is a separator, and this item is below the separator, shift the item down
	if (separatorIndexPath) {
		if ([separatorIndexPath compare:attributes.indexPath] != NSOrderedDescending) {
			f.origin.y += separatorHeight;
		}
	}
	
	return f;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *a = [super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
    
    if (!a) {
		// If superview didn’t return anything, we generate our own attributes.
        a = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:kind withIndexPath:indexPath];
    }
    
    return a;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
	// Our indexPathsForItemsInRect doesn’t know anything about item validity and may return
	// index paths that are actually not in the collection view. So validate the path.
	if (![self.separatorLayoutDelegate isValidIndexPathForItem:indexPath]) { return nil; }
    
    UICollectionViewLayoutAttributes *a = [super layoutAttributesForItemAtIndexPath:indexPath];
    a.frame = [self adjustedFrameForAttributes:a];
    return a;
}

- (CGSize)collectionViewContentSize
{
	// Increase the content size by separator height, if one is present
	CGSize s = [super collectionViewContentSize];
	if ([self.separatorLayoutDelegate indexPathForSeparator]) {
		s.height += separatorHeight;
	}
	return s;
}

- (NSSet *)indexPathsForItemsInRect:(CGRect)rect
{
    // If the frame is empty, don’t do anything
    if (rect.size.height == 0 ) { return nil; }
    
    NSMutableSet *set = [NSMutableSet set];
    
    CGFloat accountedHeight = 0;
    NSInteger item = 0;
    
    // Keep increasing the item until we reach the rect bounds
    // Also account for separator
    while (accountedHeight < rect.origin.y) {
        accountedHeight += self.itemSize.height;
        item++;
        if ([[self.separatorLayoutDelegate indexPathForSeparator] compare:[NSIndexPath indexPathForItem:item inSection:0]] == NSOrderedSame) {
            accountedHeight += separatorHeight;
        }
    }
	
    // Go back one step to account for the index that may have been partially clipped by previous stepping
	if (item > 0) {
		item--;
		if (item > 0) {
			accountedHeight -= self.itemSize.height;
		}
	}
    
    // Generate index paths for the items that are inside the rect
    while (accountedHeight < rect.origin.y + rect.size.height) {
        [set addObject:[NSIndexPath indexPathForItem:item inSection:0]];
        accountedHeight += self.itemSize.height;
        if ([[self.separatorLayoutDelegate indexPathForSeparator] compare:[NSIndexPath indexPathForItem:item inSection:0]] == NSOrderedSame) {
            accountedHeight += separatorHeight;
        }
        item++;
    }
    
    return set;
}



@end
