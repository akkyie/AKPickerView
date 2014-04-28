AKPickerView
============

![image](https://raw.githubusercontent.com/Akkyie/AKPickerView/master/Screenshot.gif)


A simple but customizable horizontal picker view.

Works on iOS 6/7.

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

You can change appearances below.

    @property (nonatomic, strong) UIFont *font;
    @property (nonatomic, strong) UIColor *textColor;
    @property (nonatomic, strong) UIColor *highlightedTextColor;
    @property (nonatomic, assign) CGFloat interitemSpacing;

After all settings, never forget to reload your picker.

    [self.pickerView reloadData];
    
For more detail, see the sample project.
