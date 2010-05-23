//
//  DemoProjectAppDelegate.m
//  DemoProject
//
//  Created by Edward Patel on 2010-02-28.
//  Copyright Memention AB 2010. All rights reserved.
//

#import "DemoProjectAppDelegate.h"
#import "MainViewController.h"

@implementation DemoProjectAppDelegate


@synthesize window;
@synthesize mainViewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
	MainViewController *aController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
	self.mainViewController = aController;
	[aController release];
	
    mainViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	[window addSubview:[mainViewController view]];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [mainViewController release];
    [window release];
    [super dealloc];
}

@end
