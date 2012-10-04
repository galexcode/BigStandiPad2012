//
//  KORViewerController+PlugSubs.h
//  MasterApp
//
//  Created by bill donner on 10/17/11.
//  Copyright (c) 2011 ShovelReadyApps. All rights reserved.
//

#import "KORViewerController.h"

@interface KORViewerController (PlugSubs)

-(void) saveAsWallpaper;

-(void) pushToWebPage:(NSString *)path;

-(void) pushToWebPageFull:(NSString *)path;
-(void) emailTune:(NSString *)type;

-(void) sendEmail:(NSString *) appBanner 
		  emailTo:(NSString *)emailTo 
	 emailSubject:(NSString *)emailSubject 
		emailBody:(NSString *)emailBody
  emailAttachment: (BOOL) emailAttachment;

-(void) printTune:(id)sender;


-(void) emailSetlist:(NSString *)plist;

-(void) printSetlist:(NSString *)plist ;

@end
