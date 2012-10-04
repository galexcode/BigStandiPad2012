//
//  TouchCapturingWindow.h
//  WTSWTSTM
//
//  Created by Bruno Nadeau on 10-10-21.
//  Copyright 2010 Wyld Collective Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KORTouchCapturingWindow : UIWindow {
    NSMutableArray *views;
	
@private
    UIView *touchView;
}

- (void)viewsForTouchPriority:(UIView*)portraitView  landscapeView:(UIView*)landscapeView;


@end
