//
//  FlipReaderViewController.m
//  FlipReader
//
//  Created by Edward Patel on 2011-02-01.
//  Copyright 2011 Memention AB. All rights reserved.
//

#import "FlipReaderViewController.h"
#import "EPGLTransitionView.h"
#import "FlipTransitions.h"

@implementation FlipReaderViewController


/*
 // The designated initializer. Override to perform setup that is required before the view is loaded.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
  [super viewDidLoad];
  
  pageNumber = 0;
  
	CGRect rect = CGRectMake(0, 0, 1024, 768);
  
	mpv = [[MyPDFView alloc] initWithFrame:rect];
	[[self view] insertSubview:mpv atIndex:0];
	[mpv gotoPage:pageNumber];
	[mpv release];
  
	UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightAction:)];
	swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
	swipeRight.delegate = self;
	[mpv addGestureRecognizer:swipeRight];
	
	UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftAction:)];
	swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
	swipeLeft.delegate = self;
	[mpv addGestureRecognizer:swipeLeft];
}

- (void)swipeLeftAction:(id)sender {	
  if (pageNumber >= mpv.numBookPages) 
		return;

  NSObject<EPGLTransitionViewDelegate> *transition = [[[FlipForward alloc] init] autorelease];
	
  EPGLTransitionView *glview = [[[EPGLTransitionView alloc] 
                                 initWithView:self.view
                                 delegate:transition] autorelease];
  
  pageNumber += 2;
	[mpv gotoPage:pageNumber];
  
	[glview prepareTextureTo:self.view];
	
	[glview setClearColorRed:0.0
                     green:0.0
                      blue:0.0
                     alpha:1.0];
  
  [glview startTransition];
}

- (void)swipeRightAction:(id)sender {  
  if (pageNumber <= 0) 
		return;

  NSObject<EPGLTransitionViewDelegate> *transition = [[[FlipBackward alloc] init] autorelease];
	
  EPGLTransitionView *glview = [[[EPGLTransitionView alloc] 
                                 initWithView:self.view
                                 delegate:transition] autorelease];

  pageNumber -= 2;
	[mpv gotoPage:pageNumber];
  
	[glview prepareTextureTo:self.view];
	
	[glview setClearColorRed:0.0
                     green:0.0
                      blue:0.0
                     alpha:1.0];
  
  [glview startTransition];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
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
