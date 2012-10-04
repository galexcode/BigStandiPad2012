//
//  KioskOneTuneWebURLView.m
//  igigstand
//
//  Created by bill donner on 9/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "KORDataManager.h"
#import "KOROneTuneWebURLKioskView.h"

@implementation KOROneTuneWebURLKioskView


- (id)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:(CGRect)frame]; // this is a UIView
    if (self) {
        // Initialization code
        self.contentFrame = frame;
        self.backgroundColor = [KORDataManager globalData].colorBehindHTMLPages;//[UIColor whiteColor];//[UIColor blueColor];
        
    }
    return self;
}
    

@end
