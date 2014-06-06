//
//  MasterViewController.m
//  SeeNote
//
//  Created by Vik Denic on 6/5/14.
//  Copyright (c) 2014 Vik and Blake. All rights reserved.
//

#import "MasterViewController.h"
#import "CustomTableViewCell.h"
#import "Picnote.h"

@interface MasterViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic)IBOutlet UITableView *tableView;
@property (weak, nonatomic)IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, weak)IBOutlet UIView *floatingView;
@property (nonatomic, weak)IBOutlet UIButton *floatingButton;
@property NSArray *resultsArray;

@end

@implementation MasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self load];
}

-(void)load
{

    //here we can set up however we want to return the results, for the time being I moved the requests to the segmented control method. We should probably have it sort by whichever segment in selected from the start.
}

#pragma mark - Table View

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return [self.fetchedResultsController.sections[section] numberOfObjects];
    return 20;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    Picnote *picNote = [self.fetchedResultsController objectAtIndexPath:indexPath];
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

//    cell.categoryLabel.text = [NSString stringWithFormat:@"%@",[picNote valueForKey:@"category"]];
//    cell.dateLabel.text = [NSString stringWithFormat:@"%@", [picNote valueForKey:@"date"]];
//    cell.cellImageView.image = [UIImage imageWithData:picNote.photo];

    return cell;
}

#pragma mark - Segmented Control

- (IBAction)onSegmentedControlTapped:(id)sender
{
    if (self.segmentedControl.selectedSegmentIndex == 0)
    {
        //predicate here for comment

//        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"PicNote"];
//        NSSortDescriptor *sortDescriptorByComment = [[NSSortDescriptor alloc] initWithKey:@"comment" ascending:YES];
//        request.sortDescriptors = [NSArray arrayWithObject:sortDescriptorByComment];
//        self.resultsArray = [self.managedObjectContext executeFetchRequest:request error:nil];

    } else if (self.segmentedControl.selectedSegmentIndex == 1)
    {
        //predicate here for date

//        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"PicNote"];
//        NSSortDescriptor *sortDescriptorByDate = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
//        request.sortDescriptors = [NSArray arrayWithObject:sortDescriptorByDate];
    }
    [self.tableView reloadData];
}

#pragma mark- Unwind Segue

- (IBAction)unwindSegueToMasterViewController:(UIStoryboardSegue *)sender
{
    
}

#pragma mark - The Floating Button - Don't touch please haha it took like an hour

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect frame = self.floatingView.frame;
//    frame.origin.y = scrollView.contentOffset.y + self.tableView.frame.size.height - self.floatingView.frame.size.height;
//    frame.origin.x = self.view.frame.origin.x +200;
    frame.origin.y = scrollView.frame.origin.y +440;
    self.floatingView.frame = frame;

    [self.view bringSubviewToFront:self.floatingView];
}





@end
