//
//  ITISignsDataSource.m
//  Rally
//
//  Created by Henrik Fogelberg on 2012-01-24.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import "ITISignsDataSource.h"

@implementation ITISignsDataSource

// Levels
- (void) updateLevels:(int)level{
    NSString *updateSql = [NSString stringWithFormat: @"UPDATE Settings SET level=%d", level];
    [self update:updateSql];
}

- (NSMutableArray *) getLevels{
    NSMutableArray *levels = [[NSMutableArray alloc] init];
    ITILevel *level;
    
    NSString *selectSql = [NSString stringWithFormat:@"SELECT description, code FROM Levels, Settings WHERE Settings.organisation = Levels.organisation"]; 
    const char *sql = [selectSql UTF8String];
    sqlite3_stmt *sqlStatement;
    ITIAppDelegate *delegate = (ITIAppDelegate*)[[UIApplication sharedApplication]delegate];
    sqlite3 *rallyDb = delegate.rallyDb;
    if(sqlite3_prepare_v2(rallyDb, sql, -1, &sqlStatement, NULL) == SQLITE_OK){                            
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {  
            level = [[ITILevel alloc] init];
            level.description = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 0)];    
            level.code = sqlite3_column_int(sqlStatement, 1);
            [levels addObject:level];
        }    
    }
    return levels;
}

- (NSMutableArray *) getLevelDescriptions{
    NSMutableArray *levels = [[NSMutableArray alloc] init];
    NSString *description;
    
    const char *sql = "SELECT description FROM Levels, Settings WHERE Levels.organisation = Settings.organisation";
    sqlite3_stmt *sqlStatement;
    ITIAppDelegate *delegate = (ITIAppDelegate*)[[UIApplication sharedApplication]delegate];
    sqlite3 *rallyDb = delegate.rallyDb;
    if(sqlite3_prepare_v2(rallyDb, sql, -1, &sqlStatement, NULL) == SQLITE_OK){
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {  
            description = [[NSString alloc] init];
            description = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 0)];    
            [levels addObject:description];
        }    
    }
    return levels;
}

- (int)getLevelCodeForDescription:(NSString *)description{
    int code;
    code = 0;
      
    NSString *sqlQuery = [NSString stringWithFormat:@ "SELECT code FROM Levels, Settings WHERE Levels.organisation = Settings.organisation AND Levels.description LIKE \"%@\"", description];
    const char *sql = [sqlQuery UTF8String];
    sqlite3_stmt *sqlStatement;
    ITIAppDelegate *delegate = (ITIAppDelegate*)[[UIApplication sharedApplication]delegate];
    sqlite3 *rallyDb = delegate.rallyDb;
    if(sqlite3_prepare_v2(rallyDb, sql, -1, &sqlStatement, NULL) == SQLITE_OK){            
         while (sqlite3_step(sqlStatement)==SQLITE_ROW) {  
             code = sqlite3_column_int(sqlStatement, 0);
         }    
     }
    
    return code;
}


// Settings
- (ITISettings *) getSettings{
    ITISettings *settings  = [[ITISettings alloc] init];
       
    const char *sql = "SELECT Levels.description, Levels.code, organisation, firstRun FROM Settings, Languages, Levels WHERE Settings.languageCode = Languages.code AND Settings.level = Levels.code AND Settings.languageCode = Levels.languageCode";
    sqlite3_stmt *sqlStatement;
    ITIAppDelegate *delegate = (ITIAppDelegate*)[[UIApplication sharedApplication]delegate];
    sqlite3 *rallyDb = delegate.rallyDb;
    if(sqlite3_prepare_v2(rallyDb, sql, -1, &sqlStatement, NULL) == SQLITE_OK){
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {  
            settings.levelDescription = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 0)];
            settings.levelCode = sqlite3_column_int(sqlStatement, 1);
            settings.organisation = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 2)];   
            settings.isFirstRun = sqlite3_column_int(sqlStatement, 3);
        }    
    }
    return settings;
}

