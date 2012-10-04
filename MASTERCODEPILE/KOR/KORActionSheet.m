//
//  WLDBarButtonItem.m
// BigStand
//
//  Created by bill donner on 6/11/11.
//  These are UIBarButtonItems that use completion Blocks 
//

#import "KORActionSheet.h"


@interface KORActionSheet()<UIActionSheetDelegate>
@property (nonatomic,retain) NSMutableArray *completionBlocks;
@end

@implementation KORActionSheet
@synthesize completionBlocks;



//-(void) dealloc 
//{
//   // NSUInteger counter = [self.completionBlocks count];
//    
////    NSLog (@"before removal completion blocks count is %d",[self.completionBlocks count]);
////   while (counter-->0)
////    { 
////        
////        NSLog (@"before removal completion blocks count is %d",[self.completionBlocks count]);
////        KORActionSheetAlertBlock wab = [self.completionBlocks lastObject];
////        [self.completionBlocks  removeLastObject]; 
////            [wab release], wab = nil;
////        NSLog (@"after removal completion blocks count is %d",[self.completionBlocks count]);
////    
////    }
//   // [self.completionBlocks removeAllObjects];
//    
//    for  (KORActionSheetAlertBlock wab in self.completionBlocks)
//    {
//        [wab release], wab=nil; // make up for the retain when these were copied in
//    }
//    
////    NSLog (@"after removal completion blocks count is %d",[self.completionBlocks count]);
//    [self.completionBlocks release],completionBlocks = nil;
//    [super dealloc];
//}


- (id) initWithTitle:(NSString *) titl;
{
	NSString *cancel = (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)?@"Cancel":nil;
	
	self = [super  initWithTitle:titl
											  delegate:nil
									 cancelButtonTitle:cancel
								destructiveButtonTitle:nil
									 otherButtonTitles:nil];
    if (self)
    {
        self.delegate = self;
        // the analyzer claims the next line is leaking, but if I autorelease it , everything crasheds
        self.completionBlocks = [[NSMutableArray alloc] init ];     
        self.actionSheetStyle = UIActionSheetStyleBlackOpaque;
		CGRect xframe = self.frame;
		xframe.size = CGSizeMake(220,xframe.size.height);//, <#CGFloat height#>)
		self.frame = xframe;
    }
    return self;
}
-(void) addButtonWithTitle:(NSString *) buttonTitle completionBlock:(NoArgBlock1) completionBlock;
{
    // the completion block must be copied, not sure if this leaks or not
    [self.completionBlocks addObject:[completionBlock copy]];
    [super addButtonWithTitle:buttonTitle];
}



- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex<0) return;
    
    
	if (UI_USER_INTERFACE_IDIOM()!= UIUserInterfaceIdiomPad) buttonIndex--;
    
    // user pressed button, ignore the tag, use button as index
 
    
    if (buttonIndex<[self.completionBlocks count])
        // execute the block
    {
    NoArgBlock1 wab = [self.completionBlocks objectAtIndex:buttonIndex];
    wab ();
    }
}

@end
