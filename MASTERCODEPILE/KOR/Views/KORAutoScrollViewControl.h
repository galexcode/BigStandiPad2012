//
//  AutoScrollButtonView.h
//  gigstand
//
//  Created by bill donner on 6/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KORTwoLineButtonLabelView.h"
#define kMaxPPS 200
#define kMinPPS 1
#define kDefaultPPS 20
#define kPPSRange (kMaxPPS - kMinPPS)
@interface KORAutoScrollViewControl : KORTwoLineButtonLabelView

@property (nonatomic,readonly) NSTimeInterval duration;
@property (nonatomic) BOOL scrollingOn;
@property (nonatomic) BOOL  cantScroll;   // set for pdfs and other things that don't scroll = makes a pure black button with no tap
@property (nonatomic) NSUInteger pps;  // this is the number of seconds to sleep before delivering the next batch=2 of pixels


-(void) refreshAutoScrollButtonLabel;

- (id)initWithFrame:(CGRect)frame isPDF:(BOOL)pdf;

@end
