//
//  ContentAbstractController.h
//  
//
//  Created by bill donner on 6/4/11.
//  Copyright 2011 ShovelReadyApps. All rights reserved.
//
#import <UIKit/UIKit.h>


#import "KORAbsViewController.h"

@interface KORAbsAdminController : KORAbsViewController {

}
- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orient;
-(UIView *) buildAdminBackground;
@end
