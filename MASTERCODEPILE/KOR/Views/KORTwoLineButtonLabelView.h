//
//  TwoLineButtonLabelView.h
//  
//
//  Created by bill donner on 6/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface KORTwoLineButtonLabelView : UIView

@property (nonatomic,retain) UILabel *line1Label;
@property (nonatomic,retain) UILabel *line2Label;

-(BOOL) refreshTwoLineButtonLabel;

@end
