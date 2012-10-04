//
//  KORViewerController+PlugSubs.m
//  MasterApp
//
//  Created by bill donner on 10/17/11.
//  Copyright (c) 2011 ShovelReadyApps. All rights reserved.
//

#import <MessageUI/MFMailComposeViewController.h>
#import <AssetsLibrary/ALAssetsLibrary.h>

#import "ClumpInfo.h"
#import "InstanceInfo.h"
#import "KORPathMappings.h"
#import "KORRepositoryManager.h"
#import "KORDataManager.h"
#import "KORAlertView.h"
#import "KORHelpViewController.h"
#import "KORAppDelegate.h"
#import "KORViewerController+PlugSubs.h"
#import "KORWebBrowserController.h"
#import "KORListsManager.h"


@implementation KORViewerController (PlugSubs)

	///// moved down

-(void) pushToWebPage:(NSString *)path
{
	NSError *error;
	NSStringEncoding encoding;
	NSString *html = [NSString stringWithContentsOfFile:path usedEncoding:&encoding error:&error];
	
	if (html)
	{
		NSString *base = [path  stringByDeletingLastPathComponent];
		NSString *putative = [path lastPathComponent];
		
		NSString *foundstr =  [[KORDataManager globalData].titlesForHiddenPages  objectForKey:putative];
		if (foundstr==nil) foundstr = putative;
		
		KORHelpViewController *wvc = [[KORHelpViewController alloc] initWithHTML: html baseURL: base   title:foundstr];
		
		wvc.modalPresentationStyle = UIModalPresentationFormSheet;
		UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: wvc] ;    
		nav.modalPresentationStyle = UIModalPresentationFormSheet;
		[self presentViewController:nav animated:YES completion: NULL];
		
	}
	else
	{
		[[KORAppDelegate sharedInstance] dieFromMisconfiguration:[NSString stringWithFormat:@"cant open %@",path]];
	}
	
}
-(void) pushToWebPageFull:(NSString *)pathx
{
//	
//	[self pushToWebPage: pathx];
//	return;
	
	NSString *path =[NSString stringWithFormat:@"%@", [NSURL fileURLWithPath: pathx]];
	NSLog (@"pushToWebPageFull %@",path);
	
		NSString *putative = [path lastPathComponent];
		
		NSString *foundstr =  [[KORDataManager globalData].titlesForHiddenPages  objectForKey:putative];
		if (foundstr==nil) foundstr = putative;
	
	self.pushedToWebBrowser = YES; // set flag so we know how to behave when coming back to viewdidappear
		KORWebBrowserController *wvc = [[KORWebBrowserController alloc] initWithURL:path andTitle:foundstr snapShotControl:NO   ];
		UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: wvc] ;    
		[self presentViewController:nav animated:YES completion: NULL];

	
}


-(NSString *) expandMacros:(NSString *) inputString
{
	NSMutableString *currentSummary = [NSMutableString stringWithString:inputString];
	currentSummary =  [[currentSummary stringByReplacingOccurrencesOfString:@"%N"
														withString:@"<br/><br/>"]
			  mutableCopy];
	
	
	return ( [[currentSummary stringByReplacingOccurrencesOfString:@"%T"
																withString:self.currentTuneTitle]
					  mutableCopy]);
	
	
	
	
}


#pragma mark MFMailComposeViewController support
- (void)mailComposeController:(MFMailComposeViewController*)controllerx 
          didFinishWithResult:(MFMailComposeResult)result 
                        error:(NSError*)error;
{
	if (result == MFMailComposeResultSent) {
			//NSLog(@"OTV MFMailComposeResultSent");
	}
    [self dismissViewControllerAnimated:YES  completion: ^(void) {/*  NSLog (@"done button hit"); */ }];
}


-(NSString *) simpleSetlistAsText: (NSString *)list  ;
{
	
	NSMutableString *sec = [[NSMutableString alloc] init];
	
	
	NSDictionary *d  = [KORListsManager listOfTunes:list ascending:YES];
	NSArray *titlesx = [d objectForKey:@"tunes"];
	
	for (NSUInteger n=0; n<[titlesx count]; n++)
	{
		
		[sec appendFormat:@"%2d.  %@ \r\n",n+1,[titlesx objectAtIndex:n]];
	}
	
	return sec;
}
-(NSString *) simpleSetlistAsHTML: (NSString *)list 
{
	
	NSMutableString *sec = [[NSMutableString alloc] init];
	
    
	
	NSString *footer = [NSString stringWithFormat: @"this setlist was built by %@ %@<br/>visit www.ShovelReadyApps for more information",
						[KORDataManager globalData].applicationName,
						[KORDataManager globalData].applicationVersion];
	NSDictionary *d  = [KORListsManager listOfTunes:list ascending:YES];
	NSArray *titlesx = [d objectForKey:@"tunes"];
	
	[sec appendFormat:@"<html><head><style>body {font-family:Tahoma,Verdana,Arial;} li {font-size:1.6em;}</style></head><body><h1>%@</h1><ul>",list];
	
	for (NSUInteger n=0; n<[titlesx count]; n++)
	{
		
		[sec appendFormat:@"<li>%@</li>",[titlesx objectAtIndex:n]];
	}
	[sec appendFormat:@"</ul><footer><small>%@</small></footer></body></html>",footer];
	return sec;//[sec autorelease];
}

