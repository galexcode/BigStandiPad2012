	//
	//  MultiButtonControl.m
	//  gigstand
	//
	//  Created by bill donner on 5/17/11.
	//  Copyright 2011 __MyCompanyName__. All rights reserved.
	//

	// this takes an array of images and a callback and does the right thing
	//

	// this control does not distinguish between ipad and iphone, etc, leaving the caller to worry over geometries
#import "KORMultiButtonControl.h"
#import "KORDataManager.h"
#import "KORTapView.h"

@implementation TransparentToolbar

	// Override draw rect to avoid
	// background coloring
- (void)drawRect:(CGRect)rect {
		// do nothing in here
}

	// Set properties to make background
	// translucent.
- (void) applyTranslucentBackground
{
    self.backgroundColor = [UIColor clearColor]; 
	self.tintColor = [UIColor clearColor];
    self.opaque = NO;
    self.translucent = YES;
}

	// Override init.
- (id) init
{
    self = [super init];
    [self applyTranslucentBackground];
    return self;
}

	// Override initWithFrame.
- (id) initWithFrame:(CGRect) frame
{
    self = [super initWithFrame:frame];
    [self applyTranslucentBackground];
    return self;
}

@end

//@implementation yWhispyToolbar
//
//	// Override draw rect to avoid
//	// background coloring
//- (void)drawRect:(CGRect)rect {
//		// do nothing in here
//}
//
//	// Set properties to make background
//	// translucent.
//- (void) applyTranslucentBackground
//{
//    self.backgroundColor = [UIColor clearColor]; 
//	self.tintColor = [UIColor clearColor];
//    self.opaque = NO;
//    self.translucent = YES;
//}
//
//	// Override init.
//- (id) init
//{
//    self = [super init];
//    [self applyTranslucentBackground];
//    return self;
//}
//
//	// Override initWithFrame.
//- (id) initWithFrame:(CGRect) frame
//{
//    self = [super initWithFrame:frame];
//    [self applyTranslucentBackground];
//    return self;
//}
//
//@end

@implementation WhispyToolbar

	// Override draw rect to avoid
	// background coloring
//- (void)drawRect:(CGRect)rect {
//		// do nothing in here
//}

	// Set properties to make background
	// translucent.
- (void) applyTranslucentBackground
{
//    self.backgroundColor = [UIColor clearColor]; 
	self.tintColor = [UIColor blackColor];
    self.opaque = NO;
    self.translucent = YES;
	self.barStyle=UIBarStyleBlack;
}

	// Override init.
- (id) init
{
    self = [super init];
    [self applyTranslucentBackground];
    return self;
}

	// Override initWithFrame.
- (id) initWithFrame:(CGRect) frame
{
    self = [super initWithFrame:frame];
    [self applyTranslucentBackground];
    return self;
}

@end


@interface KORMultiButtonControl()
@property (nonatomic,retain) UIToolbar *tools; // keep these as instance variable to hopefully staunch overallocation
@property (nonatomic,copy ) 	completionBlockForMultiButtonControl completionBlockForResponse;
@end


@implementation KORMultiButtonControl
@synthesize tools,completionBlockForResponse;



- (id)initWithTitles:(NSArray *)titles 
			  images:(NSArray *)images 
			   views:(NSArray *)views 
				tags:(NSArray *)tags 
			 navname:(NSString *)navname
		 alignment:(UITextAlignment)leftSide
	 completionBlock:(completionBlockForMultiButtonControl)completionBlock;

