//
//  MyPDFView.m
//  GoForth
//
//  Created by Edward Patel on 2010-12-25.
//  Copyright 2010 Memention AB. All rights reserved.
//

#import "MyPDFView.h"

@implementation MyPDFView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
		NSURL *bookURL = [[NSBundle mainBundle] URLForResource:@"thinking-forth-color" withExtension:@"pdf"];
		book = CGPDFDocumentCreateWithURL((CFURLRef)bookURL);
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
   
  page1 = CGPDFDocumentGetPage(book, pageNumber);
  page2 = CGPDFDocumentGetPage(book, pageNumber+1);
  
	CGRect pageRect;
  if (page1)
    pageRect = CGPDFPageGetBoxRect(page1, kCGPDFMediaBox);
  else
    pageRect = CGPDFPageGetBoxRect(page2, kCGPDFMediaBox);
  
	CGRect frameRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
	CGFloat scaleFactorWidth = 0.5*frameRect.size.width/pageRect.size.width;
  
	CGContextRef context = UIGraphicsGetCurrentContext();
  
  CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
	CGContextFillRect(context, frameRect);
	CGContextSaveGState(context);
  CGContextTranslateCTM(context, 0, rect.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
  CGContextScaleCTM(context, scaleFactorWidth, scaleFactorWidth);	
  if (page1)
    CGContextDrawPDFPage(context, page1);
  CGContextTranslateCTM(context, 0.5*rect.size.height*scaleFactorWidth, 0);
  if (page2)
    CGContextDrawPDFPage(context, page2);
  CGContextMoveToPoint(context, 0.5*scaleFactorWidth, 0);
  CGContextAddLineToPoint(context, 0.5*scaleFactorWidth, rect.size.width*scaleFactorWidth);
  CGContextStrokePath(context);
}

- (void)dealloc {
	CGPDFDocumentRelease(book);
  [super dealloc];
}

@end
