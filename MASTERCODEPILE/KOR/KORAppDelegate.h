//
//  KORAbsAppDelegate.h
//  BigStand
//
//  Created by Bill Donner 
//

#import <UIKit/UIKit.h>
	//#import "KORTouchCapturingWindow.h"


@class NSManagedObjectContext,NSManagedObjectModel,NSPersistentStoreCoordinator;

@interface KORAppDelegate :  UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

	//- (NSURL *)applicationDocumentsDirectory;

+ (KORAppDelegate *) sharedInstance;
- (void) dieFromMisconfiguration: (NSString *) msg;
- (void)saveContext:(NSString *)backtrace;
- (void) dump:(NSString *) tag;
- (NSManagedObjectContext *)managedObjectContext:(NSString *)backtrace;

@end



@interface NSString (NSStringCategory)
-(NSComparisonResult) reverseCompare : (NSString *) a;
@end