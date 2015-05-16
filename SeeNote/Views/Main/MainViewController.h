//
//  MasterViewController.h
//  SeeNote
//
//  Created by Vik Denic on 6/5/14.
//  Copyright (c) 2014 Vik and Blake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Picnote.h"

@interface MainViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) UIImage *imageTaken;
@property (strong, nonatomic) NSDate *date;

@property (strong, nonatomic) Picnote *picnote;
@property (strong, nonatomic) Picnote *picNoteFromMasterToIndividual;

@end
