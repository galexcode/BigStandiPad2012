//
//  KORViewerController+MusicViewer.m
//  MasterApp
//
//  Created by william donner on 10/23/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <MessageUI/MFMailComposeViewController.h>
#import "KORViewerController+MusicViewer.h"
#import "ClumpInfo.h"
#import "InstanceInfo.h"
#import "KORPathMappings.h"
#import "KORDataManager.h"
#import "KORRepositoryManager.h"

@implementation KORViewerController (MusicViewer)
#pragma mark MFMailComposeViewController support
- (void)mailComposeController:(MFMailComposeViewController*)controllerx 
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError*)error;
{
	if (result == MFMailComposeResultSent) {
			//NSLog(@"OTV MFMailComposeResultSent");
	}
    [self dismissViewControllerAnimated:YES  
                                                        completion: ^(void) {/*  NSLog (@"done button hit"); */ }];
}

@end
