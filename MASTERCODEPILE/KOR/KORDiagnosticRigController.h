//
//  DiagnosticRigController.h
// BigStand
//
//  Created by bill donner on 7/15/11.
//  Copyright 2011 ShovelReadyApps. All rights reserved.
//


#import "KORMultiProtocol.h"
@interface KORDiagnosticRigController : UIViewController

@property (nonatomic,retain) id<KORSlowRunningDelegate> delegate;

@property (nonatomic,retain)   UIView *activityIndicator;
@property (nonatomic,retain)   UILabel *activityLabel;  
@property (nonatomic,retain)   UIImageView *activityImageView;

@property (nonatomic)	NSTimeInterval dbrebuildStartTime;
@property (nonatomic)   NSUInteger dbrebuildFileCount;

@property (nonatomic)      dispatch_group_t countdown_group;
@property (nonatomic)      dispatch_queue_t background_queue;


@end
