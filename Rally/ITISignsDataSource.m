//
//  ITISignsDataSource.m
//  Rally
//
//  Created by Henrik Fogelberg on 2012-01-24.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import "ITISignsDataSource.h"

@implementation ITISignsDataSource

@synthesize rallyDb;
@synthesize databasePath;

// Levels
- (void) updateLevels:(int)level{
    NSString *updateSql = [NSString stringWithFormat: @"UPDATE Settings SET level=%d", level];
    [self update:updateSql];
}

- (NSMutableArray *) getLevels{
    NSMutableArray *levels = [[NSMutableArray alloc] init];
    
    @try{    
        ITILevel *level;

        [self connectToDb];        
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &rallyDb) == SQLITE_OK){
            
            NSString *selectSql = [NSString stringWithFormat:@"SELECT description, code FROM Levels, Settings WHERE Settings.organisation = Levels.organisation"];            
            const char *sql = [selectSql UTF8String];
            sqlite3_stmt *sqlStatement;
            if(sqlite3_prepare(rallyDb, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
                NSLog(@"Problem with prepare statement");
            }     
            
            while (sqlite3_step(sqlStatement)==SQLITE_ROW) {  
                level = [[ITILevel alloc] init];
                level.description = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 0)];    
                level.code = sqlite3_column_int(sqlStatement, 1);
                [levels addObject:level];
            }    
        }else{
            NSLog(@"Cannot locate database file '%@'.", databasePath);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return levels;
        levels = Nil;
    }
}

- (NSMutableArray *) getLevelDescriptions{
    NSMutableArray *levels = [[NSMutableArray alloc] init];;
    
    @try{    
        NSString *description;
        
        [self connectToDb];
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &rallyDb) == SQLITE_OK){
            const char *sql = "SELECT description FROM Levels, Settings WHERE Levels.organisation = Settings.organisation";
            sqlite3_stmt *sqlStatement;
            if(sqlite3_prepare(rallyDb, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
                NSLog(@"Problem with prepare statement");
            }     
            
            while (sqlite3_step(sqlStatement)==SQLITE_ROW) {  
                description = [[NSString alloc] init];
                description = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 0)];    
                [levels addObject:description];
            }    
        }else{
            NSLog(@"Cannot locate database file '%@'.", databasePath);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return levels;
        levels = Nil;
    }
}


// Settings
- (ITISettings *) getSettings{
    ITISettings *settings  = [[ITISettings alloc] init];;
    
    @try{    
        [self connectToDb];
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &rallyDb) == SQLITE_OK){

            const char *sql = "SELECT Levels.description, Levels.code, organisation, firstRun FROM Settings, Languages, Levels WHERE Settings.languageCode = Languages.code AND Settings.level = Levels.code AND Settings.languageCode = Levels.languageCode";
            sqlite3_stmt *sqlStatement;
            if(sqlite3_prepare(rallyDb, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
                NSLog(@"Problem with prepare statement");
            }     
            
            while (sqlite3_step(sqlStatement)==SQLITE_ROW) {  
                settings.levelDescription = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 0)];
                settings.levelCode = sqlite3_column_int(sqlStatement, 1);
                settings.organisation = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 2)];   
                settings.isFirstRun = sqlite3_column_int(sqlStatement, 3);
            }    
        }else{
            NSLog(@"Cannot locate database file '%@'.", databasePath);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return settings;
        settings = Nil;
    }
    
}


- (ITISettings *)getSettingsOverview{
    ITISettings *settings  = [[ITISettings alloc] init];;
    
    @try{    
        [self connectToDb];
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &rallyDb) == SQLITE_OK){
            
            //Organisation, First run
            const char *sqlOrg = "SELECT organisation, firstRun FROM Settings";
            sqlite3_stmt *sqlOrgStatement;
            if(sqlite3_prepare(rallyDb, sqlOrg, -1, &sqlOrgStatement, NULL) != SQLITE_OK){
                NSLog(@"Problem with prepare statement");
            }     
            while (sqlite3_step(sqlOrgStatement)==SQLITE_ROW) {  
                settings.organisation = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlOrgStatement, 0)];
                settings.isFirstRun = sqlite3_column_int(sqlOrgStatement, 1);      
            }
            
            //Level
            const char *sqlLevel = "select Levels.code, description from Levels, Settings WHERE Levels.code = Settings.level AND Levels.organisation = Settings.organisation";
            sqlite3_stmt *sqlLevelStatement;
            if(sqlite3_prepare(rallyDb, sqlLevel, -1, &sqlLevelStatement, NULL) != SQLITE_OK){
                NSLog(@"Problem with prepare statement");
            }     
            while (sqlite3_step(sqlLevelStatement)==SQLITE_ROW) {  
                settings.levelCode = sqlite3_column_int(sqlLevelStatement, 0); 
                settings.levelDescription = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlLevelStatement, 1)];   
            }
        }else{
            NSLog(@"Cannot locate database file '%@'.", databasePath);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return settings;
        settings = Nil;
    }
}

