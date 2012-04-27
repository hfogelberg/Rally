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
#import "ITIAppDelegate.h"

@interface ITISignsDataSource : NSObject

// Signs
- (NSMutableArray *) getSigns;
- (ITISign *) getRandomSign;
- (ITISign *) getNextSign: (int) currentSign;
- (ITISign *) getPreviousSign: (int) currentSign;
- (ITISign *) getFirstSign;
- (ITISign *) getLastSign;
- (ITISign *) getSignBase: (NSString *) querySql;

// Dogs
- (NSMutableArray *) getDogs;
- (int) getIdForDog: (NSString *) dogName;
- (void) createDog: (ITIDog *) newDog;
- (void) updateDog: (ITIDog *) changedDog;
- (BOOL) dogNameIsNotUnique: (NSString *) dogName;
- (BOOL) dogHasResults: (int) dogId;
- (void) deleteDog: (int) dogId;
- (void) addDogComment: (ITIDog *) dog;
- (BOOL) dogHasComment: (int) dogId;
- (ITIDog *) getDogById: (int) dogId;
- (void) saveDogComment: (int) dogId :(NSString *)comment;
- (void) deleteDogComment: (int) dogId;

// Results
- (NSMutableArray *) getResults;
- (NSMutableArray *) getResultsForDog: (int) dogId;
- (NSMutableArray *) searchResults: (NSString *) searchParams :(int) dogId;
- (NSMutableArray *) doResultSearch: (NSString *) searchParams;
- (void) createResult: (ITIResult *) newResult;
- (void) updateResults: (ITIResult *) changedResult;
- (void) deleteResult: (int) resultId;
- (void) saveResultComment: (NSString *) commentText :(int) resultId;
- (void) deleteResultsForDog: (int) dogId;
- (BOOL) resultHasComment: (int) resultId;
- (void) deleteResultComment: (int)resultId;
- (NSString *) getResultComment: (int)resultId;

// Settings
- (ITISettings *) getSettings;
- (ITISettings *) getSettingsOverview;
- (void) updateOrganisation: (NSString *) org;
- (void) setFirstRunToNo;
- (void) updateVersionTo101;

// Levels
- (void) updateLevels: (int) level;
- (NSMutableArray *) getLevelDescriptions;
- (NSMutableArray *) getLevels;
- (int) getLevelCodeForDescription: (NSString *) description;

// Comments
- (ITISignComment *) getSignComment: (int) signId;
- (void) createSignComment: (ITISignComment *) comment;
- (void) updateSignComment: (ITISignComment *) comment;
- (void) deleteSignComment: (int) commentId;

// Organisation
- (NSMutableArray *) getOrganisations;

// Generic
- (void) create: (NSString *) sqlCreate;
- (void) update: (NSString *) sqlUpdate;
- (void) delete: (NSString *) sqlDelete;
- (NSString *) getStringValue: (NSString *) sqlQuery;
- (BOOL) queryIsTrue: (NSString *) sqlQuery;

@end
