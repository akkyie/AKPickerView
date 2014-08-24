AKPickerView
============

![Screenshot](./Screenshot.gif)


A simple yet customizable horizontal picker view.

Works on iOS 6, 7 and 8.

Installation
------------

Use [CocoaPods](http://cocoapods.org)

    pod "AKPickerView"
    
…or simply add AKPickerView.h/m into your project.

Usage
-----

Instantiate and set *delegate* as you know,

    self.pickerView = [[AKPickerView alloc] initWithFrame:<#frame#>];
    self.pickerView.delegate = self;

and specify items using delegate methods.

    - (NSUInteger)numberOfItemsInPickerView:(AKPickerView *)pickerView;
    - (NSString *)pickerView:(AKPickerView *)pickerView titleForItem:(NSInteger)item;

You can change its appearance with properties below.

    @property (nonatomic, strong) UIFont *font;
    @property (nonatomic, strong) UIFont *highlightedFont;
    @property (nonatomic, strong) UIColor *textColor;
    @property (nonatomic, strong) UIColor *highlightedTextColor;
    @property (nonatomic, assign) CGFloat interitemSpacing;
    @property (nonatomic, assign) CGFloat fisheyeFactor;
    
- All cells are laid out depending on the largest font, so large differnce between sizes of *font* and *highlightedFont* is not recommended.  
- fisheyeFactor property affects perspective distortion.

After all settings, never forget to reload your picker.

    [self.pickerView reloadData];
    
For more detail, see the sample project.

Contact
-------

@akkyie http://twitter.com/akkyie

License
-------
See LICENSE.
