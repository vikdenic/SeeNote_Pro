//
//  MapAllPicNotesViewController.h
//  SeeNote
//
//  Created by Blake Mitchell on 6/5/14.
//  Copyright (c) 2014 Vik and Blake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Picnote.h"

@interface MapViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) UIImage *thePicNote;
@property (strong, nonatomic) Picnote *thePassedPicNote;

@property int theNumber;
@property int numberForDetermination;

@property double latitudeFromIndividual;
@property double longitudeFromIndividual;

@end
