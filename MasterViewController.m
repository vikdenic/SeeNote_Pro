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
#import "IndividualPicNoteViewController.h"
#import "MapAllPicNotesViewController.h"
#import "MapIndividualPicNotesController.h"

@interface MasterViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic)IBOutlet UITableView *tableView;
@property (weak, nonatomic)IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, weak)IBOutlet UIView *floatingView;
@property (nonatomic, weak)IBOutlet UIButton *floatingButton;

@property (nonatomic, strong) UIImagePickerController *cameraController;

@end

@implementation MasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.fetchedResultsController.delegate = self;
}

-(void)load
{
        NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Picnote"];
        NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"path" ascending:YES];
        request.sortDescriptors = [NSArray arrayWithObjects:sortDescriptor1, nil];
        self.fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:self.managedObjectContextMaster sectionNameKeyPath:nil cacheName:nil];

        [self.fetchedResultsController performFetch:nil];
        [self.managedObjectContextMaster save:nil];
        [self.tableView reloadData];
    }

-(void)viewWillAppear:(BOOL)animated
{

    [self.tableView reloadData];

    self.cameraController = [[UIImagePickerController alloc] init];
    self.cameraController.delegate = self;
    self.cameraController.allowsEditing = YES;

    self.cameraController.sourceType = UIImagePickerControllerSourceTypeCamera;

    self.imageTaken = [[UIImage alloc]init];

    [self load];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        //back to masterViewController
    }];
}

- (IBAction)buttonTapped:(id)sender {

    [self presentViewController:self.cameraController animated:NO completion:^{
        //
    }];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:NO completion:^{
    // Segues to SaveViewController after user picks photo
        self.imageTaken = [info valueForKey:UIImagePickerControllerOriginalImage];

//       NSData *imageData = UIImagePNGRepresentation(image);

        // Extracts and stores creation date of image as NSDate reference
        NSDictionary *metaData = [info objectForKey:@"UIImagePickerControllerMediaMetadata"];
        self.date = [[NSDate alloc]init];
        self.date = [[metaData objectForKey:@"{Exif}"] objectForKey:@"DateTimeOriginal"];

    [self performSegueWithIdentifier:@"SaveSegue" sender:self];
    }];
}

#pragma mark - Table View

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fetchedResultsController.sections[section] numberOfObjects];
//    return 20;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Picnote *picNote = [self.fetchedResultsController objectAtIndexPath:indexPath];
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    // Obtaining image via path
    NSData *pngData = [NSData dataWithContentsOfFile:picNote.path];
    UIImage *image = [UIImage imageWithData:pngData];
    cell.cellImageView.image = image;
//    NSLog(@"%@",image);

    cell.categoryLabel.text = picNote.category;

    NSDateFormatter *dateFormatter =[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM/dd/yy"];
    NSString *formattedDate = [dateFormatter stringFromDate:picNote.date];
    cell.dateLabel.text = formattedDate;

//    cell.dateLabel.text = [NSString stringWithFormat:@"%@",picNote.date];
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
    if([segue.identifier isEqual: @"AllMapSegue"])
    {
        MapAllPicNotesViewController *mapAllPicNotesViewController = segue.destinationViewController;

        mapAllPicNotesViewController.managedObjectContext = self.managedObjectContextMaster;
        mapAllPicNotesViewController.fetchedResultsController = self.fetchedResultsController;

    } else if([segue.identifier isEqual: @"SaveSegue"])
    {
        SaveViewController *saveViewController = segue.destinationViewController;

        saveViewController.imageTaken = self.imageTaken;
        saveViewController.date = self.date;

        saveViewController.managedObjectContextSave = self.managedObjectContextMaster;
        saveViewController.fetchedResultsController = self.fetchedResultsController;

    } else if([segue.identifier isEqual: @"IndividualSegue"])
    {
        IndividualPicNoteViewController *individualPicNoteViewController = segue.destinationViewController;

        individualPicNoteViewController.managedObjectContext = self.managedObjectContextMaster;
        individualPicNoteViewController.fetchedResultsController = self.fetchedResultsController;


    } else if([segue.identifier isEqual: @"MapSegue"])
    {
        MapIndividualPicNotesController *mapIndividualPicNotesViewController = segue.destinationViewController;

        mapIndividualPicNotesViewController.managedObjectContext = self.managedObjectContextMaster;
        mapIndividualPicNotesViewController.fetchedResultsController = self.fetchedResultsController;

        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        Picnote *pictnote = [self.fetchedResultsController objectAtIndexPath:selectedIndexPath];
        mapIndividualPicNotesViewController.picnote = pictnote;
    }
}

//throwin it in
-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    [self.tableView reloadData];
}

#pragma mark- Unwind Segue

- (IBAction)unwindSegueToMasterViewController:(UIStoryboardSegue *)sender
{

    SaveViewController *saveVC = sender.sourceViewController;
    self.managedObjectContextMaster = saveVC.managedObjectContextSave;
    [self load];
//    NSLog(@"%@",self.managedObjectContextMaster);
}

- (IBAction)unwindSegueToMasterViewControllerOnCancel:(UIStoryboardSegue *)sender
{

}

@end
