//
//  AKPickerView.m
//  AKPickerViewSample
//
//  Created by Akio Yasui on 3/29/14.
//  Copyright (c) 2014 Akio Yasui. All rights reserved.
//

#import "AKPickerView.h"

#import <Availability.h>

@interface AKCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIFont *highlightedFont;
@end

@interface AKCollectionViewLayout : UICollectionViewFlowLayout
@end

@interface AKPickerView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSUInteger selectedItem;
- (CGFloat)offsetForItem:(NSUInteger)item;
- (void)didEndScrolling;
- (CGSize)sizeForString:(NSString *)string;
@end

@implementation AKPickerView

- (void)initialize
{
	self.font = self.font ?: [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
	self.highlightedFont = self.highlightedFont ?: [UIFont fontWithName:@"HelveticaNeue" size:20];
	self.textColor = self.textColor ?: [UIColor darkGrayColor];
	self.highlightedTextColor = self.highlightedTextColor ?: [UIColor blackColor];

	[self.collectionView removeFromSuperview];
	self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds
											 collectionViewLayout:[AKCollectionViewLayout new]];
	self.collectionView.showsHorizontalScrollIndicator = NO;
	self.collectionView.backgroundColor = [UIColor clearColor];
	self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
	self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.collectionView.delegate = self;
	self.collectionView.dataSource = self;
	[self.collectionView registerClass:[AKCollectionViewCell class]
			forCellWithReuseIdentifier:NSStringFromClass([AKCollectionViewCell class])];
	[self addSubview:self.collectionView];

	CAGradientLayer *maskLayer = [CAGradientLayer layer];
	maskLayer.frame = self.collectionView.bounds;
	maskLayer.colors = @[(id)[[UIColor clearColor] CGColor],
						 (id)[[UIColor blackColor] CGColor],
						 (id)[[UIColor blackColor] CGColor],
						 (id)[[UIColor clearColor] CGColor],];
	maskLayer.locations = @[@0.0, @0.33, @0.66, @1.0];
	maskLayer.startPoint = CGPointMake(0.0, 0.0);
	maskLayer.endPoint = CGPointMake(1.0, 0.0);
	self.collectionView.layer.mask = maskLayer;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self initialize];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self initialize];
	}
	return self;
}

#pragma mark -

- (void)layoutSubviews
{
	[super layoutSubviews];
	[self.collectionView.collectionViewLayout invalidateLayout];
	[self scrollToItem:self.selectedItem animated:NO];
	self.collectionView.layer.mask.frame = self.collectionView.bounds;

	CATransform3D transform = CATransform3DIdentity;
	transform.m34 = -MAX(MIN(self.fisheyeFactor, 1.0), 0.0);
	self.collectionView.layer.sublayerTransform = transform;
}

- (CGSize)intrinsicContentSize
{
	return CGSizeMake(UIViewNoIntrinsicMetric, [self sizeForString:@"Xy"].height);
}

#pragma mark -

- (void)setFont:(UIFont *)font
{
	if (![_font isEqual:font]) {
		_font = font;
		[self initialize];
	}
}

- (void)setHighlightedFont:(UIFont *)highlightedFont
{
	if (![_highlightedFont isEqual:highlightedFont]) {
		_highlightedFont = highlightedFont;
		[self initialize];
	}
}

#pragma mark -

- (CGSize)sizeForString:(NSString *)string
{
	CGSize size;
	CGSize highlightedSize;
#ifdef __IPHONE_7_0
	size = [string sizeWithAttributes:@{NSFontAttributeName: self.font}];
	highlightedSize = [string sizeWithAttributes:@{NSFontAttributeName: self.highlightedFont}];
#else
	size = [string sizeWithFont:self.font];
	highlightedSize = [string sizeWithFont:self.highlightedFont];
#endif
	return CGSizeMake(ceilf(MAX(size.width, highlightedSize.width)), ceilf(MAX(size.height, highlightedSize.height)));
}

#pragma mark -

- (void)reloadData
{
	[self invalidateIntrinsicContentSize];
	[self.collectionView.collectionViewLayout invalidateLayout];
	[self.collectionView reloadData];
	dispatch_async(dispatch_get_main_queue(), ^{
		[self selectItem:self.selectedItem animated:NO];
	});
}

- (CGFloat)offsetForItem:(NSUInteger)item
{
	CGFloat offset = 0.0;
	for (NSInteger i = 0; i < item; i++) {
		NSIndexPath *_indexPath = [NSIndexPath indexPathForItem:i inSection:0];
		AKCollectionViewCell *cell = (AKCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:_indexPath];
		offset += cell.bounds.size.width;
	}

	NSIndexPath *firstIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
	CGSize firstSize = [self.collectionView cellForItemAtIndexPath:firstIndexPath].bounds.size;
	NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForItem:item inSection:0];
	CGSize selectedSize = [self.collectionView cellForItemAtIndexPath:selectedIndexPath].bounds.size;
	offset -= (firstSize.width - selectedSize.width) / 2;
	offset += self.interitemSpacing * item;

	return offset;
}

- (void)scrollToItem:(NSUInteger)item animated:(BOOL)animated
{
	[self.collectionView setContentOffset:CGPointMake([self offsetForItem:item],
													  self.collectionView.contentOffset.y)
								 animated:animated];
}

