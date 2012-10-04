//
//  ArchiveInfo.h
//  MasterApp
//
//  Created by Bill Donner on 12/27/11.
//  Copyright (c) 2011 ShovelReadyApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ArchiveInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * size;
@property (nonatomic, retain) NSString * provenanceHTML;
@property (nonatomic, retain) NSNumber * enabled;
@property (nonatomic, retain) NSString * logo;
@property (nonatomic, retain) NSString * archive;
@property (nonatomic, retain) NSNumber * fileCount;
@property (nonatomic, retain) NSNumber * sequence;

@end