-(void)setFirstRunToNo{
    NSString *updateSql = @"UPDATE Settings SET firstRun = 0";
    [self update:updateSql];
}


// Signs
- (ITISign *)getNextSign:(int)currentSign{
    ITISign *sign;
    
    @try{    
        [self connectToDb];
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &rallyDb) == SQLITE_OK){
            NSString *selectSql =  [ NSString stringWithFormat:@"SELECT header, body, image, thumb, Signs.id from Signs, Settings WHERE Signs.level=Settings.level AND Signs.organisation=Settings.organisation AND Signs.id>%d ORDER BY Signs.id LIMIT 1", currentSign];
            const char *sql = [selectSql UTF8String];
            sqlite3_stmt *sqlStatement;
            if(sqlite3_prepare(rallyDb, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
                NSLog(@"Problem with prepare statement");
            }     
            
            while (sqlite3_step(sqlStatement)==SQLITE_ROW) {  
                sign = [[ITISign alloc] init];
                sign.header = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 0)];
                sign.body = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 1)];
                NSString *imagePath = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 2)];
                NSString *thumbPath = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 3)];
                sign.id = sqlite3_column_int(sqlStatement, 4);
                sign.image = [UIImage imageNamed:imagePath]; 
                sign.thumb = [UIImage imageNamed:thumbPath];     
            } 
            if(sign==nil){
                sign = [self getFirstSign];
            }
        }else{
            NSLog(@"Cannot locate database file '%@'.", databasePath);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return sign;
        sign = nil;
    }
}


- (ITISign *)getPreviousSign:(int)currentSign{
    ITISign *sign;
    
    @try{    
        [self connectToDb];
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &rallyDb) == SQLITE_OK){
            NSString *selectSql =  [ NSString stringWithFormat:@"SELECT header, body, image, thumb, Signs.id from Signs, Settings WHERE Signs.level=Settings.level AND Signs.organisation=Settings.organisation AND Signs.id<%d ORDER BY Signs.id DESC LIMIT 1", currentSign];
            const char *sql = [selectSql UTF8String];
            sqlite3_stmt *sqlStatement;
            if(sqlite3_prepare(rallyDb, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
                NSLog(@"Problem with prepare statement");
            }     
            
            while (sqlite3_step(sqlStatement)==SQLITE_ROW) {  
                sign = [[ITISign alloc] init];
                sign.header = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 0)];
                sign.body = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 1)];
                NSString *imagePath = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 2)];
                NSString *thumbPath = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 3)];
                sign.id = sqlite3_column_int(sqlStatement, 4);
                sign.image = [UIImage imageNamed:imagePath]; 
                sign.thumb = [UIImage imageNamed:thumbPath];         
            } 
            if(sign==nil){
                sign = [self getLastSign];
            }
        }else{
            NSLog(@"Cannot locate database file '%@'.", databasePath);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return sign;
        sign = nil;
    }
}

- (ITISign *)getFirstSign{
    ITISign *sign = [[ITISign alloc] init];
    
    @try{    
        [self connectToDb];
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &rallyDb) == SQLITE_OK){
            const char *sql = "SELECT header, body, image, thumb, Signs.id from Signs, Settings WHERE Signs.level=Settings.level AND Signs.organisation=Settings.organisation AND Signs.id >= (SELECT MIN(id) FROM Signs) ORDER BY Signs.id LIMIT 1";
            sqlite3_stmt *sqlStatement;
            if(sqlite3_prepare(rallyDb, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
                NSLog(@"Problem with prepare statement");
            }     
            
                while (sqlite3_step(sqlStatement)==SQLITE_ROW) {  
                    
                    sign.header = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 0)];
                    sign.body = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 1)];
                    NSString *imagePath = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 2)];
                    NSString *thumbPath = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 3)];
                    sign.id = sqlite3_column_int(sqlStatement, 4);
                    sign.image = [UIImage imageNamed:imagePath]; 
                    sign.thumb = [UIImage imageNamed:thumbPath];         
                } 
            
        }else{
            NSLog(@"Cannot locate database file '%@'.", databasePath);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return sign;
        sign = nil;
    }
}

