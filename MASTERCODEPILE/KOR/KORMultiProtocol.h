//
//  MutiProtocol.h
//  MasterApp
//
//  Created by bill donner on 10/18/11.
//  Copyright (c) 2011 ShovelReadyApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KORTuneControllerDismissedDelegate
-(void) dismissOTCController;
@end
@protocol KORTrampolineDelegate
-(void) trampoline:(NSUInteger) commandtag; 
@end
@protocol KORTrampolineOneArgDelegate
-(void) trampolineOneArg:(NSUInteger) commandtag  arg:(id) obj; 
@end
@protocol KORItemChosenDelegate
-(void) actionItemChosen:(NSUInteger) itemIndex label:(NSString *)tune newItems:(NSArray *)newItems listKind:(NSString *)listkind listName:(NSString *)listname;
@end


@protocol KORListChooserDelegate
-(void)choseSetList:(NSDictionary *)dict;
@end


@protocol KORTapViewDelegate
-(void)buttonpressedtagged: (NSInteger) tid;
@end
@protocol KORSetlistChosenDelegate
-(void)setlistChosen: (NSString *) setlist;
@end

@protocol KORArchiveChosenDelegate
-(void)archiveChosen: (NSString *) archive;
@end
@protocol KORImportIntoArchiveDelegate
-(void)importIntoArchive: (NSString *) newarchive;
@end
@protocol KORMakeNewListDelegate
-(void)makeNewList: (NSString *) newlist;
@end


@protocol KORSlowRunningDelegate
-(void)assimilationComplete:(BOOL)success;
@end

@protocol KORHomeBaseDelegate
-(void) dismissController;
@end