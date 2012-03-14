//
//  ITISignsViewController.m
//  Rally
//
//  Created by Henrik Fogelberg on 2012-01-23.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import "ITISignsViewController.h"

@implementation ITISignsViewController

@synthesize signs;
@synthesize signsTable;

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
    self.signsTable = nil;
}

- (void)awakeFromNib{
    self.title = NSLocalizedString(@"SIGNS", nil);
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImage *bgImage= [UIImage imageNamed:@"background.png"];
    UIImageView *bgView= [[UIImageView alloc] initWithImage:bgImage];
    signsTable.backgroundView = bgView;  
    
    // On first run send user to settings
    ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
    ITISettings *settings = [dataSource getSettingsOverview];
    if(settings.isFirstRun == YES)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"SETTINGS", nil) 
                                                        message:NSLocalizedString(@"SETTINGS_MESSAGE", nil)
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];  
        [dataSource setFirstRunToNo];
        [self performSegueWithIdentifier:(@"settingsSegue") sender:self];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.signs = nil;
    self.signsTable = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
    
    ITISignsDataSource *dataSource = [[ITISignsDataSource alloc] init];
    ITISettings *settings = [dataSource getSettingsOverview ];
    self.navigationItem.title = settings.levelDescription;
    self.signs = [dataSource getSigns];    
    [signsTable reloadData];
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
    return [self.signs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    ITISign *sign = [self.signs objectAtIndex:indexPath.row];
    cell.textLabel.text = [sign header];    
    cell.imageView.image = [sign thumb];
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.cornerRadius = 5.0;
    cell.detailTextLabel.text = [sign body];
    return cell;
    
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



#pragma mark Seque methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showSignDetailSegue"]) {
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        ITISignDetailViewController *detailViewController = [segue destinationViewController];
        ITISign * selectedSign = [self.signs objectAtIndex:selectedRowIndex.row];
        detailViewController.sign = selectedSign;
    } else if([[segue identifier] isEqualToString:@"changeLevelSegue"]){
        [self dismissModalViewControllerAnimated:YES];
    }
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    ITISignDetailViewController *detail = [[ITISignDetailViewController alloc] initWithNibName:nil bundle:nil];
//    detail.sign = [self.signs objectAtIndex:indexPath.row];
//    [self presentViewController:detail animated:YES completion:nil];
//}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([[segue identifier] isEqualToString:@"showSignDetailSegue"]) {
//        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
//        ITISignDetailViewController *detailViewController = [segue destinationViewController];
//        ITISign * selectedSign = [self.signs objectAtIndex:selectedRowIndex.row];
//        detailViewController.sign = selectedSign;
//    }
//}

@end
