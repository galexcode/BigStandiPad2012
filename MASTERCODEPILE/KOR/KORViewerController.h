//
//  KORViewerController.h
//  MusicStand
//
//  Created by bill donner on 10/8/11.
//  Copyright 2011 Bill Donner and ShovelReadyApps All rights reserved.
//
// much of the support code for this controller is in the OneTuneCategories.h 

#import "KORAbsViewController.h"
#import "KORMenuController.h"
#import "KORMultiProtocol.h"
#import "KORListChooserControl.h"
#import "InstanceInfo.h"
#import <MessageUI/MFMailComposeViewController.h>

@class KORAutoScrollViewControl,KORMetronomeViewControl;
@class KORMainWebView,KORMenuController,KORActionSheet;

typedef void(^KORTuneControllerDismissedCompletionBlock)(void);



@interface KORViewerController : KORAbsViewController  <
UIAppearanceContainer,  
UIPopoverControllerDelegate,
UINavigationControllerDelegate, 
UIImagePickerControllerDelegate,
UIWebViewDelegate,
KORItemChosenDelegate, 
KORArchiveChosenDelegate,
KORListChooserDelegate,
KORSetlistChosenDelegate,
KORTuneControllerDismissedDelegate, 
KORTrampolineDelegate, 
KORTrampolineOneArgDelegate, 
KORMakeNewListDelegate,
KORImportIntoArchiveDelegate,
KORSlowRunningDelegate,
UIGestureRecognizerDelegate,
MFMailComposeViewControllerDelegate,
UIPrintInteractionControllerDelegate
>


	// these are brought out so they can be manipulated in various categories
@property (nonatomic,retain) KORActionSheet  *rightActionSheet;
@property (nonatomic,retain) KORActionSheet  *leftActionSheet;


@property (nonatomic,retain) NSArray *listItems;
@property (nonatomic,retain) NSArray *listIncoming;
@property (nonatomic,retain) NSString *listKind;
@property (nonatomic,retain) NSString *listName;
@property (nonatomic,retain) NSString *currentTuneTitle;
@property (nonatomic) NSInteger	currentListPosition;


@property (nonatomic,retain) KORMenuController *menuController,*altmenuController;
@property (nonatomic,retain) UIPopoverController *popoverController;
@property (nonatomic,retain) UIPopoverController *photoPopOverController;
@property (nonatomic,retain) UIToolbar *footerToolbarView;
@property (nonatomic,retain) UIToolbar *headerToolbarView; //now a standin
@property (nonatomic,retain) NSString *variantChooserText ;
@property (nonatomic,retain) NSArray *variantItems;
@property (nonatomic,retain) NSString *archivePathForFile;
@property (nonatomic,retain) NSString *archive;
@property (nonatomic,retain) UIView *infoOverlayXib;

@property (nonatomic,retain) UIWebView *infoWebView;

	// tune property sheet support
@property (nonatomic,retain) UIView *propsOverlayXib;

@property (nonatomic) BOOL	first;
@property (nonatomic) BOOL	pushedToWebBrowser;
@property (nonatomic) BOOL	flipFlop;
@property (nonatomic) BOOL	canPlay;
@property (nonatomic) BOOL	fullScreen;
@property (nonatomic) BOOL	skipRotate;
@property (nonatomic) BOOL	toggleEnabledState;
@property (nonatomic) BOOL	prevToggleEnabledState;

@property (nonatomic,retain) UIColor *tintColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, copy) KORTuneControllerDismissedCompletionBlock buttonCompletionBlock; 
@property (nonatomic, retain) UISwipeGestureRecognizer *rsGestureRecog;
@property (nonatomic, retain) UISwipeGestureRecognizer *lsGestureRecog;
@property (nonatomic, retain) UITapGestureRecognizer *fsGestureRecog;
	//

@property (nonatomic,retain) NSTimer *snapshotTimer;

@property (nonatomic) CGRect contentFrame;
@property (nonatomic) BOOL clumpIsShowing;

@property (nonatomic) BOOL firstFooter; // needs special handling
@property (nonatomic,retain) KORMainWebView *mainWebView;// needs more

@property (nonatomic) NSUInteger currentVariantPosition;


@property (nonatomic,retain) NSTimer *fullScreenFadeoutTimer;


	// autoscroll support - separate category for brevity
@property (nonatomic,retain) NSTimer *autoscrollTimer;

@property (nonatomic,retain ) KORAutoScrollViewControl *autoscrollControl;

-(void) scrollwebview:(NSUInteger) pixels;

	// metronome support - separate category for brevity
@property (nonatomic,retain) KORMetronomeViewControl *metronomeControl;
@property (nonatomic,retain) UITapGestureRecognizer  *bottomPressGestureRecognizer;

@property (nonatomic, assign) id<KORTuneControllerDismissedDelegate> delegate;

@property (nonatomic,retain) KORListChooserControl   *setListChooserControl;


@property (nonatomic,retain) KORActionSheet  *toass;

-(void) setupGestureRecognizers;

-(void) rewindTune;
-(void) fastforwardTune;


-(void) startFadeoutTimer;

-(void) displayTuneByTitle: (NSString *)titlex;

-(void) displayTuneByInstance:(InstanceInfo *)ii;

-(void)loadPrefsForCurrentTune;

-(NSString *) onoffLabel:(BOOL) b;

-(void) makeOneTuneView;

-(void) toggleFullScreen: (id)abt;
-(void) toggleFullRestartFadeout: (id)abt;
-(void) presentErrorScreen: (NSString *) title  arg1:(NSString *)arg1 arg2:(NSString *)arg2 arg3:(NSString *)arg3;

-(BOOL) isPath:(NSString *)s filteredBy:(NSString *)filter;
-(void) invalidateSnapshotTimer;
-(void) startSnapshotTimer;
-(KORViewerController *) initWithURL:(NSURL *)URL andWithTitle:(NSString *) titlex andWithItems:(NSArray *)items;

- (void) presentMenuWithFilter:(NSString *) filter 
						 style:(NSUInteger) mode 
			   backgroundColor:(UIColor *) bgColor 
					titleColor:(UIColor *) tcColor 
		  titleBackgroundColor:(UIColor *) tcbColor 
					 textColor:(UIColor *) txColor
		   textBackgroundColor:(UIColor *) txbColor
				 thumbnailSize:(NSUInteger) thumbsize 
			   imageBorderSize:(NSUInteger) imageborderSize 
				   columnCount:(NSUInteger) columnCount  
					   tagBase:(NSUInteger) base 
					  menuName:(NSString *) name 
					 menuTitle:(NSString *) title 
					  fromRect:(CGRect) presentingRect;

-(void) presentListController:(NSString *) s;

-(void) dismissOTCController;
-(void) trampoline:(NSUInteger) commandtag; 

-(void) trampolineOneArg:(NSUInteger) commandtag arg:(id)obj; 
@end