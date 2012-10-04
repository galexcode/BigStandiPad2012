//
//  MenuViewController.h
// BigStand
//
//  Created by bill donner on 4/1/11.
//  Copyright 2011 ShovelReadyApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KORMenuController.h"

@interface KORTableMenuController : KORMenuController

-(KORTableMenuController *) initWithItems:(NSArray *)items filteredBy: (NSString *) filter 
									style:(NSUInteger) mode 
						  backgroundColor: (UIColor *) bgColor 
							   titleColor: (UIColor *) tcColor
					 titleBackgroundColor: (UIColor *) tcbColor
							   textColor :(UIColor *) textColor
					 textBackgroundColor :(UIColor *) textBackgroundColor
							thumbnailSize: (NSUInteger) thumbsize 
						  imageBorderSize: (NSUInteger) imageborderSize 
							  columnCount: (NSUInteger) columnCount
								  tagBase: (NSUInteger) base 	 
								 menuName:(NSString *) name
       menuTitle:(NSString *) title;
@end