//
//  FlipReaderAppDelegate.h
//  FlipReader
//
//  Created by Edward Patel on 2011-02-01.
//  Copyright 2011 Memention AB. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlipReaderViewController;

@interface FlipReaderAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    FlipReaderViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet FlipReaderViewController *viewController;

@end

