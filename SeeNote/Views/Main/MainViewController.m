//
//  MasterViewController.m
//  SeeNote
//
//  Created by Vik Denic on 6/5/14.
//  Copyright (c) 2014 Vik and Blake. All rights reserved.
//

#import "MainViewController.h"
#import "MainViewControllerTableViewCell.h"
#import "Picnote.h"
#import "MapViewController.h"
#import "AppDelegate.h"
#import "SavePhotoViewController.h"

@interface MainViewController () <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (strong, nonatomic) UIImagePickerController *cameraController;

@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation MainViewController

- (void)viewDidLoad:(BOOL)animated {
    [super viewDidLoad];
    [self setUpCamera];
    [self setUpCoreData];
}

- (void)setUpCamera {
    self.cameraController = [[UIImagePickerController alloc] init];
    self.cameraController.delegate = self;
    self.cameraController.allowsEditing = YES;
    self.cameraController.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imageTaken = [[UIImage alloc]init];
}

- (void)setUpCoreData {
    self.fetchedResultsController.delegate = self;
    self.appDelegate = [[AppDelegate alloc] init];
    self.managedObjectContext = self.appDelegate.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Picnote"];
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"path" ascending:YES];
    request.sortDescriptors = [NSArray arrayWithObjects:sortDescriptor1, nil];
    self.fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    [self.fetchedResultsController performFetch:nil];
    [self.managedObjectContext save:nil];
//    [self.tableView reloadData];
}

#pragma mark - Image Picker

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:NO completion:^{
        self.imageTaken = [info valueForKey:UIImagePickerControllerOriginalImage];

        NSDictionary *metaData = [info objectForKey:@"UIImagePickerControllerMediaMetadata"];
        self.date = [[NSDate alloc]init];
        self.date = [[metaData objectForKey:@"{Exif}"] objectForKey:@"DateTimeOriginal"];

        [self performSegueWithIdentifier:@"SaveSegue" sender:self];
    }];
}

#pragma mark - Action Methods


- (IBAction)onCameraButtonTapped:(UIButton *)sender {
    [self presentViewController:self.cameraController animated:NO completion:nil];
}

- (IBAction)onIndividualButtonTapped:(UIButton *)sender {
    Picnote *picNote = [self.fetchedResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
    self.picNoteFromMasterToIndividual = picNote;
}


#pragma mark - Table View


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fetchedResultsController.sections[section] numberOfObjects];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Picnote *picNote = [self.fetchedResultsController objectAtIndexPath:indexPath];

    MainViewControllerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    NSData *pngData = [NSData dataWithContentsOfFile:picNote.path];
    UIImage *image = [UIImage imageWithData:pngData];
    cell.cellImageView.image = image;
    cell.cellImageView.backgroundColor = [UIColor orangeColor];

    cell.commentTextView.hidden = YES;
    cell.commentTextView.text = picNote.comment;
    cell.cellImageView.tag = indexPath.row;

    CGRect frame = cell.commentTextView.frame;
    frame.size.height = cell.commentTextView.contentSize.height;
    cell.commentTextView.frame = frame;

    //double tap to like
    if (cell.cellImageView.gestureRecognizers.count == 0) {
        UITapGestureRecognizer *tapping = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTap:)];
        tapping.numberOfTapsRequired = 2;
        [cell.cellImageView addGestureRecognizer:tapping];
        cell.cellImageView.userInteractionEnabled = YES;
    }

    cell.categoryLabel.text = picNote.category;

    NSDateFormatter *date = [[NSDateFormatter alloc] init];
    [date setDateFormat:@"MM-dd-yyyy"];

    NSString *formattedDate = [date stringFromDate:picNote.date];
    cell.dateLabel.text = [NSString stringWithFormat:@"🕑 %@", formattedDate];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.tableView beginUpdates];

    [self.managedObjectContext deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
    [self.managedObjectContext save:nil];
        [self.tableView endUpdates];
    }
    
    [self.tableView reloadData];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

#pragma mark - Segue


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqual: @"SaveSegue"]) {
        SavePhotoViewController *saveViewController = segue.destinationViewController;
        saveViewController.imageTaken = self.imageTaken;
        saveViewController.date = self.date;
    }
}

- (IBAction)unwindSegueToMasterViewController:(UIStoryboardSegue *)sender {
    [self.tableView reloadData];
}

- (IBAction)unwindSegueToMasterViewControllerOnCancel:(UIStoryboardSegue *)sender {
    
}

#pragma mark - Tap Gesture Recognizer


- (void)tapTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    UIImageView *sender = (UIImageView *)tapGestureRecognizer.view;

    MainViewControllerTableViewCell *customTableViewCell = (id)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    customTableViewCell.commentTextView.hidden = NO;
    customTableViewCell.commentTextView.alpha = 0;

    [UIView animateWithDuration:0.3 animations:^{
        customTableViewCell.commentTextView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateKeyframesWithDuration:0.3 delay:1.2 options:0 animations:^{
            customTableViewCell.commentTextView.alpha = 0;
        } completion:^(BOOL finished) {
            customTableViewCell.commentTextView.hidden = YES;
        }];
    }];
}

@end