- (ITISign *)getLastSign{
    ITISign *sign = [[ITISign alloc] init];
    
    @try{    
        [self connectToDb];
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &rallyDb) == SQLITE_OK){
            const char *sql = "SELECT header, body, image, thumb, Signs.id from Signs, Settings WHERE Signs.level=Settings.level AND Signs.organisation=Settings.organisation AND Signs.id <= (SELECT MAX(id) FROM Signs) ORDER BY Signs.id DESC LIMIT 1";
            sqlite3_stmt *sqlStatement;
            if(sqlite3_prepare(rallyDb, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
                NSLog(@"Problem with prepare statement");
            }     
            
            while (sqlite3_step(sqlStatement)==SQLITE_ROW) {  
                
                sign.header = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 0)];
                sign.body = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 1)];
                NSString *imagePath = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 2)];
                NSString *thumbPath = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 3)];
                sign.id = sqlite3_column_int(sqlStatement, 4);
                sign.image = [UIImage imageNamed:imagePath]; 
                sign.thumb = [UIImage imageNamed:thumbPath];         
            } 
            
        }else{
            NSLog(@"Cannot locate database file '%@'.", databasePath);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return sign;
        sign = nil;
    }
}


- (ITISign *) getRandomSign{
    ITISign *randomSign  = [[ITISign alloc] init];    
    @try{    
        [self connectToDb];
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &rallyDb) == SQLITE_OK){
            const char *sql = "SELECT header, body, image, thumb, id FROM signs WHERE level <= (SELECT level FROM Settings) AND organisation = (SELECT organisation FROM Settings) ORDER BY RANDOM() LIMIT 1";
            sqlite3_stmt *sqlStatement;
            if(sqlite3_prepare(rallyDb, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
                NSLog(@"Problem with prepare statement");
            }     
            
            while (sqlite3_step(sqlStatement)==SQLITE_ROW) {  
                NSString *imagePath = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 2)];
                NSString *thumbPath = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 3)];
                
                randomSign.header = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 0)];
                randomSign.body = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 1)];
                randomSign.id = sqlite3_column_int(sqlStatement, 4);
                randomSign.image = [UIImage imageNamed:imagePath]; 
                randomSign.thumb = [UIImage imageNamed:thumbPath];    
                
            }    
        }else{
            NSLog(@"Cannot locate database file '%@'.", databasePath);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return randomSign;
        randomSign = nil;
    }
}

- (NSMutableArray *) getSigns{
    ITISign *sign;
    NSMutableArray *signs = [[NSMutableArray alloc] init];    
    @try{    
        [self connectToDb];
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &rallyDb) == SQLITE_OK){
            const char *sql = "SELECT Signs.id, header, body, image, thumb FROM Signs, Settings WHERE Signs.organisation = Settings.organisation AND Signs.level = Settings.level";
            sqlite3_stmt *sqlStatement;
            if(sqlite3_prepare(rallyDb, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
                NSLog(@"Problem with prepare statement");
            }     
            
            while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
                sign = [[ITISign alloc] init];    
                sign.id = sqlite3_column_int(sqlStatement, 0);
                sign.header = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 1)];
                sign.body = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 2)];                
                NSString *imagePath = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 3)];
                NSString *thumbPath = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 4)];
            
                sign.image = [UIImage imageNamed:imagePath]; 
                sign.thumb = [UIImage imageNamed:thumbPath]; 
                
                [signs addObject:sign];
            }
        }else{
            NSLog(@"Cannot locate database file '%@'.", databasePath);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return signs;
        signs = nil;
    }
}

// Dog
- (void)addDogComment:(ITIDog *)dog{
    NSString *updateSql = [NSString stringWithFormat:@"UPDATE Dogs SET comment = \"%@\" WHERE id=%d", dog.comment, dog.id];
    [self update:updateSql];
    
}

