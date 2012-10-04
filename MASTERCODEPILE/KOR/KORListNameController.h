//
//  SetListNameController.h
// BigStand
//
//  Created by bill donner on 6/6/11.
//  Copyright 2011 ShovelReadyApps. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KORListNameController : UIViewController <UITextFieldDelegate>{
}

@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (retain) NSArray *listItems;

@end
