//
//  AKViewController.m
//  AKPickerViewSample
//
//  Created by Akio Yasui on 3/29/14.
//  Copyright (c) 2014 Akio Yasui. All rights reserved.
//

#import "AKViewController.h"

#import "AKPickerView.h"

@interface AKViewController () <AKPickerViewDelegate>
@property (nonatomic, strong) AKPickerView *pickerView;
@property (nonatomic, strong) NSArray *titles;
@end

@implementation AKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.pickerView = [[AKPickerView alloc] initWithFrame:self.view.bounds];
	self.pickerView.delegate = self;
	self.pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.view addSubview:self.pickerView];

	self.pickerView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
	self.pickerView.highlightedFont = [UIFont fontWithName:@"HelveticaNeue" size:20];
	self.pickerView.interitemSpacing = 20.0;
	self.pickerView.fisheyeFactor = 0.001;

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

- (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView
{
	return [self.titles count];
}

- (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item
{
	return self.titles[item];
}

- (void)pickerView:(AKPickerView *)pickerView didSelectItem:(NSInteger)item
{
	NSLog(@"%@", self.titles[item]);
}

@end
