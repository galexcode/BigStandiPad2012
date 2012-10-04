//
//  AbstractHeadsUpIncrementalController.m
//  
//
//  Created by bill donner on 7/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KORAbsHeadsUpIncrementalController.h"
#import "KORDataManager.h"

@interface  KORAbsHeadsUpIncrementalController()
@end

@implementation KORAbsHeadsUpIncrementalController

@synthesize delegate, activityLabel,activityIndicator,activityImageView;
@synthesize dbrebuildFileCount,dbrebuildStartTime,countdown_group,background_queue;


- (void) dealloc
{
    countdown_group = nil;
    background_queue = nil;
    
}


#pragma mark Overridden UIViewController Methods

- (void) didReceiveMemoryWarning
{
	NSLog (@"ASS didReceiveMemoryWarning");
    
    [super didReceiveMemoryWarning];
	
}


- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orient
{
    return YES;
}

#pragma mark Overridden NSObject Methods

- (id) init
{
    self = [super init];
    return self;
}

#pragma mark Private Instance Methods

-(void) PHASE_I
{
    
    NSLog (@"HeadsUp expects PHASE_I to be overriden..."); 
}
-(void) PHASE_II
{
    
    NSLog (@"HeadsUp expects PHASE_II to be overriden..."); 
}
-(void) PHASE_III
{
    
    NSLog (@"HeadsUp expects PHASE_III to be overriden..."); 
}
-(void) startPhases:(NSTimer *)timer;
{
    // should display background fall thru I hope
    [self PHASE_I];
    
    
    // wait for that group of tasks to finish
    //dispatch_group_notify (self.countdown_group,dispatch_get_main_queue(),^{
 
        [self PHASE_II];
   
		//  dispatch_group_notify (self.countdown_group,dispatch_get_main_queue(),^{
            
            // waot for PHASE_II
            
            NSTimeInterval endTime = [NSDate timeIntervalSinceReferenceDate];
            
            // Get the elapsed time in milliseconds
            NSTimeInterval elapsedTime = (endTime - self.dbrebuildStartTime) * 1000;
            
            float perdoc = elapsedTime/self.dbrebuildFileCount;
            if (self.dbrebuildFileCount>0){
                
            NSLog (@"PHASE_II assimilation finished...,%@",[NSString stringWithFormat:@" %d docs at %3.2f ms/doc",self.dbrebuildFileCount,  perdoc]);
            [self.activityLabel setText:[NSString stringWithFormat:@"Processed %d docs at %3.2f ms/doc",self.dbrebuildFileCount,  perdoc]];
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            
            [self PHASE_III];
            }
            else
            NSLog (@"PHASE_II NO FILES");

            self.navigationController.navigationBarHidden = NO;
            if (self.activityIndicator) 
            {
                [self.activityIndicator removeFromSuperview];
                self.activityIndicator = nil;
            }
                        if (self.delegate) 
            {
                NSLog (@"PHASE_III complete calling assimilationComplete delegate");
                [self.delegate assimilationComplete:YES];
            }
                
            
		//  });
        
	//  });
}
-(void) processDirect:(UIColor *)backgroundColor textColor:(UIColor *)textColor label:(NSString *) static_label;
{	
	
	self.view.backgroundColor =  backgroundColor;//[UIColor clearColor]; 
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

	//
    // Add Activity indicator view:
    //
    self.activityIndicator= [[UIImageView alloc] init]; 
    CGRect frame = self.view.bounds; // inset this a little bit
	
	frame = [KORDataManager busyOverlayFrame:frame];
    
	
	self.activityIndicator.frame  =frame;
	self.activityIndicator.backgroundColor  = backgroundColor ;
	
	UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	
	// Adjust the indicator so it is up a few pixels from the bottom of the alert
	indicator.center = CGPointMake(frame.size.width / 2.f, frame.size.height /2.f - 60.f);
	[indicator startAnimating];
	[self.activityIndicator addSubview:indicator];
	
	// display in non-offensive
	// manner
	
    [self.view addSubview: self.activityIndicator];
    self.activityImageView  = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,120,120)];
    self.activityImageView.center = CGPointMake(frame.size.width / 2.f, 90.f);
    //
    // Add Label just below indicator view:
    //
    self.activityLabel =  [[UILabel alloc] init];
    self.activityLabel.frame = CGRectMake (frame.size.width/2.f - 150.f, 
                                           frame.size.height /2.f + 130.f,
                                           300.f, 30.f); // make some more space
    self.activityLabel.text = @"Commencing Processing";
    
    self.activityLabel.textAlignment = UITextAlignmentLeft;
    self.activityLabel.textColor = textColor;
    self.activityLabel.backgroundColor = [UIColor clearColor];
    
    
    // add a static label up above
    UILabel *label =  [[UILabel alloc] init];
	label.frame = CGRectMake (frame.size.width/2.f - 150.f, frame.size.height /2.f +80.f, 300.f, 20.f); // make some more space
    label.text = static_label;
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12.f];
    label.textColor = textColor;
    label.backgroundColor = [UIColor clearColor];
    
	// display in non-offensive
	// manner
	
    [self.view addSubview: self.activityIndicator];
    [self.view addSubview: self.activityLabel];
    [self.view addSubview:self.activityImageView];
    [self.view addSubview: label];
    
	// at this point the titleDictionary and variant structure has been rebuilt either thru expandFiles or by the reload of the TitlesSection
	
    
		//  self.background_queue = dispatch_queue_create("com.gigstand.background", 0);
    
		//self.countdown_group = dispatch_group_create();
    
    self.dbrebuildStartTime = [NSDate timeIntervalSinceReferenceDate];
    self.dbrebuildFileCount = 0;
    
    [self startPhases:nil];
    //[NSTimer timerWithTimeInterval:0.001f target:self selector:@selector(startPhases:) userInfo:nil repeats:NO];
        
    
}

- (void) loadView
{
    CGRect theframe = 
    (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)? 
	CGRectMake(0,0,540,576+44):
	[[UIScreen mainScreen] bounds];
    UIView *tmpView = [[UIView alloc] initWithFrame: theframe ] ;
	tmpView.opaque = YES;
    //turn off the nav for now
	self.navigationController.navigationBarHidden = YES;
	
	self.view = tmpView	;
}

// concrete subclass must iomplement viewDidLoad

@end
