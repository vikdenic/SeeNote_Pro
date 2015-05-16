//
//  MapAllPicNotesViewController.m
//  SeeNote
//
//  Created by Blake Mitchell on 6/5/14.
//  Copyright (c) 2014 Vik and Blake. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "Picnote.h"
#import "MapAnnotation.h"
#import "IndividualPicNoteViewController.h"
#import "MapViewAnnotationView.h"

@interface MapViewController () <CLLocationManagerDelegate, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;

@property (strong, nonatomic) NSArray *mapItems;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.theNumber = 1;
    self.mapItems = [NSArray array];
    self.mapView.tintColor = [UIColor colorWithRed:202/255.0 green:250/255.0 blue:53/255.0 alpha:1];
    [self setUpCoreLocation];
    [self populateMap];
}

#pragma mark - Location


- (void)setUpCoreLocation {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self.locationManager stopUpdatingLocation];
    [self.mapView setShowsUserLocation:YES];
    self.location = [self.locationManager location];

    [self performSelector:@selector(delayForZoom)
               withObject:nil
               afterDelay:1.0];
}

- (void)delayForZoom {
        MKCoordinateRegion mapRegion;
        mapRegion.center = self.location.coordinate;
        mapRegion.span.latitudeDelta = 0.25;
        mapRegion.span.longitudeDelta = 0.25;
        [self.mapView setRegion:mapRegion animated: YES];
}

#pragma mark - Map


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if (![annotation isKindOfClass:[MKUserLocation class]]) {
        MapAnnotation *annot = (MapAnnotation *)annotation;
        
        MapViewAnnotationView *annotationView = [[MapViewAnnotationView alloc]initWithAnnotation:annot reuseIdentifier:nil];

        annotationView.image = [self circleImageWithImage:[UIImage imageWithData:[NSData dataWithContentsOfFile:annot.picPath]]];
        annotationView.layer.cornerRadius = annotationView.image.size.width/2;
        annotationView.layer.borderColor = [[UIColor colorWithRed:202/255.0 green:250/255.0 blue:53/255.0 alpha:1] CGColor];
        annotationView.layer.borderWidth = 2.0;
        annotationView.clipsToBounds = YES;
        annotationView.path = annot.picPath;

        //double tap
        if (annotationView.gestureRecognizers.count == 0) {
            UITapGestureRecognizer *tapping = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTap:)];
            tapping.numberOfTapsRequired = 2;
            [annotationView addGestureRecognizer:tapping];
            annotationView.userInteractionEnabled = YES;
        }

        return annotationView;
    }
    
    return nil;
}

- (void)populateMap {
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Picnote"];
    self.mapItems = [self.managedObjectContext executeFetchRequest:request error:nil];
    
    for (Picnote *picnote in self.mapItems) {
        MapAnnotation *annotation = [[MapAnnotation alloc]init];
        annotation.coordinate = CLLocationCoordinate2DMake(picnote.latitude, picnote.longitude);
        annotation.title = [NSString stringWithFormat:@"%@", picnote.date];
        annotation.subtitle = picnote.category;
        annotation.picPath = picnote.path;
        
        [self.mapView addAnnotation:annotation];
    }
}

- (UIImage *)circleImageWithImage:(UIImage *)image {
    CGSize sacleSize = CGSizeMake(50, 50);
    UIGraphicsBeginImageContextWithOptions(sacleSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, sacleSize.width, sacleSize.height)];
    return UIGraphicsGetImageFromCurrentImageContext();
}

#pragma mark - Tap Gesture Recognizer


- (void)tapTap:(UITapGestureRecognizer *)tapGestureRecognizer {
    MapViewAnnotationView *annotationView = (MapViewAnnotationView *)tapGestureRecognizer.view;

    for (Picnote *picNote in self.mapItems) {
        if ([annotationView.path isEqualToString:[NSString stringWithFormat:@"%@", picNote.path]]) {
            self.thePassedPicNote = picNote;
            [self performSegueWithIdentifier:@"MapAllPicsToIndividualSegue" sender:self];
        }
    }
}

#pragma mark - Segue


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MapAllPicsToIndividualSegue"]) {
        IndividualPicNoteViewController *individualViewController = segue.destinationViewController;
        individualViewController.thePassedPicNote = self.thePassedPicNote;
        individualViewController.theNumber = self.theNumber;
    }
}

- (IBAction)unwindSegueToMapAllViewController:(UIStoryboardSegue *)sender {
    
}

- (IBAction)unwindSegueToMapFromIndividualThatWasFromMaster:(UIStoryboardSegue *)sender {
    IndividualPicNoteViewController *individualPicNoteViewController = sender.sourceViewController;
    self.latitudeFromIndividual = individualPicNoteViewController.latitudeFromIndividual;
    self.longitudeFromIndividual = individualPicNoteViewController.longitudeFromIndividual;
    self.numberForDetermination = individualPicNoteViewController.numberForDetermination;
}

@end
