//
//  FlipReaderViewController.h
//  FlipReader
//
//  Created by Edward Patel on 2011-02-01.
//  Copyright 2011 Memention AB. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyPDFView.h"

@interface FlipReaderViewController : UIViewController<UIGestureRecognizerDelegate> {
	MyPDFView *mpv;
  int pageNumber;
}

@end

