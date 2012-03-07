//
//  ITIDogsViewController.m
//  Rally
//
//  Created by Henrik Fogelberg on 2012-01-26.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import "ITIDogsViewController.h"
#import "ITIEditDogViewController.h"


@implementation ITIDogsViewController

@synthesize dogs;
@synthesize dogsView;

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
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)awakeFromNib{
    self.title = NSLocalizedString(@"DOGS", nil);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.topViewController.title = NSLocalizedString(@"DOGS", nil);
    UIImage *bgImage= [UIImage imageNamed:@"background.png"];
    UIImageView *bgView= [[UIImageView alloc] initWithImage:bgImage];
    dogsView.backgroundView = bgView;  
    
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Åter" style:UIBarButtonItemStylePlain target:nil action:nil];

    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.dogs = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self populateDataSource];
    [self.dogsView reloadData];
}

- (void)populateDataSource{
    ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
    self.dogs = [dataSource getDogs];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dogs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    ITIDog *dog = [dogs objectAtIndex:indexPath.row];
    cell.textLabel.text = dog.name;
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier] isEqualToString:@"showDogDetailSegue"]){
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        ITIEditDogViewController *detailViewController = [segue destinationViewController];
        ITIDog * selectedDog = [self.dogs objectAtIndex:selectedRowIndex.row];
        detailViewController.dog = selectedDog;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

@end
