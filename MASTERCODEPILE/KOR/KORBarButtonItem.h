//
//  WLDBarButtonItem.h
// BigStand
//
//  Created by bill donner on 6/11/11.
//  Copyright 2011 ShovelReadyApps. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^completionBlockForBarButtonItem)(UIBarButtonItem *); 

@interface KORBarButtonItem : UIBarButtonItem
@property (nonatomic,retain) UIView *labelViews;

+ (id)buttonWithImage:(UIImage *)image 
                style:(UIBarButtonItemStyle)style
      completionBlock:(completionBlockForBarButtonItem)completionBlock;

+ (id)buttonWithImage:(UIImage *)image 
  landscapeImagePhone:(UIImage *)landscapeImagePhone 
                style:(UIBarButtonItemStyle)style 
      completionBlock:(completionBlockForBarButtonItem)completionBlock;

+ (id)buttonWithTitle:(NSString *)title 
                style:(UIBarButtonItemStyle)style 
      completionBlock:(completionBlockForBarButtonItem)completionBlock;

+ (id)buttonWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem
                    completionBlock:(completionBlockForBarButtonItem)completionBlock;

+ (id)buttonWithCustomView:(UIView *)view 
               completionBlock:(completionBlockForBarButtonItem)completionBlock;


;
@end