-(void) emailSetlist:(NSString *)plist;
{
	
	MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
	controller.mailComposeDelegate = self;
	[controller setSubject:[NSString stringWithFormat:@"Sending Setlist -  %@",plist]];
		// SettingsManager *settings = [SettingsManager sharedInstance];
	NSString *st =  [self simpleSetlistAsText: plist];
		//NSData *plistXML = nil; // ***** MUST FIX ******* [[NSFileManager defaultManager] contentsAtPath:plistPath];
	[controller setMessageBody:[NSString stringWithFormat:@"%@\n\r%@\n\r%@%@\n\r%@\n\r\n\r%@\n\r%@",								
								@"Hello there.\r\n\r\nI'm sending you a list from GigStand so that we can play the same tunes.",
								@"\r\nIf you have GigStand, please click on the attachment.",
								@"",
								@"\r\nIf you don't have GigStand yet, please visit the Apple App Store.",
								@"\r\nFor those without an iPad here is the setlist as plain text for use in a standard editor:",
								st ,								
								[NSString stringWithFormat: 
								 @"this email was built by %@ %@ \r\nvisit www.ShovelReadyApps for more information",
								 [KORDataManager globalData].applicationName,
								 [KORDataManager globalData].applicationVersion]
								] 
						isHTML:NO]; 
	NSDate *now = [NSDate date];
	NSString *fname = [NSString stringWithFormat:@"%@ from %@.stl",plist,[[UIDevice currentDevice] name]];
    NSString *content = [NSString stringWithFormat:@"## %@ \r\n## written by %@ %@ on %@\r\n##\r\n%@",
                         fname, [KORDataManager globalData].applicationName, [KORDataManager globalData].applicationVersion,now, st];
	
	[controller addAttachmentData:[content dataUsingEncoding: NSUTF8StringEncoding] mimeType:@"gigstand/x-stl" fileName:fname]; 
    
    
	controller.modalPresentationStyle = UIModalPresentationFormSheet;	
    [self presentViewController:controller animated:YES 
					 completion: ^(void){
						 NSLog (@"presented aModalViewController view controller %@ t",controller); }];
}
-(void) printSetlist:(NSString *)plist 
{		
	UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
	pic.delegate = self;
	
	UIPrintInfo *printInfo = [UIPrintInfo printInfo];
	printInfo.outputType = UIPrintInfoOutputGeneral;
	printInfo.jobName = plist;
	pic.printInfo = printInfo;
	NSString *mt = [self simpleSetlistAsHTML:plist];
	UIMarkupTextPrintFormatter *htmlFormatter = [[UIMarkupTextPrintFormatter alloc]
												 initWithMarkupText:mt];
	htmlFormatter.startPage = 0;
	htmlFormatter.contentInsets = UIEdgeInsetsMake(72.0f, 72.0f, 72.0f, 72.0f); // 1 inch margins
	htmlFormatter.maximumContentWidth = 6 * 72.0f;
	pic.printFormatter = htmlFormatter;
	pic.showsPageRange = YES;
	
	void (^completionAction)(UIPrintInteractionController *, BOOL, NSError *) =
	^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
		if (!completed && error) {
			NSLog(@"Printing could not complete because of error: %@", error);
		}
	};
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		[pic presentFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES completionHandler:completionAction];
	} 
	else 
	{
		[pic presentAnimated:YES completionHandler:completionAction];
	}
		//[mt release];
	
}



-(NSString *) emailAttachmentPathForCurrentTune /////////// ************* 
{
	
	ClumpInfo *tn = [KORRepositoryManager findClump:self.currentTuneTitle];
	if (tn) 
	{
		for (InstanceInfo *ii in [KORRepositoryManager allVariantsFromTitle:tn.title])
			
		{
			
			NSString *filename = [NSString stringWithFormat:@"%@/%@/%@",[KORPathMappings pathForSharedDocuments],ii.archive,ii.filePath];   //must change
			
			return filename;
			
			
		}
	}
	return @"/not found";
}

-(NSString *) emailAttachmentNameForCurrentTune; ///////NEEDS UPGRADE _ ALWAYS USES FIRST//// ************* 
{
	
	ClumpInfo *tn = [KORRepositoryManager findClump:self.currentTuneTitle];
	if (tn) 
	{
		for (InstanceInfo *ii in [KORRepositoryManager allVariantsFromTitle:tn.title])
			
		{	
			NSString *ext = [ii.filePath pathExtension];
			NSString *mypersonalname = [[UIDevice currentDevice] name];
			return [NSString stringWithFormat:@"%@-%@.%@",self.currentTuneTitle,mypersonalname,ext]; //must change
			
		}
	}
	
	return @"/not found";
}

