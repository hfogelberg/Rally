//
//  ITIInfoViewController.m
//  Rally
//
//  Created by Henrik Fogelberg on 2012-04-23.
//  Copyright (c) 2012 Itio Systems AB. All rights reserved.
//

#import "ITIInfoViewController.h"

@implementation ITIInfoViewController

@synthesize infoText;
@synthesize infoLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Set the tabe bar label depending on localization
- (void)awakeFromNib{
    self.title = NSLocalizedString(@"INFO", nil);
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    infoLabel.text = NSLocalizedString(@"INFO", Nil);
    infoText.text = NSLocalizedString(@"INFO_TEXT", Nil);
    infoText.editable = NO;
    self.infoText.dataDetectorTypes = UIDataDetectorTypeAll;
    
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"background.png"]];
    self.view.backgroundColor = background;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