- (void) updateDog: (ITIDog *) changedDog{
    NSString *updateSql = [NSString stringWithFormat: @"UPDATE Dogs SET breed=\"%@\", is_male=%d, dob=\"%@\", comment=\"%@\", height=%d WHERE id=%d", changedDog.breed, changedDog.isMale, changedDog.dob, changedDog.comment, changedDog.height, changedDog.id];
    [self update:updateSql];
}

- (void) createDog: (ITIDog *) newDog{
    NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO Dogs(name, breed, is_male, dob, comment, height) values(\"%@\", \"%@\", %d, \"%@\", \"%@\", %d)", newDog.name, newDog.breed, newDog.isMale, newDog.dob, newDog.comment, newDog.height];     
    [self create:insertSQL];
}

- (NSMutableArray *) getDogs{
    NSMutableArray *dogs = [[NSMutableArray alloc] init];
    ITIDog *dog;
    
    @try{
        
        [self connectToDb];
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &rallyDb) == SQLITE_OK){
            const char *sql = "SELECT name, breed, is_male, dob, comment, id, height FROM Dogs ORDER BY name";
            sqlite3_stmt *sqlStatement;
            if(sqlite3_prepare(rallyDb, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
                NSLog(@"Problem with prepare statement");
            }     
            
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
        }else{
            NSLog(@"Cannot locate database file '%@'.", databasePath);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return dogs;
    }
}

