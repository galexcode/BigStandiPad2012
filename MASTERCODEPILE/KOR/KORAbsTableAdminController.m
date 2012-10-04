//
//  ContentTableAbstractController.m
// BigStand
//
//  Created by bill donner on 5/29/11.
//  Copyright 2011 ShovelReadyApps. All rights reserved.
//


// ContentTableAbstractController is a superclass for all Content Lists , typically from the left side menu in // BigStand


#import "KORAbsTableAdminController.h"
#import "KORAttributedLabel.h"
#import "InstanceInfo.h"
#import "ClumpInfo.h"
#import "KORDataManager.h"
#import "KORRepositoryManager.h"
#import "KORAccessoryView.h"
#import "KORHelpPanelView.h"

// ipad table cell geometry

#define ipad_textOffset +0.f
#define ipad_topLabelFontSize 24.f
#define ipad_middleLabelFontSize 1.f
#define ipad_bottomLabelFontSize 16.f
   
#define ipad_toplabelHeight 30.f 
#define ipad_middlelabelHeight 0.f 
#define ipad_bottomlabelHeight 30.f 

#define ipad_imageWidth 80.f
#define ipad_activityImageScale 1.0f
#define ipad_indicatorFrameWidth 20.f
#define ipad_indicatorWidth 20.f 


// iphone table cell geometry

#define iphone_textOffset 0.f
#define iphone_topLabelFontSize 20.f
#define iphone_middleLabelFontSize 16.f
#define iphone_bottomLabelFontSize 12.f
   
#define iphone_toplabelHeight 20.f 
#define iphone_middlelabelHeight 0.f 
#define iphone_bottomlabelHeight 20.f 


#define iphone_imageWidth 80.f

#define iphone_activityImageScale .7f
#define iphone_indicatorFrameWidth 20.f
#define iphone_indicatorWidth 20.f 

@interface KORAbsTableAdminController()
@property (retain) UIView *headerView;
@property (retain) UIFont *leftFont;
@property (retain) UIFont *rightFont;
@property (retain) UITableView *thetable;
@property () CGRect frame;
@end


@implementation KORAbsTableAdminController
@synthesize headerView,thetable,frame;
@synthesize leftFont,rightFont;
@synthesize leftTextLines,rightTextLines;

-(id)init{
		// make sure never called at this entry point
	self = [super init];
	return self;
} 

-(UIView *) setupHelpPanel;
{
    KORHelpPanelView *hv = 
        [KORHelpPanelView  panelWithFrame:(CGRectMake(0,0,frame.size.width,50.f))
                  
                                         leftTextLines:self.leftTextLines    
                                 
                                         rightTextLines:self.rightTextLines      
                                           
                                          leftFont:self.leftFont rightFont:self.rightFont
                  
                                                 color:[UIColor grayColor]
                  dismissable:YES

                  ];
    
    // to avoid conflict with the webView, use taps and swipes not handled by webkit
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector (toggleHeaderView:)] ;
	tgr.numberOfTapsRequired = 1;
	[hv addGestureRecognizer: tgr];
    return hv;

}
-(void) setupHeaderView;
{
    headerView = [ self setupHelpPanel];
}

-(void) toggleHeaderView:(id)sender
{
  if (thetable.tableHeaderView == nil)
  {
      [self setupHeaderView];
      [self propset:[self propname:[[self class] description]] tovalue:YES];
  }
    else
    {
         headerView = nil;
        
        [self propset:[self propname:[[self class] description]] tovalue:NO];
    }
    
    thetable.tableHeaderView = headerView;
    
}


