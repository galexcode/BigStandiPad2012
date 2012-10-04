//
//  ContentTableAbstractController.h
// BigStand
//
//  Created by bill donner on 5/29/11.
//  Copyright 2011 ShovelReadyApps. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "KORAbsAdminController.h"
@class KORHelpPanelView;
@interface KORAbsTableAdminController : KORAbsAdminController<UIGestureRecognizerDelegate> {}

@property (retain) NSArray *leftTextLines;
@property (retain) NSArray *rightTextLines;


//-(HelpPanelView *) setupHelpPanel;

-(NSArray *) buildAdminUIViews:(id)o leftTextLines:(NSArray *) left rightTextLines:(NSArray *)right    
                      leftfont:(UIFont *)lfont rightfont:(UIFont *)rfont;

- (UITableViewCell *)makeAdminTableCellView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
                                 text:(NSString *) text detail:(NSString *)detail image: (UIImage *) image;
@end
