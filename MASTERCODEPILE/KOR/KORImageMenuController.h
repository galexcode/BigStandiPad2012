//
//  KioskAltMenuController.h
//  MasterApp
//
//  Created by bill donner on 9/14/11.
//  Copyright (c) 2011 ShovelReadyApps. All rights reserved.
//

#import "KORMenuController.h"

@interface KORImageMenuController : KORMenuController
@property float initx;
@property float inity;
@property float height;
@property float width;
@property float imageheight;
@property float imagewidth;




-(KORImageMenuController *) initWithItems:(NSArray *)items filteredBy: (NSString *) pileFilter 
									style:(NSUInteger) mode 
						  backgroundColor:(UIColor *) bgColor 
							   titleColor: (UIColor *) tcColor 

					titleBackgroundColor :(UIColor *) tcbColor

							   textColor :(UIColor *) textColor
					 textBackgroundColor :(UIColor *) textBackgroundColor
							thumbnailSize:(NSUInteger) thumbsize 
						  imageBorderSize:(NSUInteger) imageborderSize 
							  columnCount:(NSUInteger) columnCount
								  tagBase:(NSUInteger) base 
								 menuName:(NSString *) name
								menuTitle:(NSString *) title;



@end
