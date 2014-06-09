//
//  SaveViewController.m
//  SeeNote
//
//  Created by Blake Mitchell on 6/5/14.
//  Copyright (c) 2014 Vik and Blake. All rights reserved.
//

#import "SaveViewController.h"
#import "Picnote.h"
#import <MapKit/MapKit.h>

@interface SaveViewController () <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UITextField *tagTextField;

@property CLLocationManager *locationManager;
@property double latitude;
@property double longitude;


@end

@implementation SaveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];

    self.date = [[NSDate alloc]init];

    self.imageView.image = [[UIImage alloc]init];
    self.imageView.image = self.imageTaken;
//    self.imageView.image = [UIImage imageNamed:@"bob.jpg"];

    NSLog(@"%@",self.imageTaken);

    //set text field to uneditable then editable when the edit button is pressed
    //test
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark- Action

- (IBAction)onSaveButtonTapped:(id)sender
{
    //here we need to save both the picture and the text to that instance of an entity object and hook the action up

    Picnote *picnote = [NSEntityDescription insertNewObjectForEntityForName:@"Picnote" inManagedObjectContext:self.managedObjectContextSave];

    NSData *data = UIImagePNGRepresentation(self.imageTaken);
    picnote.photo = data;
    picnote.comment = self.commentTextView.text;
    picnote.category = self.tagTextField.text;
    picnote.date = self.date;
    picnote.latitude = self.latitude;
    picnote.longitude = self.longitude;


    NSLog(@"PASSED THRU DATE IS %@", picnote.date);

    [self.managedObjectContextSave save:nil];
//    NSLog(@"SAVEVIEW MANOBJCOUNT IS %d",self.managedObjectContextSave.registeredObjects.count);
//    NSLog(@"%@",picnote.photo);
}

#pragma mark - Core Location

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Change your location in the simulator!!!!");
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{

    self.latitude = self.locationManager.location.coordinate.latitude;
    self.longitude = self.locationManager.location.coordinate.longitude;

        [self.locationManager stopUpdatingLocation];



    //need to get these in the saveViewController when the picture is saved- so in the background, save their location. will need to put all the code from above to maek it work.


    //we now have the location
    //we can store the latitude and longitude here....
}

@end
