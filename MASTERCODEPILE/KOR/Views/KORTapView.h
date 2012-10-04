//
//  KORTapView.h
//  MasterApp
//
//  Created by william donner on 10/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "KORMultiProtocol.h"

@interface KORTapView: UIView
@property (nonatomic,retain) UIViewController<KORTapViewDelegate> *vc;

-(id) initWithParent:(UIViewController<KORTapViewDelegate>*)viewControllerDelegate frame:(CGRect) frame base:(NSInteger)basex;
@end


