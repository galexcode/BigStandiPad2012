//
//  ExternalMonitorManager.m
// BigStand
//
//  Created by bill donner on 8/18/11.
//  Copyright (c) 2011 ShovelReadyApps. All rights reserved.
//

#import "KORExternalMonitorManager.h"
#import "KORPathMappings.h"
#import "KORDataManager.h"

@interface KORExternalMonitorManager()
@property (nonatomic,retain) UIView *testPattern1;
@property (nonatomic,retain) UIView *testPattern2;
@property (nonatomic,retain) UIView *patternView;
@property (nonatomic,retain) UIWebView *xmWebView;
@property (nonatomic, retain) UIScreen *extScreen;
@property (nonatomic, retain) UIWindow *extWindow;
@property (nonatomic, retain) NSArray *availableModes;
@end

@implementation KORExternalMonitorManager

@synthesize dummy,testPattern1,testPattern2,patternView,xmWebView,extScreen,extWindow,availableModes;




+ (void)flush {
	
	[self sharedInstance]. testPattern1 = nil;
	[self sharedInstance]. testPattern2 = nil;
	[self sharedInstance]. patternView = nil;
	[self sharedInstance]. xmWebView = nil;
	[self sharedInstance]. extWindow = nil; 
	
	NSLog (@"KORExternalMonitorManager flush complete");
}




- (void)screenDidChange//:(NSNotification *)notificationx
{
	NSArray			*screens;
	//UIScreen		*aScreen;
	//UIScreenMode	*mode;
	
	// 1.	
	
	// Log the current screens and display modes
	screens = [UIScreen screens];
	
//	NSLog (@"Device now has %d screen(s).\n",
//           [screens count]);
//	
//	uint32_t screenNum = 1;
//	for (aScreen in screens) {			  
//		NSArray *displayModes;
//		
//		NSLog (
//@"\tScreen %d   scale: %1.2f brightness: %1.2f dim: %d overScan: %d prefMode: %@ currentMode: %@ \n",
//               screenNum,[aScreen scale], 
//               [aScreen brightness], [aScreen wantsSoftwareDimming], [aScreen overscanCompensation],
//               [aScreen preferredMode],[aScreen currentMode]);
//		
//		displayModes = [aScreen availableModes];
//		for (mode in displayModes) {     
//            
//            NSLog(@"\t\tScreen mode: %@\n",
//                  mode);
//        }
//        
//        screenNum++;
//    }
    
    NSUInteger screenCount = [screens count];
    
    if (screenCount > 1) {
        // 2.
        
        // Select first external screen
        self.extScreen = [screens objectAtIndex:1];
        self.availableModes = [extScreen availableModes];
        
        // Set initial display mode to highest resolution
        extScreen.currentMode = [availableModes lastObject];
        
        if (extWindow == nil || !CGRectEqualToRect(extWindow.bounds, [extScreen bounds])) {
            // Size of window has actually changed
            
            // 4.
            extWindow = [[UIWindow alloc] initWithFrame:[extScreen bounds]];
            
            // 5.
            extWindow.screen = extScreen;
            
            
            [KORDataManager globalData].xMonitorView.backgroundColor = [UIColor greenColor];
            [extWindow addSubview:[KORDataManager globalData].xMonitorView];

            
            // 6.
            
            // 7.
            [extWindow makeKeyAndVisible];
            
        }
        else {
            // Release external screen and window
            self.extScreen = nil;
            
            self.extWindow = nil;
            self.availableModes = nil;
            
        }
    }
    
}


- (void)screenBrightnessDidChange: (id) ob//:(NSNotification *)notificationx

{
    
    NSLog (@"screenBrightnesssDidChange to %1.2f", [ob brightness]);
    [self screenDidChange];
    
}

- (void)screenModeDidChange: (id) ob
{
    
    NSLog (@"screenModeDidChange to %@", [ob currentMode]);
        [self screenDidChange];
    
}


- (void) showDisplayPattern1
{
    UIView *xv = [KORDataManager globalData].xMonitorView;
        xv.hidden = YES;
    [patternView removeFromSuperview];
    [xv addSubview:testPattern1];
    patternView = testPattern1;
    	xv.hidden = NO;
}

