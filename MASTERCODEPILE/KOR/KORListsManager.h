//
//  SetListsManager.h
//

#import <UIKit/UIKit.h>

//singleton datamanager

@class ListItemInfo,ListInfo;
@interface KORListsManager : NSObject 
+(void) dump;
+(void) updateRecents:(NSString *)newtune;
+(ListItemInfo *) insertListItemUnique:(NSString *)tune onList:(NSString *)list top:(BOOL)onTop;
+(NSUInteger)  itemCountForList:(NSString * ) path ;


+(NSMutableArray *) makeSetlistsScan;
+(NSMutableArray *) makeSetlistsScanNoRecents;

+(NSMutableArray *) makeSetlistsScanNoRecentsOrFavorites;
+(NSDictionary *) listOfTunes: (NSString * ) listName  ascending:(BOOL) ascending; 


+(NSMutableArray *)listOfTunesFromFile: (NSString *) filePath;

+(void) makeSetList :(NSString *)list items:(NSArray *) items;

+(ListInfo *) insertListUnique:(NSString *)list;

+(NSString *) lastTuneOn: (NSString * ) listName  ascending:(BOOL) ascending;

+(BOOL) removeTune:(NSString *) tune list:(NSString *) list;
+(void) updateTune:(NSString *)tune after: (NSString *) previous list: (NSString *) list;

+(void) updateTune:(NSString *)tune before: (NSString *) existing list: (NSString *) list;


+(BOOL) removeOldestOnList:(NSString *)listName ;
+(ListInfo *) insertList:(NSString *)list;

+(BOOL) deleteList:(NSString *)list;
+(NSString *) picSpecForList:(NSString *) listName;
+(void) setup;

+(NSArray *)rewriteListOfListsSequenceNums: (NSArray *) inMemory;
+(NSArray *)rewriteSetlistSequenceNums: (NSString *) listName inMemory:(NSArray *) inMemory;

+(BOOL) renameTuneOnAllLists:(NSString *) oldTune newName:(NSString *) newTune;

@end
