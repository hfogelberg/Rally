//
//  ITIDogsViewController.h
//  Rally
//
//  Created by Henrik Fogelberg on 2012-01-26.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITISignsDataSource.h"

@interface ITIDogsViewController : UITableViewController

@property (nonatomic, retain) NSMutableArray *dogs;
@property (nonatomic, retain) IBOutlet UITableView *dogsView;

- (void) populateDataSource;

@end