- (int) getIdForDog:(NSString *)dogName{
    int dogId;
    
    @try{    
        [self connectToDb];
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &rallyDb) == SQLITE_OK){
            NSString *selectSql =  [ NSString stringWithFormat:@"SELECT id FROM Dogs WHERE name=\"%@\"", dogName];
            const char *sql = [selectSql UTF8String];
            sqlite3_stmt *sqlStatement;
            if(sqlite3_prepare(rallyDb, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
                NSLog(@"Problem with prepare statement");
            }     
            
            while (sqlite3_step(sqlStatement)==SQLITE_ROW) {  
                dogId = sqlite3_column_int(sqlStatement, 0);
            }    
        }else{
            NSLog(@"Cannot locate database file '%@'.", databasePath);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return dogId;
    }
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

- (NSMutableArray *)searchResults:(NSString *)dogName :(NSString *)city{
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    @try{    
        [self connectToDb];
        const char *dbpath = [databasePath UTF8String];        
        if (sqlite3_open(dbpath, &rallyDb) == SQLITE_OK){
            NSString *selectSql = [NSString stringWithFormat:@"SELECT place, event_date, is_competition, level, Results.comment, result, name, dog_id, Results.id, position  FROM Results, Dogs WHERE Results.Dog_id = Dogs.id and Dogs.name = \"%@\" OR place =\"@\"", dogName, city];
            
            const char *sql = [selectSql UTF8String];
            sqlite3_stmt *sqlStatement;
            if(sqlite3_prepare(rallyDb, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
                NSLog(@"Problem with prepare statement");
            }     
            
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
                
                [results addObject:result];
            }
        }else{
            NSLog(@"Cannot locate database file '%@'.", databasePath);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return results;
    }

}

- (void) updateResults: (ITIResult *) changedResult{
    NSString *updateSQL = [NSString stringWithFormat: @"UPDATE Results SET place = \"%@\", event_date=\"%@\", is_competition=%d, level=%d, comment=\"%@\", result=%d, dog_id=%d, position=%d  WHERE id=%d", changedResult.place, changedResult.event_date, changedResult.is_competition, changedResult.level, changedResult.comment, changedResult.points, changedResult.dog_id, changedResult.position,  changedResult.id]; 
    [self update:updateSQL];
}

- (void) createResult: (ITIResult *) newResult{
    if([newResult.place length] == 0){
        newResult.place = @" ";
    }
    if([newResult.comment length] == 0){
        newResult.comment = @" ";
    }
    
    NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO Results(place, event_date, is_competition, level, comment, result, dog_id, position) values(\"%@\", \"%@\", %d, %d, \"%@\", %d, %d, %d)", newResult.place, newResult.event_date, newResult.is_competition, newResult.level, newResult.comment, newResult.points, newResult.dog_id, newResult.position]; 
    [self create:insertSQL];
}

- (NSMutableArray *) getResults{
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    @try{    
        [self connectToDb];
        const char *dbpath = [databasePath UTF8String];        
        if (sqlite3_open(dbpath, &rallyDb) == SQLITE_OK){
            const char *sql = "SELECT place, event_date, is_competition, level, Results.comment, result, name, dog_id, Results.id, position  FROM Results, Dogs WHERE Results.Dog_id = Dogs.id ORDER by event_date DESC";
            sqlite3_stmt *sqlStatement;
            if(sqlite3_prepare(rallyDb, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
                NSLog(@"Problem with prepare statement");
            }     
            
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
                
                [results addObject:result];
            }
        }else{
            NSLog(@"Cannot locate database file '%@'.", databasePath);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return results;
    }
    
}

- (void)deleteResult:(int)resultId{
    NSString *deletSQL = [NSString stringWithFormat: @"DELETE FROM Results WHERE id = %d ", resultId]; 
    [self delete:deletSQL];       
}

- (NSMutableArray *)getResultsForDog:(int)dogId{
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    @try{    
        [self connectToDb];
        const char *dbpath = [databasePath UTF8String];        
        if (sqlite3_open(dbpath, &rallyDb) == SQLITE_OK){
            NSString *querySQL = [NSString stringWithFormat:@"SELECT place, event_date, is_competition, level, Results.comment, result, name, dog_id, Results.id, position  FROM Results, Dogs WHERE Results.Dog_id = Dogs.id AND Dogs.id = %d ORDER by Results.Dog_id, event_date DESC", dogId];
            const char *query_stmt = [querySQL UTF8String]; 
            sqlite3_stmt *sqlStatement;
            if(sqlite3_prepare(rallyDb, query_stmt, -1, &sqlStatement, NULL) != SQLITE_OK){
                NSLog(@"Problem with prepare statement");
            }     
            
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
                
                [results addObject:result];
            }
        }else{
            NSLog(@"Cannot locate database file '%@'.", databasePath);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return results;
    }
}

- (void)saveResultComment:(ITIResult *)result{
    NSString *updateSql = [NSString stringWithFormat:@"UPDATE Results SET comment = \"%@\" WHERE id=%d", result.comment, result.id];
    [self update:updateSql];
}


// Sign comment
- (void)createSignComment:(ITISignComment *)comment{
    NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO SignsComment(signs_id, description) values(%d, \"%@\")", comment.sign_id, comment.body]; 
    [self create:insertSQL];
}

- (ITISignComment *)getSignComment:(int)signId{
    
    ITISignComment *comment;
    @try{    
        [self connectToDb];
        const char *dbpath = [databasePath UTF8String];        
        if (sqlite3_open(dbpath, &rallyDb) == SQLITE_OK){
            NSString *querySQL = [NSString stringWithFormat:@"SELECT description, id, signs_id FROM SignsComment WHERE signs_id = %d", signId];
            const char *query_stmt = [querySQL UTF8String]; 
            sqlite3_stmt *sqlStatement;
            if(sqlite3_prepare(rallyDb, query_stmt, -1, &sqlStatement, NULL) != SQLITE_OK){
                NSLog(@"Problem with prepare statement");
            }     
            while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
                comment = [[ITISignComment alloc]init];
                comment.body = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 0)];
                comment.id = sqlite3_column_int(sqlStatement, 1);
                comment.sign_id = sqlite3_column_int(sqlStatement, 2);
                
            }
        }else{
            NSLog(@"Cannot locate database file '%@'.", databasePath);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return comment;
    }

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
    
    @try{    
        [self connectToDb];
        const char *dbpath = [databasePath UTF8String];        
        if (sqlite3_open(dbpath, &rallyDb) == SQLITE_OK){
            const char *query_stmt = "SELECT Organisations.id, code FROM Organisations ORDER BY code";
            sqlite3_stmt *sqlStatement;
            if(sqlite3_prepare(rallyDb, query_stmt, -1, &sqlStatement, NULL) != SQLITE_OK){
                NSLog(@"Problem with prepare statement");
            }     
            while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
                organisation = [[ITIOrganisation alloc] init];
                organisation.id = sqlite3_column_int(sqlStatement, 0);
                organisation.code = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 1)];
                [organisations addObject:organisation];
            }
        }else{
            NSLog(@"Cannot locate database file '%@'.", databasePath);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return organisations;
    }
}

