    //
//  MediaViewController.m
// BigStand
//
//  Created by bill donner on 2/4/11.
//  Copyright 2011 ShovelReadyApps. All rights reserved.
//

#import "KORMediaViewController.h"
#import "KORDataManager.h"
#import "KORBarButtonItem.h"
@interface KORMediaViewController()
@property (nonatomic,retain) UIWebView *webView;
@property (nonatomic,retain) NSURL *url;
@property (nonatomic,retain) NSString *tune;
@end

@implementation KORMediaViewController
@synthesize webView,url,tune; 

-(KORMediaViewController *) initWithURL: (NSURL *)urlx andWithTune: (NSString *)tunex;
{
	self=[super init];
	if (self)
	{
		url = [urlx copy];
		tune = [tunex copy];
	}
	return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
    
    UIViewController *presenter = [self presentingViewController]; // get this reliably out here

	self.webView = [[UIWebView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	webView.delegate = nil;
	NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
	[webView loadRequest:request];
	
	
	NSString *tite = [NSString stringWithFormat:@"\u266C %@",self.tune];
	
	
	self.navigationItem.title/*View*/  = [KORDataManager makeUnadornedTitleView:tite] ;	
    
	self.navigationItem.leftBarButtonItem =
	[KORBarButtonItem buttonWithBarButtonSystemItem:UIBarButtonSystemItemDone 
                                    completionBlock:^(UIBarButtonItem *bbi){
                                        [presenter dismissViewControllerAnimated:YES  completion: ^(void) {/*  NSLog (@"done button hit"); */ }];
                                    }
     ];
    
	self.view = self.webView;
}



/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}




@end
