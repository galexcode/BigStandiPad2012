//
//  AssimilationController.h
//  MCProvider
//
//  Created by Bill Donner on 1/22/11.
//  Copyright 2011 Bill Donner and GigStand. Net All rights reserved.
//
#import "KORMultiProtocol.h"
@interface KORAssimilationController : UIViewController

- (id) initWithArchive:(NSString *)archiveNamex ; // not the short name
@property (nonatomic,retain) id<KORSlowRunningDelegate> delegate;

@property (nonatomic,retain)   UIView *activityIndicator;
@property (nonatomic,retain)   UILabel *activityLabel;  
@property (nonatomic,retain)   UIImageView *activityImageView;

@property (nonatomic)	NSTimeInterval dbrebuildStartTime;
@property (nonatomic)   NSUInteger dbrebuildFileCount;

@property (nonatomic)      dispatch_group_t countdown_group;
@property (nonatomic)      dispatch_queue_t background_queue;

@end
