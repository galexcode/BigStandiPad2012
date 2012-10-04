//
//  KORViewerController+InXoOverlays.h
//  MasterApp
//
//  Created by bill donner on 10/17/11.
//  Copyright (c) 2011 ShovelReadyApps. All rights reserved.
//

#import "KORViewerController.h"

@interface KORViewerController (InXoOverlays)
-(UIView *) standardPanel:(NSString *) xibname;
-(void) showPanel:(UIView *) panelView dismissBlock:(KORTuneControllerDismissedCompletionBlock)completionBlock;
-(void) showIntroOverlay;
-(void) showInfoOverlay;
@end
