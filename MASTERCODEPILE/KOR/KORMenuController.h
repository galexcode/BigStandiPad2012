    //
    //  KORMenuController.h
    //  
    //
    //  Created by bill donner on 9/14/11.
    //  Copyright (c) 2011 ShovelReadyApps. All rights reserved.
    //


#import "KORViewerController.h"
#import "KORMultiProtocol.h"


@interface KORMenuController : KORAbsViewController

@property (nonatomic,retain) NSArray  *itemDetail; 
@property BOOL listsAreFresh;  // set it to NO to get a refresh of constiuent parts
@property CGSize menuSize;
@property (nonatomic,retain) id<KORItemChosenDelegate> tuneselectordelegate;
@property NSUInteger tagBase;
@property NSUInteger rowSize;
@property (nonatomic,retain)NSString *menuName;
@property (nonatomic,retain)NSString *menuTitle;

@property (nonatomic,retain)UIColor *backgroundColor;
@property (nonatomic,retain)UIColor *titleBackgroundColor;
@property (nonatomic,retain)UIColor *titleColor;
@property (nonatomic,retain)UIColor *textColor;
@property (nonatomic,retain)UIColor *textBackgroundColor;

@property NSUInteger desiredCols; // set to what the user wants
@property NSUInteger perRow; // this gets computed and will be <=wantscools

@property BOOL leftSide; // controls which presentation options to use
@property (nonatomic, retain)   id<KORHomeBaseDelegate> delegate;
-(CGSize) computeMenuSize;

-(KORMenuController *) initWithItems:(NSArray *)items filteredBy: (NSString *) filter 
                               style:(NSUInteger) mode 
                     backgroundColor: (UIColor *) bgColor 
                          titleColor: (UIColor *) tcColor 
               titleBackgroundColor :(UIColor *) tcbColor
                          textColor :(UIColor *) textColor
                textBackgroundColor :(UIColor *) textBackgroundColor
                       thumbnailSize: (NSUInteger) thumbsize 
                     imageBorderSize: (NSUInteger) imageborderSize 
                         columnCount: (NSUInteger) columnCount
                             tagBase:(NSUInteger) base 	 
                            menuName:(NSString *) name
                           menuTitle:(NSString *) title;

@end
