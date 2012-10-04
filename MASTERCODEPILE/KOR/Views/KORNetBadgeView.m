//
//  NetworkStatusBadgeView.m
//  gigstand
//
//  Created by bill donner on 6/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KORNetBadgeView.h"
#import "KORDataManager.h"

@implementation KORNetBadgeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        float deltay = ([KORDataManager globalData].navBarHeight-6.f)/3.f ;
        float starty = 3.f;
        float statuswidth = frame.size.width;
        
        float skip = 0;
        
        
        CGRect framex = CGRectMake(skip, starty, statuswidth, deltay);
        CGRect framey = CGRectMake(skip, starty + deltay, statuswidth, deltay);    
        CGRect framez = CGRectMake(skip, starty + 2*deltay, statuswidth, deltay);
        
        
        UILabel *labelx = [[UILabel alloc] initWithFrame:framex];
        labelx.backgroundColor = [UIColor clearColor];
        labelx.font = [UIFont boldSystemFontOfSize:12.0f];
      //  labelx.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        labelx.textAlignment = UITextAlignmentRight;
        labelx.textColor = [UIColor whiteColor];//        [DataManager sharedInstance].headlineColor;
        labelx.text = NSLocalizedString(@"GigStand.Net: OFF", @"");
        
        
        UILabel *labely = [[UILabel alloc] initWithFrame:framey];
        labely.backgroundColor = [UIColor clearColor];
        labely.font = [UIFont boldSystemFontOfSize:12.0f];
       // labely.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        labely.textAlignment = UITextAlignmentRight;
        labely.textColor =  [UIColor whiteColor];//    [DataManager sharedInstance].headlineColor;
        labely.text = NSLocalizedString(@"iCloud: OFF", @"");
        
        
        UILabel *labelz = [[UILabel alloc] initWithFrame:framez];
        labelz.backgroundColor = [UIColor clearColor];
        labelz.font = [UIFont boldSystemFontOfSize:12.0f];
        //labelz.shadowColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        labelz.textAlignment = UITextAlignmentRight;
        labelz.textColor =  [UIColor whiteColor];//    [DataManager sharedInstance].headlineColor;
        labelz.text = NSLocalizedString(@"Web Server: OFF", @"");
        
        [self addSubview:labelx];    
        [self addSubview:labely];
        [self addSubview:labelz];
    }
    return self;
}

@end
