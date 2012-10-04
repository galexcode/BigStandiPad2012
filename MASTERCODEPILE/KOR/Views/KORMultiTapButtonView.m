//
//  MultiTapButtonView.m
//  gigstand
//
//  Created by bill donner on 6/10/11.
//  These are UIBarButtonItems that use completion Blocks 
//

#import "KORMultiTapButtonView.h"



@interface KORMultiTapButtonView()

- (id)initWithView:(UIView *)view 
     completionBlock:(MultiTapButtonViewBlock)completionBlock
    longPressBlock:(MultiTapButtonViewBlock)longPressBlock;

@property (nonatomic, copy) MultiTapButtonViewBlock shortTapCompletionBlock;
@property (nonatomic, copy) MultiTapButtonViewBlock longPressCompletionBlock;
@end

@implementation KORMultiTapButtonView
@synthesize shortTapCompletionBlock,longPressCompletionBlock;


+ (id)multiTapGestureForView:(UIView *)view 
               completionBlock:(MultiTapButtonViewBlock)completionBlock
              longPressBlock:(MultiTapButtonViewBlock)longPressBlock;
{
    return [[self alloc] initWithView: view completionBlock:completionBlock longPressBlock:longPressBlock] ; 
}

-(void) shortTapPressed:(id)sender
{
    // just execute the completion Block
    
    shortTapCompletionBlock(sender);
}
-(void) longPressPressed:(id)sender
{
    // just execute the completion Block
    
    longPressCompletionBlock(sender);
}
-(id) initWithView:(UIView *)view 
     completionBlock:(MultiTapButtonViewBlock)completionBlock
    longPressBlock:(MultiTapButtonViewBlock)longPressBlock;

{   self = [super initWithFrame:[view frame]]; // general nsobject
    if (self)
    {
        self.shortTapCompletionBlock   =  completionBlock;
        self.longPressCompletionBlock = longPressBlock;
   
        if (completionBlock)
        {
            UITapGestureRecognizer* tapGestureRecogizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shortTapPressed:)];
            tapGestureRecogizer.numberOfTapsRequired  =1;
            tapGestureRecogizer.numberOfTouchesRequired = 1;
            [view addGestureRecognizer:tapGestureRecogizer];
        }
        
        
        if (longPressBlock)
        {
           UILongPressGestureRecognizer* longGestureRecogizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressPressed:)] ;
            
            [view addGestureRecognizer:longGestureRecogizer];
        }
        
        [self addSubview:view]; 
    
    }
    return self;
}


@end
