//
//  KORWebBrowserController.m
//
#import "KORMultiButtonControl.h"
#import "KORRepositoryManager.h"
#import "KORDataManager.h"
#import "KORWebBrowserController.h"
#import "KORBarButtonItem.h"

@interface KORWebBrowserController() <UIWebViewDelegate,UITextFieldDelegate>    
@property (nonatomic,retain) UIWebView *webView;
@property () BOOL showSnapshotControl;
@property (strong) NSString *pageTitle;
@property (strong) NSString *pageURL;
@property (strong) NSURLRequest *premaderequest;

-(void ) gotoAddress:(id)sender;
-(void ) goBack:(id)sender;
-(void ) goForward:(id)sender;
@end

@implementation KORWebBrowserController
@synthesize pageTitle,showSnapshotControl,pageURL,premaderequest,webView;//,addressBar,headerToolbarItems,headerToolbar;

-(KORWebBrowserController *) initWithURL:(NSString *)URLstring
								andTitle:(NSString *)title
						 snapShotControl:(BOOL) ss;
{
	self = [super init];
	if (self)
	{
		self.pageURL = URLstring;
		self.pageTitle = title;
		self.showSnapshotControl = ss;
		
		NSLog (@"Browsing to %@ %@",self.pageURL,self.pageTitle);
		
		
	}
	return self;
}
-(KORWebBrowserController *) initWithRequest:(NSURLRequest *) requestObj;
{
	self = [super init];
	if (self)
	{
		self.pageURL = @"";
		self.premaderequest = requestObj;
		self.pageTitle = @"dummy";
		self.showSnapshotControl = NO;
		
			//NSLog (@"New Style Browsing to %@",premaderequest.URL);
		
		
	}
	return self;
}
-(CGRect)setupnav
{
	
	UIViewController *presenter = self.presentingViewController; // can't get self reliably inside nested blocks, so just get this now
	self.navigationItem.title =self.pageTitle;
	
	CGRect tmpFrame;

	
	UIInterfaceOrientation o = [UIApplication sharedApplication].statusBarOrientation;
	if ((o==UIInterfaceOrientationLandscapeLeft )|| (o ==UIInterfaceOrientationLandscapeRight))
	{
		
		o = UIInterfaceOrientationLandscapeLeft;
		tmpFrame = CGRectMake(0,0,1024,748-44);
			// add forward and backward buttons only in landscape mode
		NSMutableArray *images = [NSMutableArray array];
		NSMutableArray *tags = [NSMutableArray array];
		[images addObject: @"UIBarButtonSystemItemDone"];
		[tags addObject:  [NSNumber numberWithUnsignedInt:601]];
		[images addObject: @"UIBarButtonSystemItemRefresh"];
		[tags addObject:  [NSNumber numberWithUnsignedInt:602]];
		
		if ([webView canGoBack]) 
		{
			[images addObject: @"UIBarButtonSystemItemRewind"];
			
			[tags addObject:  [NSNumber numberWithUnsignedInt:603]];
		}
		else
		{
			[images addObject: @"UIBarButtonSystemItemRewind"];
			
			[tags addObject:  [NSNumber numberWithUnsignedInt:10000+603]];
		}
		
		if ([webView canGoForward]) 
		{
			[images addObject: @"UIBarButtonSystemItemFastForward"];
			
			[tags addObject:  [NSNumber numberWithUnsignedInt:604]];
		}
		else
		{
			
			[images addObject: @"UIBarButtonSystemItemFastForward"];
			
			[tags addObject:  [NSNumber numberWithUnsignedInt:10000+ 604]];		
		}
		self.navigationItem.leftBarButtonItem = [KORMultiButtonControl multibuttonWithTitles:[NSArray arrayWithObjects:@"Done",@"Refresh",@"Back",@"Forward",nil]
																					  images:images
																					   views:[NSArray arrayWithObjects:[KORDataManager globalData].nullView,
																							  [KORDataManager globalData].nullView, 
																							  [KORDataManager globalData].nullView,
																							  [KORDataManager globalData].nullView,
																							  nil] 
																						tags:tags																					 navname:@"WebBrowser" 
																				   alignment:UITextAlignmentLeft 
																			 completionBlock:^(NSUInteger x) {
																				 switch (x)
																				 {
																					 case 601: {
																						 
																						 [presenter dismissViewControllerAnimated:YES  
																													   completion: ^(void) { 
																															   // NSLog (@"web capture done button hit"); 
																													   }];
																						 break;
																					 }
																					 case 602: {
																							 // repaint with new bounds
																						 
																						 [self mainsetup];
																						 if ([self.pageURL length]>0)
																							 [self gotoAddress:self.pageURL];
																						 else [webView loadRequest:self.premaderequest];
																						 break;
																					 }
																					 case 603: {
																						 NSLog (@"go back");
																						 [self goBack:nil];
																						 break;
																					 }
																					 case 604: {
																						 NSLog (@"go forward");
																						 [self goForward:nil];
																						 break;
																					 }
																				 }
																			 }];
		
	}
	else 
	{	
		o = UIInterfaceOrientationPortrait; 
		tmpFrame = CGRectMake(0,0,768,1004-44);		// add forward and backward buttons only in landscape mode
		NSMutableArray *images = [NSMutableArray array];
		NSMutableArray *tags = [NSMutableArray array];
		[images addObject: @"UIBarButtonSystemItemDone"];
		[tags addObject:  [NSNumber numberWithUnsignedInt:601]];
		[images addObject: @"UIBarButtonSystemItemRefresh"];
		[tags addObject:  [NSNumber numberWithUnsignedInt:602]];
		
		if ([webView canGoBack]) 
		{
			[images addObject: @"UIBarButtonSystemItemRewind"];
			
			[tags addObject:  [NSNumber numberWithUnsignedInt:603]];
		}
		else
		{
			[images addObject: @"UIBarButtonSystemItemRewind"];
			
			[tags addObject:  [NSNumber numberWithUnsignedInt:10000+603]];
		}
		
		if ([webView canGoForward]) 
		{
			[images addObject: @"UIBarButtonSystemItemFastForward"];
			
			[tags addObject:  [NSNumber numberWithUnsignedInt:604]];
		}
		else
		{
			
			[images addObject: @"UIBarButtonSystemItemFastForward"];
			
			[tags addObject:  [NSNumber numberWithUnsignedInt:10000+ 604]];		
		}
		self.navigationItem.leftBarButtonItem = [KORMultiButtonControl multibuttonWithTitles:[NSArray arrayWithObjects:@"Done",@"Refresh",@"Back",@"Forward",nil]
																					  images:images
																					   views:[NSArray arrayWithObjects:[KORDataManager globalData].nullView,
																							  [KORDataManager globalData].nullView, 
																							  [KORDataManager globalData].nullView,
																							  [KORDataManager globalData].nullView,
																							  nil] 
																						tags:tags
												 
																					 navname:@"WebBrowser" 
																				   alignment:UITextAlignmentLeft 
																			 completionBlock:^(NSUInteger x) {
																				 switch (x)
																				 {
																					 case 601: {
																						 
																						 [presenter dismissViewControllerAnimated:YES  
																													   completion: ^(void) { 
																															   // NSLog (@"web capture done button hit"); 
																													   }];
																						 break;
																					 }
																					 case 602: {
																							 // repaint with new bounds
																						 
																						 [self mainsetup];
																						 if ([self.pageURL length]>0)
																							 [self gotoAddress:self.pageURL];
																						 else [webView loadRequest:self.premaderequest];
																						 break;
																					 }
																					 case 603: {
																						 NSLog (@"go back");
																						 [self goBack:nil];
																						 break;
																					 }
																					 case 604: {
																						 NSLog (@"go forward");
																						 [self goForward:nil];
																						 break;
																					 }
																				 }
																			 }];
		
;
	}
	
	
	
	
	
	if (self.showSnapshotControl)
		
		self.navigationItem.rightBarButtonItem = [KORMultiButtonControl multibuttonWithTitles:[NSArray arrayWithObjects:@"Snap",@"Safari",nil]
																					   images:[NSArray arrayWithObjects:@"UIBarButtonSystemItemCamera",@"icon_fullScreen_24x24", nil]
																						views:[NSArray arrayWithObjects:[KORDataManager globalData].nullView,
																							   [KORDataManager globalData].nullView, nil] 
																						 tags:[NSArray arrayWithObjects:[NSNumber numberWithUnsignedInt:602],
																							   [NSNumber numberWithUnsignedInt:601], nil]
												  
																					  navname:@"WebBrowser" 
																					alignment:UITextAlignmentRight
																			  completionBlock:^(NSUInteger x) {
																					  // NSLog (@"got %d",x);
																				  if (x==601) {
																					  
																					  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.pageURL]];
																				  }
																				  
																				  else if (x==602){
																					  
																					  
																					  UIImage *shot = [KORDataManager captureView:self.webView];
																					  [KORRepositoryManager saveImageToOnTheFlyArchive: shot 
																																 title:[KORDataManager generateUniqueTitle:[NSString stringWithFormat:@" %1.0fx%1.0f",
																																											shot.size.width,shot.size.height]]];
																					  [presenter dismissViewControllerAnimated:YES  
																													completion: ^(void) { //NSLog (@"web capture button hit"); 
																													}];
																					  
																					  
																					  
																					  
																				  }
																			  }];
	else self.navigationItem.rightBarButtonItem = nil;
		
