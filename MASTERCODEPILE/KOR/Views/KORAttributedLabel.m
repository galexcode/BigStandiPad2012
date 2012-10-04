//
//  KORAttributedLabel.m
//  coreText
//
//  Created by Paul Warren on 2/8/11.
//  Copyright 2011 Primitive Dog Software. All rights reserved.
//

#import "KORAttributedLabel.h"
#import <CoreText/CoreText.h>
@interface KORAttributedLabel()

@end

@implementation KORAttributedLabel

@synthesize attributedText;



// START:setAttributedText
- (void)setAttributedText:(NSAttributedString  *)newAttributedText {
    
    if (attributedText != newAttributedText) {
        attributedText = [newAttributedText copy];
        [self setNeedsDisplay];  
}    
    
  //super.text = [newAttributedText string];
    
}
// END:setAttributedText

// START:drawRect
- (void)drawRect:(CGRect)rect {
	if (self.attributedText == nil) 
		return;
    
	CGContextRef context = UIGraphicsGetCurrentContext(); 	
	
	CGContextSaveGState(context);

	CGContextTranslateCTM(context, self.bounds.size.width/2, 
                                self.bounds.size.height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	CTLineRef line = CTLineCreateWithAttributedString((__bridge  CFAttributedStringRef) 
                                                      self.attributedText);
	
	CGContextSetTextPosition(context, ceill(-self.bounds.size.width/2), 
                                ceill(self.bounds.size.height/4));
	CTLineDraw(line, context);

	CGContextRestoreGState(context);	
	CFRelease(line);	
}
// END:drawRect
    

@end