- (ITISettings *)getSettingsOverview{
    ITISettings *settings  = [[ITISettings alloc] init];;
    
    ITIAppDelegate *delegate = (ITIAppDelegate*)[[UIApplication sharedApplication]delegate];
    sqlite3 *rallyDb = delegate.rallyDb;
         //Settings
         const char *sql = "SELECT organisation, level, firstRun, version FROM Settings";
         sqlite3_stmt *sqlStatement;
         if(sqlite3_prepare_v2(rallyDb, sql, -1, &sqlStatement, NULL) == SQLITE_OK){
         while (sqlite3_step(sqlStatement)==SQLITE_ROW) {  
             settings.organisation = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 0)];
             settings.levelCode = sqlite3_column_int(sqlStatement, 1);
             settings.isFirstRun = sqlite3_column_int(sqlStatement, 2);      
             //settings.version = sqlite3_column_decltype(sqlStatement, 3);
            }
         }
         
         //Level
         const char *sqlLevel = "select Levels.code, description from Levels, Settings WHERE Levels.code = Settings.level AND Levels.organisation = Settings.organisation";
         sqlite3_stmt *sqlLevelStatement;
         sqlite3_prepare_v2(rallyDb, sqlLevel, -1, &sqlLevelStatement, NULL);
         while (sqlite3_step(sqlLevelStatement)==SQLITE_ROW) {  
             settings.levelCode = sqlite3_column_int(sqlLevelStatement, 0); 
             settings.levelDescription = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlLevelStatement, 1)];   
         }

    return settings;
}

-(void)setFirstRunToNo{
    NSString *updateSql = @"UPDATE Settings SET firstRun = 0";
    [self update:updateSql];
}


// Signs
- (ITISign *)getNextSign:(int)currentSign{
    ITISign *sign;
    NSString *sql =  [ NSString stringWithFormat:@"SELECT Signs.id, header, body, thumb, imageOrderId, signFile FROM Signs, Settings WHERE Signs.level=Settings.level AND Signs.organisation=Settings.organisation AND Signs.imageOrderId>%d ORDER BY Signs.imageOrderId LIMIT 1", currentSign];
    sign = [self getSignBase:sql];
    if (sign == nil)
        sign =[self getFirstSign];
    return sign;
}


- (ITISign *)getPreviousSign:(int)currentSign{
    ITISign *sign;
    NSString *sql =  [ NSString stringWithFormat:@"SELECT Signs.id, header, body, thumb, imageOrderId, signFile FROM Signs, Settings WHERE Signs.level=Settings.level AND Signs.organisation=Settings.organisation AND Signs.imageOrderId<%d ORDER BY Signs.imageOrderId DESC LIMIT 1", currentSign];
    sign = [self getSignBase:sql];
    if(sign == Nil)
        sign = [self getLastSign];
    return sign;
}

- (ITISign *)getFirstSign{
    NSString *sql = @"SELECT Signs.id, header, body, thumb, imageOrderId, signFile FROM Signs, Settings WHERE Signs.level=Settings.level AND Signs.organisation=Settings.organisation AND Signs.imageOrderId >= (SELECT MIN(imageOrderId) FROM Signs WHERE Signs.level = Settings.level AND Signs.organisation = Settings.organisation) ORDER BY Signs.imageOrderId LIMIT 1";
    return [self getSignBase:sql];
}

- (ITISign *)getLastSign{
    NSString *sql = @"SELECT Signs.id, header, body, thumb, imageOrderId, signFile FROM Signs, Settings WHERE Signs.level=Settings.level AND Signs.organisation=Settings.organisation AND Signs.imageOrderId <= (SELECT MAX(imageOrderId) FROM Signs WHERE Signs.level = Settings.level AND Signs.organisation = Settings.organisation) ORDER BY Signs.imageOrderId DESC LIMIT 1";
    return [self getSignBase:sql];
}


- (ITISign *) getRandomSign{
    NSString *sql = @"SELECT id, header, body,  thumb, imageOrderId, signFile FROM signs WHERE level <= (SELECT level FROM Settings) AND organisation = (SELECT organisation FROM Settings) ORDER BY RANDOM() LIMIT 1";
    return [self getSignBase:sql];
}

- (NSMutableArray *) getSigns{
    ITISign *sign;
    NSMutableArray *signs = [[NSMutableArray alloc] init];    
           
    const char *sql = "SELECT Signs.id, header, body, thumb, imageOrderId, signFile FROM Signs, Settings WHERE Signs.organisation = Settings.organisation AND Signs.level = Settings.level ORDER By imageOrderId";
    sqlite3_stmt *sqlStatement;
    
    ITIAppDelegate *delegate = (ITIAppDelegate*)[[UIApplication sharedApplication]delegate];
    sqlite3 *rallyDb = delegate.rallyDb;
    
    if(sqlite3_prepare_v2(rallyDb, sql, -1, &sqlStatement, NULL) == SQLITE_OK)
    {   
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
            sign = [[ITISign alloc] init];    
            sign.id = sqlite3_column_int(sqlStatement, 0);
            sign.header = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 1)];
            sign.body = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 2)];                
            sign.thumb = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(sqlStatement, 3)];
            sign.imageOrderId = sqlite3_column_int(sqlStatement, 4);
            sign.signFile = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(sqlStatement, 5)];
            [signs addObject:sign];
        }
    }

    return signs;
}