- (void)updateOrganisation:(NSString *)org{
    NSString *updateSql = [NSString stringWithFormat:@"UPDATE Settings SET organisation = \"%@\"", org];
    [self update:updateSql];
}

// Generic
- (void) connectToDb{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    databasePath = [documentsDirectory stringByAppendingPathComponent:@"Rally.sqlite"];  
}

- (BOOL)queryIsTrue:(NSString *)sqlQuery{
    BOOL retVal = NO;
    
    @try{    
        [self connectToDb];
        const char *dbpath = [databasePath UTF8String];        
        if (sqlite3_open(dbpath, &rallyDb) == SQLITE_OK){
            NSLog(@"Query is true statement: %@", sqlQuery);
            const char *query_stmt = [sqlQuery UTF8String];
            sqlite3_stmt *sqlStatement;
            if(sqlite3_prepare(rallyDb, query_stmt, -1, &sqlStatement, NULL) != SQLITE_OK){
                NSLog(@"Problem with prepare statement");
            }     
            while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
                retVal = YES;
            }
        }else{
            NSLog(@"Cannot locate database file '%@'.", databasePath);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return retVal;
    }

}

- (NSString *)getStringValue:(NSString *)sqlQuery{
    NSString *ret;
    
    @try{
        
        [self connectToDb];
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, & rallyDb) == SQLITE_OK){
            const char *sql = [sqlQuery UTF8String];
            sqlite3_stmt *sqlStatement;
            if(sqlite3_prepare(rallyDb, sql, -1, &sqlStatement, NULL) != SQLITE_OK){
                NSLog(@"Problem with prepare statement");
            }     
            while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
                ret = [[NSString alloc] init];
                ret = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(sqlStatement, 0)];
            }
        }else{
            NSLog(@"Cannot locate database file '%@'.", databasePath);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally {
        return ret;
    }
}

- (void)create:(NSString *)sqlCreate{
    @try{
        
        [self connectToDb];
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &rallyDb) == SQLITE_OK){
            sqlite3_stmt  *statement;
            NSLog(@"Create statement %@", sqlCreate);
            const char *insert_stmt = [sqlCreate UTF8String];
            sqlite3_prepare_v2(rallyDb, insert_stmt, -1, &statement, NULL);
            
            int ret = sqlite3_step(statement);
            if (ret == SQLITE_DONE)
            {
                NSLog(@"Create succeeded");
            } else {
                NSLog(@"Create failed");
            }
            sqlite3_finalize(statement);
            NSLog(@"%s", sqlite3_errmsg(rallyDb));
            sqlite3_close(rallyDb);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
}

- (void)update:(NSString *)sqlUpdate{
    @try{
        
        [self connectToDb];
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &rallyDb) == SQLITE_OK){
            sqlite3_stmt  *statement;
            NSLog(@"Update statement %@", sqlUpdate);
            const char *insert_stmt = [sqlUpdate UTF8String];
            sqlite3_prepare_v2(rallyDb, insert_stmt, -1, &statement, NULL);
            
            int ret = sqlite3_step(statement);
            if (ret == SQLITE_DONE)
            {
                NSLog(@"Update succeeded");
            } else {
                NSLog(@"Update failed");
            }
            sqlite3_finalize(statement);
            NSLog(@"%s", sqlite3_errmsg(rallyDb));
            sqlite3_close(rallyDb);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
}

- (void)delete:(NSString *)sqlDelete{
    
    @try{    
        [self connectToDb];
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &rallyDb) == SQLITE_OK){
            NSLog(@"Delete statement: %@", sqlDelete);
            sqlite3_stmt    *statement;
            
            const char *insert_stmt = [sqlDelete UTF8String];
            sqlite3_prepare_v2(rallyDb, insert_stmt, -1, &statement, NULL);
            
            int ret = sqlite3_step(statement);
            if (ret == SQLITE_DONE)
            {
                NSLog(@"Delete succeeded");
            } else {
                NSLog(@"Delete dog failed");
            }
            sqlite3_finalize(statement);
            NSLog(@"%s", sqlite3_errmsg(rallyDb));
            sqlite3_close(rallyDb);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
    }  
}


@end