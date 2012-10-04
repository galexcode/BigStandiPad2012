//
//  KORRepositoryManager
// BigStand
//
//  Created by bill donner on 2/22/11.
//  Copyright 2011 ShovelReadyApps. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>
@class ClumpInfo,InstanceInfo,DBInfo,SnapshotInfo,ArchiveInfo,ArchiveHeaderInfo;

@interface KORRepositoryManager :NSObject

+(ClumpInfo *) tuneInfo:(NSString *) tune;

+(ClumpInfo *) findClump:(NSString *)tune;
+(ClumpInfo *) findTune: (NSString *)tune;
+(NSArray *) allVariantsFromTitle:(NSString *)title;
+(void) setLastTitle:(NSString *)title;

+(SnapshotInfo *) findSnapshotInfo: (NSString *)tune;
+(void) insertSnapshotInfo:(NSString *)filepath title:(NSString *)titl;
+(NSUInteger) snapshotCount;
+(BOOL) removeOldestSnapshot;
+ (void) dump;

+(BOOL) renameTune:(NSString *)fromtune toTune:(NSString *) totune;

+(void) insertGBInfo;
+(void) updateDBInfo;

+(NSString *) lastTitle;
+(NSUInteger) clumpCount;
+(NSUInteger) instancesCount;
+(NSArray *) allTitles;
+(NSArray *) allTitlesFromArchive:(NSString *)archive;

+ (NSArray *) allTitlesOrderedByFileSpec;
+(void) titlePurgeCheck:(NSString *)title;
+(void) setup;


+(ClumpInfo *) insertTuneUnique:(NSString *) tune lastArchive:(NSString *) lastarchive lastFilePath:(NSString *) lastfilepath;
+(InstanceInfo *) insertInstanceUnique:(NSString *)tune  archive:(NSString *)archive filePath:(NSString *)filepath;


+(NSArray *)rewriteListOfArchivesSequenceNums: (NSArray *) inMemory;

+ (NSArray *) allEnabledArchives;

+ (NSMutableArray *) allArchives;

+ (NSArray *) allArchivesObjs;

+ (NSUInteger) archivesCount;

+(ArchiveInfo *) findArchive: (NSString *)archive ;

+(ArchiveInfo *) insertArchive:(NSString *) archive;

+(ArchiveInfo *) insertArchiveUnique:(NSString *) archive;

+(ArchiveHeaderInfo *) findArchiveHeader: (NSString *)archive forType: (NSString *)type ;

+(ArchiveHeaderInfo *) insertArchiveHeader:(NSString *)archive headerHTML:(NSString *)headerHTML forType:(NSString *)extension ;

+(BOOL) deleteArchive:(NSString *)archive;


+(BOOL) deleteTune:(NSString *) tune fromArchive:(NSString *)archive;
// these came from KORRepositoryManager


// archives singleton object is gated thru these routines

+(BOOL) isArchiveEnabled: (NSString *) archive;
+(void) setArchiveEnabled:(BOOL) b forArchiveName: (NSString *) archive;

+(NSString *) archiveThumbnailSpec :(NSString *) archive;
+(double) fileSize: (NSString *) archive;
+(NSUInteger ) fileCount: (NSString *) archive;
+(NSString *) headerdataFromArchive: (NSString *) archive type: (NSString *) ext;

+(void ) bumpFileCount: (NSString *) archive;

+(UIImage *) makeArchiveThumbnail:(NSString *) archive; 

// utility routine that doesnt need db
+(NSString *) shortName: (NSString * ) archive;

// db startup, etc
+(unsigned long long) totalFileSystemSize;
+(NSUInteger) convertDirectoryToArchive:(NSString *) archive ;


+(DBInfo *) findDBInfo;
+(void) buildNewDB;
+(void) setupDB;
+(NSString *)nameForOnTheFlyArchive;
+(void) copyFromInboxToOnTheFlyArchive: (NSString *) path  ofType:(NSString *) t withName:(NSString *) name;
+(void) saveImageToOnTheFlyArchive:  (UIImage *) image   title:(NSString *) title;

+(BOOL) moveTune:(NSString *)title fromarchive:(NSString *)fromarchive toarchive:(NSString *)toarchive ;


+(BOOL) deleteTune:(NSString *) tune fromArchive:(NSString *)archive;

+(BOOL) deleteTuneFromAllArchives:(NSString *) tune;


@property (nonatomic, readonly, retain) NSString *otfarchive;

@end

