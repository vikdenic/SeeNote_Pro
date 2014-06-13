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
#import "DetailedMapAllPicsNotesViewController.h"

@interface MapAllPicNotesViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic, weak)IBOutlet MKMapView *mapView;
@property CLLocationManager *locationManager;

@property NSArray *mapItems;

@property int number;


@end

@implementation MapAllPicNotesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.number = 0;

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
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
        annotation.coordinate = CLLocationCoordinate2DMake(picnote.latitude, picnote.longitude);
        annotation.title = [NSString stringWithFormat:@"%@", picnote.date];
        annotation.subtitle = picnote.category;

        self.thePicNote = [UIImage imageWithData:picnote.photo];

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
    static NSString *identifier = @"MyLocation";

    MKAnnotationView *annotationView = (MKAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];

    self.number++;

    NSLog(@"%i",self.number);

        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;


                 Picnote *picnote = [self.mapItems objectAtIndex:self.number];

                 UIImage *tempImage = [UIImage imageWithData:picnote.photo];

                 CGSize sacleSize = CGSizeMake(50, 50);
                 UIGraphicsBeginImageContextWithOptions(sacleSize, NO, 0.0);
                 [tempImage drawInRect:CGRectMake(0, 0, sacleSize.width, sacleSize.height)];
                 UIImage * resizedImage = UIGraphicsGetImageFromCurrentImageContext();
                 UIGraphicsEndImageContext();

                 annotationView.image = resizedImage;

        return annotationView;
}



-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"ToDetailedViewOfPinAnnotation" sender:view];
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    //a way to tell the index path????
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ToDetailedViewOfPinAnnotation"])
    {
        //pass the correct data here and populate the image view

        DetailedMapAllPicsNotesViewController *DMAPNVC = segue.destinationViewController;
        DMAPNVC.thePicNote = self.thePicNote;
    }
}

- (IBAction)unwindSegueToMapAllViewController:(UIStoryboardSegue *)sender
{
    
}


@end
