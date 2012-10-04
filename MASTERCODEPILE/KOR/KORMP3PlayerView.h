//
//  KORMP3PlayerView.h
//  MasterApp
//
//  Created by bill donner on 11/17/11.
//  Copyright (c) 2011 ShovelReadyApps. All rights reserved.
//



@interface KORMP3PlayerView : UIView

-(void) hide;
-(void) show;

-(void) loadMP3Tune:(NSDictionary *)tuneProps atURL:(NSString *)URLString;
@end

