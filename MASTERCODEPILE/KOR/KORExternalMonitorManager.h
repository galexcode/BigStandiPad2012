//
//  ExternalMonitorManager.h
// BigStand
//
//  Created by bill donner on 8/18/11.
//  Copyright (c) 2011 ShovelReadyApps. All rights reserved.
//


#import <UIKit/UIKit.h>
@interface KORExternalMonitorManager : NSObject {
	NSInteger dummy;	
}

@property (nonatomic) NSInteger dummy;
+ (KORExternalMonitorManager *) sharedInstance;
+(void) setup;


- (void) showDisplayPattern1;

- (void) showDisplayPattern2;


- (void) showDisplayView:(UIView *)v;


- (void) showDisplayHTML: (NSString *)html;


- (void) showDisplayURL: (NSURL *)URL;


+ (void)flush; // cleans out views 

@end