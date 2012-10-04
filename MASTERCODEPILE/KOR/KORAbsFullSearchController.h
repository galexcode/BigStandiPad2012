//
//  AllTunesViewController.h
//  MCProvider
//
//  Created by Bill Donner on 1/22/11.
//

#import <UIKit/UIKit.h>
#import "KORAbsContentTableController.h"


@class KORViewerController;
@interface KORAbsFullSearchController : KORAbsContentTableController
-(id) initWithArray:(NSArray *) a andTitle:(NSString *)titl andArchive:(NSString *)archiv helpView:(UIView *) hvx ;
@end


