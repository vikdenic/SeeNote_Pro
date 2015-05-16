//
//  SaveViewController.m
//  SeeNote
//
//  Created by Blake Mitchell on 6/5/14.
//  Copyright (c) 2014 Vik and Blake. All rights reserved.
//

#import "SavePhotoViewController.h"
#import "Picnote.h"
#import <MapKit/MapKit.h>
#import "AppDelegate.h"

@interface SavePhotoViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UITextField *tagTextField;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation SavePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView.image = self.imageTaken;
    [self setUpCoreLocation];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark- Save


- (IBAction)onSaveButtonTapped:(UIButton *)sender {
    self.appDelegate = [[AppDelegate alloc] init];
    self.managedObjectContext = self.appDelegate.managedObjectContext;

    Picnote *picnote = [NSEntityDescription insertNewObjectForEntityForName:@"Picnote" inManagedObjectContext:self.managedObjectContext];

    CGSize scaleSize = CGSizeMake((self.imageTaken.size.width/12), (self.imageTaken.size.height/12));
    UIGraphicsBeginImageContextWithOptions(scaleSize, NO, 0.0);
    [self.imageTaken drawInRect:CGRectMake(0, 0, scaleSize.width, scaleSize.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    NSData *pngData = UIImagePNGRepresentation(resizedImage);

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];

    NSString *uniqueFileName = [NSString stringWithFormat:@"image-%lul.png", (unsigned long)([[NSDate date] timeIntervalSince1970])];

    NSString *filePath = [documentsPath stringByAppendingPathComponent:uniqueFileName];
    [pngData writeToFile:filePath atomically:YES];

    picnote.path = filePath;
    picnote.comment = self.commentTextView.text;
    picnote.category = self.tagTextField.text;
    picnote.date = self.date;
    picnote.latitude = self.locationManager.location.coordinate.latitude;
    picnote.longitude = self.locationManager.location.coordinate.longitude;
    [self.managedObjectContext save:nil];
}

#pragma mark - Core Location


- (void)setUpCoreLocation {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self.locationManager stopUpdatingLocation];
}

#pragma mark - Text Field and Text View


-(void)textViewDidBeginEditing:(UITextView *)textView {
    self.commentTextView.text = nil;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    self.tagTextField.text = nil;
}

@end
