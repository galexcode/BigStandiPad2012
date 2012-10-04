//
//  AccessoryView.m
//  gigstand
//
//  Created by bill donner on 6/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "KORAccessoryView.h"

@interface KORAccessoryView()
@property (nonatomic,retain)   UIImageView *imageView;
@end

@implementation KORAccessoryView
@synthesize imageView;




// puts extra space on the right of the accessory view, just make the frame bigger than the image
- (id)initWithFrame:(CGRect)frame image:(UIImage *) image inset: (CGFloat) inset scale:(CGFloat) scale;
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        CGRect insetFrame = CGRectMake  (frame.origin.x+inset ,
                             frame.origin.y+inset,
                             image.size.width*scale,
                             image.size.height*scale);
        
        imageView = [[UIImageView alloc] initWithFrame:insetFrame];
        imageView.image = image;
        [self addSubview:imageView];
    
    
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


@end
