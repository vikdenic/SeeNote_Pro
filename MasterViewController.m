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
#import "SaveViewController.h"

@interface MasterViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic)IBOutlet UITableView *tableView;
@property (weak, nonatomic)IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, weak)IBOutlet UIView *floatingView;
@property (nonatomic, weak)IBOutlet UIButton *floatingButton;
@property NSArray *resultsArray;

@property (nonatomic, strong) UIImagePickerController *cameraController;
@property (nonatomic, strong) SaveViewController *saveViewController;

@property (nonatomic, strong) UIImage *imageTaken;

@end

@implementation MasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Set delegate AFTER instantiation of object reference
    self.cameraController = [[UIImagePickerController alloc] init];
    self.cameraController.delegate = self;

    self.cameraController.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.saveViewController = [[SaveViewController alloc]init];

    self.imageTaken = [[UIImage alloc]init];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self load];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

- (IBAction)buttonTapped:(id)sender {

    [self presentViewController:self.cameraController animated:NO completion:^{
    }];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Segues to SaveViewController after user picks photo
    [picker dismissViewControllerAnimated:NO completion:^{
        [self performSegueWithIdentifier:@"SaveSegue" sender:self];
    }];

//    // Attempting to capture image
//    self.imageTaken = [info objectForKey:UIImagePickerControllerOriginalImage];
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

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqual: @"SaveSegue"])
    {

    }
}

#pragma mark- Unwind Segue

- (IBAction)unwindSegueToMasterViewController:(UIStoryboardSegue *)sender
{
    
}

@end
