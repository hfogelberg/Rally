//
//  ITIResultsViewController.h
//  Rally
//
//  Created by Henrik Fogelberg on 2012-01-30.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITIResult.h"
#import "ITISignsDataSource.h"
#import "ITIEditResultViewController.h"
#import "ITIAddResultViewController.h"

@interface ITIResultsViewController : UITableViewController<UISearchBarDelegate>{
    UISearchBar *searchResults;
}

@property (nonatomic, assign) int dogId;
@property (nonatomic, retain) NSMutableArray *results;
@property (nonatomic, retain) IBOutlet UITableView *resultsTable;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;

- (void) populateDataSource;

@end
