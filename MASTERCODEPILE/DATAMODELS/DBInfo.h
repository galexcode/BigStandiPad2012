//
//  DBInfo.h
//  MasterApp
//
//  Created by Bill Donner on 12/27/11.
//  Copyright (c) 2011 ShovelReadyApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DBInfo : NSManagedObject

@property (nonatomic, retain) NSDate * dbPreviousStartTime;
@property (nonatomic, retain) NSDate * dbOperationalTime;
@property (nonatomic, retain) NSString * dbUserEmail;
@property (nonatomic, retain) NSString * gigbaseVersion;
@property (nonatomic, retain) NSDate * dbStartTime;
@property (nonatomic, retain) NSString *gigstandVersion;

@end