- (ITISign *)getSignBase:(NSString *)querySql{
    ITISign *sign;
       
    const char *sql = [querySql UTF8String];
    sqlite3_stmt *sqlStatement;
    ITIAppDelegate *delegate = (ITIAppDelegate*)[[UIApplication sharedApplication]delegate];
    sqlite3 *rallyDb = delegate.rallyDb;
    if(sqlite3_prepare_v2(rallyDb, sql, -1, &sqlStatement, NULL) == SQLITE_OK){   
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
            sign = [[ITISign alloc] init];    
            sign.id = sqlite3_column_int(sqlStatement, 0);
            sign.header = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 1)];
            sign.body = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 2)];       
            sign.thumb = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(sqlStatement, 3)];
            sign.imageOrderId = sqlite3_column_int(sqlStatement, 4);
            sign.signFile = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(sqlStatement, 5)];
        }
    } else{ 
        NSLog(@"Problem with prepare statement");
    }
    return sign;
}

// Dog
- (void)deleteDogComment:(int)dogId{
    NSString *updateSql = [NSString stringWithFormat:@"UPDATE Dogs Set comment = \" \" WHERE id=%d", dogId];
    [self delete:updateSql];
}

- (ITIDog *)getDogById:(int)dogId{    
    ITIDog *dog; 
    
    NSString  *selectSql = [NSString stringWithFormat:@"SELECT name, breed, is_male, dob, comment, id, height FROM Dogs WHERE id = %d", dogId];
    const char *sql = [selectSql UTF8String];
    sqlite3_stmt *sqlStatement;
    
    ITIAppDelegate *delegate = (ITIAppDelegate*)[[UIApplication sharedApplication]delegate];
    sqlite3 *rallyDb = delegate.rallyDb;
    
    if(sqlite3_prepare_v2(rallyDb, sql, -1, &sqlStatement, NULL) == SQLITE_OK){
         while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
             dog = [[ITIDog alloc] init];
             dog.name = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 0)];
             dog.breed = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 1)];
             dog.isMale = sqlite3_column_int(sqlStatement, 2);
             dog.dob = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 3)];
             dog.comment = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 4)];
             dog.id = sqlite3_column_int(sqlStatement, 5);
             dog.height = sqlite3_column_int(sqlStatement, 6);
         }
     }

    return dog;
}

-(void)saveDogComment: (int) dogId :(NSString *)comment{
    NSString *updateSql = [NSString stringWithFormat:@"UPDATE Dogs SET comment = \"%@\" WHERE id=%d", comment, dogId];
    [self update:updateSql];
}

- (BOOL)dogHasComment:(int)dogId{
    BOOL hasComment = NO;
    
    NSString *selectSql = [NSString stringWithFormat:@"SELECT comment FROM Dogs WHERE id = %d", dogId];
    const char *sql = [selectSql UTF8String];
    sqlite3_stmt *sqlStatement;
    
    ITIAppDelegate *delegate = (ITIAppDelegate*)[[UIApplication sharedApplication]delegate];
    sqlite3 *rallyDb = delegate.rallyDb;
    
    if(sqlite3_prepare(rallyDb, sql, -1, &sqlStatement, NULL) == SQLITE_OK){
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
            NSString *comment = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 0)];
            NSString *trimmedComment = [comment stringByTrimmingCharactersInSet:
                                        [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if([trimmedComment length]>0) 
                hasComment = YES;
        }
    }
    
    return hasComment;   
}

- (void)addDogComment:(ITIDog *)dog{
    NSString *updateSql = [NSString stringWithFormat:@"UPDATE Dogs SET comment = \"%@\" WHERE id=%d", dog.comment, dog.id];
    [self update:updateSql];
    
}

