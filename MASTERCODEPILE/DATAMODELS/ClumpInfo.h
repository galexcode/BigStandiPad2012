//
//  ClumpInfo.h
//  MasterApp
//
//  Created by Bill Donner on 12/27/11.
//  Copyright (c) 2011 ShovelReadyApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ClumpInfo : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * lastArchive;
@property (nonatomic, retain) NSString * lastFilePath;

@end
