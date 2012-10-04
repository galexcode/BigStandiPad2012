//
//  SetListViewController.h
//  MusicStand
//
//  Created by bill donner on 11/5/11.
//  Copyright 2011 Bill Donner and ShovelReadyApps All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KORMultiProtocol.h"

@interface KORSetListControllerIpad : UIViewController 

@property (nonatomic,retain) id<KORItemChosenDelegate> tuneselectordelegate;
@property (nonatomic,retain) id<KORTrampolineOneArgDelegate> trampolinedelegate;
-(id) initWithName:(NSString *) namex edit:(BOOL) editx currentTitle:(NSString *) ctitle;
@end
