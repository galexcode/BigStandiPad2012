//
//  LogManager.h
// BigStand
//
//  Created by bill donner on 3/17/11.
//  Copyright 2011 ShovelReadyApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KORLogManager : NSObject {
	NSInteger dummy;	
	NSMutableArray *logfilespecs;
}

@property (nonatomic, retain) NSMutableArray *logfilespecs;
@property (nonatomic) NSInteger dummy;
+ (KORLogManager *) sharedInstance;
+(void) setup;
-(id) init;
+(NSString *) pathForCurrentLog;
+(NSString *) pathForPreviousLog;
+(void) clearCurrentLog;
+(void) rotateLogs;
@end
