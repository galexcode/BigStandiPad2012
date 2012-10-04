//
//  SongsViewController.h
// BigStand
//
//  Created by bill donner on 12/25/11.
//  Copyright 2010 ShovelReadyApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KORAbsFullSearchController.h"
#import "KORMultiProtocol.h"

@class KORViewerController;
@interface KORLargeArchiveController : KORAbsFullSearchController {}

-(id) initWithArchive :(NSString *)archive ;
@end
