//
//  KORViewLineButtonLabelView.m
//  MasterApp
//
//  Created by william donner on 10/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "KORViewLineButtonLabelView.h"
#import "KORDataManager.h"

@interface KORViewLineButtonLabelView()
@property CGRect theframe;
@property BOOL leftSide;
@property (nonatomic,retain)  NSString *imageName;
@end
@implementation KORViewLineButtonLabelView
@synthesize line1CustomView,sideLabel,line2Label,imageName,leftSide,theframe;

-(BOOL) refreshViewLineButtonLabel;
{
		// this is called from init so can't use properties on self
    
    [line1CustomView removeFromSuperview];
    [line2Label removeFromSuperview];
	[sideLabel removeFromSuperview];
    
	
	CGRect iconFrame,sideFrame;
	UITextAlignment align;
	
    line1CustomView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];

	if (leftSide)
	{
		iconFrame = CGRectMake(0,2,20,theframe.size.height/2);
		
		sideFrame = CGRectMake(30,2,theframe.size.width - 10 - 20,theframe.size.height/2);
		
		
		align = UITextAlignmentLeft;
	}
	else 
	{	
		
		iconFrame = CGRectMake(theframe.size.width-20,2,20,theframe.size.height/2);
		
		sideFrame = CGRectMake(0,2,theframe.size.width - 10 - 20,theframe.size.height/2);

		align = UITextAlignmentRight;
	}
 
	line1CustomView.frame = iconFrame;
	[self addSubview:line1CustomView];

	sideLabel = [[UILabel alloc] initWithFrame:sideFrame];
	sideLabel.textAlignment = align;
	sideLabel.font = [UIFont boldSystemFontOfSize:12];//(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 15:12];
    sideLabel.textColor = [UIColor whiteColor];
		// sideLabel.shadowOffset    = CGSizeMake (1.0, 0.0);    
    sideLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:sideLabel];

    line2Label = [[UILabel alloc] initWithFrame: CGRectMake(0,2+theframe.size.height/2,theframe.size.width,theframe.size.height/2)];
	line2Label.font = [UIFont boldSystemFontOfSize:(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 15:12];
    line2Label.textColor = [UIColor whiteColor];
    line2Label.textAlignment = UITextAlignmentCenter;
		//line2Label.shadowOffset    = CGSizeMake (1.0, 0.0);    
    line2Label.backgroundColor = [UIColor clearColor];
    [self addSubview:line2Label];
	
	if ([KORDataManager globalData].gigStandEnabled)
	{
		line1CustomView.alpha = .5f;
		line2Label.textColor =[UIColor grayColor]; 
		sideLabel.textColor =[UIColor grayColor];
	}
	
    return YES;
    
}

- (id)initWithFrame:(CGRect)frame imageNamed:(NSString *)imagename whichSide:(BOOL)leftside;
{
    self = [super initWithFrame:frame];
    if (self) {
        
        theframe = frame; // remember this
		imageName = imagename;
		leftSide = leftside;
        self.backgroundColor = [UIColor clearColor];
        [self refreshViewLineButtonLabel];
        
    }
    return self;
}

@end