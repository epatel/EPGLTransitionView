
This was done to a "Utility Application" straight from the Xcode template

• Added files from 'src' the directory.

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
		
		EPGLTransitionView *glview = [[[EPGLTransitionView alloc] 
									   initWithView:self.view
									   delegate:transition] autorelease];
		
    #ifdef ENABLE_PHASE_IN
 
        // Get texture for the "next" view
        [glview prepareTextureTo:controller.view];
 
        // If you are using an "IN" animation for the "next" view set appropriate 
        // clear color (ie no alpha) 
        [glview setClearColorRed:0.3
                           green:0.3
                            blue:0.3
                           alpha:1.0];
    #endif

		[glview startTransition];
		
		[self presentModalViewController:controller animated:NO];
		
		[controller release];
	}


• To enable a demo of creating a transition for the 'next' view, uncomment the
  macro definition in 'DemoTransition.h'

• Added check for iPad screen size and increases size used for textures of 
  screen copies
