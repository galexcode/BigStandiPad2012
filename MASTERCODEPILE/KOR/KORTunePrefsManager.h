//
//  TunePrefsManager.h
// BigStand
//
//  Created by bill donner on 6/25/11.
//  Copyright 2011 ShovelReadyApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KORDictionaryAdditions.h"
@interface KORTunePrefsManager : NSObject
+ (KORTunePrefsManager *) cloudInstance;

-(id) init;

// unsigned ints - return 0 if never set
+(void) addPref: (NSString *) key valueWithUnsignedInt:(NSUInteger) value forTune:(NSString *)tune;
+ (NSUInteger) prefUnsignedIntValueForKey:(NSString *) key forTune:(NSString *)tune;

// bools - return NO if never set
+(void) addPref: (NSString *) key valueWithBool:(BOOL) value forTune:(NSString *)tune;
+ (BOOL) prefBoolValueForKey:(NSString *) key forTune:(NSString *)tune;

@end
