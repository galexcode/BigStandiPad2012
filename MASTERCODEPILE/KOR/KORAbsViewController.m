//
//  LookFeelAbstractController.m
//  
//
//  Created by bill donner on 6/4/11.
//  Copyright 2011 ShovelReadyApps. All rights reserved.
//

#import "KORAbsViewController.h"

#import "KORDataManager.h"

@implementation KORAbsViewController

-(void) makeSearchNavHeaders;
{
	self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];	
	[self.navigationController.navigationBar
	 
	 setTitleTextAttributes:
	 [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor, 
	  [UIFont boldSystemFontOfSize:20.0f],UITextAttributeFont,
	  nil]];
	self.navigationItem.leftBarButtonItem.tintColor = [UIColor darkGrayColor];
	
	self.navigationItem.rightBarButtonItem.tintColor = [UIColor darkGrayColor];
	
}

-(UIView *) buildModalSizedBackgroundWithImageNamed:(NSString *)imagename frame:(CGRect) theframe;
{

    UIImageView *gradientBackgroundView  = [[UIImageView alloc] initWithFrame: theframe];
    
		// gradientBackgroundView.image= [UIImage imageNamed:imagename];
    gradientBackgroundView.alpha = 1.000;
    gradientBackgroundView.autoresizesSubviews = YES;
    gradientBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gradientBackgroundView.backgroundColor = [UIColor colorWithWhite:0.900 alpha:1.000];
    gradientBackgroundView.clearsContextBeforeDrawing = NO;
    gradientBackgroundView.clipsToBounds = NO;
    gradientBackgroundView.contentMode = UIViewContentModeScaleToFill;
    gradientBackgroundView.contentStretch = CGRectFromString(@"{{0, 0}, {1, 1}}");
    gradientBackgroundView.hidden = NO;
    gradientBackgroundView.multipleTouchEnabled = NO;
    gradientBackgroundView.opaque = NO;
    gradientBackgroundView.tag = 0;
    gradientBackgroundView.userInteractionEnabled = YES;
    return gradientBackgroundView; //0611
    
}

#pragma mark -
#pragma mark User Defaults Prop Support  Based on Class Controller  

-(NSString *)propname:(NSString *) classname
{
    return [@"prop-" stringByAppendingString:classname];
}
-(BOOL) ispropset:(NSString *) prop
{
    
    id ob = [[NSUserDefaults standardUserDefaults] objectForKey:prop];
    
    if (ob == nil) return YES; // no key means the prop is set
    
    return [ob boolValue];
    
}
-(void) propset:(NSString *) prop tovalue:(BOOL) b;

{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:b] forKey:prop];
}

#pragma mark -
#pragma mark Attributed String Utility methods 