- (void) updateDog: (ITIDog *) changedDog{
    NSString *updateSql = [NSString stringWithFormat: @"UPDATE Dogs SET breed=\"%@\", is_male=%d, dob=\"%@\", height=%d WHERE id=%d", changedDog.breed, changedDog.isMale, changedDog.dob, changedDog.height, changedDog.id];
    [self update:updateSql];
}

- (void) createDog: (ITIDog *) newDog{
    NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO Dogs(name, breed, is_male, dob, comment, height) values(\"%@\", \"%@\", %d, \"%@\", \"%@\", %d)", newDog.name, newDog.breed, newDog.isMale, newDog.dob, newDog.comment, newDog.height];     
    [self create:insertSQL];
}

- (NSMutableArray *) getDogs{
    NSMutableArray *dogs = [[NSMutableArray alloc] init];
    ITIDog *dog;
    sqlite3_stmt *sqlStatement;
    
    ITIAppDelegate *delegate = (ITIAppDelegate*)[[UIApplication sharedApplication]delegate];
    sqlite3 *rallyDb = delegate.rallyDb;
    const char *sql = "SELECT name, breed, is_male, dob, comment, id, height FROM Dogs ORDER BY name";
    
    if(sqlite3_prepare_v2(rallyDb, sql, -1, &sqlStatement, NULL) == SQLITE_OK){
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
            dog = [[ITIDog alloc] init];
            dog.name = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 0)];
            dog.breed = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 1)];
            dog.isMale = sqlite3_column_int(sqlStatement, 2);
            dog.dob = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 3)];
            dog.comment = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 4)];
            dog.id = sqlite3_column_int(sqlStatement, 5);
            dog.height = sqlite3_column_int(sqlStatement, 6);
            [dogs addObject:dog];
        }
    }
    
    return dogs;
}

- (void)deleteDog:(int)dogId{
    [self deleteResultsForDog:dogId];
    NSString *deleteSql =[NSString stringWithFormat:@"DELETE FROM Dogs WHERE id=%d", dogId];
    [self delete:deleteSql];
}

// Return True if the dog name is unique.
- (BOOL) dogNameIsNotUnique:(NSString *)dogName{
    NSString *selectSql =  [ NSString stringWithFormat:@"SELECT id FROM Dogs WHERE name=\"%@\"", dogName];
    return [self queryIsTrue:selectSql];
}

- (BOOL)dogHasResults:(int)dogId{
    NSString *sqlQuery = [NSString stringWithFormat:@"SELECT * FROM Results WHERE dog_id = %d", dogId];
    return [self queryIsTrue:sqlQuery];
}

// Result
-(void)deleteResultsForDog:(int)dogId{
    NSString *deleteSql = [NSString stringWithFormat:@"DELETE FROM Results WHERE dog_id = %d", dogId];
    [self delete:deleteSql];
}

- (void) deleteResultComment:(int)resultId{
    NSString *updateSql = [NSString stringWithFormat:@"UPDATE Results SET comment = \" \" WHERE id=%d", resultId];
    [self update:updateSql];
}

- (NSString *)getResultComment:(int)resultId{
    NSString *comment = [[NSString alloc] init];
    sqlite3_stmt *sqlStatement;
    
    NSString *selectSQL  = [NSString stringWithFormat:@"SELECT comment FROM Results WHERE id = %d", resultId];
    const char *sql = [selectSQL UTF8String];
    ITIAppDelegate *delegate = (ITIAppDelegate*)[[UIApplication sharedApplication]delegate];
    if(sqlite3_prepare_v2(delegate.rallyDb, sql, -1, &sqlStatement, NULL) == SQLITE_OK){
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
            comment = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 0)];
        }
    }
    
    return comment;
}

- (BOOL)resultHasComment:(int)resultId{
    BOOL hasComment = NO;
    sqlite3_stmt *sqlStatement;
    
    ITIAppDelegate *delegate = (ITIAppDelegate*)[[UIApplication sharedApplication]delegate];
    sqlite3 *rallyDb = delegate.rallyDb;        
    NSString *selectSQL  = [NSString stringWithFormat:@"SELECT comment FROM Results WHERE id = %d", resultId];
        const char *sql = [selectSQL UTF8String];
    
    if(sqlite3_prepare_v2(rallyDb, sql, -1, &sqlStatement, NULL) == SQLITE_OK){    
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
            NSString *comment = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 0)];
            NSString *trimmedComment = [comment stringByTrimmingCharactersInSet:
                                        [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if([trimmedComment length]>0) 
                hasComment = YES;
        }
    }
    
    return hasComment;
}

