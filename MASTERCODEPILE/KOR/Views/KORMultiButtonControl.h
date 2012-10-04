//
//  MultiButtonControl.h
//  gigstand
//
//  Created by bill donner on 5/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KORBarButtonItem.h"

@interface TransparentToolbar : UIToolbar
@end

@interface WhispyToolbar : UIToolbar
@end



typedef void(^completionBlockForMultiButtonControl)(NSUInteger);



@interface KORMultiButtonControl : KORBarButtonItem 

+ (id)multibuttonWithTitles:(NSArray *)titles 
					 images:(NSArray *)images 
					  views: (NSArray *)views 
					   tags:(NSArray *)tagsx  					
					navname:(NSString *)navname
				  alignment:(UITextAlignment)leftSide
			completionBlock:(completionBlockForMultiButtonControl)completionBlock;
@end
