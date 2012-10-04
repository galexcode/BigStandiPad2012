//
//  KORViewLineButtonLabelView.h
//  MasterApp
//
//  Created by william donner on 10/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface KORViewLineButtonLabelView : UIView

@property (nonatomic,retain) UIView *line1CustomView;
@property (nonatomic,retain) UILabel *line2Label;
@property (nonatomic,retain) UILabel *sideLabel;

-(BOOL) refreshViewLineButtonLabel;

- (id)initWithFrame:(CGRect)frame imageNamed:(NSString *)imagename whichSide:(BOOL)leftside;

@end


