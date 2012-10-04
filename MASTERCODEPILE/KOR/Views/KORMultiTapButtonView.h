//
//  MultiTapButtonView.m
//  gigstand
//
//  Created by bill donner on 6/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

// START:PRPAlertBlock
typedef void(^MultiTapButtonViewBlock)(UIBarButtonItem *);
// END:PRPAlertBlock

@interface KORMultiTapButtonView: UIView 


+ (id)multiTapGestureForView:(UIView *)view 
      completionBlock:(MultiTapButtonViewBlock)completionBlock
               longPressBlock:(MultiTapButtonViewBlock)longPressBlock;

@end
