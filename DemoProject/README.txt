
This was done to a "Utility Application" straight from the Xcode template

• Added frameworks
	- OpenGLES.framework
	- QuartzCore.framework

• Added an image and some buttons and text in the views for texture effect

• Added #import "DemoTransition.h" in MainViewController.m

• Changed showInfo in MainViewController.m as below

	- (IBAction)showInfo {   	
		
		FlipsideViewController *controller = [[FlipsideViewController alloc]
											  initWithNibName:@"FlipsideView" 
											  bundle:nil];
		controller.delegate = self;
		
		DemoTransition *transition = [[[DemoTransition alloc] init] autorelease];
		
		EPGLTransitionView *glview = [[EPGLTransitionView alloc] 
									  initWithWindow:self.view.window
									  delegate:transition];
		
		[glview autorelease];
		[glview startAnimation];
		
		[self presentModalViewController:controller animated:NO];
		
		[controller release];
	}
