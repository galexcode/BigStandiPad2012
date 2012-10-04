//
//  ContentTableAbstractController.h
// BigStand
//
//  Created by bill donner on 5/29/11.
//  Copyright 2011 ShovelReadyApps. All rights reserved.
//

#import "KORAbsContentController.h"
#import "KORMultiProtocol.h"

@class KORHelpPanelView,KORAbsContentController;
@interface KORAbsContentTableController : KORAbsContentController <UIGestureRecognizerDelegate> {}

@property (nonatomic,assign) id<KORImportIntoArchiveDelegate>   importDelegate;
@property (nonatomic,retain) NSString *thisArchive;
@property (nonatomic,retain) id<KORItemChosenDelegate> tuneselectordelegate;
@property (retain) NSArray *leftTextLines;
@property (retain) NSArray *rightTextLines;

//-(UIView *) setupHelpPanel;
- (UITableViewCell *)makeContentTableCellView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath listItems:(NSArray *)listItems;

-(NSArray *) buildContentUIViews:(id)o leftTextLines:(NSArray *) left rightTextLines:(NSArray *)right    
                      leftfont:(UIFont *)lfont rightfont:(UIFont *)rfont;
@end
