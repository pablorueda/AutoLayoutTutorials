# Auto Layout Programmatically

This project shows how to create constraints programmatically.

You can create them in 2 ways:

1)

	NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:label1 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:20];
    [self.view addConstraint:constraint];

2) Using the Visual Format Language 

	NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(button1, button2);
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[button1]-[button2]" options:0 metrics:nil views:viewsDictionary];
    [self.view addConstraints:constraints];

## Tips

1) If we create the view programmatically we need to indicate that we will add the constraints ourselves: 

    [button1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    
2) All views must have been added to the superview before you can create the constraints.

3) We can NOT use dot notation for properties when we are creating the view dictionary.

4) We can create metrics to don't need to enter numbers directly:

	NSDictionary *metrics = @{@"separation":@20.0};
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[button1]-separation-[button2]" options:0 metrics:metrics views:viewsDictionary];
    
5) We can set format options, it's useful for alignment:

	NSLayoutFormatOptions options = NSLayoutFormatAlignAllTop;
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[button1]-[button2]" options:options metrics:nil views:viewsDictionary];