//
//  HelpPanelView.h
//  gigstand
//
//  Created by bill donner on 6/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KORHelpPanelView : UIView

+(KORHelpPanelView *)panelWithFrame:(CGRect)frame leftTextLines:(NSArray *)leftText rightTextLines:(NSArray *)rightText
                        leftFont:(UIFont *) leftFont rightFont:(UIFont *) rightFont color:(UIColor *)color dismissable:(BOOL)dismis;
@end
