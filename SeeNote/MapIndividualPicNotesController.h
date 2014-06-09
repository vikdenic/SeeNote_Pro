//
//  MapIndividualPicNotesController.h
//  SeeNote
//
//  Created by Vik Denic on 6/7/14.
//  Copyright (c) 2014 Vik and Blake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Picnote.h"

@interface MapIndividualPicNotesController : UIViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property Picnote *picnote;

@end
