//
//  WLDBarButtonItem.h
// BigStand
//
//  Created by bill donner on 6/11/11.
//  Copyright 2011 ShovelReadyApps. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^NoArgBlock1)(void);


@interface KORActionSheet : UIActionSheet
- (id) initWithTitle:(NSString *) title;
-(void) addButtonWithTitle:(NSString *) buttonTitle completionBlock:(NoArgBlock1) completionBlock;
@end
