//
//  KORViewerController+PropsOverlays.m
//  MasterApp
//
//  Created by bill donner on 10/17/11.
//  Copyright (c) 2011 ShovelReadyApps. All rights reserved.
//
#import "InstanceInfo.h"
#import "ClumpInfo.h"
#import "KORDataManager.h"
#import "KORRepositoryManager.h"
#import "KORTunePrefsManager.h"
#import "KORViewerController+InXoOverlays.h"
#import "KORViewerController+PropsOverlays.h"

@implementation KORViewerController (PropsOverlays)

	//// footer stuff ////

- (void) propsOverlayTextSet:(NSString *)s forTag:(float)tag;
{
    UILabel *temp = (UILabel *)[self.propsOverlayXib viewWithTag:tag];
    temp.text = s;
}


-(void) showPropsSheet:(NSString*)masterTitle tuneTitle:(NSString *)tuneTitle;
{
		// this is the long press handler for the archive props overlay
    
    if (!self.propsOverlayXib) 
        self.propsOverlayXib = 
        [self standardPanel: [KORDataManager lookupXib:@"MusicStandArchiveProps"]];
	

    UIView *theview = self.propsOverlayXib;
    
    
    [self showPanel: theview
        dismissBlock: ^(void){
            [theview removeFromSuperview];
        }];
    
    [self propsOverlayTextSet:masterTitle forTag:901];
    [self propsOverlayTextSet:tuneTitle forTag:902];
    
		// compute last played
    
    
	ClumpInfo *ti = [KORRepositoryManager findTune:tuneTitle] ;
    
    NSArray *variants = [KORRepositoryManager allVariantsFromTitle:tuneTitle];
    
	for (InstanceInfo *ii in variants) 
	{
        if (([ii.filePath isEqualToString:ti.lastFilePath]))// && ([ii.archive isEqualToString: ti.lastArchive])) //must change might not need 2nd test
            
        { // on the precise match add to the prefix
            
            [self propsOverlayTextSet:[NSString stringWithFormat:@"%@",ii.lastVisited] forTag:904];
            
            break;
            
        }
    } 
    
    
    NSUInteger bpm = [KORTunePrefsManager prefUnsignedIntValueForKey:@"BeatsPerMinute" forTune:tuneTitle];
    if (bpm==0) bpm=120;
    NSUInteger numerator = [KORTunePrefsManager prefUnsignedIntValueForKey:@"SigNumerator" forTune:tuneTitle];
    if (numerator==0) numerator=4;
    NSUInteger denominator = [KORTunePrefsManager prefUnsignedIntValueForKey:@"SigDenominator" forTune:tuneTitle];
    if (denominator==0) denominator=4;
    
    NSUInteger pps = [KORTunePrefsManager prefUnsignedIntValueForKey:@"PixelsPerSecond" forTune:tuneTitle];
    if (pps==0) pps=20;
    BOOL scrollingOn = [KORTunePrefsManager prefBoolValueForKey:@"AutoScrollOn" forTune:tuneTitle];
    
    [self propsOverlayTextSet:[self onoffLabel:scrollingOn] forTag:903];
    [self propsOverlayTextSet:[NSString stringWithFormat:@"%d source files",[variants count]] forTag:905];  
    [self propsOverlayTextSet:[NSString stringWithFormat:@"%d",bpm]  forTag:906];
    [self propsOverlayTextSet:[NSString stringWithFormat:@"%d/%d",numerator,denominator ]forTag:907]; 
    [self propsOverlayTextSet:[NSString stringWithFormat:@"%d",pps] forTag:908];
    
    [self.view addSubview:theview];;
}
@end
