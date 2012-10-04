//
//  mainWebView.m
//  gigstand
//
//  Created by bill donner on 6/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KORMainWebView.h"
#import "KORPathMappings.h"
#import "KORDataManager.h"
#import "KORWebBrowserController.h"
#import "KORViewerController.h"

@interface KORMainWebView()<UIWebViewDelegate>

@end
@implementation KORMainWebView
@synthesize contentURL,contentFrame;
@synthesize controller,contentWebView,fallbackView,fallbackFullPathSpec,activityIndicator,depth,startTime;

-(void)dealloc
{
	[self.fallbackView removeFromSuperview];
	self.fallbackView = nil;
	[self.contentWebView removeFromSuperview];
	self.contentWebView = nil;
}
-(void) remakeContentView:(CGRect) newframe ;
{
    NSLog (@"KOROneTuneWebView remakeContentView must be subclassed");
    
}

-(NSString *) windowDotScrollBy:(NSUInteger) pixels;
{
	return [self.contentWebView stringByEvaluatingJavaScriptFromString:
			[NSString stringWithFormat:@"window.scrollBy(0,%d);",pixels]];
}

- (id)initWithFrame:(CGRect)frame fallbackPath:(NSString *)fallbackspec controller:(KORViewerController *)controllerx;
{
    self = [super initWithFrame:(CGRect)frame]; // this is a UIView
    if (self) {
			// Initialization code
		self.fallbackFullPathSpec =fallbackspec ;
        self.contentFrame = frame;
        self.backgroundColor = [KORDataManager globalData].colorBehindHTMLPages;
		self.contentWebView = [[UIWebView alloc] initWithFrame: self.contentFrame] ;
		self.controller = controllerx;
    }
    
    return self;
}

#pragma mark UIWebViewDelegate Methods


- (void) startTrackingLoad
{
    self.depth++;
	
    [self.activityIndicator startAnimating];
	
    self.startTime = [NSDate timeIntervalSinceReferenceDate];
}

- (NSTimeInterval) stopTrackingLoad
{
    NSTimeInterval stopTime = [NSDate timeIntervalSinceReferenceDate];
	
		//   [self.appDelegate didStopNetworkActivity];
	
    [self.activityIndicator stopAnimating];
	
    if (self.depth > 0)
        self.depth--;
	
    return stopTime - self.startTime;
}
- (void) webView: (UIWebView *) webView didFailLoadWithError: (NSError *) error
{
	
	
	
	if (error.code == 204) return; // no content, who cares?
	NSTimeInterval elapsedTime = [self stopTrackingLoad];
	
	
	if (![@"" isEqual: [webView.request.URL description]])  // avoid spurious errors ...
		NSLog (@"*****Failed to load <%@>, error code: %d, elapsed time: %.3fs",
			   //self.contentURL_,
			   webView.request.URL,
			   error.code,
			   elapsedTime);
	
	if (error.code != -999) // PDFs return this error code!
	{
		
		
	}
	
	NSString *url = [webView.request.URL path];
	NSString *alt = [[url stringByDeletingPathExtension] stringByAppendingString:@"-fallback.png"];
	UIImage *img = [UIImage imageWithContentsOfFile:alt];
	if (img==nil) 
	{
		NSLog (@"*******no fallback for %@",alt);
		img = [UIImage imageWithContentsOfFile:self.fallbackFullPathSpec];
	}
	self.fallbackView  = [[UIImageView alloc] initWithImage:img];
	
	float x = [[[KORDataManager globalData].absoluteSettings objectForKey:@"NetworkFallbackOffsetX"] floatValue];	
	float y = [[[KORDataManager globalData].absoluteSettings objectForKey:@"NetworkFallbackOffsetY"] floatValue];	
	
	self.fallbackView.frame = CGRectMake(x,y,img.size.width,img.size.height); 
	self.fallbackView.center = webView.center;
	
	[self addSubview:fallbackView];
	self.fallbackView.hidden = NO;
	
}

- (void) webViewDidFinishLoad: (UIWebView *) webView
{
    NSTimeInterval elapsedTime = [self stopTrackingLoad];
	
    NSLog (@"****LOA %.2f %@", elapsedTime,
           [KORDataManager prettyPath: [NSString stringWithFormat:@"%@",webView.request.URL]]
		   );
    webView.opaque = YES;
	webView.backgroundColor = [KORDataManager globalData].colorBehindHTMLPages;
	self.contentWebView.opaque = YES; 
	
}

