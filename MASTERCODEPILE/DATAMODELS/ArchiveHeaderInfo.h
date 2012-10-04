//
//  ArchiveHeaderInfo.h
//  MasterApp
//
//  Created by Bill Donner on 12/27/11.
//  Copyright (c) 2011 ShovelReadyApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ArchiveHeaderInfo : NSManagedObject

@property (nonatomic, retain) NSString * archive;
@property (nonatomic, retain) NSString * extension;
@property (nonatomic, retain) NSString * headerHTML;

@end
