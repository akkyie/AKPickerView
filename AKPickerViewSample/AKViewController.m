//
//  AKViewController.m
//  AKPickerViewSample
//
//  Created by Akio Yasui on 3/29/14.
//  Copyright (c) 2014 Akio Yasui. All rights reserved.
//

#import "AKViewController.h"

#import "AKPickerView.h"

@interface AKViewController () <AKPickerViewDataSource, AKPickerViewDelegate>
@property (nonatomic, strong) AKPickerView *pickerView;
@property (nonatomic, strong) NSArray *titles;
@end

@implementation AKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.pickerView = [[AKPickerView alloc] initWithFrame:self.view.bounds];
	self.pickerView.delegate = self;
	self.pickerView.dataSource = self;
	self.pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:self.pickerView];

	self.pickerView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
	self.pickerView.highlightedFont = [UIFont fontWithName:@"HelveticaNeue" size:20];
	self.pickerView.interitemSpacing = 20.0;
	self.pickerView.fisheyeFactor = 0.001;
	self.pickerView.pickerViewStyle = AKPickerViewStyle3D;

	self.titles = @[@"Tokyo",
					@"Kanagawa",
					@"Osaka",
					@"Aichi",
					@"Saitama",
					@"Chiba",
					@"Hyogo",
					@"Hokkaido",
					@"Fukuoka",
					@"Shizuoka"];

	[self.pickerView reloadData];
}

#pragma mark - AKPickerViewDataSource

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView
{
	return [self.titles count];
}

/*
 * AKPickerView now support images!
 *
 * Please comment '-pickerView:titleForItem:' entirely
 * and uncomment '-pickerView:imageForItem:' to see how it works.
 *
 */

- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item
{
	return self.titles[item];
}

/*
- (UIImage *)pickerView:(AKPickerView *)pickerView imageForItem:(NSInteger)item
{
	return [UIImage imageNamed:self.titles[item]];
}
*/

#pragma mark - AKPickerViewDelegate

- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item
{
	NSLog(@"%@", self.titles[item]);
}


/*
 * Label Customization
 *
 * You can customize labels by their any properties (except font,)
 * and margin around text.
 * These methods are optional, and ignored when using images.
 *
 */

/*
- (void)pickerView:(AKPickerView *)pickerView configureLabel:(UILabel *const)label forItem:(NSInteger)item
{
	label.textColor = [UIColor lightGrayColor];
	label.highlightedTextColor = [UIColor whiteColor];
	label.backgroundColor = [UIColor colorWithHue:(float)item/(float)self.titles.count
									   saturation:1.0
									   brightness:1.0
											alpha:1.0];
}
*/

/*
- (CGSize)pickerView:(AKPickerView *)pickerView marginForItem:(NSInteger)item
{
	return CGSizeMake(40, 20);
}
*/

#pragma mark - UIScrollViewDelegate

/*
 * AKPickerViewDelegate inherits UIScrollViewDelegate.
 * You can use UIScrollViewDelegate methods
 * by simply setting pickerView's delegate.
 *
 */

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	// Too noisy...
	// NSLog(@"%f", scrollView.contentOffset.x);
}

@end
