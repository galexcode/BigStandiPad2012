//
//  KORAlertView.m
//  KORAlertView
//
//  Created by Matt Drance on 1/24/11.
//  Copyright 2011 Bookhouse Software LLC. All rights reserved.
//

#import "KORAlertView.h"

// START: PrivateInterface
@interface KORAlertView ()

@property (nonatomic, copy) KORAlertViewCompletionBlock cancelBlock;
@property (nonatomic, copy) KORAlertViewCompletionBlock otherBlock;

@property (nonatomic, copy) KORAlertViewTextCompletionBlock cancelBlockForSingleField;
@property (nonatomic, copy) KORAlertViewTextCompletionBlock otherBlockForSingleField;


@property (nonatomic, copy) KORAlertViewTextTwoCompletionBlock otherBlockForTwoField;

@property (nonatomic, copy) NSString *cancelButtonTitle;
@property (nonatomic, copy) NSString *otherButtonTitle;

- (id)initWithTitle:(NSString *)title 
            message:(NSString *)message 
        cancelTitle:(NSString *)cancelTitle 
        cancelBlock:(KORAlertViewCompletionBlock)cancelBlock
         otherTitle:(NSString *)otherTitle
         otherBlock:(KORAlertViewCompletionBlock)otherBlock;



- (id)initWithInputTitle:(NSString *)title 

				 message: (NSString *)message
			  cancelTitle:(NSString *)cancelTitle 
			  cancelBlock:(KORAlertViewCompletionBlock)cancelBlk
			   otherTitle:(NSString *)otherTitle
			   otherBlock:(KORAlertViewTextCompletionBlock)otherBlk;


- (id)initWithInputCredentialsTitle:(NSString *)title 

							message: (NSString *)message
						   cancelTitle:(NSString *)cancelTitle 
						   cancelBlock:(KORAlertViewCompletionBlock)cancelBlk
							otherTitle:(NSString *)otherTitle
							otherBlock:(KORAlertViewTextTwoCompletionBlock)otherBlk;


@end
// END: PrivateInterface

@implementation KORAlertView

@synthesize cancelBlock,cancelBlockForSingleField;
@synthesize otherBlock,otherBlockForSingleField;
@synthesize cancelButtonTitle;
@synthesize otherButtonTitle;
@synthesize otherBlockForTwoField;


// START:ShowNoHandler
+ (void)alertWithTitle:(NSString *)title
              message:(NSString *)message
          buttonTitle:(NSString *)buttonTitle {
    [self alertWithTitle:title message:message
            cancelTitle:buttonTitle cancelBlock:nil
             otherTitle:nil otherBlock:nil];
}

// END:ShowNoHandler

// START:buttonWithTitle        
+ (void)alertWithTitle:(NSString *)title 
              message:(NSString *)message 
          cancelTitle:(NSString *)cancelTitle 
          cancelBlock:(KORAlertViewCompletionBlock)cancelBlk
           otherTitle:(NSString *)otherTitle
           otherBlock:(KORAlertViewCompletionBlock)otherBlk {
    [[[self alloc] initWithTitle:title message:message
                      cancelTitle:cancelTitle cancelBlock:cancelBlk
                       otherTitle:otherTitle otherBlock:otherBlk]
       show];                           
}



+ (void)alertWithInputTitle:(NSString *)title 
					message: (NSString *)message
			  cancelTitle:(NSString *)cancelTitle 
			  cancelBlock:(KORAlertViewCompletionBlock)cancelBlk
			   otherTitle:(NSString *)otherTitle
			   otherBlock:(KORAlertViewTextCompletionBlock)otherBlk;
{ [[[self alloc] initWithInputTitle:title 
	
							message: (NSString *)message
				 cancelTitle:cancelTitle cancelBlock:cancelBlk
				  otherTitle:otherTitle otherBlock:otherBlk]
 show];  
}

