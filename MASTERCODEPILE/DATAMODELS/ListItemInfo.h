//
//  ListItemInfo.h
//  MasterApp
//
//  Created by Bill Donner on 12/27/11.
//  Copyright (c) 2011 ShovelReadyApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ListItemInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * sequence;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * listName;
@property (nonatomic, retain) NSDate * insertTime;

@end
