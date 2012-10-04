//
//  KORAlertView.h
//  KORAlertView
//
//  Created by Matt Drance on 1/24/11.
//  Copyright 2011 Bookhouse Software LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^KORAlertViewCompletionBlock)(void);

typedef void(^KORAlertViewTextCompletionBlock)(UITextField *);
typedef void(^KORAlertViewTextTwoCompletionBlock)(UITextField *,UITextField *);

@interface KORAlertView : UIAlertView <UIAlertViewDelegate> {}

+ (void)alertWithTitle:(NSString *)title
			   message:(NSString *)message
		   buttonTitle:(NSString *)buttonTitle;

+ (void)alertWithTitle:(NSString *)title
              message:(NSString *)message 
          cancelTitle:(NSString *)cancelTitle 
          cancelBlock:(KORAlertViewCompletionBlock)cancelBlock
           otherTitle:(NSString *)otherTitle
           otherBlock:(KORAlertViewCompletionBlock)otherBlock;



+ (void)alertWithInputTitle:(NSString *)title 

					message: (NSString *)message
			 cancelTitle:(NSString *)cancelTitle 
			 cancelBlock:(KORAlertViewCompletionBlock)cancelBlk
			  otherTitle:(NSString *)otherTitle
			  otherBlock:(KORAlertViewTextCompletionBlock)otherBlk;

+ (void)alertWithInputCredentialsTitle:(NSString *)title 

							   message: (NSString *)message
						   cancelTitle:(NSString *)cancelTitle 
						   cancelBlock:(KORAlertViewCompletionBlock)cancelBlk
							otherTitle:(NSString *)otherTitle
							otherBlock:(KORAlertViewTextTwoCompletionBlock)otherBlk;

// END:buttonWithTitle

@end
