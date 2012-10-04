	//
	//  KioskAltMenuController.m
	//  MasterApp
	//
	//  Created by bill donner on 9/14/11.
	//  Copyright (c) 2011 ShovelReadyApps. All rights reserved.
	//

#import "KORImageMenuController.h"
#import "ClumpInfo.h"
#import "InstanceInfo.h"
#import "KORPathMappings.h"
#import "KORBarButtonItem.h"
#import "KORRepositoryManager.h"
#import "KORDataManager.h"
#import "KORTapView.h"


@interface KORImageMenuController()<KORTapViewDelegate>
-(void)buttonpressedtagged: (NSInteger) tid;
@end

@implementation KORImageMenuController

@synthesize  initx;
@synthesize  inity;
@synthesize  height;
@synthesize  width;
@synthesize  imageheight;
@synthesize  imagewidth;

-(void)buttonpressedtagged: (NSInteger) tid;
{
    NSString *name = [self.itemDetail  objectAtIndex:tid];
    if (!name)
    {
        NSLog(@"no name found for item at row %d", tid);
        return;
    }
    
    if (self.tuneselectordelegate)
        [self.tuneselectordelegate actionItemChosen: tid label:name newItems:nil listKind:@"imenu" listName:@""];
}

-(void)buttonpressedlabel:(NSString *)label;
{
	NSUInteger i = [self.itemDetail indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
		return  ([label isEqualToString:obj]);
	}];
	
	[self buttonpressedtagged: i];
	
}

-(void)buttonpressed: (id)sender {
    NSInteger tid = ((UIControl *) sender).tag - self.tagBase;
	[self buttonpressedtagged:tid];
}

-(UIView *) layoutImageMenu
{
		// make and add views to each of the items, adding video or web overlays if called for
	float initialx = self.initx;
	float initialy = self.inity;

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.menuSize.width, self.menuSize.height)];
    view.backgroundColor = self.backgroundColor;
	
    NSString *title  = self.menuTitle;

	if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad))   {
		if (title!=nil) // if there is a title then add it as a small label
		{
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(initialx,initialy,160,20)];//
			label.text = title;
			label.textColor = self.titleColor;
			label.backgroundColor = self.backgroundColor;
			label.font = [UIFont systemFontOfSize:16.f];
			[view addSubview:label];
			initialy+=24.f;
		}
	} 
	else
	{
			// on the iphone we adjust the left hand margin to center the matrix
		
		
		float twidth = (320- self.desiredCols *self.width);
		initialx = ceil(.5*(.5+twidth));  
		
		
		float theight = ([self.itemDetail count] + (self.desiredCols-1))/self.desiredCols*self.height;
		if (theight<434) 
			initialy = (434-theight)*.5;
	
		
	}
	
	float tx = [[[KORDataManager globalData].absoluteSettings objectForKey:@"ThumbnailOverlayOffsetX"] floatValue];
	float ty= [[[KORDataManager globalData].absoluteSettings objectForKey:@"ThumbnailOverlayOffsetY"] floatValue];
	
	
	CGRect bframe = CGRectMake(0,0,imagewidth,imageheight) ;
	
	CGRect tinyframe = CGRectMake(tx,ty,imagewidth*0.3f,imageheight*0.3f);  
	
	
	NSString *thumbnailfodder;
	NSString *fullPathToThumbnail;

	float x = initialx;
	float y=initialy;
	
    NSUInteger buttonNumber = 0;
    int viewsThisRow = 0;
	for (NSString *item in self.itemDetail)
		
    {
		NSString *imageShortPath = nil;
		ClumpInfo  *tn = [KORRepositoryManager findClump:item];
		if (tn) // item might have disappeared
		{
			InstanceInfo *ii = [[KORRepositoryManager allVariantsFromTitle:tn.title] objectAtIndex:0]; // only executed for the first variant	
			imageShortPath = ii.filePath;// 111111 [NSString stringWithFormat:@"%@/%@",ii.archive,ii.filePath]; //must change
		}
		
		CGRect frame = CGRectMake(x,y,imagewidth,imageheight) ;
		
		
		UIImage *image = [KORDataManager makeThumbnailImage:imageShortPath ];
		if (image ==nil) 
			image= [UIImage imageNamed:@"24-gift.png"];
		UIImageView *imview = [[UIImageView alloc] initWithFrame:bframe];
		imview.image = image;
		
		KORTapView *button = [[KORTapView alloc] initWithParent:self frame:frame base: self.tagBase];
		
		button.tag = self.tagBase + buttonNumber++;
		[button addSubview:imview];
		
		
		thumbnailfodder =[NSString stringWithFormat:@"%@-thumbvideo.png", [imageShortPath stringByDeletingPathExtension]];
		fullPathToThumbnail = [NSString stringWithFormat: @"%@/%@",[KORPathMappings pathForSharedDocuments ] ,thumbnailfodder];
		if ([[NSFileManager defaultManager] fileExistsAtPath:fullPathToThumbnail])
				// add video overlay
		{
			UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_play.png"]];
			iv.frame = tinyframe;
			[button addSubview: iv];
			
		}
		
		else
			
		{	
			thumbnailfodder =[NSString stringWithFormat:@"%@-thumbweb.png", [imageShortPath stringByDeletingPathExtension]];
			fullPathToThumbnail = [NSString stringWithFormat: @"%@/%@",[KORPathMappings pathForSharedDocuments ] ,thumbnailfodder];
			if ([[NSFileManager defaultManager] fileExistsAtPath:fullPathToThumbnail])
			{	
					// add web overlay
				UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_globe.png"]];
				iv.frame = tinyframe;
					//iv.center = button.center;
				[button addSubview: iv];
					//[button bringSubviewToFront:iv];
				
			}
			
			else
			{
					// no overlay just make button the thing
				
			}
			
		}
		
		[view addSubview:button];
		
		if (viewsThisRow == (self.perRow-1))
		{
			viewsThisRow = 0;
			x=initialx;
			y=y+height;
		}
		else {
			viewsThisRow++;
			x = x+width;
		}
	}
    return view;
}


