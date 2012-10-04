//
//  mainWebView.h
//  gigstand
//
//  Created by bill donner on 6/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KORViewerController;
@interface KORMainWebView : UIView;

@property (nonatomic,retain) NSURL *contentURL;	
@property (nonatomic,retain) KORViewerController *controller;	
@property (nonatomic) CGRect contentFrame;
@property (nonatomic,retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic) NSUInteger      depth;
@property (nonatomic) NSTimeInterval startTime;
@property (nonatomic,retain) NSString  *fallbackFullPathSpec;
@property (nonatomic,retain) UIImageView *fallbackView;
@property (nonatomic,retain) UIWebView *contentWebView;

- (NSString *) windowDotScrollBy:(NSUInteger) pixels;
- (void) remakeContentView:(CGRect) newframe ;
- (void) webViewDidFinishLoad: (UIWebView *) webView;
- (id)initWithFrame:(CGRect)frame fallbackPath:(NSString *)fallbackspec controller:(KORViewerController *)controllerx;
- (void) refreshWithURL : (NSURL *) URL ;

@end