+ (void)alertWithInputCredentialsTitle:(NSString *)title 
							   message: (NSString *)message
				cancelTitle:(NSString *)cancelTitle 
				cancelBlock:(KORAlertViewCompletionBlock)cancelBlk
				 otherTitle:(NSString *)otherTitle
				 otherBlock:(KORAlertViewTextTwoCompletionBlock)otherBlk;
{ [[[self alloc] initWithInputCredentialsTitle:title 
									   message: (NSString *)message
						cancelTitle:cancelTitle cancelBlock:cancelBlk
						 otherTitle:otherTitle otherBlock:otherBlk]
   show];  
}
// END:buttonWithTitle

// START:InitWithTitle
- (id)initWithInputTitle:(NSString *)title 
				 message: (NSString *)message
        cancelTitle:(NSString *)cancelTitle 
        cancelBlock:(KORAlertViewCompletionBlock)cancelBlk
         otherTitle:(NSString *)otherTitle
			  otherBlock:(KORAlertViewTextCompletionBlock)otherBlk;
{
    if ((self = [super initWithTitle:title 
                             message:message
                            delegate:self
                   cancelButtonTitle:cancelTitle 
                   otherButtonTitles:otherTitle, nil])) {
        if (cancelBlk == nil && otherBlk == nil) {
            self.delegate = nil;
        }
        self.cancelButtonTitle = cancelTitle;
        self.otherButtonTitle = otherTitle;
        self.cancelBlock = cancelBlk;
        self.otherBlockForSingleField = otherBlk;
		self.alertViewStyle = UIAlertViewStylePlainTextInput; // new in 5.0
    }
    return self;
}
- (id)initWithInputCredentialsTitle:(NSString *)title 

							message: (NSString *)message
			 cancelTitle:(NSString *)cancelTitle 
			 cancelBlock:(KORAlertViewCompletionBlock)cancelBlk
			  otherTitle:(NSString *)otherTitle
			  otherBlock:(KORAlertViewTextTwoCompletionBlock)otherBlk;
{
    if ((self = [super initWithTitle:title 
                             message:message
                            delegate:self
                   cancelButtonTitle:cancelTitle 
                   otherButtonTitles:otherTitle, nil])) {
        if (cancelBlk == nil && otherBlk == nil) {
            self.delegate = nil;
        }
        self.cancelButtonTitle = cancelTitle;
        self.otherButtonTitle = otherTitle;
        self.cancelBlock = cancelBlk;
        self.otherBlockForTwoField = otherBlk;
		self.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput; // new in 5.0
    }
    return self;
}
- (id)initWithTitle:(NSString *)title 
            message:(NSString *)message 
        cancelTitle:(NSString *)cancelTitle 
        cancelBlock:(KORAlertViewCompletionBlock)cancelBlk
         otherTitle:(NSString *)otherTitle
         otherBlock:(KORAlertViewCompletionBlock)otherBlk {
    if ((self = [super initWithTitle:title 
                             message:message
                            delegate:self
                   cancelButtonTitle:cancelTitle 
                   otherButtonTitles:otherTitle, nil])) {
        if (cancelBlk == nil && otherBlk == nil) {
            self.delegate = nil;
        }
        self.cancelButtonTitle = cancelTitle;
        self.otherButtonTitle = otherTitle;
        self.cancelBlock = cancelBlk;
        self.otherBlock = otherBlk;
		self.alertViewStyle = UIAlertViewStyleDefault; // new in 5.0
    }
    return self;
}
// END:InitWithTitle

#pragma mark -
#pragma mark KORAlertViewDelegate
// START:DelegateImpl
- (void)alertView:(UIAlertView *)alertView
willDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];

    if ([buttonTitle isEqualToString:self.cancelButtonTitle]) {
        if (self.cancelBlock) self.cancelBlock();
    } else if ([buttonTitle isEqualToString:self.otherButtonTitle]) {
		
		if (self.alertViewStyle == UIAlertViewStylePlainTextInput)
		{
			if (self.otherBlockForSingleField) (self.otherBlockForSingleField( [alertView textFieldAtIndex:0]));
		}
		else		if (self.alertViewStyle == UIAlertViewStyleLoginAndPasswordInput)
		{
			if (self.otherBlockForTwoField) (self.otherBlockForTwoField( [alertView textFieldAtIndex:0],[alertView textFieldAtIndex:1]));
		}
		
        if (self.otherBlock) self.otherBlock();
    }
}
// END:DelegateImpl



@end