- (void) updateResults: (ITIResult *) changedResult{
    NSString *updateSQL = [NSString stringWithFormat: @"UPDATE Results SET place = \"%@\", event_date=\"%@\", is_competition=%d, level=%d, result=%d, dog_id=%d, position=%d, event = \"%@\", club = \"%@\" WHERE id=%d", changedResult.place, changedResult.event_date, changedResult.is_competition, changedResult.level, changedResult.points, changedResult.dog_id, changedResult.position,  changedResult.event, changedResult.club, changedResult.id]; 
    [self update:updateSQL];
}

- (void) createResult: (ITIResult *) newResult{
    if([newResult.place length] == 0){
        newResult.place = @" ";
    }
    if([newResult.comment length] == 0){
        newResult.comment = @" ";
    }
    
    NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO Results(place, event_date, is_competition, level, comment, result, dog_id, position, club, event) values(\"%@\", \"%@\", %d, %d, \"%@\", %d, %d, %d, \"%@\", \"%@\")", newResult.place, newResult.event_date, newResult.is_competition, newResult.level, newResult.comment, newResult.points, newResult.dog_id, newResult.position, newResult.club, newResult.event]; 
    [self create:insertSQL];
}

- (NSMutableArray *)searchResults:(NSString *)searchParams :(int) dogId{
    NSMutableArray *results;
    NSString *sql;
    NSString *param;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];    NSString *queryParam = [[NSString alloc] init];
    NSArray *params = [searchParams componentsSeparatedByString: @" "];            
   
    if(dogId>0)
        queryParam = [queryParam stringByAppendingFormat:@" AND Dogs.id = %d", dogId];
    
    // 1. First figure out what the various search params are,    
    for(int i=0;i<[params count];i++){
        NSString *paramsBase = @"SELECT * FROM Results, Dogs WHERE Results.Dog_id = Dogs.id ";
        if(dogId>0)
            paramsBase = [paramsBase stringByAppendingFormat:@" AND Dogs.id = %d", dogId];
        
        param = [params objectAtIndex:i];
         
        // Check if it isn't a numeric value
        NSNumber *number = [numberFormatter numberFromString:param];
        if(number==nil){
            // No. Let's figure out what it is 

            // Dog
            sql = [paramsBase stringByAppendingFormat:@" AND Dogs.name LIKE '%%%@%%'", param];            
            NSMutableArray *dogs = [self doResultSearch:sql];
            if([dogs count] > 0) 
                queryParam = [queryParam stringByAppendingFormat:@" AND Dogs.name  LIKE '%%%@%%'", param];   
        
            // City
            sql = [paramsBase stringByAppendingFormat:@" AND place LIKE '%%%@%%'", param];            
            NSMutableArray *cities = [self doResultSearch:sql];
            if([cities count] > 0) 
                queryParam = [queryParam stringByAppendingFormat:@" AND place LIKE '%%%@%%'", param];   
            
            // Dog comment 
            sql = [paramsBase stringByAppendingFormat:@" AND Dogs.comment LIKE '%%%@%%'", param];            
            NSMutableArray *dogComments = [self doResultSearch:sql];
            if([dogComments count] > 0) 
                queryParam = [queryParam stringByAppendingFormat:@" AND Dogs.comment LIKE '%%%@%%'", param];   
            
            // Result comment
            sql = [paramsBase stringByAppendingFormat:@" AND Results.comment LIKE '%%%@%%'", param];            
            NSMutableArray *resultComments = [self doResultSearch:sql];
            if([resultComments count] > 0) 
                queryParam = [queryParam stringByAppendingFormat:@" AND Results.comment LIKE '%%%@%%'", param];   
            
            // Club
            sql = [paramsBase stringByAppendingFormat:@" AND Results.club LIKE '%%%@%%'", param];            
            NSMutableArray *clubs = [self doResultSearch:sql];
            if([clubs count] > 0) 
                queryParam = [queryParam stringByAppendingFormat:@" AND club LIKE '%%%@%%'", param];   
            
            // Event name
            sql = [paramsBase stringByAppendingFormat:@" AND Results.event LIKE '%%%@%%'", param];            
            NSMutableArray *events = [self doResultSearch:sql];
            if([events count] > 0) 
                queryParam = [queryParam stringByAppendingFormat:@" AND Results.event LIKE '%%%@%%'", param];   
            
            // Level
            int levelId = [self getLevelCodeForDescription:param];
            if(levelId>0)
                queryParam = [queryParam stringByAppendingFormat:@" AND Results.level = %d", levelId];            
        }
    }
    
    // 2. Perform the actual search
    if([queryParam length]>0){
        NSString *sqlQuery = [NSString stringWithFormat:@"SELECT place, event_date, is_competition, level, Results.comment, result, name, dog_id, Results.id, position, club, event FROM Results, Dogs WHERE Results.dog_id = Dogs.id %@", queryParam];
        results = [self doResultSearch:sqlQuery];
    }
    
    return results;
}



