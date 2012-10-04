//
//  KORMetronomePrefsController.h
//  MasterApp
//
//  Created by william donner on 10/28/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "KORAbsTableAdminController.h"
#import "KORMetronomeViewControl.h"

@interface KORMetronomePrefsController : KORAbsTableAdminController


- (id) initWithMetronomeControl :(KORMetronomeViewControl *)kasp title:(NSString *) tune;

@end
