//
//  MisConfigurationController.m
//  // BigStand
//
//  Created by bill donner on 9/4/11.
//  Copyright (c) 2011 ShovelReadyApps. All rights reserved.
//

#import "KORMisConfigurationController.h"
#import "KORAlertView.h"

@interface KORMisConfigurationController()
@property (nonatomic, retain) NSString *errorString;
@end

@implementation KORMisConfigurationController
@synthesize errorString;


// THIS DUMMY CONTROLLER JUST PUTS SOMETHING UP SO AN ALERT CAN GET OUT DURING STARTUP


- (KORMisConfigurationController *) initWithError:(NSString *)errorstring;
{
    
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        self.view = nil;
        self.errorString = [errorstring copy];
    }
    return self;
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
-(void) loadView
{
    [super loadView];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view  addSubview: [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds]];
    self.view.backgroundColor = [UIColor redColor];
    [KORAlertView alertWithTitle:@"Misconfigured" message:self.errorString
                     buttonTitle:@"OK" ];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}
@end
