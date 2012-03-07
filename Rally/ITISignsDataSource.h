//
//  ITISignsDataSource.h
//  Rally
//
//  Created by Henrik Fogelberg on 2012-01-24.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "/usr/include/sqlite3.h"
#import "ITISign.h"
#import "ITIDog.h"
#import "ITIResult.h"
#import "ITISettings.h"
#import "ITILevel.h"
#import "ITISignComment.h"
#import "ITIOrganisation.h"

@interface ITISignsDataSource : NSObject{
    sqlite3 *rallyDb;
    NSString *datasePath;
}

@property (nonatomic, assign) sqlite3 *rallyDb;
@property (nonatomic, retain) NSString *databasePath;

// Signs
- (NSMutableArray *) getSigns;
- (ITISign *) getRandomSign;
- (ITISign *) getNextSign: (int) currentSign;
- (ITISign *) getPreviousSign: (int) currentSign;
- (ITISign *) getFirstSign;
- (ITISign *) getLastSign;

// Dogs
- (NSMutableArray *) getDogs;
- (int) getIdForDog: (NSString *) dogName;
- (void) createDog: (ITIDog *) newDog;
- (void) updateDog: (ITIDog *) changedDog;
- (BOOL) dogNameIsNotUnique: (NSString *) dogName;
- (BOOL) dogHasResults: (int) dogId;
- (void) deleteDog: (int) dogId;
- (void) addDogComment: (ITIDog *) dog;

// Results
- (NSMutableArray *) getResults;
- (void) createResult: (ITIResult *) newResult;
- (void) updateResults: (ITIResult *) changedResult;
- (NSMutableArray *) getResultsForDog: (int) dogId;
- (void) deleteResult: (int) resultId;
- (NSMutableArray *) searchResults: (NSString *) dogName: (NSString *) city;
- (void) saveResultComment: (ITIResult *) result;
- (void) deleteResultsForDog: (int) dogId;

// Settings
- (ITISettings *) getSettings;
- (ITISettings *) getSettingsOverview;
- (void) updateOrganisation: (NSString *) org;
- (void) setFirstRunToNo;

// Levels
- (void) updateLevels: (int) level;
- (NSMutableArray *) getLevelDescriptions;
- (NSMutableArray *) getLevels;

// Comments
- (ITISignComment *) getSignComment: (int) signId;
- (void) createSignComment: (ITISignComment *) comment;
- (void) updateSignComment: (ITISignComment *) comment;
- (void) deleteSignComment: (int) commentId;

// Organisation
- (NSMutableArray *) getOrganisations;

// Generic
- (void) connectToDb;
- (void) create: (NSString *) sqlCreate;
- (void) update: (NSString *) sqlUpdate;
- (void) delete: (NSString *) sqlDelete;
- (NSString *) getStringValue: (NSString *) sqlQuery;
- (BOOL) queryIsTrue: (NSString *) sqlQuery;

@end