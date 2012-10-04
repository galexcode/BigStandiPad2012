//
//  AutoScrollButtonView.m
//  gigstand
//
//  Created by bill donner on 6/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KORAutoScrollViewControl.h"


@interface KORAutoScrollViewControl() 
@property (nonatomic) BOOL isPDF;

@property (nonatomic) NSTimeInterval duration;
@end
@implementation KORAutoScrollViewControl
@synthesize isPDF,scrollingOn, cantScroll,pps,duration;

-(void) refreshAutoScrollButtonLabel;
{
    // this is called from init so can't use properties on self
    
	
		//	NSLog (@"refreshing with self.scrollingOn %d",self.scrollingOn);
	
    [super refreshTwoLineButtonLabel];
    
    if ( self.cantScroll) return; // does not restore labels
    
    
    super.line1Label.text =[NSString stringWithFormat:@"%@",self.scrollingOn?@"AUTO":@"OFF"] ;
	
    super.line2Label.text =[NSString stringWithFormat:@"%3dpps",pps] ;
	
	if (((self.pps==1)&&(!self.scrollingOn)) || self.isPDF)
		
		super.line1Label.textColor = super.line2Label.textColor = [UIColor grayColor]; 
	else
		super.line1Label.textColor = super.line2Label.textColor =  (self.scrollingOn?[UIColor yellowColor]:[UIColor whiteColor]);

}
-(void) startScolling;
{
    self.scrollingOn = YES;
}
-(void) stopScrolling;
{
    self.scrollingOn = NO;
    
}

- (id)initWithFrame:(CGRect)frame isPDF:(BOOL)pdf
{
    self = [super initWithFrame:frame];
    if (self) {
   
        // irrelevant button.backgroundColor = [UIColor grayColor];
        // Initialization code
        scrollingOn = NO;
        pps = kDefaultPPS;
        duration = 2.f/pps;
		isPDF = pdf;

        [self refreshAutoScrollButtonLabel];

    }
    return self;
}


#pragma mark -
#pragma mark === pps ===
#pragma mark -

- (NSUInteger)pps {
		//return lrint(ceil(1.f / (self.duration))); // how many pixels to deliver per second
	return pps;
}

- (void)setPps:(NSUInteger)ppsx {
    if (ppsx >= kMaxPPS) {
        ppsx = kMaxPPS;
    } else if (ppsx <= kMinPPS) {
        ppsx = kMinPPS;
    }    
    pps = ppsx; // don't go thru property IT will llop
    self.duration = (2.f / ppsx) ; // this is how long to wait between 2 pixel updates
}
@end
