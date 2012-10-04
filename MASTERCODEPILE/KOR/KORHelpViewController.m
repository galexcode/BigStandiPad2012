//
//  LocalWebViewController.m
// BigStand
//
//  Created by bill donner on 4/28/11.
//  Copyright 2011 ShovelReadyApps. All rights reserved.
//

#import "KORHelpViewController.h"
#import "KORDataManager.h"
#import "KORBarButtonItem.h"
#import "KORDiagnosticRigController.h"

#pragma mark Internal Constants

#define CONTENT_VIEW_EDGE_INSET    0.0f

@interface KORHelpViewController () <UIWebViewDelegate,KORSlowRunningDelegate>

@property (nonatomic,retain) NSString *html;
@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSURL *baseURL;
@property (nonatomic,retain) UIWebView *contentView;

@end

@implementation KORHelpViewController

@synthesize contentView ;
@synthesize title;
@synthesize html;
@synthesize baseURL;



#pragma mark Public Instance Methods

- (id) initWithHTML: (NSString *) htmlx baseURL:(NSString *) base title:(NSString *) titlex;
{
    self = [super init];
    
    if (self)
    {
		baseURL = [NSURL fileURLWithPath:base isDirectory:YES];
        html = [htmlx copy ];
        title = [titlex copy];
        self.view = nil;
    }
    
    return self;
}

- (void) injectJavaScript: (NSString *) jsString
{
    [self.contentView stringByEvaluatingJavaScriptFromString: jsString];
}

- (void) refresh
{
    [self.contentView loadHTMLString: self.html baseURL:baseURL];
}


#pragma mark Private Instance Methods

#pragma mark Overridden UIViewController Methods

- (void) loadView
{
	
    UIViewController *presenter = [self presentingViewController]; // get this reliably out here  ! this might be wrong
    
	self.navigationItem.leftBarButtonItem =
	[KORBarButtonItem buttonWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                    completionBlock: ^(UIBarButtonItem *bbi){
                                        [presenter dismissViewControllerAnimated:YES  
                                                                      completion: ^(void) {/*  NSLog (@"done button hit"); */ }];
                                    }
     ];
    
    self.navigationItem.title/*View*/ = [KORDataManager makeUnadornedTitleView:self.title ];	
    
    CGRect tmpFrame;
    
    //
    // Background view:
    //
    tmpFrame = CGRectStandardize (self.presentingViewController.view.bounds);
    
    UIView *backgroundView = [[UIView alloc] initWithFrame: tmpFrame];    
    backgroundView.autoresizingMask = (UIViewAutoresizingFlexibleHeight |
                                       UIViewAutoresizingFlexibleWidth);
    backgroundView.backgroundColor = [UIColor lightGrayColor];
    
    //
    // Content view:
    //
    tmpFrame = CGRectStandardize (backgroundView.bounds);
    
    float fudge = 0;//[DataManager navBarHeight];
	tmpFrame.origin.y+=fudge;
	tmpFrame.size.height-=fudge;
    
    CGFloat edgeInset = CONTENT_VIEW_EDGE_INSET;
    
    //
    // If desired, inset content view frame a bit to help in debugging:
    //
    if (edgeInset > 0.0f)
        tmpFrame = UIEdgeInsetsInsetRect (tmpFrame,
                                          UIEdgeInsetsMake (edgeInset,
                                                            edgeInset,
                                                            edgeInset,
                                                            edgeInset));
    
    self.contentView = [[UIWebView alloc] initWithFrame: tmpFrame];
    
    self.contentView.autoresizingMask = (UIViewAutoresizingFlexibleHeight |
                                         UIViewAutoresizingFlexibleWidth);
    self.contentView.backgroundColor = [UIColor blackColor];
    self.contentView.dataDetectorTypes = UIDataDetectorTypeLink; // no phone numbers
    self.contentView.delegate =  nil ; // no delegate for string stuff
    self.contentView.scalesPageToFit = YES;
    
    [backgroundView addSubview: self.contentView];
    
//    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector (didReceiveSecretHandshake:)];
//    
//    tgr.numberOfTapsRequired = 4;
//    
//    [ self.contentView addGestureRecognizer: tgr];
    
    
    self.view = backgroundView;
    
    //
    // Kick off initial load of content view:
    //
    [self.contentView //loadRequest: [NSURLRequest requestWithURL: self.contentURL_]];
     loadHTMLString: self.html baseURL: baseURL];
}

#pragma mark Overridden NSObject Methods

#pragma mark AssimilationComplete Protocol Methods

-(void)assimilationComplete:(BOOL)success
{
        
        NSLog (@"DiagnosticRigController signaled assimilationComplete to LocalWebViewController");
    //this used to work
	//      [self.presentingViewController dismissModalViewControllerAnimated:NO];
        // this doesnt work - it isnt going away
        [self.presentingViewController.presentingViewController dismissViewControllerAnimated:NO  
                                 completion: ^(void) {
                                     NSLog (@"Help View hits dismissViewControllerAnimated assimilationComplete");
                                 }
         ];  
}
@end

