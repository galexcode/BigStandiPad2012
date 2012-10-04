    //
    //  KioskAbsMenuController.m
    //  
    //
    //  Created by bill donner on 9/14/11.
    //  Copyright (c) 2011 ShovelReadyApps. All rights reserved.
    //
#import "ClumpInfo.h"
#import "InstanceInfo.h"
#import "KORRepositoryManager.h"
#import "KORMenuController.h"
#import "KORDataManager.h"
#import "KORPathMappings.h"

@implementation KORMenuController
@synthesize leftSide,delegate,listsAreFresh,itemDetail,tuneselectordelegate,menuSize;
@synthesize titleColor,titleBackgroundColor,textBackgroundColor,textColor,backgroundColor,menuName,menuTitle,tagBase,perRow,rowSize,desiredCols;


-(id)init
{
    // make sure never called at this entry point
    NSLog (@"KORMenuController init() incorrectly called by %@", [self class]);
    return nil;
} 


-(CGSize) computeMenuSize
{
    NSUInteger rowsize = self.rowSize;
    float twidth =320;
    float theight = rowsize *[self.itemDetail count]+20;
		// trim this down
	if (theight>900) theight = 900;
    return CGSizeMake(twidth,theight); 
}
-(KORMenuController *) initWithItems:(NSArray *)items 
                          filteredBy: (NSString *) pileFilter 
                               style:(NSUInteger) mode 
                     backgroundColor:(UIColor *) bgColor 
                          titleColor: (UIColor  *) tcColor 
               titleBackgroundColor :(UIColor *) tcbColor
               textColor  :(UIColor *) txtColor
               textBackgroundColor  :(UIColor *) txtBackgroundColor
                       thumbnailSize:(NSUInteger) thumbsize 
                     imageBorderSize:(NSUInteger) imageborderSize 
                         columnCount:(NSUInteger) columnCount
                             tagBase:(NSUInteger) base 	 
                            menuName:(NSString *) name
                           menuTitle:(NSString *) title;
{
    self = [super init];
    if (self) 
    {
        self.rowSize = thumbsize+imageborderSize;
		self.backgroundColor = bgColor;
        self.titleColor = tcColor;
        self.titleBackgroundColor = tcbColor;
		self.menuName = name;
        self.menuTitle = title;
		self.tagBase = base; 
        self.desiredCols = columnCount; 
        self.textColor = txtColor;
        self.textBackgroundColor = txtBackgroundColor;
        self.itemDetail = items; 
        self.menuSize = [self computeMenuSize]; // should reach down 
        self.listsAreFresh = YES;
            // NSLog (@"KORMenuController assigns %d items to self.itemDetail",[self.itemDetail count]);
    }
    return self;
}

-(void) viewDidLoad
{
    
        if ((UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)) 
        {
                // on iphone this is a nav controller
    self.navigationItem.title = self.menuTitle;
      
        }
}
@end
