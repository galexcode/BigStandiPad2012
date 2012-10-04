//
//  KORTapView.m
//  MasterApp
//
//  Created by william donner on 10/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "KORTapView.h"




@interface KORTapView()
@property NSInteger base;
@end


@implementation KORTapView
@synthesize vc,base;
-(id) initWithParent:(UIViewController<KORTapViewDelegate>*)viewControllerDelegate frame:(CGRect) frame base:(NSInteger)basex;
{
	self = [super initWithFrame:frame];
	if (self) {
		self.vc = viewControllerDelegate;
		self.base = basex;
		self.backgroundColor = [UIColor lightGrayColor];
	}
	return self;
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.vc buttonpressedtagged: (self.tag - self.base)];
		//[self removeFromSuperview];
}


@end