//
//  HelpPanelView.m
//  gigstand
//
//  Created by bill donner on 6/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KORHelpPanelView.h"

@interface KORHelpPanelView()
@property (retain) UILabel *leftLabel;
@property (retain) UILabel *rightLabel1;
@property (retain) UILabel *rightLabel2;
@property (retain) UILabel *rightLabel3;
@property (retain) UILabel *dismissLabel;

- (KORHelpPanelView *)initWithFrame:(CGRect)frame leftTextLines:(NSArray *)leftText rightTextLines:(NSArray *)rightText
                        leftFont:(UIFont *) leftFont rightFont:(UIFont *) rightFont color:(UIColor *)color dismissable:(BOOL)dismis;
@end


@implementation KORHelpPanelView
@synthesize    leftLabel,rightLabel1,rightLabel2,rightLabel3,dismissLabel;


+ (KORHelpPanelView *)panelWithFrame:(CGRect)frame leftTextLines:(NSArray *)leftText rightTextLines:(NSArray *)rightText
                        leftFont:(UIFont *) leftFont rightFont:(UIFont *) rightFont color:(UIColor *)color dismissable:(BOOL)dismis;

{
    
    return [[self alloc] initWithFrame:frame leftTextLines:leftText rightTextLines:rightText leftFont:leftFont rightFont:rightFont color:color dismissable:dismis];
}



- (KORHelpPanelView *)initWithFrame:(CGRect)frame leftTextLines:(NSArray *)leftText rightTextLines:(NSArray *)rightText
                        leftFont:(UIFont *) leftFont rightFont:(UIFont *) rightFont color:(UIColor *)color dismissable:(BOOL)dismis;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        float width = frame.size.width;
        float leftwidth = trunc(width * .333f);
        float rightwidth = width - leftwidth;
        
        float leftpad = 7.f;
        
        CGRect leftframe = CGRectMake(leftpad, 0, leftwidth-leftpad, frame.size.height);
        
        leftLabel  = [[UILabel alloc] initWithFrame:leftframe];
        
        leftLabel.text = [leftText objectAtIndex: 0];
        
        leftLabel.textColor = color;
        
        leftLabel.backgroundColor = [UIColor clearColor];
        
        leftLabel.font = leftFont;
        
        [self addSubview:leftLabel];
        
    //    if (dismis==YES)
        {
            
            CGRect dismissframe = CGRectMake(1.f,1.f,60.f,60.f);//frame.size.width-17.f, frame.size.height-30.f,17.f,30.f);//3.f,3.f,17.f,17.f);//f
            CGRect dismisslabel = CGRectMake(1.f,1.f,10.f,10.f);
            UIView *dismissview = [[UIView alloc]initWithFrame:dismissframe];
                   dismissview.backgroundColor = [UIColor clearColor];
            dismissLabel  = [[UILabel alloc] initWithFrame:dismisslabel];
        
        dismissLabel.text = @"x"; // the x is fake, tapping anywhere will do
        
        dismissLabel.textColor = color;
        
        dismissLabel.backgroundColor = [UIColor clearColor];
        
        dismissLabel.font = rightFont;
            [dismissview addSubview:dismissLabel];
            
        [self addSubview:dismissview];
        }
        
        
        NSUInteger count = [rightText count];
        // these are cumulative
        float linestart = 0.0f;
        float height = frame.size.height/count;
        
        if (count > 0)
        {
        rightLabel1  = [[UILabel alloc] initWithFrame:CGRectMake(leftwidth, linestart , rightwidth, height)];
        rightLabel1.text = [rightText objectAtIndex: 0];
        rightLabel1.textColor =color; 
        rightLabel1.backgroundColor = [UIColor clearColor];
        rightLabel1.font = rightFont;
        [self addSubview:rightLabel1];
        
        linestart +=height;
        }
        if (count > 1)
        {
        
        rightLabel2  = [[UILabel alloc] initWithFrame:CGRectMake(leftwidth, linestart , rightwidth, height)];
        rightLabel2.text = [rightText objectAtIndex: 1];
        rightLabel2.textColor = color; 
        rightLabel2.backgroundColor = [UIColor clearColor];
        rightLabel2.font = rightFont;
        [self addSubview:rightLabel2];
        
        linestart +=height;
        }
        if (count > 2)
        {
        rightLabel3  = [[UILabel alloc] initWithFrame:CGRectMake(leftwidth, linestart , rightwidth, height)];
        rightLabel3.text = [rightText objectAtIndex: 2];
        rightLabel3.textColor =color;
        rightLabel3.backgroundColor = [UIColor clearColor];
        rightLabel3.font = rightFont;
        [self addSubview:rightLabel3];
        }
        
        self.backgroundColor = [UIColor colorWithWhite:.1f alpha:.05f];
        
        
        
    }
    return self;
}



@end
