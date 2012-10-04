//
//  MenuViewController.h
// BigStand
//
//  Created by bill donner on 4/1/11.
//  Copyright 2011 ShovelReadyApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KORMultiProtocol.h"
#import "KORMenuController.h"
#import "KORViewerController.h"

@interface KORSetlistsMenuController : UIViewController
@property (nonatomic,retain) id<KORSetlistChosenDelegate> dismissalTarget;

@property (nonatomic,retain) id<KORTrampolineDelegate> trampolinedelegate;


- (id) initWithViewController:(KORViewerController *) otc traversingName:(NSString *) tn traversingKind:(NSString *) tk;
@end