-(int) computePerRow
{
	int cols = self.desiredCols;
    float twidth = self.initx+self.desiredCols *self.width+self.initx;
    while (twidth>600) {
        cols --;
        twidth = self.initx+cols *self.width+self.initx;
    }
    return cols ;
}

-(CGSize) computeMenuSize
{    
	
	
		//	NSLog (@"KORImageMenuController computeMenuSize is height %.f width %.f imageh %.f imagew %.f ",self.height,self.width, 
		//		   self.imageheight,self.imagewidth);
	int cols = self.desiredCols;
	
    float twidth = self.initx+cols *self.width;//+self.initx;
    while (twidth>600) {
        cols --;
        twidth = self.initx+cols *self.width;//+self.initx;
    }
    
    
    int wants_rows = ([self.itemDetail count] + (cols-1))/cols;
    float theight = wants_rows*self.height+1*self.inity;
	
	if (self.menuTitle!=nil) theight+=24; // juice it
    while (theight>950) {
        wants_rows--;
        theight = wants_rows*self.height+1*self.inity;
    }
    return CGSizeMake(twidth,theight); 
    
}


- (void) loadView
{
	
    
    self.perRow = self.desiredCols;	
    
    self.menuSize = [self computeMenuSize];  // self.perRow
    
    self.view = [self layoutImageMenu];  
	
    
}
- (void) didReceiveMemoryWarning
{
    NSLog (@"KORImageMenuController didReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
}
-(KORImageMenuController *) initWithItems:(NSArray *)items filteredBy: (NSString *) pileFilter 
									style:(NSUInteger) mode 
						  backgroundColor:(UIColor *) bgColor 
							   titleColor: (UIColor  *) tcColor 
					titleBackgroundColor :(UIColor *) tcbColor

							   textColor :(UIColor *) textColor
					 textBackgroundColor :(UIColor *) textBackgroundColor

							thumbnailSize:(NSUInteger) thumbsize 
						  imageBorderSize:(NSUInteger) imageborderSize 
							  columnCount:(NSUInteger) columnCount
								  tagBase:(NSUInteger) base 
								 menuName:(NSString *) name
								menuTitle:(NSString *) title;
{
    
    self = [super initWithItems:(NSArray *)items filteredBy: (NSString *) pileFilter 
						  style:(NSUInteger) mode 
				backgroundColor:(UIColor *) bgColor 
					 titleColor: (UIColor  *) tcColor 
		  titleBackgroundColor :(UIColor *) tcbColor
					 textColor :(UIColor *) textColor
		   textBackgroundColor :(UIColor *) textBackgroundColor			
				  thumbnailSize: (NSUInteger) thumbsize 
				imageBorderSize: (NSUInteger) imageborderSize 
					columnCount: (NSUInteger) columnCount
						tagBase:(NSUInteger) base 
					   menuName:(NSString *) name
					  menuTitle:(NSString *) title];
    if (self) 
    {
        self.initx= imageborderSize;
        self.inity = imageborderSize;
        self.imageheight = thumbsize;
        self.imagewidth = thumbsize;
        self.height =  self.imageheight + imageborderSize;
        self.width = self.imagewidth + imageborderSize;
		
    }
    return self;
}

@end
