//
//  ITIAppDelegate.m
//  Rally
//
//  Created by Henrik Fogelberg on 2012-01-23.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import "ITIAppDelegate.h"

@implementation ITIAppDelegate
@synthesize window = _window;
@synthesize rallyDb;

// Copy database to documentsdirectory on initialization
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self copyDatabase];
    [self setRallyDb];
    [self checkVersion];
    
    return YES;
}

- (void)checkVersion{
    ITISettings *settings;
    ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
    settings = dataSource.getSettingsOverview;
    NSString *version = [NSString stringWithFormat: @"%d", settings.version];
    
    if(version == @"1.01"){
        [self updateDbTo101];
    }
    
}

// Fix 
- (void)updateDbTo101{
    
}

- (void) setRallyDb{
        
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *databasePath = [documentsDirectory stringByAppendingPathComponent:@"Rally.sqlite"];  
    const char *dbpath = [databasePath UTF8String];
    int con = sqlite3_open(dbpath, &rallyDb);
        
    NSLog(@"Connection code: %d", con);
}


// Copy database to do documents folder if it isn't already done
- (void) copyDatabase{
    NSString *databaseName; 
    NSString *databasePath;
    BOOL success;
    
    databaseName = @"Rally.sqlite";
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    databasePath = [documentDir stringByAppendingPathComponent:databaseName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:databasePath];
    
    if(!success){
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
        [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
    }
    
    databaseName = nil;
    databasePath = nil;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
