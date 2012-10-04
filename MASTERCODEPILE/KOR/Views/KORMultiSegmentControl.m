//
//  KORMultiSegmentControl.m
//  MasterApp
//
//  Created by william donner on 11/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "KORMultiSegmentControl.h"
#import "KORDataManager.h"

@interface KORMultiSegmentControl()
@property (nonatomic,copy ) 	completionBlockForMultiSegmentControl completionBlockForResponse;
@property (strong) NSArray *tagz;
@end


@implementation KORMultiSegmentControl
@synthesize tagz,completionBlockForResponse;

-(void) segmentPressed: (UISegmentedControl *)segment
{
		//	NSLog (@"segment pressed %@",segment);
	NSUInteger theTag = 
	
	[[self.tagz objectAtIndex:segment.selectedSegmentIndex] unsignedIntValue];
	completionBlockForResponse(theTag);
}

- (id)initWithTitles:(NSArray *)titles
			  images:(NSArray *)images
				tags:(NSArray *)tags 
			 navname:(NSString *)navname
	 completionBlock:(completionBlockForMultiSegmentControl)completionBlock;

{
	float spacing = 5;
	NSDictionary *dict = [[KORDataManager globalData].cornerNavSettings objectForKey:navname];		
	if ([[dict objectForKey:@"MenuSpacing"] integerValue] >=0)
		spacing  = [[dict objectForKey:@"MenuSpacing"] integerValue];
    self = [super initWithItems:titles];
    if (self)
        
    {
		self.tagz = [tags copy];
		self.completionBlockForResponse = completionBlock;
		self.momentary = YES;
		self.selectedSegmentIndex = 0;
		self.segmentedControlStyle = UISegmentedControlStyleBar;
		for (NSUInteger i=0; i<[titles count]; i++)
		{
			NSString *theImage = [images objectAtIndex:i];
			
			if ([theImage length]>0)
			{
				
				{  
						[self setImage:[UIImage imageNamed:theImage] forSegmentAtIndex:(NSUInteger)i]; 
				}
				
				
			}
			[self setWidth:(40.+spacing) forSegmentAtIndex:i];
			[self setEnabled:YES forSegmentAtIndex:i];
		}
		[self addTarget:self action:@selector(segmentPressed:) forControlEvents:UIControlEventValueChanged];
		
    }
	
    return self;
}


+ (id)multiSegmentWithTitles:(NSArray *)titles 
					  images:(NSArray *)images
				tags:(NSArray *)tags 
			 navname:(NSString *)navname
	 completionBlock:(completionBlockForMultiSegmentControl)completionBlock;
{
	return [[self alloc] initWithTitles:titles images:images tags:tags  navname:navname completionBlock:completionBlock];

}	
@end
