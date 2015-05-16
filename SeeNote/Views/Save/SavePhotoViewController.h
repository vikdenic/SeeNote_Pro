//
//  SaveViewController.h
//  SeeNote
//
//  Created by Blake Mitchell on 6/5/14.
//  Copyright (c) 2014 Vik and Blake. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface SavePhotoViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) UIImage *imageTaken;
@property (strong, nonatomic) NSDate *date;

@end
