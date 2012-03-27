//
//  ITISignsViewController.h
//  Rally
//
//  Created by Henrik Fogelberg on 2012-01-23.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ITISignsDataSource.h"
#import "ITISignDetailViewController.h"
#import "ITIImageStore.h"

@interface ITISignsViewController : UITableViewController{
    NSMutableArray *signs;
    UITableView *signsTable;
}

@property (nonatomic, retain) NSMutableArray *signs;
@property (nonatomic, retain) IBOutlet UITableView *signsTable;

@end
