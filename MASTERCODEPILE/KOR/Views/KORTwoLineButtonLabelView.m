//
//  TwoLineButtonLabelView.m
//  
//
//  Created by bill donner on 6/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KORTwoLineButtonLabelView.h"
@interface KORTwoLineButtonLabelView()
@property CGRect theframe;
@end
@implementation KORTwoLineButtonLabelView
@synthesize line1Label,line2Label,theframe;
-(BOOL) refreshTwoLineButtonLabel;
{
    // this is called from init so can't use properties on self
    
    [line1Label removeFromSuperview];
    [line2Label removeFromSuperview];
    
    line1Label = [[UILabel alloc] initWithFrame: CGRectMake(0,0,theframe.size.width,theframe.size.height/2)];
    line1Label.textColor = [UIColor whiteColor];
    line1Label.textAlignment = UITextAlignmentCenter;
    line1Label.font = [UIFont boldSystemFontOfSize: 12];
    line1Label.shadowOffset    = CGSizeMake (1.0, 0.0);
    line1Label.backgroundColor = [UIColor clearColor];
    [self addSubview:line1Label];
    
    line2Label = [[UILabel alloc] initWithFrame: CGRectMake(0,20,theframe.size.width,theframe.size.height/2)];
    line2Label.font = [UIFont boldSystemFontOfSize: 15];
    line2Label.textColor = [UIColor whiteColor];
    line2Label.textAlignment = UITextAlignmentCenter;
    line2Label.shadowOffset    = CGSizeMake (1.0, 0.0);    
    line2Label.backgroundColor = [UIColor clearColor];
    [self addSubview:line2Label];
	
    return YES;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        theframe = frame; // remember this
        self.backgroundColor = [UIColor clearColor];
        [self refreshTwoLineButtonLabel];
        
    }
    return self;
}

@end