-(UITableView *) buildAdminTable:(CGRect) xframe  delegate:(id)o;
{
    UITableView *tableOverlayNoRowSeparators = [[UITableView alloc] initWithFrame: xframe
                                                                             style: UITableViewStylePlain];
    tableOverlayNoRowSeparators.dataSource = o;
    tableOverlayNoRowSeparators.delegate = o;
    tableOverlayNoRowSeparators.separatorStyle = //UITableViewCellSeparatorStyleSingleLineEtched;
    UITableViewCellSeparatorStyleNone;//
	tableOverlayNoRowSeparators.rowHeight = 100;
	tableOverlayNoRowSeparators.backgroundColor = [UIColor clearColor];
    tableOverlayNoRowSeparators.opaque = NO;
    thetable = tableOverlayNoRowSeparators;
    
    [self setupHeaderView];
    // decide whether to show or now based on classname based key in user defaults
    
    if ([self ispropset:[self propname:[[self class] description]]])
	tableOverlayNoRowSeparators.tableHeaderView = headerView; else
    tableOverlayNoRowSeparators.tableHeaderView = nil;
    
    return tableOverlayNoRowSeparators;
    
}


-(NSArray *) buildAdminUIViews:(id)o leftTextLines:(NSArray *) left rightTextLines:(NSArray *)right    
                      leftfont:(UIFont *)lfont rightfont:(UIFont *)rfont;

{
    self.leftTextLines = left;
    self.rightTextLines = right;
    self.leftFont = lfont;
    self.rightFont = rfont;

    UIView *compositeview  = [super buildAdminBackground];
    
	frame = compositeview.frame;

	// outer view installed just to get background colors right
    
    UITableView *t = [self buildAdminTable:frame delegate:self ];
    [compositeview addSubview:t];
    
    return [NSArray arrayWithObjects: compositeview, t,nil];
}



