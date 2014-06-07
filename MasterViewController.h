//
//  MasterViewController.h
//  SeeNote
//
//  Created by Vik Denic on 6/5/14.
//  Copyright (c) 2014 Vik and Blake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface MasterViewController : UIViewController <NSFetchedResultsControllerDelegate>

// Efficiently manages the results returned from a Core Data fetch request to provide data for a UITableView object.
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

// Manages a collection of managed objects.
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContextMaster;

@property (nonatomic, strong) UIImage *imageTaken;


@end