-(void) sendEmail:(NSString *) appBanner 
		  emailTo:(NSString *)emailTo 
	 emailSubject:(NSString *)emailSubject 
		emailBody:(NSString *)emailBody
  emailAttachment: (BOOL) emailAttachment;
{	
	
	
	MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
	
	controller.mailComposeDelegate = self;
	[controller setSubject:emailSubject];
    [controller setToRecipients:[NSArray arrayWithObject:emailTo]];	
	[controller setMessageBody:
	 [NSString stringWithFormat:@"<html><head><title>%@</title></head><body><h2>%@</h2>%@<hr><footer><small>this email was built by %@ %@<br/>visit http://www.shovelreadyapps.com to make an app in one day</small></footer></body></html>",
	  appBanner,
	  appBanner,
	  emailBody ,
	  [KORDataManager globalData].applicationName,
	  [KORDataManager globalData].applicationVersion]	  
						isHTML:YES];
	
	if (emailAttachment) 
	{
		NSString *filespec = [self emailAttachmentPathForCurrentTune];
		NSString *attachmentname = [self emailAttachmentNameForCurrentTune];
		
		BOOL pdf = [KORDataManager isPDF:filespec];
		
		if (pdf == NO)
		{
			[controller addAttachmentData:[NSData dataWithContentsOfFile:filespec] mimeType:@"text/html" fileName:attachmentname];
		}
		else
		{
			
			[controller addAttachmentData:[NSData dataWithContentsOfFile:filespec] mimeType:@"application/pdf" 
								 fileName:attachmentname];
		}
	}
	
	controller.modalPresentationStyle = UIModalPresentationFormSheet;	
    [self presentViewController:controller animated:YES 
					 completion: ^(void){
					 }];
}
-(void) emailTune:(NSString *)type

{
	
	NSDictionary *dict = [[KORDataManager globalData].emailSettings objectForKey:type];
	if (dict ==nil)
	{
		NSLog (@"Email type %@ is incorrectly setup",type);
	}
	else
		[self 
		 sendEmail:[self expandMacros:[dict objectForKey:  @"EmailApplicationBanner"]]
		 emailTo:[dict objectForKey:  @"EmailTo"]
		 emailSubject:[self expandMacros:[dict  objectForKey: @"EmailSubject"]]
		 emailBody:[self expandMacros:[dict objectForKey: @"EmailBody"]]
		 emailAttachment:[[dict objectForKey: @"EmailAttachment"] boolValue]
		 ];
	
}



#pragma mark UIPrintInteractionController support

- (void)printTune:(id)sender {
    UIPrintInteractionController *pcontroller = [UIPrintInteractionController sharedPrintController];
    if(!pcontroller){
        NSLog(@"Couldn't get shared UIPrintInteractionController!");
        return;
    }
    void (^completionAction)(UIPrintInteractionController *, BOOL, NSError *) =
	^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if(!completed && error){
            NSLog(@"FAILED! due to error in domain %@ with error code %u",
				  error.domain, error.code);
        }
    };
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = self.currentTuneTitle;
    printInfo.duplex = UIPrintInfoDuplexLongEdge;
    pcontroller.printInfo = printInfo;
    pcontroller.showsPageRange = YES;
	
    UIViewPrintFormatter *viewFormatter = [(UIView *)self.mainWebView viewPrintFormatter];
    
    viewFormatter.startPage = 0;
    pcontroller.printFormatter = viewFormatter;
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		[pcontroller presentFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES completionHandler:completionAction];
	}
	else
		[pcontroller presentAnimated:YES completionHandler:completionAction];
}



#pragma mark screenshot support
-(UIImage *) imageFromView :(UIView *)theView
{
		// changed from bounds to frame size on 20 sep 11
	
	UIGraphicsBeginImageContext(theView.frame.size);
	[theView drawRect:theView.frame];
		//CGContextRef context = UIGraphicsGetCurrentContext();
		//[theView.layer renderInContext:context];
	UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return theImage;
}

#pragma mark
-(void) saveAsWallpaper;
{
	UIImage *image =
	[KORDataManager captureView:(UIView*)self.mainWebView];// [self imageFromView :self.mainWebView];
	
	ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
	
    [library writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] 
						  completionBlock:^(NSURL *assetURL, NSError *error){
							  if (error) {
									  // TODO: error handling
								  NSLog (@"could not save to photo album %@", [error localizedDescription]);
								  [KORAlertView alertWithTitle:@"Could not save" message:[error localizedDescription] 
												   buttonTitle:@"OK"];
								  
							  } else {
									  // TODO: success handling
								  NSLog (@"saved to assetsURL %@",assetURL);
								  [KORAlertView alertWithTitle:@"Image Saved in Photo Album" message:
								   @"To set as wallpaper select in Photos or Settings"
												   buttonTitle:@"OK"];
							  }
						  }];
	
}

@end