// START:topString
- (NSAttributedString *)topString:(NSString *)primary suffix:(NSString *)suffix 
                          topFont:(UIFont *)AtFont suffixFont:(UIFont *)suffixFont;
{
	
    if (suffix == nil) suffix = @" ";
    
    int suffixlen = [suffix length];
    int suffixstart = [primary length];
    
    NSString *text = [NSString stringWithFormat:@"%@ %@",primary, suffix];
    
    // int len = [text length];
    
    NSMutableAttributedString *mutaString = 
    [[NSMutableAttributedString alloc] initWithString:text];
    
    
    // string is now fully assembled, must add font and color attributes
    // first part is black, second is red
    CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)AtFont.fontName, 
                                            AtFont.pointSize, 
                                            NULL);
    
    CTFontRef ctFont2 = CTFontCreateWithName((__bridge CFStringRef)AtFont.fontName, 
                                             AtFont.pointSize*0.8,
                                             NULL);
    
    
    [mutaString addAttribute:(NSString *)(kCTForegroundColorAttributeName) 
                       value:(id)[UIColor blackColor].CGColor 
                       range:NSMakeRange(0, suffixstart)];
    
    [mutaString addAttribute:(NSString *)(kCTFontAttributeName) 
                       value:(__bridge id)ctFont 
                       range:NSMakeRange(0, suffixstart)];
    
    [mutaString addAttribute:(NSString *)(kCTForegroundColorAttributeName) 
                       value:(id)[KORDataManager globalData].appBackgroundColor.CGColor
                       range:NSMakeRange(suffixstart, suffixlen)];
    [mutaString addAttribute:(NSString *)(kCTFontAttributeName) 
                       value:(__bridge id)ctFont2 
                       range:NSMakeRange(suffixstart, suffixlen)];
    CFRelease(ctFont);
    CFRelease(ctFont2);
    return mutaString;
}
// END:topString
- (NSAttributedString *)simpleString:(NSString *)text 
                                font:(UIFont *)AtFont;
{
	
    int len = [text length];
    NSMutableAttributedString *mutaString = 
    [[NSMutableAttributedString alloc] initWithString:text];
    
    CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)AtFont.fontName, 
                                            AtFont.pointSize, 
                                            NULL);
    
    [mutaString addAttribute:(NSString *)(kCTForegroundColorAttributeName) 
                       value:(id)[UIColor blackColor].CGColor 
                       range:NSMakeRange(0,len)];
    
    [mutaString addAttribute:(NSString *)(kCTFontAttributeName) 
                       value:(__bridge id)ctFont 
                       range:NSMakeRange(0, len)];
    
    
    CFRelease(ctFont);
    return mutaString;
}
- (NSAttributedString *)appColorString:(NSString *)text 
                                  font:(UIFont *)AtFont;
{
	
    int len = [text length];
    NSMutableAttributedString *mutaString = 
    [[NSMutableAttributedString alloc] initWithString:text] ;
    
    CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)AtFont.fontName, 
                                            AtFont.pointSize, 
                                            NULL);
    
    [mutaString addAttribute:(NSString *)(kCTForegroundColorAttributeName) 
                       value:(id)[KORDataManager globalData].appBackgroundColor.CGColor 
                       range:NSMakeRange(0,len)];
    
    [mutaString addAttribute:(NSString *)(kCTFontAttributeName) 
                       value:(__bridge id)ctFont 
                       range:NSMakeRange(0, len)];
    
    
    CFRelease(ctFont);
    return mutaString;
}

- (NSAttributedString *)plainString:(NSString *)text 
                               font:(UIFont *)AtFont;

{
	
    int len = [text length];
    NSMutableAttributedString *mutaString = 
    [[NSMutableAttributedString alloc] initWithString:text] ;
    
    CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)AtFont.fontName, 
                                            AtFont.pointSize, 
                                            NULL);
    
    [mutaString addAttribute:(NSString *)(kCTForegroundColorAttributeName) 
                       value:(id)[UIColor darkGrayColor].CGColor 
                       range:NSMakeRange(0,len)];
    
    [mutaString addAttribute:(NSString *)(kCTFontAttributeName) 
                       value:(__bridge id)ctFont 
                       range:NSMakeRange(0, len)];
    
    CFRelease(ctFont); 
    return mutaString;
}

//- (NSAttributedString *)multiColoredString:(NSString *)text 
//                                      font:(UIFont *)AtFont {
//    
//	NSArray *colors = [NSArray arrayWithObjects:(id)
//                       [UIColor cyanColor].CGColor,
//					   [UIColor redColor].CGColor,
//					   [UIColor orangeColor].CGColor,
//					   [UIColor cyanColor].CGColor,
//					   [UIColor greenColor].CGColor,
//					   [UIColor redColor].CGColor,
//					   nil];
//    
//	NSMutableAttributedString *mutaString = 
//    [[NSMutableAttributedString alloc] initWithString:text];
//	
//	int colorIndex = 0;
//	for (int i = 0; i < [mutaString length]; i++) {
//		[mutaString addAttribute:(NSString *)(kCTForegroundColorAttributeName) 
//						   value:(id)[colors objectAtIndex:colorIndex] 
//						   range:NSMakeRange(i, 1)];
//		colorIndex++;
//		if (colorIndex == [colors count]) colorIndex = 0;
//	}
//	
//    int len = [text length];
//	CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)AtFont.fontName, 
//                                            AtFont.pointSize,
//											NULL);
//	[mutaString addAttribute:(NSString *)(kCTFontAttributeName) 
//                       value:(__bridge id)ctFont 
//                       range:NSMakeRange(0, len)];
//    
//    CFRelease(ctFont);
//     return mutaString;
//}
-(id) init
{
    self = [super init];
    if (self){
   // NSLog (@"LFAC initing %@",self);
    }
    return self;
}

- (void) didReceiveMemoryWarning
{
    NSLog (@"KORAbsViewController didReceiveMemoryWarning");
		//[super didReceiveMemoryWarning];
}

@end
