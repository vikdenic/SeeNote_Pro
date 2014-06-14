//
//  MapAllPicNotesViewController.m
//  SeeNote
//
//  Created by Blake Mitchell on 6/5/14.
//  Copyright (c) 2014 Vik and Blake. All rights reserved.
//

#import "MapAllPicNotesViewController.h"
#import <MapKit/MapKit.h>
#import "Picnote.h"
#import "PicNoteAnnotation.h"
#import "IndividualPicNoteViewController.h"

@interface MapAllPicNotesViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic, weak)IBOutlet MKMapView *mapView;
@property CLLocationManager *locationManager;

@property NSArray *mapItems;

@end

@implementation MapAllPicNotesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.theNumber = 1;


    self.mapItems = [NSArray array];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];

    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Picnote"];
    self.mapItems = [self.managedObjectContext executeFetchRequest:request error:nil];

    for (Picnote *picnote in self.mapItems)
    {
        PicNoteAnnotation *annotation = [[PicNoteAnnotation alloc]init];
        annotation.coordinate = CLLocationCoordinate2DMake(picnote.latitude, picnote.longitude);
        annotation.title = [NSString stringWithFormat:@"%@", picnote.date];
        annotation.subtitle = picnote.category;
        annotation.picPath = picnote.path;

        [self.mapView addAnnotation:annotation];
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Change your location in the simulator!!!!");
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.locationManager stopUpdatingLocation];
    [self.mapView setShowsUserLocation:YES];
}

#pragma mark - Map 

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;

    PicNoteAnnotation *annot = (PicNoteAnnotation *)annotation;

    MKAnnotationView *annotationView = [[MKAnnotationView alloc]initWithAnnotation:annot reuseIdentifier:nil];

    NSData *data = [NSData dataWithContentsOfFile:annot.picPath];

    UIImage *image = [UIImage imageWithData:data];

    CGSize sacleSize = CGSizeMake(50, 50);
    UIGraphicsBeginImageContextWithOptions(sacleSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, sacleSize.width, sacleSize.height)];
    UIImage * resizedImage = UIGraphicsGetImageFromCurrentImageContext();

    annotationView.image = resizedImage;
    annotationView.layer.cornerRadius = resizedImage.size.width/2;
    annotationView.layer.borderColor = [[UIColor colorWithRed:202/255.0 green:250/255.0 blue:53/255.0 alpha:1] CGColor];
    annotationView.layer.borderWidth = 2.0;
    annotationView.clipsToBounds = YES;

    //double tap to like
    if (annotationView.gestureRecognizers.count == 0)
    {
        UITapGestureRecognizer *tapping = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTap:)];
        tapping.numberOfTapsRequired = 2;
        [annotationView addGestureRecognizer:tapping];
        annotationView.userInteractionEnabled = YES;
    }

    return annotationView;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    for (Picnote *picNote in self.mapItems)
    {
        if ([view.annotation.title isEqualToString:[NSString stringWithFormat:@"%@", picNote.date]])
        {
            self.thePassedPicNote = picNote;
        }
    }
}


#pragma mark - Tap Gesture Recognizer

- (void)tapTap:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self performSegueWithIdentifier:@"MapAllPicsToIndividualSegue" sender:self];

}


#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MapAllPicsToIndividualSegue"])
    {
        IndividualPicNoteViewController *individualViewController = segue.destinationViewController;
        individualViewController.thePassedPicNote = self.thePassedPicNote;
        individualViewController.theNumber = self.theNumber;
    }
}

- (IBAction)unwindSegueToMapAllViewController:(UIStoryboardSegue *)sender
{
    
}


@end
