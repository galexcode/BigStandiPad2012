//
//  MetronomeView.m
//  gigstand
//
//  Created by bill donner on 6/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "KORMetronomeViewControl.h"

@interface KORMetronomeViewControl()
@property CGFloat duration;
@property NSUInteger beatNumber;
@property (nonatomic, retain) AVAudioPlayer *tickPlayer;
@property (nonatomic, retain) AVAudioPlayer *tockPlayer;
@property (nonatomic, retain)NSThread *soundPlayerThread;
@end
@implementation KORMetronomeViewControl
@synthesize numerator;
@synthesize denominator;
@synthesize isTicking;
@synthesize beatNumber;
@synthesize tickPlayer,tockPlayer,soundPlayerThread,duration;




#pragma mark -
#pragma mark === bpm setter/getter ===
#pragma mark -

- (NSUInteger)bpm {
    return lrint(ceil(60.0 / (self.duration)));
}


- (void)setBpm:(NSUInteger)bpm {
    if (bpm >= kMaxBPM) {
        bpm = kMaxBPM;
    } else if (bpm <= kMinBPM) {
        bpm = kMinBPM;
    }    
    self.duration = (60.0 / bpm);
}

#pragma mark -
#pragma mark === Actions ===
#pragma mark -

-(void)fontsizeSmall
{
	super.line1Label.font = [UIFont systemFontOfSize:12];
}
-(void)fontsizeLarge
{
	super.line1Label.font = [UIFont boldSystemFontOfSize:18];	
}
- (void)playSound {
    
    AVAudioPlayer *currentPlayer;
	
    if (self.beatNumber < self.numerator) {  // beats 1 thru numerator get a TOC
		currentPlayer = self.tockPlayer;
		 [currentPlayer play];
		[self performSelectorOnMainThread:@selector(fontsizeSmall) withObject:nil waitUntilDone:NO];
			
    }
	else  {  // beat 0 gets a TIC
        beatNumber = 0;
		currentPlayer = self.tickPlayer;
		 [currentPlayer play];
		[self performSelectorOnMainThread:@selector(fontsizeLarge) withObject:nil waitUntilDone:NO];
    }
    
    self.beatNumber++;
}
// This method is invoked from the driver thread
- (void)startDriverTimer:(id)info {
    @autoreleasepool {
        
        // Give the sound thread high priority to keep the timing steady.
        [NSThread setThreadPriority:1.0];
        BOOL continuePlaying = YES;
        
        while (continuePlaying) {  // Loop until cancelled.
            
            // An autorelease pool to prevent the build-up of temporary objects.
            @autoreleasepool {
                
                [self playSound];
                //[self performSelectorOnMainThread:@selector(animateArmToOppositeExtreme) withObject:nil waitUntilDone:NO];
                NSDate *curtainTime = [[NSDate alloc] initWithTimeIntervalSinceNow:self.duration];
                NSDate *currentTime = [[NSDate alloc] init];
                
                // Wake up periodically to see if we've been cancelled.
                while (continuePlaying && ([currentTime compare:curtainTime] != NSOrderedDescending)) { 
                    if ([soundPlayerThread isCancelled] == YES) {
                        continuePlaying = NO;
                    }
                    [NSThread sleepForTimeInterval:0.01];
                    
                    currentTime = [[NSDate alloc] init];
                }
                
            }
        }
    }
}


- (void)waitForSoundDriverThreadToFinish {
    while (soundPlayerThread && ![soundPlayerThread isFinished]) { // Wait for the thread to finish.
        [NSThread sleepForTimeInterval:0.1];
    }
}


- (void)startDriverThread {
    if (soundPlayerThread != nil) {
        [soundPlayerThread cancel];
        [self waitForSoundDriverThreadToFinish];
    }
    
    NSThread *driverThread = [[NSThread alloc] initWithTarget:self selector:@selector(startDriverTimer:) object:nil];
    self.soundPlayerThread = driverThread;
    
    [self.soundPlayerThread start];
}


- (void)stopDriverThread {
    [self.soundPlayerThread cancel];
    [self waitForSoundDriverThreadToFinish];
    self.soundPlayerThread = nil;
}

#pragma  mark public methods
-(void) startSound;
{
    beatNumber = 1;
    [self startDriverThread];
}

-(void) stopSound;
{
    [self stopDriverThread];
    
}

-(void) refreshMetronomeButtonLabel;
{
    // this is called from init so can't use properties on self
    
    [super refreshTwoLineButtonLabel];
    
    super.line1Label.text =[NSString stringWithFormat:@"%d/%d",self.numerator,self.denominator] ;
	super.line2Label.text =[NSString stringWithFormat:@"%3dbpm",self.bpm] ;
   
	if ((self.numerator == 0) && (self.denominator == 0)) super.line1Label.textColor = super.line2Label.textColor = [UIColor grayColor]; 
	else
	super.line1Label.textColor = super.line2Label.textColor = (self.isTicking?[UIColor yellowColor]:[UIColor whiteColor]);  
    super.line2Label.font = [UIFont boldSystemFontOfSize: 14];    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.bpm = kDefaultBPM;
		self.numerator = 4;
		self.denominator = 4;
		
		/*
		 Set up sounds and views.
         */
        
        
		// Create and prepare audio players for tick and tock sounds
		NSBundle *mainBundle = [NSBundle mainBundle];
		NSError *error;
		
		NSURL *tickURL = [NSURL fileURLWithPath:[mainBundle pathForResource:@"tick" ofType:@"caf"]];
		
		tickPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:tickURL error:&error];
		if (!tickPlayer) {
			NSLog(@"no tickPlayer: %@", [error localizedDescription]);	
		}
		[tickPlayer prepareToPlay];
		
		NSURL *tockURL = [NSURL fileURLWithPath:[mainBundle pathForResource:@"tock" ofType:@"caf"]];
		tockPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:tockURL error:&error];
		if (!tockPlayer) {
			NSLog(@"no tockPlayer: %@", [error localizedDescription]);	
		}
		[tockPlayer prepareToPlay];
		
		self.backgroundColor = [UIColor clearColor];  
        
        [self refreshMetronomeButtonLabel];
    
    }
    return self;
}

@end