- (UITableViewCell *)makeAdminTableCellView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
                                 text:(NSString *) text detail:(NSString *)detail image: (UIImage *) image;
{
    

        ////////////////// basic geometry for iphone vs ipad ////////////
    
    
    float textOffset;
    float topLabelFontSize;
    float bottomLabelFontSize;
    float indicatorWidth;   
    float imageWidth;
   // float activityImageScale;
  //  float indicatorFrameWidth;
    float middleLabelFontSize;
    float toplabelHeight;
    float middlelabelHeight;
    float bottomlabelHeight;
    
    if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))
    {
        textOffset=ipad_textOffset;
        topLabelFontSize=ipad_topLabelFontSize;
        middleLabelFontSize=ipad_middleLabelFontSize;
        bottomLabelFontSize=ipad_bottomLabelFontSize;
        indicatorWidth=ipad_indicatorWidth;   
        
        imageWidth=ipad_imageWidth;
    //    activityImageScale=ipad_activityImageScale;
     //   indicatorFrameWidth=ipad_indicatorFrameWidth;
        
        toplabelHeight = ipad_toplabelHeight ;
        middlelabelHeight = ipad_middlelabelHeight ; 
        bottomlabelHeight =  ipad_bottomlabelHeight ;
        
        
    }
    else
    {
        textOffset=iphone_textOffset;
        topLabelFontSize=iphone_topLabelFontSize;
        middleLabelFontSize=iphone_middleLabelFontSize;
        bottomLabelFontSize=iphone_bottomLabelFontSize;
        indicatorWidth=iphone_indicatorWidth;   
        
        imageWidth=iphone_imageWidth;   
    //    activityImageScale=iphone_activityImageScale;
     //   indicatorFrameWidth=iphone_indicatorFrameWidth;
        
        
        toplabelHeight = iphone_toplabelHeight ;
        middlelabelHeight =iphone_middlelabelHeight ; 
        bottomlabelHeight =  iphone_bottomlabelHeight;
    }
    
    // hack - if no image then clip imageWidth
    
    if (image == nil) imageWidth = 5.f;
    
    NSInteger row = [indexPath row];
    
	const NSInteger TOP_LABEL_TAG = 1001;
	const NSInteger MIDDLE_LABEL_TAG = 1002;
	const NSInteger BOTTOM_LABEL_TAG = 1003;
    
	KORAttributedLabel *topLabel;
    KORAttributedLabel *middleLabel;
	KORAttributedLabel *bottomLabel;
    NSString *displayOne;
    NSString *displayTwo;
    NSString *displayThree;
    
	static NSString *CellIdentifier = @"aaxdddyzzyCell";

    displayOne = text;
    displayTwo = @"";
    displayThree = detail;

	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
		//
		// Create the cell.
		//
		cell =
        [[UITableViewCell alloc]
          initWithStyle:UITableViewCellStyleSubtitle 
          reuseIdentifier:CellIdentifier];
        
        cell.indentationLevel = 1;
        cell.indentationWidth = 20.f;
        
        
		//
		// Create the label for the top row of text
		//
		topLabel =
        [[KORAttributedLabel alloc]
          initWithFrame:
          CGRectMake(
                     imageWidth + 2.0 * cell.indentationWidth,
                     0.5 * (aTableView.rowHeight - 2 * toplabelHeight)+textOffset,
                     aTableView.bounds.size.width -
                     imageWidth - 4.0 * cell.indentationWidth
                     - indicatorWidth,
                     toplabelHeight)];
		[cell.contentView addSubview:topLabel];
        
		//
		// Configure the properties for the text that are the same on every row
		//
		topLabel.tag = TOP_LABEL_TAG;
		topLabel.backgroundColor = [UIColor clearColor];
        
        //
		// Create the label for the top row of text
		//
		middleLabel =
        [[KORAttributedLabel alloc]
          initWithFrame:
          CGRectMake(
                     imageWidth + 2.0 * cell.indentationWidth,
                     0.5 * (aTableView.rowHeight - 2 * middlelabelHeight)+toplabelHeight +textOffset,
                     aTableView.bounds.size.width -
                     imageWidth - 4.0 * cell.indentationWidth
                     - indicatorWidth,
                    middlelabelHeight)];
		[cell.contentView addSubview:middleLabel];
        
		//
		// Configure the properties for the text that are the same on every row
		//
		middleLabel.tag = MIDDLE_LABEL_TAG;
		middleLabel.backgroundColor = [UIColor clearColor];
        
		//
		// Create the label for the bottom row of text
		//
		bottomLabel =
        [[KORAttributedLabel alloc]
          initWithFrame:
          CGRectMake(
                     imageWidth + 2.0 * cell.indentationWidth,
                     0.5 * (aTableView.rowHeight - 2 * bottomlabelHeight) +toplabelHeight + middlelabelHeight+ textOffset,
                     aTableView.bounds.size.width -
                     imageWidth - 4.0 * cell.indentationWidth
                     - indicatorWidth,
                    bottomlabelHeight)];
		[cell.contentView addSubview:bottomLabel];
        
		//
		// Configure the properties for the text that are the same on every row
		//
		bottomLabel.tag = BOTTOM_LABEL_TAG;
		bottomLabel.backgroundColor = [UIColor clearColor];
        
		//
		// Create a background image view.
		//
		// cell.imageView.image = image; // admin has images       
		cell.backgroundView =
        [[UIImageView alloc] init] ;
		cell.selectedBackgroundView =
        [[UIImageView alloc] init];
        
        
        
        if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))
        {
        
        KORAttributedLabel *topLabel2 = (id)[cell.contentView viewWithTag:TOP_LABEL_TAG];
        topLabel2.attributedText = 
        [super // attributedText code is up there 
         topString:displayOne suffix: displayTwo 
         topFont:[UIFont boldSystemFontOfSize:topLabelFontSize ]
         suffixFont:[UIFont systemFontOfSize:12.f ]         
         ];
        
        
        
        KORAttributedLabel *bottomLabel2 = (id)[cell.contentView viewWithTag:BOTTOM_LABEL_TAG];
        bottomLabel2.attributedText = 
        [super // attributedText code is up there  
         plainString:displayThree
         font:[UIFont systemFontOfSize:bottomLabelFontSize ]];
            
        }
        else
        {
            // iphone 
            KORAttributedLabel *topLabel2 = (id)[cell.contentView viewWithTag:TOP_LABEL_TAG];
            topLabel2.attributedText = 
            
            [super // attributedText code is up there   
             simpleString:displayOne font:[UIFont boldSystemFontOfSize:topLabelFontSize ] ];
            
            KORAttributedLabel *middleLabel2 = (id)[cell.contentView viewWithTag:MIDDLE_LABEL_TAG];
            middleLabel2.attributedText = [self
                                          appColorString:displayTwo
                                           font:[UIFont systemFontOfSize:middleLabelFontSize ]
                                        ];
            
            KORAttributedLabel *bottomLabel2 = (id)[cell.contentView viewWithTag:BOTTOM_LABEL_TAG];
            bottomLabel2.attributedText = 
            [super // attributedText code is up there  
             appColorString:displayThree
             font:[UIFont systemFontOfSize:bottomLabelFontSize ]
             ];
        }
        
        
	}
    
	else
	{
        // using a recycled cell
        
        if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))
        {
        KORAttributedLabel *topLabel2 = (id)[cell.contentView viewWithTag:TOP_LABEL_TAG];
        topLabel2.attributedText = 
        [super // attributedText code is up there  
         topString:displayOne suffix: displayTwo 
         topFont:[UIFont boldSystemFontOfSize:topLabelFontSize ]
         suffixFont:[UIFont systemFontOfSize:12.f ]         
         ];
        
        
        KORAttributedLabel *bottomLabel2 = (id)[cell.contentView viewWithTag:BOTTOM_LABEL_TAG];
        bottomLabel2.attributedText = 
        [super // attributedText code is up there  
         plainString:displayThree
         font:[UIFont systemFontOfSize:bottomLabelFontSize ]];
        }
        else
            
        {
            KORAttributedLabel *topLabel2 = (id)[cell.contentView viewWithTag:TOP_LABEL_TAG];
        topLabel2.attributedText = 
        [super // attributedText code is up there 
         simpleString:displayOne font:[UIFont boldSystemFontOfSize:topLabelFontSize ] ];
            
            
            KORAttributedLabel *middleLabel2 = (id)[cell.contentView viewWithTag:MIDDLE_LABEL_TAG];
            middleLabel2.attributedText = [self
                                           appColorString:displayTwo
                                           font:[UIFont systemFontOfSize:middleLabelFontSize ]
                                           ];
            
        
        
        
        KORAttributedLabel *bottomLabel2 = (id)[cell.contentView viewWithTag:BOTTOM_LABEL_TAG];
        bottomLabel2.attributedText = 
        [super // attributedText code is up there  
         appColorString:displayThree
         font:[UIFont systemFontOfSize:bottomLabelFontSize ]];
        }
        
    }
	
	//
	// Set the background and selected background images for the text.
	// Since we will round the corners at the top and bottom of sections, we
	// need to conditionally choose the images based on the row index and the
	// number of rows in the section.
	//
	UIImage *rowBackground;
	UIImage *selectionBackground;
	NSInteger sectionRows = [aTableView numberOfRowsInSection:[indexPath section]];
	
	if (row == 0 && row == sectionRows - 1)
	{
		rowBackground = [UIImage imageNamed:@"admin-topAndBottomRow.png"];
		selectionBackground = [UIImage imageNamed:@"admin-topAndBottomRowSelected.png"];
	}
	else if (row == 0)
	{
		rowBackground = [UIImage imageNamed:@"admin-topRow.png"];
		selectionBackground = [UIImage imageNamed:@"admin-topRowSelected.png"];
	}
	else if (row == sectionRows - 1)
	{
		rowBackground = [UIImage imageNamed:@"admin-bottomRow.png"];
		selectionBackground = [UIImage imageNamed:@"admin-bottomRowSelected.png"];
	}
	else
	{
		rowBackground = [UIImage imageNamed:@"admin-middleRow.png"];
		selectionBackground = [UIImage imageNamed:@"admin-middleRowSelected.png"];
	}
	((UIImageView *)cell.backgroundView).image = rowBackground;
	((UIImageView *)cell.selectedBackgroundView).image = selectionBackground;
	
//    
//    UIImage *indicatorImage = [UIImage imageNamed:rightHandImage];
//    CGRect aframe =  ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))? 
//    CGRectMake(0, 0, ipad_indicatorFrameWidth, 40): CGRectMake(0, 0, iphone_indicatorFrameWidth, 40);
//    cell.accessoryView = [[[AccessoryView alloc] initWithFrame:aframe image:indicatorImage inset:4 scale:activityImageScale] autorelease];
    
	return cell;
}


@end
