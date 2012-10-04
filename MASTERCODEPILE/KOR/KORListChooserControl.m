//
//  SetListChooserControl.m
// BigStand
//
//  Created by bill donner on 1/31/11.
//  Copyright 2011 ShovelReadyApps. All rights reserved.
//

#import "KORListChooserControl.h"
#import "KORDataManager.h"
#import "KORListsManager.h"
#import "KORActionSheet.h"
@interface KORListChooserControl()

@property (nonatomic,retain) NSMutableArray *names;
@property (nonatomic,retain)   NSString				*tune;
@property (nonatomic,retain)   KORActionSheet          *mysheet; 

@end



@implementation KORListChooserControl
@synthesize names,tune,mysheet,delegate;
-(void) dealloc {
    [mysheet dismissWithClickedButtonIndex:-1 animated:NO];
}

-(void) showInView:(UIView *) v ;
{
    [self.mysheet showInView:v];
}



- (id) initWithTune:(NSString *)tunex
{
    self = [super init]; // plain nsobject
    if (self)
    {
        __block typeof(self) bself = self;
        // recents need to go first so the "choices" for set list control are linear
        
        names = [KORDataManager list:[KORListsManager makeSetlistsScanNoRecents] 
                        bringToTop:[NSArray arrayWithObjects:@"favorites",nil]];
        
        NSString *titl = [NSString stringWithFormat:@"add tune %@ to",tunex,nil];
        
        mysheet = [[KORActionSheet alloc] initWithTitle: titl];
        
		tune = [tunex copy];
        
        for (NSString *list in names) 
            
            [mysheet addButtonWithTitle:list completionBlock:^(void){
                
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                      tunex,@"tune",list,@"list",nil];
                
                if (bself.delegate) [bself.delegate choseSetList:dict];
            
                
            }];
    }
	
	return self;
}

@end
