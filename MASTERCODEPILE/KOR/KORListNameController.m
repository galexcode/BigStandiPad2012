//
//  SetListNameController.m
// BigStand
//
//  Created by bill donner on 6/6/11.
//  Copyright 2011 ShovelReadyApps. All rights reserved.
//

#import "KORListNameController.h"
#import "KORListsManager.h"
#import "KORAlertView.h"


@implementation KORListNameController

@synthesize listItems;
@synthesize textField;


-(void) parseanswer :(NSString *) answer
{
	if ([answer length]<1) return;
	
	BOOL unique = YES;
	
	// check for duplicates
	for (NSString *s in self.listItems)
	{
		if ([s isEqualToString: answer])
		{
			unique = NO;	
			break;
		}
	}
	if (unique == YES)
	{
		
		[KORListsManager insertList:answer]; // new list
		
        
        
        [KORAlertView alertWithTitle:[NSString stringWithFormat:@"Created a list named %@.", answer]
                            message:@"" buttonTitle:@"OK"];
        //  must get background to redraw
		
	}
	else {
        [KORAlertView alertWithTitle:[NSString stringWithFormat:@"Sorry, there is already a list named %@.", answer]
                            message:@"" buttonTitle:@"OK"];
	}
    
    //    // Solicit text respons
    //	NSString *answer = [ModalAlert ask:@"New list name?" withTextPrompt:@"Name"];
    //	
    //    [self parseanswer:answer];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textFieldx{
	NSLog (@"%@ returned %@",[self class],textFieldx);
    [self parseanswer:textFieldx.text];
	
    return YES;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
   // UINib *nib = [UINib nibWithNibName:[[super class] description] bundle:nil];
    
//    NSArray *infoarray = // [[NSBundle mainBundle] loadNibNamed:@"ugband" owner:self options:nil] ;
//    
//    [nib instantiateWithOwner:nil options:nil];
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // must set delegate
      //
        
        NSAssert((textField.tag==901),@"textField must have tag 901 from IB");
      textField.delegate = self;

    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
