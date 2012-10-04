//
//  MetronomeView.h
//  gigstand
//
//  Created by bill donner on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#define kMaxBPM 225
#define kMinBPM 1
#define kDefaultBPM 120
#import <UIKit/UIKit.h>
#import "KORTwoLineButtonLabelView.h"

#import <AVFoundation/AVFoundation.h>

@interface KORMetronomeViewControl : KORTwoLineButtonLabelView
@property NSUInteger bpm;
@property NSUInteger numerator;
@property NSUInteger denominator;
@property BOOL isTicking;

-(void) startSound;
-(void) stopSound;
-(void) refreshMetronomeButtonLabel;


@end
