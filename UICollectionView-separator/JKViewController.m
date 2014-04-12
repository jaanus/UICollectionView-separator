//
//  JKViewController.m
//  UICollectionView-separator
//
//  Created by Jaanus Kase on 11.04.14.
//  Copyright (c) 2014 Jaanus Kase. All rights reserved.
//



#import "JKViewController.h"
#import "JKCell.h"
#import "JKSeparatorLayout.h"



NSString *const separatorReuseIdentifier = @"Separator";



static NSUInteger numberOfItemsWithoutSeparator = 3;
static NSUInteger numberOfItemsWithSeparator = 50;



@interface JKViewController () <JKSeparatorLayoutDelegate>

@property (nonatomic, assign) BOOL expanded;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *showSeparatorBarButtonItem;

@end



@implementation JKViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		_expanded = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	// Register the separator class.
	[self.collectionView registerClass:[UICollectionReusableView class]
			forSupplementaryViewOfKind:SeparatorViewKind
				   withReuseIdentifier:@"Separator"];
}



#pragma mark - Getter/setter methods

- (void) setExpanded:(BOOL)expanded
{
	if (expanded != _expanded) {
		_expanded = expanded;
		if (_expanded) {
			self.showSeparatorBarButtonItem.title = @"Separator off";
		} else {
			self.showSeparatorBarButtonItem.title = @"Separator on";
		}
	}
}



#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.expanded ? numberOfItemsWithSeparator : numberOfItemsWithoutSeparator;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
	UICollectionReusableView *separator = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:separatorReuseIdentifier forIndexPath:indexPath];
	
	if ([kind isEqualToString:SeparatorViewKind]) {
		separator.backgroundColor = [UIColor clearColor];
		
		if (!separator.subviews.count) {
			UIView *line = [[UIView alloc] init];
			line.translatesAutoresizingMaskIntoConstraints = NO;
			line.backgroundColor = [UIColor whiteColor];
			[separator addSubview:line];
			
			// Oh man. This autolayout syntax.
			// This makes the line be fixed height, vertically centered, and with margin on left and right.
			[separator addConstraint:[NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:1]];
			[separator addConstraint:[NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:separator attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
			[separator addConstraint:[NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:separator attribute:NSLayoutAttributeLeft multiplier:1 constant:20]];
			[separator addConstraint:[NSLayoutConstraint constraintWithItem:line attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:separator attribute:NSLayoutAttributeRight multiplier:1 constant:-20]];
		}	
	}
		
	return separator;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	JKCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
	cell.label.text = [NSString stringWithFormat:@"Cell #%ld", (long)indexPath.row];
	return cell;
}



#pragma mark - Bar item actions

- (IBAction)didTapSeparatorSwitch:(UIBarButtonItem *)sender {
	self.expanded = !self.expanded;
	[self.collectionView reloadData];
}



#pragma mark - JKSeparatorLayoutDelegate

- (NSIndexPath *)indexPathForSeparator
{
	if (self.expanded) {
		return [NSIndexPath indexPathForItem:numberOfItemsWithoutSeparator inSection:0];
	}
	
	return nil;
}

- (BOOL)isValidIndexPathForItem:(NSIndexPath *)indexPath
{
	return indexPath.item < [self.collectionView numberOfItemsInSection:0];
}



@end
