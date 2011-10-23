//
//  MainViewController.m
//  DemoProject
//
//  Created by Edward Patel on 2010-02-28.
//  Copyright Memention AB 2010. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"

#import "DemoTransition.h"
#import "Demo2Transition.h"
#import "Demo3Transition.h"

@implementation MainViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}


/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */


- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    
    [self dismissModalViewControllerAnimated:YES];
}


- (IBAction)showInfo:(id)sender 
{        
    FlipsideViewController *controller = [[FlipsideViewController alloc] 
                                          initWithNibName:@"FlipsideView" 
                                          bundle:nil];
    controller.delegate = self;
    
    NSObject<EPGLTransitionViewDelegate> *transition;
    
	switch ([sender tag]) {
		case 0:
			transition = [[[DemoTransition alloc] init] autorelease];
			break;
		case 1:
			transition = [[[Demo2Transition alloc] init] autorelease];
			break;
		case 2:
			transition = [[[Demo3Transition alloc] init] autorelease];
			break;
	}

    EPGLTransitionView *glview = [[[EPGLTransitionView alloc] 
                                   initWithView:self.view
                                   delegate:transition] autorelease];
    
    if ([sender tag]) {
        [glview prepareTextureTo:controller.view];
		// If you are using an "IN" animation for the "next" view set appropriate 
		// clear color (ie no alpha) 
		[glview setClearColorRed:0.0
						   green:0.0
							blue:0.0
						   alpha:1.0];
	}    
    
    [glview startTransition];
    
    [self presentModalViewController:controller animated:NO];
    
    
    [controller release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
