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
#import "PicNoteAnnotation.h"

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
