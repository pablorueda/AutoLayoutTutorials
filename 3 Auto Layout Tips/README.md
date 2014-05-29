# Auto Layout Tips

## Hide a view

Sometimes we have a layer like this

	[ViewA]-[ViewB]-[ViewC]
 
and we want to hide B, and move C accordly so that our relation will be 

	[ViewA]-[ViewC]
	
There are two ways of doing this:

### 1) To have 2 constraints with different priorities

1) In Interface Builder, create a second constraint between the ViewA and viewC with priority lower than the constraint between ViewB and ViewC.

	[ViewA]-yourDistance@lowPriority-[ViewC]

In code, remove ViewB. You will get the desired effect. 

If you want to show again the ViewB, you will need to recreate the constraints, so it's a good idea to save them in an array if you plan to show the view again.

### 2) To set the size-constraint's constant-value to 0

##### A) Without intrinsic content size

Set the ViewB's size constraint and his vertical/horizontal space constraint to variables/properties.

When you want to hide ViewB, just set to 0 the constant value of these constraints.

##### B) With intrinsic content size

You need to set ViewB's compression resistance priority to 0 in code when you want to hide it, and when you want to show again restore that value. Apart of that you need to add a constraint in interface builder to set the size of the view to 0. There is not need to touch this contraint in the code.


## Animate a view

Here i explain 2 ways of doing animation with autolayout:

1)

	//Update constraints
	
	[UIView animateWithDuration:1 animations:^{
    	[myView layoutIfNeeded];
	}];

2)

	[containerView layoutIfNeeded]; // Ensures that all pending layout operations have been completed

	[UIView animateWithDuration:1.0 animations:^{

     	// Make all constraint changes here

     	[containerView layoutIfNeeded]; // Forces the layout of the subtree animation block and then captures all of the frame changes

	}];


## Swap two views

- http://stackoverflow.com/questions/19816703/replacing-nsview-while-keeping-autolayout-constraints