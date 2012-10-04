	//
	//  KORViewerController+InXoOverlays.m
	//  MasterApp
	//
	//  Created by bill donner on 10/17/11.
	//  Copyright (c) 2011 ShovelReadyApps. All rights reserved.
	//
#import "ClumpInfo.h"
#import "KORPathMappings.h"
#import "KORDataManager.h"
#import "KORRepositoryManager.h"
#import "KORViewerController+InXoOverlays.h"

#import "KORViewerController+PlugSubs.h"

@implementation KORViewerController (InXoOverlays)
#pragma mark Maintenance of Headers and Footers

-(void) dismissPanel
{
    self.buttonCompletionBlock();
}

-(UIView *) standardPanel:(NSString *) xibname;
{
		// build a standard panel and return it
    
    UIView *xib = [[[NSBundle mainBundle] loadNibNamed:xibname owner:self options:NULL] lastObject] ; 
    if (xib==nil) return nil;
	
    UIView *theview = (UIView *) [xib viewWithTag:900];
    theview.frame = self.view.frame; 
	if ([KORDataManager globalData].gigStandEnabled)
	{
		theview.frame =CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-20, self.view.frame.size.width, self.view.frame.size.height);
	}
    return theview;
}

-(void) showPanel:(UIView *) panelView
     dismissBlock:(KORTuneControllerDismissedCompletionBlock)completionBlock;

{
    UIImageView *cancelButton = (UIImageView *)[panelView viewWithTag:899];
	if (cancelButton) 
	{
		self.buttonCompletionBlock = completionBlock;
		UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector (dismissPanel) ];
		tgr.numberOfTapsRequired = 1;
		tgr.numberOfTouchesRequired = 1;
		[cancelButton addGestureRecognizer:tgr];		
		[self.view addSubview:panelView];   		
	}
}



- (void) infoOverlayXibHTMLSet:(NSString *)html baseURL:(NSURL *)baseURL;
{
		// delegate off for html
	
	self.infoWebView.delegate = nil;
    self.infoWebView = (UIWebView *)[self.infoOverlayXib viewWithTag:898];
		//
	self.infoWebView.delegate = nil;
    self.infoWebView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    self.infoWebView.scalesPageToFit = YES;
	
	
	NSLog (@"infoOverlayXibHTMLSet loadHTMLString baseURL %@ ",baseURL);
    [self.infoWebView loadHTMLString: html baseURL: baseURL];
    
}



-(void) showIntroOverlay;
{
	self.prevToggleEnabledState = self.toggleEnabledState; 
	self.toggleEnabledState = NO;
	NSString *xibname = [KORDataManager lookupXib:@"IntroOverlay"];
	
	self.infoOverlayXib = 	[self standardPanel:xibname];
	
	UIView *theview= self.infoOverlayXib;
	
	if (theview) {
		
		
			// if nothing matches, check the special bindings
		
		NSArray *buttonTags = [[KORDataManager globalData].specialButtonBindings objectForKey:@"ButtonTags"];
		NSUInteger udx = 0;
		for (NSNumber *num in buttonTags)
		{
			NSUInteger tag = [num unsignedIntValue];
			UIImageView *iv = (UIImageView *)[theview viewWithTag:tag];			
			UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] 
										   initWithTarget:self action:@selector(specialButtonBindingHit:)];
			tgr.numberOfTapsRequired = 1;
			[iv addGestureRecognizer:tgr];
				//NSLog (@"udx %d tag %d iv %@ tgr %@",udx,tag,iv,tgr);			
			udx++;
		}
		
		[self showPanel: theview
		   dismissBlock: ^(void){
			   [self.infoOverlayXib removeFromSuperview];
			   self.clumpIsShowing = NO;
			   self.infoOverlayXib = nil;
			   self.toggleEnabledState = YES;
		   }];
		[self.view addSubview:theview];    
		self.clumpIsShowing = NO;  // important!! - inhibit regular info overlay from coming up
	}	
}
-(void) showInfoOverlay;

{
	
	self.prevToggleEnabledState = self.toggleEnabledState; 
	self.toggleEnabledState = NO;
//    if (!self.infoOverlayXib) self.infoOverlayXib = 
//        [self standardPanel: [KORDataManager lookupXib:@"InfoOverlay"]];
//    
//    UIView *theview= self.infoOverlayXib;
//    [self showPanel: theview  // adds to subview
//       dismissBlock: ^(void){
//           [self.infoOverlayXib removeFromSuperview];
//           self.clumpIsShowing = NO;
//           self.infoOverlayXib = nil;
//		   self.toggleEnabledState = self.prevToggleEnabledState; 
//           
//       }];
    
		// look for a file with an .ihtml pathextension in this very directory
    
    ClumpInfo *ti = [KORRepositoryManager findTune:self.currentTuneTitle];
    
    NSString *filepath = ti.lastFilePath; 
    NSString *plainpath = [filepath stringByDeletingPathExtension];  //111111
    NSString *fullpath = [[KORPathMappings pathForSharedDocuments] stringByAppendingFormat:@"/%@.ihtml",plainpath]; //must change
    
	[self pushToWebPageFull:(NSString *)fullpath]; 
	
	
	
		//	if ([[NSFileManager defaultManager] fileExistsAtPath:fullpath] == NO) 
		//	{
//    { 
//        [self infoOverlayXibHTMLSet:[NSString stringWithFormat:@"<html><head><meta name='viewport' content='initial-scale=1.0'><style>body,center,div,img {margin:0;padding:0;background:transparent;color:white;border-style:none;}</style></head><body><div style='margin:3px; padding: 3px; font-family:Arial; font-size:.8em;'><h1>Standard Info for %@</h1><h2>No custom information supplied.</h2><p>You can add a custom overlay html file to the zip archive</p></div></body></html>",self.currentTuneTitle ]
//                            baseURL:nil];      
//    }
//    else 
//        
//    {
//			// ok we got the meta file
//        NSError *error;
//        NSStringEncoding encoding;
//        NSString *contents = [NSString stringWithContentsOfFile:fullpath usedEncoding:&encoding error: &error];
//			//NSString *fullpathOfArchive = [[KORPathMappings pathForSharedDocuments] stringByAppendingFormat:@"/%@",ti.lastArchive];
//        [self infoOverlayXibHTMLSet:contents baseURL:nil];//[NSURL fileURLWithPath:    fullpathOfArchive isDirectory:YES]];    
//    }
    
		//	[self.view addSubview:theview];
		// self.clumpIsShowing = YES;
}
@end
