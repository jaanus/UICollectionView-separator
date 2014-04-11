//
//  JKViewController.m
//  UICollectionView-separator
//
//  Created by Jaanus Kase on 11.04.14.
//  Copyright (c) 2014 Jaanus Kase. All rights reserved.
//



#import "JKViewController.h"
#import "JKCell.h"



static NSUInteger showWithoutSeparator = 3;
static NSUInteger showWithSeparator = 50;



@interface JKViewController ()

@property (nonatomic, assign) BOOL showBelowSeparator;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *showSeparatorBarButtonItem;

@end



@implementation JKViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		
		_showBelowSeparator = NO;
		
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	NSLog(@"did load");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Getter/setter methods

- (void) setShowBelowSeparator:(BOOL)showBelowSeparator
{
	if (showBelowSeparator != _showBelowSeparator) {
		_showBelowSeparator = showBelowSeparator;
		if (_showBelowSeparator) {
			self.showSeparatorBarButtonItem.title = @"Separator off";
		} else {
			self.showSeparatorBarButtonItem.title = @"Separator on";
		}
	}
}



#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.showBelowSeparator ? showWithSeparator : showWithoutSeparator;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	JKCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
	cell.label.text = [NSString stringWithFormat:@"Cell #%ld", (long)indexPath.row];
	return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



#pragma mark - Bar item actions

- (IBAction)didTapSeparatorSwitch:(UIBarButtonItem *)sender {
	NSLog(@"wat: %@", sender);
	self.showBelowSeparator = !self.showBelowSeparator;
	[self.collectionView reloadData];
}




@end
