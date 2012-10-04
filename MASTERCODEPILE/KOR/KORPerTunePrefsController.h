//
//  KORAutoScrollPrefs.h
//  MasterApp
//
//  Created by bill donner on 10/28/11.
//  Copyright (c) 2011 ShovelReadyApps. All rights reserved.
//

@class  KORAutoScrollViewControl,KORMetronomeViewControl,KORViewerController;

@interface KORTunePrefsCustomCell: UITableViewCell
@property (nonatomic,retain)	UILabel *slival;
@property (nonatomic,retain)	UISlider *slider;
@property (nonatomic,retain)	UILabel *minLabel;
@property (nonatomic,retain)	UILabel *maxLabel;
@property (nonatomic,retain)	UILabel *theLabel;
@end
@interface KORPerTunePrefsController : UIViewController

@property (nonatomic,retain)	NSDictionary *cellprops;
- (id) initWithAutoscrollControl :(KORAutoScrollViewControl *)kasp 
				 metronomeControl: (KORMetronomeViewControl *)kmet 
						   viewer: (KORViewerController *)vc
							title:(NSString *) tune;
@end
