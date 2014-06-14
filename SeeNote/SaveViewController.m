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

@property int num;

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

//    NSLog(@"%@",self.imageTaken);

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

//    Compressing and converting user's image
    CGSize scaleSize = CGSizeMake((self.imageTaken.size.width/12), (self.imageTaken.size.height/12));
    UIGraphicsBeginImageContextWithOptions(scaleSize, NO, 0.0);
    [self.imageTaken drawInRect:CGRectMake(0, 0, scaleSize.width, scaleSize.height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    NSData *pngData = UIImagePNGRepresentation(resizedImage);

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory

    // Need to assign filePath a unique fileName everytime

    NSString *uniqueFileName = [NSString stringWithFormat:@"image-%lul.png", (unsigned long)([[NSDate date] timeIntervalSince1970])];

    NSString *filePath = [documentsPath stringByAppendingPathComponent:uniqueFileName]; //Add the file name

    [pngData writeToFile:filePath atomically:YES]; //Write the file

    picnote.path = filePath;
    picnote.comment = self.commentTextView.text;
    picnote.category = self.tagTextField.text;
    picnote.date = self.date;
    picnote.latitude = self.latitude;
    picnote.longitude = self.longitude;

    [self.managedObjectContextSave save:nil];
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

#pragma mark - Text Field and Text View

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    self.commentTextView.text = nil;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.tagTextField.text = nil;
}

@end
