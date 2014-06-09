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

@interface MapAllPicNotesViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (nonatomic, weak)IBOutlet MKMapView *mapView;
@property CLLocationManager *locationManager;

@property NSArray *mapItems;

@end

@implementation MapAllPicNotesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.mapItems = [NSArray array];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];

    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Picnote"];
//    self.fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    self.mapItems = [self.managedObjectContext executeFetchRequest:request error:nil];
    [self.managedObjectContext save:nil];

    NSLog(@"%lu", (unsigned long)self.mapItems.count);


    for (Picnote *picnote in self.mapItems)
    {

        MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
        annotation.coordinate = CLLocationCoordinate2DMake(picnote.latitude, picnote.longitude);
        annotation.title = [NSString stringWithFormat:@"%@", picnote.date];
        annotation.subtitle = picnote.category;

        NSLog(@"%f %f", picnote.latitude, picnote.longitude);

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

//    self.mapView.userLocation.coordinate.latitude
//    self.mapView.userLocation.coordinate.longitude

    //need to get these in the saveViewController when the picture is saved- so in the background, save their location. will need to put all the code from above to maek it work.



    //we now have the location
    //we can store the latitude and longitude here....
}

//need to pass the MOC and then fetch request the user and put their lat and long into the annotation, will need to get each instance of picnote and fast enumerate through it to populate the map.

#pragma mark - Map 

//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
//{
//    for (Picnote *picnote in self.mapItems)
//    {
//    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:nil];
//    pin.canShowCallout = YES;
//    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    pin.image = [UIImage imageWithData:picnote.photo];
//
//    return pin;
//
//    }
//
//    return nil;
//    //can i do two separate for loops or somehow put them in one?
//}


@end
