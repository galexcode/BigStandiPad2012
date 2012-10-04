	//
	//  KORMP3PlayerView.m
	//  MasterApp
	//
	//  Created by bill donner on 11/17/11.
	//  Copyright (c) 2011 ShovelReadyApps. All rights reserved.
	//

#import "KORMP3PlayerView.h"
#import "KORDataManager.h"

@interface KORMP3PlayerView()<UIWebViewDelegate>
@property (nonatomic) CGRect initialframe;
@property (nonatomic,retain) UILabel *label;

@property (nonatomic,retain) UIWebView *wv;
@end

@implementation KORMP3PlayerView
@synthesize wv, label,initialframe;

-(NSString *) makeHTML:(NSString *)URLString
{
	NSString *str = [NSString stringWithFormat:@"<html><body style='background:black'><center><audio class=right controls='controls' autoplay loop='loop'><source src='%@' type='audio/mpeg'/><a href='%@' type='audio/mpeg'>play</a></audio></center></body></html>",URLString,URLString];
	return str;
}

-(void) loadMP3Tune:(NSDictionary *)tuneProps atURL:(NSString *)URLString;
{
	label.text= [tuneProps objectForKey:@"TuneLabel"];
	
	[wv loadHTMLString:[self makeHTML:URLString]  baseURL:nil];
}
-(void) show;
{
	super.hidden = NO;
}
-(void) hide;
{
	super.hidden = YES;
}
-(KORMP3PlayerView *) initWithFrame:(CGRect)frame;
{
	self = [super initWithFrame:frame];
	if (self){
		self.initialframe = frame;
		self.backgroundColor = [UIColor blackColor];
		wv = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,208,27)];
		wv.delegate = self;
		label = [[UILabel alloc] initWithFrame:CGRectMake(0,27,208,14)];
		label.textAlignment = UITextAlignmentCenter;
		label.font = [UIFont systemFontOfSize:12];
		label.backgroundColor = [UIColor blackColor];
		label.textColor = [UIColor whiteColor];
		[self addSubview:wv];
		[self addSubview:label];
		[self loadMP3Tune:[NSDictionary dictionaryWithObject:@"<no tune selected>" forKey:@"mp3Tune"] atURL:@""];
		
	}
	return self;
	
}
- (void)webViewDidStartLoad:(UIWebView *)webViewx {
		//[activityIndicatorView startAnimating];
		 NSLog (@"mp3webviewdidstartload");
}

- (void)webViewDidFinishLoad:(UIWebView *)webViewX {
		//[activityIndicatorView stopAnimating];
		NSLog (@"mp3webviewdidfinishload");
}
-(void) webView:(UIWebView *)webViewx didFailLoadWithError:(NSError *)error
{
    
    NSLog (@"%@ didFailLoadWithError %@", webViewx,[error description]);
}
@end
