//
//  AllSetListsController.h
//  MusicStand
//
//  Created by bill donner on 11/9/11.
//  Copyright 2011 Bill Donner and ShovelReadyApps All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KORAbsTableAdminController.h"
#import "KORMultiProtocol.h"

@interface KORListsEditorController : KORAbsTableAdminController 

@property (nonatomic,retain) id<KORTrampolineDelegate> trampolinedelegate;
@end