- (void) webViewDidStartLoad: (UIWebView *) webView
{	//NSLog (@"webviewdidstartload");
	
	[self startTrackingLoad];
	
}




- (BOOL)webView:(UIWebView*)webViewx shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
		//CAPTURE USER LINK-CLICK.
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		NSURL *URL = [request URL];	
			//		if ([[URL scheme] isEqualToString:@"http"]) {
			//				//addressBar.text = [URL absoluteString];
			//			[self gotoAddress:[URL absoluteString]];
			//		}
			//		else if  (![URL scheme]|| [[URL scheme] isEqualToString:@""]) {
			//				//addressBar.text = [NSString stringWithFormat:@"http://%@",[URL absoluteString] ];
			//			[self gotoAddress:self.pageURL];
			//		}
        NSLog (@"must push %@",[URL absoluteString]);
		
		self.controller.pushedToWebBrowser = YES; // set flag so we know how to behave when coming back to viewdidappear
		KORWebBrowserController *kac = [[KORWebBrowserController alloc] 
										initWithURL:[URL absoluteString]
										andTitle:[URL absoluteString]
										snapShotControl:NO]
		;
		
		UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:kac];
		[self.controller presentViewController:nav animated:YES 
									completion: ^(void){
											// NSLog (@"WebCaptureController presentViewController completion"); 
										
									}];
		
		
		
		return NO;
	}	
	return YES;   
}



#pragma mark xxx

-(BOOL) xwebView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	if (navigationType == 5) return YES;
	
	
	NSString *theURL;
	NSString  *url = [NSString stringWithFormat:@"%@",request.URL];
	
		// hack this to get rid of crap
	NSArray  *parts = [url componentsSeparatedByString:@"#"];
	
	if ([parts count]>1)
	{
		
		NSString *part = [parts lastObject];
		
		NSString *instURLstring = [[KORDataManager globalData].URLMappings objectForKey:@"Instructions-Root"];
		
		NSString *pattern = [[KORDataManager globalData].URLMappings objectForKey:@"Instructions-Pattern"];
		
		NSString *preciseURL = [[pattern stringByReplacingOccurrencesOfString:@"*" withString:part] stringByReplacingOccurrencesOfString:@"^" withString:instURLstring];
		
		theURL  = preciseURL;
	}
	else theURL = url; 
		//This launches your custom ViewController, replace it with your initialization-code
	
	self.controller.pushedToWebBrowser = YES; // set flag so we know how to behave when coming back to viewdidappear
	KORWebBrowserController *kac = [[KORWebBrowserController alloc ] initWithURL:theURL   andTitle:@"GigStand Instructions" snapShotControl:NO];  
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:kac];
	[self.controller presentViewController:nav animated:YES 
								completion: ^(void){
										// NSLog (@"WebCaptureController presentViewController completion"); 
								}];
	return NO;
	
}


#pragma mark Private Instance Methods
-(void) makeContentView// webLoad:(BOOL) webload;
{	

		 [self.contentWebView removeFromSuperview];

        
	self.contentWebView.dataDetectorTypes = UIDataDetectorTypeLink; // no phone numbers	
	self.contentWebView.scalesPageToFit =  YES; // super important!!
        
    self.contentWebView.delegate =  self ; 
    [self.contentWebView loadRequest: [NSURLRequest requestWithURL: self.contentURL]];

		  [self addSubview:self.contentWebView];
	
	
			// OK, the backgroundcolor is touchy - to remove white flicker we must use clearColor but this causes many webpages to come out with a black background
			// because they are lacking a bit of css ala body {background-color:white;}
			// // SO, just use this if we are in KIOSK mode 
			// if ([DataManager sharedInstance].isKioskMode == YES)
		self.contentWebView.backgroundColor = [UIColor clearColor]; // gets corrected in didfinishload
																	 //else self.contentWebView.backgroundColor = [UIColor whiteColor];// for pdfs there is an inset
		self.contentWebView.opaque = NO; // this gets reset in didfinishload
}


#pragma mark Public Instance Methods


- (void) refreshWithURL : (NSURL *) URL ;//andWithShortPath: (NSString *) shortpath;
{	

	self.contentURL = URL; 
	[self makeContentView];
	
}


	//


@end
