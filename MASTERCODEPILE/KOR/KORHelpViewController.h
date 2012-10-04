//
//  LocalWebViewController.h
// BigStand
//
//  Created by bill donner on 4/28/11.
//  Copyright 2011 ShovelReadyApps. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface KORHelpViewController : UIViewController 
 

    @property (nonatomic, retain, readonly) UIWebView *contentView;
    


- (id) initWithHTML: (NSString *) htmlx baseURL:(NSString *) base title:(NSString *) titlex;

    
    - (void) injectJavaScript: (NSString *) jsString;
    
    - (void) refresh;
    
@end
