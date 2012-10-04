//
//  SongsViewController.h
// BigStand
//
//  Created by bill donner on 12/25/11.
//  Copyright 2010 ShovelReadyApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KORAbsContentTableController.h"

@class KORViewerController;
@interface KORSmallArchiveController : KORAbsContentTableController
-(id) initWithArchive: (NSString *)archiv;
-(id) initWithArchiveReversed: (NSString *)archiv;
@end