- (void)selectItem:(NSUInteger)item animated:(BOOL)animated
{
	[self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:item inSection:0]
									  animated:animated
								scrollPosition:UICollectionViewScrollPositionNone];
	[self scrollToItem:item animated:animated];

	self.selectedItem = item;

	if ([self.delegate respondsToSelector:@selector(pickerView:didSelectItem:)])
		[self.delegate pickerView:self didSelectItem:item];
}

- (void)didEndScrolling
{
	if ([self.delegate numberOfItemsInPickerView:self]) {
		for (NSUInteger i = 0; i < [self collectionView:self.collectionView numberOfItemsInSection:0]; i++) {
			NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
			AKCollectionViewCell *cell = (AKCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
			if ([self offsetForItem:i] + cell.bounds.size.width / 2 > self.collectionView.contentOffset.x) {
				[self selectItem:i animated:YES];
				break;
			}
		}
	}
}

#pragma mark -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return ([self.delegate numberOfItemsInPickerView:self] > 0);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return [self.delegate numberOfItemsInPickerView:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *title = [self.delegate pickerView:self titleForItem:indexPath.item];

	AKCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([AKCollectionViewCell class])
																		   forIndexPath:indexPath];
	cell.label.textColor = self.textColor;
	cell.label.highlightedTextColor = self.highlightedTextColor;
	cell.label.font = self.font;
	cell.font = self.font;
	cell.highlightedFont = self.highlightedFont;
	if ([cell.label respondsToSelector:@selector(setAttributedText:)]) {
		cell.label.attributedText = [[NSAttributedString alloc] initWithString:title
																	attributes:@{NSFontAttributeName: self.font}];
	} else {
		cell.label.text = title;
	}

	cell.selected = (indexPath.item == self.selectedItem);

	return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *title = [self.delegate pickerView:self titleForItem:indexPath.item];
	return [self sizeForString:title];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
	return self.interitemSpacing;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
	NSInteger number = [self collectionView:collectionView numberOfItemsInSection:section];
	NSIndexPath *firstIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
	CGSize firstSize = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:firstIndexPath];
	NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:number - 1 inSection:section];
	CGSize lastSize = [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:lastIndexPath];
	return UIEdgeInsetsMake((collectionView.bounds.size.height - ceilf(self.highlightedFont.lineHeight)) / 2,
							(collectionView.bounds.size.width - firstSize.width) / 2,
							(collectionView.bounds.size.height - ceilf(self.highlightedFont.lineHeight)) / 2,
							(collectionView.bounds.size.width - lastSize.width) / 2);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
	[self selectItem:indexPath.item animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	[self didEndScrolling];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (!decelerate) [self didEndScrolling];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue
					 forKey:kCATransactionDisableActions];
	self.collectionView.layer.mask.frame = self.collectionView.bounds;
	[CATransaction commit];
}

@end

@implementation AKCollectionViewCell

- (void)initialize
{
	self.layer.doubleSided = NO;
	self.label = [[UILabel alloc] initWithFrame:self.contentView.bounds];
	self.label.backgroundColor = [UIColor clearColor];
	self.label.textAlignment = NSTextAlignmentCenter;
	self.label.textColor = [UIColor grayColor];
	self.label.numberOfLines = 1;
	self.label.lineBreakMode = NSLineBreakByTruncatingTail;
	self.label.highlightedTextColor = [UIColor blackColor];
	self.label.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
	self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.contentView addSubview:self.label];
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		[self initialize];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self initialize];
	}
	return self;
}

- (void)setSelected:(BOOL)selected
{
	[super setSelected:selected];

	CATransition *transition = [CATransition animation];
	[transition setType:kCATransitionFade];
	[transition setDuration:0.15];
	[self.label.layer addAnimation:transition forKey:nil];

	UIFont *font = self.selected ? self.highlightedFont : self.font;
	if ([self.label respondsToSelector:@selector(setAttributedText:)]) {
		self.label.attributedText = [[NSAttributedString alloc] initWithString:self.label.attributedText.string
																	attributes:@{NSFontAttributeName: font}];
	} else {
		self.label.font = font;
	}
}

@end

@interface AKCollectionViewLayout ()
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat midX;
@property (nonatomic, assign) CGFloat maxAngle;
@end

@implementation AKCollectionViewLayout

- (id)init
{
	self = [super init];
	if (self) {
		self.sectionInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
		self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
		self.minimumLineSpacing = 0.0;
	}
	return self;
}

- (void)prepareLayout
{
	CGRect visibleRect = (CGRect){self.collectionView.contentOffset, self.collectionView.bounds.size};
	self.midX = CGRectGetMidX(visibleRect);
	self.width = CGRectGetWidth(visibleRect) / 2;
	self.maxAngle = M_PI_2;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
	return YES;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];

	CGFloat distance = CGRectGetMidX(attributes.frame) - self.midX;
	CGFloat currentAngle = self.maxAngle * distance / self.width / M_PI_2;

	CATransform3D transform = CATransform3DIdentity;
	transform = CATransform3DTranslate(transform, -distance, 0, -self.width);
	transform = CATransform3DRotate(transform, currentAngle, 0, 1, 0);
	transform = CATransform3DTranslate(transform, 0, 0, self.width);
	attributes.transform3D = transform;

	attributes.alpha = (ABS(currentAngle) < self.maxAngle);

	return attributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
	NSMutableArray *attributes = [NSMutableArray array];
	if ([self.collectionView numberOfSections]) {
		for (NSInteger i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
			NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
			[attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
		}
	}
	return attributes;
}

@end