- (void) showDisplayPattern2
{
    UIView *xv = [KORDataManager globalData].xMonitorView;
    	xv.hidden = YES;
    [patternView removeFromSuperview];
    [xv addSubview:testPattern2];
    patternView = testPattern2;
    	xv.hidden = NO;
}
- (void) showDisplayView:(UIView *)v
{
    UIView *xv = [KORDataManager globalData].xMonitorView;
    xv.hidden = YES;
    [patternView removeFromSuperview];
    [xv addSubview:v];
    patternView = v;
    xv.hidden = NO;
}
- (void) showDisplayHTML: (NSString *)html
{
    
    if ( [[UIScreen screens] count] > 1 )
    {
    UIView *xv = [KORDataManager globalData].xMonitorView;
    xv.hidden = YES;
    [patternView removeFromSuperview];
    
    xmWebView = [[UIWebView alloc] initWithFrame: [extScreen bounds]] ;
	xmWebView.backgroundColor = [UIColor blackColor];//[UIColor grayColor]; // for pdfs there is an inset
	xmWebView.dataDetectorTypes = UIDataDetectorTypeLink; // no phone numbers	
	xmWebView.scalesPageToFit =  YES; // super important!!

	{	xmWebView.delegate =  nil ; //was just self XYZZY
        NSURL *baseurl = [NSURL fileURLWithPath: [KORPathMappings pathForOnTheFlyArchive]];
        // NSLog (@"loading html %@ baseURL %@", self.html, baseurl);
		[xmWebView loadHTMLString:html baseURL:baseurl];
	}
    
    
    
    [xv addSubview:xmWebView];
    patternView = xmWebView;
    xv.hidden = NO;
    }
}

- (void) showDisplayURL: (NSURL *)URL
{
    
    if ( [[UIScreen screens] count] > 1 )
    {
        UIView *xv = [KORDataManager globalData].xMonitorView;
        xv.hidden = YES;
        [patternView removeFromSuperview];
        
        xmWebView = [[UIWebView alloc] initWithFrame: [extScreen bounds]] ;
        xmWebView.backgroundColor = [UIColor blackColor];//[UIColor grayColor]; // for pdfs there is an inset
        xmWebView.dataDetectorTypes = UIDataDetectorTypeLink; // no phone numbers	
        xmWebView.scalesPageToFit =  YES; // super important!!
        
        {	xmWebView.delegate =  nil ; //was just self XYZZY
            // NSLog (@"loading html %@ baseURL %@", self.html, baseurl);
            [xmWebView loadRequest:[NSURLRequest requestWithURL:URL]];
        }
        
        
        
        [xv addSubview:xmWebView];
        patternView = xmWebView;
        xv.hidden = NO;
    }
}



-(id) init
{
	self = [super init];
	if (self)
	{	
		if ([KORDataManager globalData].inSim == NO)
		{
            
            // Register for screen connect and disconnect notifications.
            
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(screenDidChange)
                                                         name:UIScreenDidConnectNotification 
                                                       object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(screenDidChange)
                                                         name:UIScreenDidDisconnectNotification 
                                                       object:nil];
            
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(screenModeDidChange:)
                                                         name:UIScreenModeDidChangeNotification 
                                                       object:nil];
            
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(screenBrightnessDidChange:)
                                                         name:UIScreenBrightnessDidChangeNotification 
                                                       object:nil];
            
            
            CGRect rect = CGRectMake(0,0,1280,720);
            
            
            UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gss_landscape_1024x704_v1.jpg"]];
            
            testPattern1 = [[UIView alloc] initWithFrame :rect];
            testPattern1.backgroundColor = [UIColor blackColor];
            iv.center = CGPointMake(testPattern1.center.x,testPattern1.center.y);
            [testPattern1 addSubview:iv];
            
            testPattern2 = [[UIView alloc] initWithFrame:rect];
            testPattern2.backgroundColor = [UIColor yellowColor];
            
            [KORDataManager globalData].xMonitorView= [[UIView alloc]   initWithFrame:rect];
            [KORDataManager globalData].xMonitorView.backgroundColor = [UIColor redColor];
            [[KORDataManager globalData].xMonitorView addSubview:testPattern1];
            
      
            
            
		}
        //else NSLog (@"Cant really support 2nd monitor in simulators - calls are no-ops");
        [self screenDidChange];
	}
	return self;
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIScreenDidConnectNotification 
                                                  object:nil];
    
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIScreenDidDisconnectNotification 
												  object:nil];
    
    
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIScreenModeDidChangeNotification 
												  object:nil];
    
    
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:UIScreenBrightnessDidChangeNotification 
												  object:nil];
    
}

+(void) setup
{
	[KORExternalMonitorManager sharedInstance].dummy = 1;
    
 
    
    
}
+ (KORExternalMonitorManager *) sharedInstance;
{
	static KORExternalMonitorManager *SharedInstance;
	
	if (!SharedInstance)
	{
		SharedInstance = [[KORExternalMonitorManager alloc] init];		
	}	
	return SharedInstance;
}
@end

