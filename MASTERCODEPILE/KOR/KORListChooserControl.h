//
//  SetListChooserControl.h
// BigStand
//
//  Created by bill donner on 1/31/11.
//  Copyright 2011 ShovelReadyApps. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KORMultiProtocol.h"


@interface KORListChooserControl: NSObject 

@property (nonatomic,retain) id<KORListChooserDelegate> delegate;
- (id) initWithTune:(NSString *)tune;
-(void) showInView:(UIView *) v ;
@end