- (NSMutableArray *) getResults{
    NSString *searchSql = @"SELECT place, event_date, is_competition, level, Results.comment, result, name, dog_id, Results.id, position, club, event FROM Results, Dogs WHERE Results.Dog_id = Dogs.id ORDER by event_date DESC";
    return [self doResultSearch:searchSql];
}

- (NSMutableArray *)doResultSearch:(NSString *)searchSql{
    NSMutableArray *results = [[NSMutableArray alloc] init];
    sqlite3_stmt *sqlStatement;
    
    ITIAppDelegate *delegate = (ITIAppDelegate*)[[UIApplication sharedApplication]delegate];
    sqlite3 *rallyDb = delegate.rallyDb;
    
    const char * sql = [searchSql UTF8String];
    if(sqlite3_prepare_v2(rallyDb, sql, -1, &sqlStatement, NULL) == SQLITE_OK){
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
            ITIResult *result = [[ITIResult alloc] init];
            
            result.place = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 0)];
            result.event_date = [NSString stringWithUTF8String: (char *)sqlite3_column_text(sqlStatement,1)];
            result.is_competition = sqlite3_column_int(sqlStatement, 2);
            result.level = sqlite3_column_int(sqlStatement, 3);
            result.comment = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 4)];
            result.points = sqlite3_column_int(sqlStatement, 5);
            result.dog_name= [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 6)];
            result.dog_id = sqlite3_column_int(sqlStatement, 7);
            result.id = sqlite3_column_int(sqlStatement, 8);
            result.position = sqlite3_column_int(sqlStatement, 9);
            result.club = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 10)];
            result.event = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 11)];
            
            [results addObject:result];
        }
    }

    return results;
}

- (void)deleteResult:(int)resultId{
    NSString *deletSQL = [NSString stringWithFormat: @"DELETE FROM Results WHERE id = %d ", resultId]; 
    [self delete:deletSQL];       
}

- (NSMutableArray *)getResultsForDog:(int)dogId{
    NSString *querySQL = [NSString stringWithFormat:@"SELECT place, event_date, is_competition, level, Results.comment, result, name, dog_id, Results.id, position, Results.club, event  FROM Results, Dogs WHERE Results.Dog_id = Dogs.id AND Dogs.id = %d ORDER by Results.Dog_id, event_date DESC", dogId];
    return [self doResultSearch:querySQL];
}

- (void)saveResultComment:(NSString *)resultComment :(int) resultId{
    NSString *updateSql = [NSString stringWithFormat:@"UPDATE Results SET comment = \"%@\" WHERE id=%d", resultComment, resultId];
    [self update:updateSql];
}


// Sign comment
- (void)createSignComment:(ITISignComment *)comment{
    NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO SignsComment(signs_id, description) values(%d, \"%@\")", comment.sign_id, comment.body]; 
    [self create:insertSQL];
}

- (ITISignComment *)getSignComment:(int)signId{
    ITISignComment *comment;
    sqlite3_stmt *sqlStatement;
    ITIAppDelegate *delegate = (ITIAppDelegate*)[[UIApplication sharedApplication]delegate];
    sqlite3 *rallyDb = delegate.rallyDb;
    NSString *querySQL = [NSString stringWithFormat:@"SELECT description, id, signs_id FROM SignsComment WHERE signs_id = %d", signId];
    const char *sql = [querySQL UTF8String];
    
    if(sqlite3_prepare_v2(rallyDb, sql, -1, &sqlStatement, NULL) == SQLITE_OK){
         while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
             comment = [[ITISignComment alloc]init];
             comment.body = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 0)];
             comment.id = sqlite3_column_int(sqlStatement, 1);
             comment.sign_id = sqlite3_column_int(sqlStatement, 2);
             
         }
     }
    
    return comment;
}

