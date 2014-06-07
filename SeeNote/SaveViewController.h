//
//  SaveViewController.h
//  SeeNote
//
//  Created by Blake Mitchell on 6/5/14.
//  Copyright (c) 2014 Vik and Blake. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaveViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) UIImage *imageTaken;


@end
