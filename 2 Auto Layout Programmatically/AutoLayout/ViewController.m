//
//  ViewController.m
//
//  Copyright (C) 2014 Pablo Rueda
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.

#import "ViewController.h"

@interface ViewController ()
- (void)createConstraints;
- (void)createConstraintsWithVisualFormatLanguage;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createConstraints];
    
    //Cocoa provides a visual format language to represent the layout we want to describe, this method uses it
    [self createConstraintsWithVisualFormatLanguage];
}

- (void)createConstraints {
    
    UILabel *label1 = [[UILabel alloc] init];
    //This line is important! Here we indicate that we want to indicate the constraints ourselves
    [label1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    label1.text = @"Label 1";
    //All views must have been added to the superview before you can create the constraints
    [self.view addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] init];
    [label2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    label2.text = @"Label 2";
    [self.view addSubview:label2];
    
    //We will use intrinsic content size, so we don't need to assign the size of the labels
    
    //We place the first label related to the container view
    NSLayoutConstraint *label1XPositionConstraint = [NSLayoutConstraint constraintWithItem:label1
                                                                           attribute:NSLayoutAttributeLeading
                                                                           relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.view
                                                                           attribute:NSLayoutAttributeLeading
                                                                           multiplier:1.0
                                                                           constant:20];
    NSLayoutConstraint *label1YPositionConstraint = [NSLayoutConstraint constraintWithItem:label1
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.view
                                                                          attribute:NSLayoutAttributeTop
                                                                         multiplier:1.0
                                                                           constant:50];
    [self.view addConstraint:label1XPositionConstraint];
    [self.view addConstraint:label1YPositionConstraint];
    
    //We place the second label related to the first label
    NSLayoutConstraint *horizontalSeparationConstraint =[NSLayoutConstraint constraintWithItem:label2
                                                                                     attribute:NSLayoutAttributeLeading
                                                                                     relatedBy:NSLayoutRelationEqual
                                                                                        toItem:label1
                                                                                     attribute:NSLayoutAttributeTrailing
                                                                                    multiplier:1
                                                                                      constant:10];
    NSLayoutConstraint *alignTopConstraint = [NSLayoutConstraint constraintWithItem:label2
                                                                           attribute:NSLayoutAttributeTop
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:label1
                                                                           attribute:NSLayoutAttributeTop
                                                                          multiplier:1
                                                                            constant:0];
    [self.view addConstraint:horizontalSeparationConstraint];
    [self.view addConstraint:alignTopConstraint];
}

- (void)createConstraintsWithVisualFormatLanguage {
    
    UIButton *bottomButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [bottomButton setTitle:@"Bottom Button" forState:UIControlStateNormal];
    [bottomButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:bottomButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [rightButton setTitle:@"Right Button" forState:UIControlStateNormal];
    [rightButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:rightButton];
    
    //Note we can NOT use self.leftButton
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings(_leftButton, bottomButton, rightButton);
    
    NSArray *verticalBottomButtonConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_leftButton]-[bottomButton]" options:0 metrics:nil views:viewsDictionary];
    [self.view addConstraints:verticalBottomButtonConstraints];
    
    //We can create metrics to don't need to enter numbers directly
    NSDictionary *metrics = @{@"separation":@20.0};
    NSArray *horizontalBottomButtonConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_leftButton]-separation-[bottomButton]" options:0 metrics:metrics views:viewsDictionary];
    [self.view addConstraints:horizontalBottomButtonConstraints];
    
    //We can set format options, it's useful for alignment
    NSLayoutFormatOptions options = NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom;
    NSArray *rightButtonConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_leftButton]-[rightButton]" options:options metrics:nil views:viewsDictionary];
    [self.view addConstraints:rightButtonConstraints];
}

@end
