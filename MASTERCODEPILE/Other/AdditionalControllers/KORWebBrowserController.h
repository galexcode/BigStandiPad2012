//
//  KORWebBrowserController.h

#import <UIKit/UIKit.h>

@interface KORWebBrowserController : UIViewController

-(KORWebBrowserController *) initWithURL:(NSString *)URLstring
								andTitle:(NSString *)title
						 snapShotControl:(BOOL) ss;

-(KORWebBrowserController *) initWithRequest:(NSURLRequest *) requestObj;

@end
