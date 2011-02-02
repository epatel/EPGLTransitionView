//
//  MyPDFView.h
//  GoForth
//
//  Created by Edward Patel on 2010-12-25.
//  Copyright 2010 Memention AB. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MyPDFView : UIView {
	CGPDFDocumentRef cover;
	CGPDFDocumentRef book;
	int pageNumber;
  int numBookPages;
}

@property (readonly, nonatomic) int numBookPages;

- (void)gotoPage:(int)nextPage;

@end
