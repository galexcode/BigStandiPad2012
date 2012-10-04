//
//  KORBaseAbstractController.h
//  
//
//  Created by bill donner on 6/4/11.
//  Copyright 2011 ShovelReadyApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>


@interface KORAbsViewController : UIViewController 

-(void) makeSearchNavHeaders;

-(UIView *) buildModalSizedBackgroundWithImageNamed:(NSString *)imagename frame:(CGRect) frame;
-(NSString *)propname:(NSString *) classname;
-(BOOL) ispropset:(NSString *) prop;
-(void) propset:(NSString *) prop tovalue:(BOOL) b;

- (NSAttributedString *)topString:(NSString *)primary suffix:(NSString *)suffix 
                          topFont:(UIFont *)AtFont suffixFont:(UIFont *)suffixFont;
- (NSAttributedString *)simpleString:(NSString *)text 
                                font:(UIFont *)AtFont;

- (NSAttributedString *)appColorString:(NSString *)text 
                                  font:(UIFont *)AtFont;

- (NSAttributedString *)plainString:(NSString *)text 
                               font:(UIFont *)AtFont;
@end
