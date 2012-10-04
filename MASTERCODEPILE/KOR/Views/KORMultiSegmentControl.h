//
//  KORMultiSegmentControl.h
//  MasterApp
//
//  Created by william donner on 11/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KORBarButtonItem.h"




typedef void(^completionBlockForMultiSegmentControl)(NSUInteger);



@interface KORMultiSegmentControl : UISegmentedControl

+ (id)multiSegmentWithTitles:(NSArray *)titles 
					  images:(NSArray *)images
						tags:(NSArray *)tags 
					 navname:(NSString *)navname
			 completionBlock:(completionBlockForMultiSegmentControl)completionBlock;
@end