//
//  WLDBarButtonItem.m
// BigStand
//
//  Created by bill donner on 6/11/11.
//  These are UIBarButtonItems that use completion Blocks 
//

#import "KORBarButtonItem.h"


@interface KORBarButtonItem()
- (id)initWithImage:(UIImage *)image 
style:(UIBarButtonItemStyle)style
completionBlock:(completionBlockForBarButtonItem)completionBlock;

- (id)initWithImage:(UIImage *)image 
landscapeImagePhone:(UIImage *)landscapeImagePhone 
style:(UIBarButtonItemStyle)style 
completionBlock:(completionBlockForBarButtonItem)completionBlock;

- (id)initWithTitle:(NSString *)title 
style:(UIBarButtonItemStyle)style 
completionBlock:(completionBlockForBarButtonItem)completionBlock;

- (id)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem
completionBlock:(completionBlockForBarButtonItem)completionBlock;

- (id)initWithCustomView:(UIView *)view 
		 completionBlock:(completionBlockForBarButtonItem)completionBlock;

@property (nonatomic, copy) completionBlockForBarButtonItem buttonCompletionBlock;
@end

@implementation KORBarButtonItem
@synthesize buttonCompletionBlock,labelViews;

-(void) buttonPressed:(id)sender
{
    // just execute the completion Block
    
    buttonCompletionBlock(sender);
}
-(void) tapGestureDone:(id)sender
{
	if(buttonCompletionBlock)
	buttonCompletionBlock(self); // note this is the actual bar button
}
+ (id)buttonWithCustomView:(UIView *)view 
               completionBlock:(completionBlockForBarButtonItem)completionBlock;
{
    return [[self alloc] initWithCustomView:view
                         completionBlock:(completionBlockForBarButtonItem)completionBlock] ;
}

+ (id)buttonWithImage:(UIImage *)image 
              style:(UIBarButtonItemStyle)style
         completionBlock:(completionBlockForBarButtonItem)completionBlock;

{ 
    return [[self alloc] initWithImage:image style:style completionBlock:completionBlock];
}

+ (id)buttonWithImage:(UIImage *)image 
landscapeImagePhone:(UIImage *)landscapeImagePhone 
              style:(UIBarButtonItemStyle)style 
         completionBlock:(completionBlockForBarButtonItem)completionBlock;
{
    return [[self alloc] initWithImage:image landscapeImagePhone: landscapeImagePhone style:style completionBlock:completionBlock] ;
}

+ (id)buttonWithTitle:(NSString *)title 
              style:(UIBarButtonItemStyle)style 
         completionBlock:(completionBlockForBarButtonItem)completionBlock;
{
    return [[self alloc] initWithTitle:title style:style completionBlock:completionBlock];
}
+ (id)buttonWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem
                       completionBlock:(completionBlockForBarButtonItem)completionBlock;
{
    return [[self alloc] initWithBarButtonSystemItem: systemItem completionBlock:completionBlock ];
}

- (id)initWithImage:(UIImage *)image 
              style:(UIBarButtonItemStyle)style
         completionBlock:(completionBlockForBarButtonItem)completionBlock;
{
    self= [self initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style target:self action:@selector(buttonPressed:)];
    
    if (self ) {
        
        self.buttonCompletionBlock = completionBlock;
        
        
    }
    return self;
}

- (id)initWithImage:(UIImage *)image 
landscapeImagePhone:(UIImage *)landscapeImagePhone 
              style:(UIBarButtonItemStyle)style 
         completionBlock:(completionBlockForBarButtonItem)completionBlock;
{
    
    self = [super initWithImage:(UIImage *)image 
            landscapeImagePhone:(UIImage *)landscapeImagePhone 
                          style:(UIBarButtonItemStyle)style 
                         target:self 
                         action:@selector(buttonPressed:)];
     if (self ) {
        self.buttonCompletionBlock = completionBlock;
        
    }
    return self;
}

- (id)initWithTitle:(NSString *)title 
              style:(UIBarButtonItemStyle)style 
         completionBlock:(completionBlockForBarButtonItem)completionBlock;
{
    
    self = [super initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style target:self action:@selector(buttonPressed:)];
    if (self ) {
         self.buttonCompletionBlock = completionBlock;
        
    }
    return self;
}

- (id)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem
                       completionBlock:(completionBlockForBarButtonItem)completionBlock;
{
    
    
    self = [super initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem target:self action:@selector(buttonPressed:)];
    if (self ) {
         self.buttonCompletionBlock = completionBlock;
        
    }
    return self;
}

- (id)initWithCustomView:(UIView *)view completionBlock:(completionBlockForBarButtonItem)completionBlock;
{
	UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc] 
	 initWithTarget: self 
	 action: @selector (tapGestureDone:)];
	gest.numberOfTapsRequired = 1;			
	gest.numberOfTouchesRequired = 1;
	[view addGestureRecognizer: gest];
	
    self = [super initWithCustomView:view];
    if (self)
    {	
		  self.buttonCompletionBlock = completionBlock;
    }
    return self;
}


@end
