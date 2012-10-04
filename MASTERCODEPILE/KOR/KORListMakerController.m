//
//  KORListMakerController.m
//  MasterApp
//
//  Created by bill donner on 10/27/11.
//  Copyright (c) 2011 ShovelReadyApps. All rights reserved.
//

#import "KORListMakerController.h"
#import "KORDataManager.h"
#import "KORListsManager.h"
#import "KORBarButtonItem.h"
#import "KORActionSheet.h"
#import "KORAlertView.h"



enum
{
    SECTION_COUNT = 1  // MUST be kept in display order ...
    
};

@interface KORListMakerController () <UITextFieldDelegate>

@property (nonatomic,retain) NSMutableArray *listItems;
@property (nonatomic,retain) UIView *overlayXib;
@property (nonatomic,retain) NSString *name;



@end


@implementation  KORListMakerController
@synthesize listItems,overlayXib,name;

- (void) dealloc
{	
    [KORDataManager singleTapPulse];
}



#pragma mark Overridden UIViewController Methods


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)orient
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)||
    (UIDeviceOrientationIsPortrait ([UIDevice currentDevice].orientation));
}


- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



#pragma mark Private Instance Methods


-(void) paintit;
{	
    
		//    self.overlayXib = [[[NSBundle mainBundle] loadNibNamed:[KORDataManager lookupXib:@"SetList"]
		//  owner:self options:NULL] lastObject];//0612
		//
    UIViewController *presenter = [self presentingViewController]; // get this reliably out here
	
		// put up an overlay subview which will have a textfield
    
    UIView *theview = (UIView *) [self.overlayXib viewWithTag:900];
    UITextField *field1 = (UITextField *)[theview viewWithTag:901];
    field1.delegate = self;
    [self.view addSubview:theview];
		// change the title bar
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = 
    [KORBarButtonItem
     buttonWithBarButtonSystemItem:UIBarButtonSystemItemCancel
     completionBlock: ^(UIBarButtonItem *bbi){
         
         [presenter dismissViewControllerAnimated:YES  
									   completion: ^(void) { NSLog (@"cancel button hit"); }];
     }];
    
}




#pragma mark Overridden UIViewController Methods


-(void) viewDidUnload
{
    [KORDataManager singleTapPulse];
    [super viewDidUnload];
}



- (void) viewDidLoad
{
    UIViewController *presenter = [self presentingViewController]; // get this reliably out here
	[super viewDidLoad];
    self.navigationItem.leftBarButtonItem =     [KORBarButtonItem  buttonWithBarButtonSystemItem:UIBarButtonSystemItemCancel                                                  completionBlock: ^(UIBarButtonItem *bbi){
		[KORDataManager allowOneTouchBehaviors];
		[presenter dismissViewControllerAnimated:YES  completion: ^(void) {/*  NSLog (@"done button hit"); */ }];                                                 
	}];
	[self makeSearchNavHeaders];
    [self paintit];
}


	// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
	
	self.listItems = [KORListsManager makeSetlistsScan]; //locallistItems;
	
	self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	self.view.backgroundColor = [UIColor purpleColor];
	
		// get overlays in case we need them    
    self.overlayXib = [[[NSBundle mainBundle] loadNibNamed:[KORDataManager lookupXib:@"SetList"]
                                                     owner:self options:NULL] lastObject];//0612
    

	self.navigationItem.title = [KORDataManager makeUnadornedTitleView:@"Add Set List"] ;		
	
	[KORDataManager disallowOneTouchBehaviors];
	
}



#pragma mark Overridden NSObject Methods

- (id) init 
{
    self = [super init];
    if (self)
    {
        
        name = @"Add List";
    }
	return self;
}

#pragma mark textField delegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [ (UIView *) [self.overlayXib viewWithTag:901] resignFirstResponder];
    [ (UIView *) [self.overlayXib viewWithTag:900] resignFirstResponder];
    return YES;
}
- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	BOOL unique = YES;
    
    
		//[textField resignFirstResponder];
	
		// check for duplicates
	for (NSString *s in self.listItems)
	{
		if ([s isEqualToString: textField.text])
		{
			unique = NO;	
			break;
		}
	}
	if (unique == YES)
	{
		
		[KORListsManager insertList:textField.text]; // new list
		
		[KORAlertView alertWithTitle:@"We created a new Setlist: "
                             message:textField.text buttonTitle:@"OK" ];
        [self paintit];
		
	}
	else {
        
        [KORAlertView alertWithTitle:@"Sorry, there is already a list with that name"
                             message:@"Make sure your name is unique and try again"
                         buttonTitle:@"OK"];
	}
    
    
    UIView *theview = (UIView *) [self.overlayXib viewWithTag:900];
    [theview removeFromSuperview];
	[self dismissModalViewControllerAnimated:YES];
    return YES;
}

@end
