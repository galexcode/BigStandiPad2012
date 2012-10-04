//
//  ContentAbstractController.m
//  
//
//  Created by bill donner on 6/4/11.
//  Copyright 2011 ShovelReadyApps. All rights reserved.
//

#import "KORAbsContentController.h"



@implementation KORAbsContentController



-(UIView *) buildContentBackground;
{
    
    CGRect theframe = 
    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? CGRectMake(0,0,540,576):[[UIScreen mainScreen] bounds];
    return [super buildModalSizedBackgroundWithImageNamed:@"content-gradientBackground.png" frame:theframe];
    
    
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orient
{
    return YES;
}

@end
