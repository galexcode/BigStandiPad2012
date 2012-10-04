//
//  ListInfo.h
//  MasterApp
//
//  Created by Bill Donner on 12/27/11.
//  Copyright (c) 2011 ShovelReadyApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ListInfo : NSManagedObject

@property (nonatomic, retain) NSDate * creationTime;
@property (nonatomic, retain) NSString * listName;
@property (nonatomic, retain) NSNumber * sequence;

@end
