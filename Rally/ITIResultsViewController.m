//
//  ITIResultsViewController.m
//  Rally
//
//  Created by Henrik Fogelberg on 2012-01-30.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import "ITIResultsViewController.h"

@implementation ITIResultsViewController

@synthesize dogId;
@synthesize results;
@synthesize resultsTable;
@synthesize searchBar;

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
    NSString *searchParams = self.searchBar.text;
    results = [dataSource searchResults:searchParams :dogId];
    [self.resultsTable reloadData];
    [self.searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    [self populateDataSource];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.results = Nil;
}

// Set tab bar depending on localization
- (void)awakeFromNib{
    self.title = NSLocalizedString(@"RESULTS", nil);
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIView *hackView = [[UIView alloc] initWithFrame:CGRectZero];
    UIBarButtonItem *hackItem = [[UIBarButtonItem alloc] initWithCustomView:hackView];      
    self.navigationItem.backBarButtonItem = hackItem;
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    [self.searchBar sizeToFit];
    self.navigationItem.titleView = self.searchBar;
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton = TRUE;
    
    self.navigationController.topViewController.title = NSLocalizedString(@"RESULTS", nil);
    UIImage *bgImage= [UIImage imageNamed:@"background.png"];
    UIImageView *bgView= [[UIImageView alloc] initWithImage:bgImage];
    resultsTable.backgroundView = bgView;      
    searchResults.delegate = self;
}

- (void) populateDataSource{
    ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
    
    if(dogId == 0){
        self.results = dataSource.getResults;
    }else{
        self.results = [dataSource getResultsForDog:dogId];
    }
    
    [self.resultsTable reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.results = Nil;
    self.resultsTable = Nil;
}

// Refresh the table when a new result has been added
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self populateDataSource];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.searchBar.text = @"";
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    ITIResult *result = [results objectAtIndex:indexPath.row];
    NSString *dog = result.dog_name;
    NSString *place = result.place;
    NSString *event_date = result.event_date;
    
    NSString *label = [NSString stringWithFormat:@"%@ %@ %@", event_date, dog, place ];
    cell.textLabel.text = label;
    
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"editResultSegue"]) {
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        ITIEditResultViewController *detailViewController = [segue destinationViewController];
        ITIResult * selectedResult = [self.results objectAtIndex:selectedRowIndex.row];
        detailViewController.result = selectedResult;
    }else if([[segue identifier] isEqualToString:@"addResultSegue"]){ 
        if(dogId > 0){
            ITIAddResultViewController *addViewController = [segue destinationViewController];            addViewController.dogId = dogId;
        }
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        ITIResult *result = [self.results objectAtIndex:indexPath.row];
        ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
        [dataSource deleteResult:result.id];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


@end
