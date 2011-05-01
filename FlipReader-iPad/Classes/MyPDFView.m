//
//  MyPDFView.m
//  GoForth
//
//  Created by Edward Patel on 2010-12-25.
//  Copyright 2010 Memention AB. All rights reserved.
//

#import "MyPDFView.h"

@implementation MyPDFView

@synthesize numBookPages;

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
		NSURL *coverURL = [[NSBundle mainBundle] URLForResource:@"thinking-forth-cover" withExtension:@"pdf"];
		cover = CGPDFDocumentCreateWithURL((CFURLRef)coverURL);
		NSURL *bookURL = [[NSBundle mainBundle] URLForResource:@"thinking-forth-color" withExtension:@"pdf"];
		book = CGPDFDocumentCreateWithURL((CFURLRef)bookURL);
    numBookPages = CGPDFDocumentGetNumberOfPages(book);
		pageNumber = 1;
  }
  return self;
}

- (void)gotoPage:(int)nextPage
{
	pageNumber = nextPage;
	[self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {	
	CGPDFPageRef page1;
	CGPDFPageRef page2;
  
  if (pageNumber) {
    page1 = CGPDFDocumentGetPage(book, pageNumber-2);
    page2 = CGPDFDocumentGetPage(book, pageNumber-1);
    CGRect pageRect;
    if (page1)
      pageRect = CGPDFPageGetBoxRect(page1, kCGPDFMediaBox);
    else
      pageRect = CGPDFPageGetBoxRect(page2, kCGPDFMediaBox);
    
    CGRect frameRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    CGFloat scaleFactorWidth = 0.5*frameRect.size.width/pageRect.size.width;
    CGFloat nudge = ((frameRect.size.height/scaleFactorWidth) - pageRect.size.height) / 2.0;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextFillRect(context, frameRect);
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, frameRect.size.width/2.0, frameRect.size.height-nudge);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextScaleCTM(context, scaleFactorWidth, scaleFactorWidth);	
    CGContextTranslateCTM(context, -0.5*frameRect.size.width/scaleFactorWidth, 0);
    if (page1)
      CGContextDrawPDFPage(context, page1);
    CGContextTranslateCTM(context, 0.5*frameRect.size.width/scaleFactorWidth, 0);
    if (page2)
      CGContextDrawPDFPage(context, page2);
    CGContextMoveToPoint(context, -0.5/scaleFactorWidth, -nudge/scaleFactorWidth);
    CGContextAddLineToPoint(context, -0.5/scaleFactorWidth, frameRect.size.height/scaleFactorWidth);
    CGContextStrokePath(context);
  } else {
    page1 = CGPDFDocumentGetPage(cover, 1);
    CGRect pageRect = CGPDFPageGetBoxRect(page1, kCGPDFMediaBox);
    
    CGRect frameRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    CGFloat scaleFactorHeight = frameRect.size.height/pageRect.size.height;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    //CGContextFillRect(context, frameRect);
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextScaleCTM(context, scaleFactorHeight, scaleFactorHeight);	
    CGContextDrawPDFPage(context, page1);
  }
}

- (void)dealloc {
	CGPDFDocumentRelease(book);
  [super dealloc];
}

@end