//		self.navigationItem.rightBarButtonItem = [KORMultiButtonControl multibuttonWithTitles:[NSArray arrayWithObjects:@"Safari",nil]
//																					   images:[NSArray arrayWithObjects:@"icon_fullScreen_24x24", nil]
//																						views:[NSArray arrayWithObjects:
//																							   [KORDataManager globalData].nullView, nil] 
//																						 tags:[NSArray arrayWithObjects:
//																							   [NSNumber numberWithUnsignedInt:601], nil]
//												  
//																					  navname:@"WebBrowser" 
//																					alignment:UITextAlignmentRight
//																			  completionBlock:^(NSUInteger x) {
//																					  // NSLog (@"got %d",x);
//																				  if (x==601) {
//																					  
//																					  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.pageURL]];
//																				  }
//																				  
//																				  
//																			  }];
	
	return tmpFrame;
	
}
-(void)mainsetup
{
    [self.webView removeFromSuperview];

	webView = [[UIWebView alloc] initWithFrame:[self setupnav]];//webViewFrame]; 
	webView.alpha = 1.000f;
	webView.autoresizesSubviews = YES;
	webView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
	webView.backgroundColor = self.view.backgroundColor;
	webView.clearsContextBeforeDrawing = YES;
	webView.clipsToBounds = YES;
	webView.contentMode = UIViewContentModeScaleToFill;
	webView.contentStretch = CGRectFromString(@"{{0, 0}, {2, 2}}");
	webView.hidden = NO;
	webView.multipleTouchEnabled = YES;
	webView.opaque = YES;
	webView.scalesPageToFit = YES;
	webView.tag = 0.0f;
	webView.userInteractionEnabled = YES;
    
    webView.delegate = self; //mf**ker
	
    [self.view  addSubview:webView];


}

