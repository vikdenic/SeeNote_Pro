//
//  IndividualPicNoteViewController.h
//  SeeNote
//
//  Created by Blake Mitchell on 6/6/14.
//  Copyright (c) 2014 Vik and Blake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Picnote.h"

@interface IndividualPhotoViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) Picnote *thePassedPicNote;
@property (strong, nonatomic) Picnote *picNoteFromMasterToIndividual;

@property int numberForDetermination;
@property int theNumber;

@property double latitudeFromIndividual;
@property double longitudeFromIndividual;


@end
