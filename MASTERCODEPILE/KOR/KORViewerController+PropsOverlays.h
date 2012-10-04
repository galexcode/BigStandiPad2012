//
//  KORViewerController+PropsOverlays.h
//  MasterApp
//
//  Created by bill donner on 10/17/11.
//  Copyright (c) 2011 ShovelReadyApps. All rights reserved.
//

#import "KORViewerController.h"

@interface KORViewerController (PropsOverlays)

- (void) propsOverlayTextSet:(NSString *)s forTag:(float)tag;
-(void) showPropsSheet:(NSString*)masterTitle tuneTitle:(NSString *)tuneTitle;
@end
