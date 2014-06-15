//
//  IndividualPicNoteViewController.h
//  SeeNote
//
//  Created by Blake Mitchell on 6/6/14.
//  Copyright (c) 2014 Vik and Blake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Picnote.h"

@interface IndividualPicNoteViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property Picnote *thePassedPicNote;
@property int theNumber;

@property Picnote *picNoteFromMasterToIndividual;

@property int numberForDetermination;

@property double latitudeFromIndividual;
@property double longitudeFromIndividual;


@end
