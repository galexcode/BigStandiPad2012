//
//  KORViewerController+CommandSystem.h
//  MasterApp
//
//  Created by bill donner on 10/16/11.
//  Copyright (c) 2011 ShovelReadyApps. All rights reserved.
//

#import "KORViewerController.h"
@class KORListChooserControl;
@interface KORViewerController (CommandSystem)

-(void) setupViewerHeaderAndFooter;

-(void) exec_command:(NSUInteger) tagx;

-(void) exec_command_one_arg:(NSUInteger) tagx arg:(id)obj;


-(NSString *) goBackOnList;

-(NSString *) goForwardOnList;

-(UIView *) buildView:(NSUInteger) tag;

@end


