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
- (NSArray*)constraintsContainingView:(UIView*)view;
- (BOOL)view:(UIView*)view containtConstraint:(NSLayoutConstraint*)constraintToFind;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //We need to remember the original vertical space because we are going to overwrite
    _view1SecondLabelVerticalSpaceSize = self.view1SecondLabelVerticalSpaceConstraint.constant;
}

//With this method we set the size-constraint's constant-value to 0 in IB, and we change the compression resistance priority value
- (IBAction)view1ButtonPushed:(UIButton *)sender {
    
    if (self.view1FirstLabel.hidden) {
        self.view1FirstLabel.hidden = NO;
        [self.view1FirstLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        self.view1SecondLabelVerticalSpaceConstraint.constant = _view1SecondLabelVerticalSpaceSize;
        [sender setTitle:@"Hide first label" forState:UIControlStateNormal];
    } else {
        self.view1FirstLabel.hidden = YES;
        [self.view1FirstLabel setContentCompressionResistancePriority:0 forAxis:UILayoutConstraintAxisVertical];
        self.view1SecondLabelVerticalSpaceConstraint.constant = 0;
        [sender setTitle:@"Show first label" forState:UIControlStateNormal];
    }
}

//With this method we have 2 constraints with different priorities, and we remove the view
- (IBAction)view2ButtonPushed:(UIButton *)sender {
    
    if (self.view2FirstLabel.hidden) {
        self.view2FirstLabel.hidden = NO;
        [self.view2 addSubview:self.view2FirstLabel];
        [self.view2 addConstraints:_constraints];
        [sender setTitle:@"Hide first label" forState:UIControlStateNormal];
    } else {
        self.view2FirstLabel.hidden = YES;
        _constraints = [self constraintsContainingView:self.view2FirstLabel];
        [self.view2FirstLabel removeFromSuperview];
        [sender setTitle:@"Show first label" forState:UIControlStateNormal];
    }
}

- (IBAction)animationButtonPushed:(UIButton *)sender {
    
    if ([self view:sender.superview containtConstraint:self.leftAnimationConstraint]) {
        
        [sender.superview removeConstraint:self.leftAnimationConstraint];
        
        //We may have other constraints that are dependent on the one we just changed
        [sender.superview setNeedsUpdateConstraints];
        
        [UIView animateWithDuration:1 animations:^{
            [sender.superview layoutIfNeeded];
        }];
    }else
    //If you have animations pending use this way (in our example it doesn't matter):
    {
        //Ensures that all pending layout operations have been completed
        [self.view layoutIfNeeded];
    
        [UIView animateWithDuration:1 animations:^{
            [sender.superview addConstraint:self.leftAnimationConstraint];
            
            //Forces the layout of the subtree animation block and then captures all of the frame changes
            [sender.superview layoutIfNeeded];
        }];
    }
}

- (IBAction)swap:(UIButton*)sender {
    [self swapView:self.swapLabel withView:self.swapButton];
}

//Code from: http://stackoverflow.com/questions/19816703/replacing-nsview-while-keeping-autolayout-constraints
- (void)swapView:(UIView*)source withView:(UIView*)dest {
    
    //The 2 views must have the same superview
    if (source.superview != dest.superview) {
        return;
    }
    
    // we are altering the constraints so iterate a copy!
    NSArray *constraints = [dest.superview.constraints copy];
    for (NSLayoutConstraint *constraint in constraints) {
        id first = constraint.firstItem;
        id second = constraint.secondItem;
        id newFirst = first;
        id newSecond = second;
        
        BOOL match = NO;
        if (first == dest) {
            newFirst = source;
            match = YES;
        }
        if (second == dest) {
            newSecond = source;
            match = YES;
        }
        if (first == source) {
            newFirst = dest;
            match = YES;
        }
        if (second == source) {
            newSecond = dest;
            match = YES;
        }
        if (match && newFirst) {
            [dest.superview removeConstraint:constraint];
            NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:newFirst
                                                         attribute:constraint.firstAttribute
                                                         relatedBy:constraint.relation
                                                            toItem:newSecond
                                                         attribute:constraint.secondAttribute
                                                        multiplier:constraint.multiplier
                                                          constant:constraint.constant];
            newConstraint.shouldBeArchived = constraint.shouldBeArchived;
            newConstraint.priority = constraint.priority;
            [dest.superview addConstraint:newConstraint];
        }
    }
    
    NSMutableArray *newSourceConstraints = [NSMutableArray array];
    NSMutableArray *newDestConstraints = [NSMutableArray array];
    
    // again we need a copy since we will be altering the original
    constraints = [source.constraints copy];
    for (NSLayoutConstraint *constraint in constraints) {
        // WARNING: do not tamper with intrinsic layout constraints
        if ([constraint class] == [NSLayoutConstraint class]
            && constraint.firstItem == source) {
            // this is a source constraint. we need to copy it to the destination.
            NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:dest
                                                         attribute:constraint.firstAttribute
                                                         relatedBy:constraint.relation
                                                            toItem:constraint.secondItem
                                                         attribute:constraint.secondAttribute
                                                        multiplier:constraint.multiplier
                                                          constant:constraint.constant];
            newConstraint.shouldBeArchived = constraint.shouldBeArchived;
            newConstraint.priority = constraint.priority;
            [newDestConstraints addObject:newConstraint];
            [source removeConstraint:constraint];
        }
    }
    
    // again we need a copy since we will be altering the original
    constraints = [dest.constraints copy];
    for (NSLayoutConstraint *constraint in constraints) {
        // WARNING: do not tamper with intrinsic layout constraints
        if ([constraint class] == [NSLayoutConstraint class]
            && constraint.firstItem == dest) {
            // this is a destination constraint. we need to copy it to the source.
            NSLayoutConstraint *newConstraint = [NSLayoutConstraint constraintWithItem:source
                                                         attribute:constraint.firstAttribute
                                                         relatedBy:constraint.relation
                                                            toItem:constraint.secondItem
                                                         attribute:constraint.secondAttribute
                                                        multiplier:constraint.multiplier
                                                          constant:constraint.constant];
            newConstraint.shouldBeArchived = constraint.shouldBeArchived;
            newConstraint.priority = constraint.priority;
            [newSourceConstraints addObject:newConstraint];
            [dest removeConstraint:constraint];
        }
    }
    
    [dest addConstraints:newDestConstraints];
    [source addConstraints:newSourceConstraints];
}

#pragma mark - Help Methods

- (NSArray*)constraintsContainingView:(UIView*)view {
    
    NSMutableArray *constraints = [NSMutableArray array];
    for (NSLayoutConstraint *constraint in view.superview.constraints) {
        if (constraint.firstItem == view || constraint.secondItem == view) {
            [constraints addObject:constraint];
        }
    }
    return [NSArray arrayWithArray:constraints];
}

- (BOOL)view:(UIView*)view containtConstraint:(NSLayoutConstraint*)constraintToFind {
    BOOL wasFound = NO;
    for (NSLayoutConstraint *constraint in view.constraints) {
        if (constraint == constraintToFind) {
            wasFound = YES;
            break;
        }
    }
    return wasFound;
}

@end
