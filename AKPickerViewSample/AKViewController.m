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
@property (nonatomic, strong) NSArray *colors;
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
    
    self.colors = @[[UIColor redColor],
                    [UIColor greenColor],
                    [UIColor yellowColor],
                    [UIColor blueColor],
                    [UIColor orangeColor],
                    [UIColor purpleColor],
                    [UIColor brownColor],
                    [UIColor redColor],
                    [UIColor greenColor],
                    [UIColor yellowColor]];

	[self.pickerView reloadData];
}

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

- (void)pickerView:(AKPickerView *)pickerView editLabel:(UILabel *)label forItem:(NSInteger)item
{
    label.layer.cornerRadius = 2.0;
    label.backgroundColor = self.colors[item];
    label.clipsToBounds = YES;
}

- (CGSize)pickerView:(AKPickerView *)pickerView editLabelMarginForItem:(NSInteger)item
{
    return CGSizeMake(8, 4);
}

- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item
{
	NSLog(@"%@", self.titles[item]);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	// Too noisy...
	// NSLog(@"%f", scrollView.contentOffset.x);
}

@end