-(void) loadView
{
    
    [super loadView]; // must be called if dinking with self.view
    self.view.backgroundColor = [UIColor colorWithRed:.8000f green:1.000f blue:1.000f alpha:.9000f];
	
    [self mainsetup];
		// new style, if no pageURL, then a premade request was passed in
	if ([self.pageURL length]>0 )
	[self gotoAddress:self.pageURL];
	else
		[webView loadRequest:self.premaderequest];
    
    
	
}

-(void)gotoAddress:(NSString *) URLString {

		NSURL *url = [NSURL URLWithString:URLString];
		NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
		//	NSError *error;
		//	NSStringEncoding encoding;
//	NSString *html = [NSString stringWithContentsOfURL:url usedEncoding:&encoding error:&error];
//	
//	if (html)
//	{
//		
//		NSURL *base = [NSURL URLWithString:[URLString  stringByDeletingLastPathComponent]];
//	self.pageURL =URLString; // keep tracking that so we can get to safari if we want 
//	self.navigationItem.title =self.pageURL;
//	[webView loadHTMLString:html baseURL:base];
//	}
	[webView loadRequest:requestObj];
	
		//else NSLog (@"gotoAddress %@ failure",URLString);
	
}

-(void) goBack:(id)sender {
	[webView goBack];
}

-(void) goForward:(id)sender {
	[webView goForward];
}

- (BOOL)webView:(UIWebView*)webViewx shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
	//CAPTURE USER LINK-CLICK.
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		NSURL *URL = [request URL];	
		if ([[URL scheme] isEqualToString:@"http"]) {
				//addressBar.text = [URL absoluteString];
			[self gotoAddress:[URL absoluteString]];
		}
		else if  (![URL scheme]|| [[URL scheme] isEqualToString:@""]) {
				//addressBar.text = [NSString stringWithFormat:@"http://%@",[URL absoluteString] ];
			[self gotoAddress:self.pageURL];
		}
        
		return NO;
	}	
	return YES;   
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[self gotoAddress:textField.text]; // shgould be a full url
	
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webViewx {
	//[activityIndicatorView startAnimating];
   // NSLog (@"webviewdidstartload");
}
- (void)webViewDidFinishLoad:(UIWebView *)webViewX {
	//[activityIndicatorView stopAnimating];
	//NSLog (@"webviewdidfinishload");
	[self setupnav]; // redo the nav after we've navigated someplace new
	self.navigationItem.title =
	
	[NSString stringWithFormat:
	 @"%@ - %@(%@)",
	 [webView stringByEvaluatingJavaScriptFromString:@"document.title"],
	 [KORDataManager globalData].applicationName,
	 [KORDataManager globalData].applicationVersion
	];
	
}
-(void) webView:(UIWebView *)webViewx didFailLoadWithError:(NSError *)error
{
    self.navigationItem.title =[error localizedDescription];
    NSLog (@"-- %@", [error localizedDescription]);
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orient
{
    return YES;
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
		// repaint with new bounds
	
    [self mainsetup];
	if ([self.pageURL length]>0)
	[self gotoAddress:self.pageURL];
	else [webView loadRequest:self.premaderequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}
@end