{
	float width = 0;
	
	NSUInteger spacing = 5;
	BOOL plainTextBorders = NO;
	BOOL plainImageBorders = NO;
	
    NSUInteger count = [titles count];
	NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:count] ;
	UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace 
																			   target: nil action: NULL] ;	
	UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFixedSpace 
																				target: nil action: NULL] ;		
	
	
	UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace 
																				target:nil action:nil];
	negativeSeperator.width = -12;
		
	NSDictionary *dict = [[KORDataManager globalData].cornerNavSettings objectForKey:navname];		
	if ([[dict objectForKey:@"MenuSpacing"] integerValue] >=0)
		spacing  = [[dict objectForKey:@"MenuSpacing"] integerValue];
	else spacing = 5;
	
	fixedSpace.width = spacing;
	
	
	if ([[dict objectForKey:@"MenuImageButtonBorders"] boolValue] >=0)
		plainImageBorders  = [[dict objectForKey:@"MenuImageButtonBorders"] boolValue];
	if ([[dict objectForKey:@"MenuTextButtonBorders"] boolValue] >=0)
		plainTextBorders  = [[dict objectForKey:@"MenuTextButtonBorders"] boolValue];
	
	// create the array to hold the buttons, which then gets added to the toolbar
	
	UIBarButtonItemStyle bistext= !plainTextBorders? UIBarButtonItemStylePlain:UIBarButtonItemStyleBordered;
	UIBarButtonItemStyle bisimage = !plainImageBorders? UIBarButtonItemStylePlain:UIBarButtonItemStyleBordered;
	
	if (leftSide == UITextAlignmentRight )
		[buttons addObject:flexSpace];
	else 
		
		if (leftSide == UITextAlignmentLeft)
		[buttons addObject:negativeSeperator]; // hack to get rid of left side wastage
	

	for (NSUInteger i = 0; i<count; i++)
	{
		NSString *title = [titles objectAtIndex:i];
		NSString *image = [images objectAtIndex:i];
		NSUInteger tagx = [[tags objectAtIndex:i] unsignedIntValue];
		UIView *thisview = [views objectAtIndex:i];
		
			// create a standard "add" button
		KORBarButtonItem* bi;
		
		if (thisview!=[KORDataManager globalData].nullView)
		{	
			bi =  [KORBarButtonItem buttonWithCustomView:thisview
										completionBlock:   ^(UIBarButtonItem *bbi)
				  {
					  completionBlockForResponse(bbi.tag);
					  
				  }
				  
				  ] ; 
			width+=thisview.frame.size.width;
		}
		else		
			if ([@"" isEqualToString:image])
			{	
				bi = [KORBarButtonItem buttonWithTitle:[NSString stringWithFormat:@"  %@  ",title]
												 style: bistext
									   completionBlock:	  ^(UIBarButtonItem *bbi)
					  {
						  completionBlockForResponse(bbi.tag);
						  
					  }] ; 
				width+=60;
			}
		
			else
			{
					// okay its some sort of image - first see if its in or system icons dictionary
				
				NSNumber *numobj = [[KORDataManager globalData].systemBarButtonImageNames objectForKey:image];
				
				if (numobj!=nil) 
					
					bi = [KORBarButtonItem buttonWithBarButtonSystemItem:[numobj integerValue] 
										completionBlock:	  ^(UIBarButtonItem *bbi)
						  {
							  completionBlockForResponse(bbi.tag);
							  
						  }];
				
				
				if (bi==nil)
					bi = [KORBarButtonItem buttonWithImage:[UIImage imageNamed:image]
													 style: bisimage
										   completionBlock:	  ^(UIBarButtonItem *bbi)
						  {
							  completionBlockForResponse(bbi.tag);
							  
						  }] ;
				width +=60;
				
			}
			// add a bit of space
		if (i!=0) [buttons addObject:fixedSpace];
		bi.tag = tagx;
		if (bi.tag >10000)
		{
			bi.enabled = NO;
			bi.tag -= 10000;
		}
        [buttons addObject:bi];    
	}
	
	if (leftSide == UITextAlignmentLeft)
		[buttons addObject:flexSpace];
	else
		
		if (leftSide == UITextAlignmentRight)
		[buttons addObject:negativeSeperator]; // hack to get rid of left side wastage
	
        // stick the buttons in the toolbar
	
	
		// float width =  50.f*count + (count-1)*spacing;
	
		// if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) height +=.01f; // fudge on iphone
    
	
	CGRect frame = CGRectMake (0,0,width,[KORDataManager globalData].toolBarHeight); // hack to make this right	
	self.tools  = [[TransparentToolbar alloc] initWithFrame:frame];
	[self.tools setItems:buttons animated:NO];
	
    self = [super initWithCustomView:self.tools];
    if (self)
        
    {
		self.completionBlockForResponse = completionBlock;
    }
	
    return self;
}


+ (id)multibuttonWithTitles:(NSArray *)titles 
					 images:(NSArray *)images 
					  views: (NSArray *)views 
					   tags:(NSArray *)tagsx  					
					navname:(NSString *)navname
				alignment:(UITextAlignment)leftSide
			completionBlock:(completionBlockForMultiButtonControl)completionBlock;
{
	return [[self alloc] initWithTitles:titles 
								 images:images 
								  views:views 
								   tags: tagsx 					
								navname:(NSString *)navname
							alignment:(UITextAlignment)leftSide 
						completionBlock:completionBlock];
}	
@end