-(void)updateSignComment:(ITISignComment *)comment{
    NSString *updateSQL = [NSString stringWithFormat: @"UPDATE SignsComment SET description = \"%@\" WHERE id=%d", comment.body, comment.id];
    [self update:updateSQL];
}

- (void)deleteSignComment:(int)commentId{
    NSString *deleteSQL = [NSString stringWithFormat: @"DELETE FROM SignsComment WHERE id = %d ", commentId]; 
    [self delete:deleteSQL];
}

- (NSMutableArray *)getOrganisations{
    NSMutableArray *organisations = [[NSMutableArray alloc] init];
    ITIOrganisation *organisation;
    sqlite3_stmt *sqlStatement;
    const char *sql = "SELECT Organisations.id, code FROM Organisations ORDER BY code";
    ITIAppDelegate *delegate = (ITIAppDelegate*)[[UIApplication sharedApplication]delegate];
    sqlite3 *rallyDb = delegate.rallyDb;
    
    if(sqlite3_prepare_v2(rallyDb, sql, -1, &sqlStatement, NULL) == SQLITE_OK){        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
            organisation = [[ITIOrganisation alloc] init];
            organisation.id = sqlite3_column_int(sqlStatement, 0);
            organisation.code = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 1)];
            [organisations addObject:organisation];
        }
    }
    return organisations;
}

- (void)updateOrganisation:(NSString *)org{
    NSString *updateSql = [NSString stringWithFormat:@"UPDATE Settings SET organisation = \"%@\"", org];
    [self update:updateSql];
}

// Generic

- (BOOL)queryIsTrue:(NSString *)sqlQuery{
    BOOL retVal = NO;
    
    sqlite3_stmt *sqlStatement;
    ITIAppDelegate *delegate = (ITIAppDelegate*)[[UIApplication sharedApplication]delegate];
    sqlite3 *rallyDb = delegate.rallyDb;
    const char *sql = [sqlQuery UTF8String];
    if(sqlite3_prepare_v2(rallyDb, sql, -1, &sqlStatement, NULL) == SQLITE_OK){
         while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
             retVal = YES;
         }
     }
    
    return retVal;
}

- (NSString *)getStringValue:(NSString *)sqlQuery{
    NSString *ret;
    sqlite3_stmt *sqlStatement;
    ITIAppDelegate *delegate = (ITIAppDelegate*)[[UIApplication sharedApplication]delegate];
    sqlite3 *rallyDb = delegate.rallyDb;
    const char *sql = [sqlQuery UTF8String];
    
    if(sqlite3_prepare_v2(rallyDb, sql, -1, &sqlStatement, NULL) == SQLITE_OK){        
        while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
            ret = [[NSString alloc] init];
            ret = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 0)];
        }
    }
    
    return ret;
}

- (void)create:(NSString *)sqlCreate{        
    ITIAppDelegate *delegate = (ITIAppDelegate*)[[UIApplication sharedApplication]delegate];
    sqlite3 *rallyDb = delegate.rallyDb;
    const char *sql = [sqlCreate UTF8String];
    sqlite3_stmt  *statement;
    if(sqlite3_prepare_v2(rallyDb, sql, -1, &statement, NULL) == SQLITE_OK){        
        sqlite3_step(statement);
        sqlite3_finalize(statement);
    }
}

- (void)update:(NSString *)sqlUpdate{
     
    ITIAppDelegate *delegate = (ITIAppDelegate*)[[UIApplication sharedApplication]delegate];
    sqlite3 *rallyDb = delegate.rallyDb;
    const char *sql = [sqlUpdate UTF8String];
    sqlite3_stmt  *statement;
    if(sqlite3_prepare_v2(rallyDb, sql, -1, &statement, NULL) == SQLITE_OK){        
        sqlite3_step(statement);
        sqlite3_finalize(statement);
    }
}

- (void)delete:(NSString *)sqlDelete{
    @try {
    ITIAppDelegate *delegate = (ITIAppDelegate*)[[UIApplication sharedApplication]delegate];
    sqlite3 *rallyDb = delegate.rallyDb;
    const char *sql = [sqlDelete UTF8String];
    sqlite3_stmt  *statement;
    if(sqlite3_prepare_v2(rallyDb, sql, -1, &statement, NULL) == SQLITE_OK){        
        sqlite3_step(statement);
        sqlite3_finalize(statement);
    }
    }
    @catch (NSException *exception) {
        NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
    }
}

@end
