//
//  SaveViewController.m
//  SeeNote
//
//  Created by Blake Mitchell on 6/5/14.
//  Copyright (c) 2014 Vik and Blake. All rights reserved.
//

#import "SaveViewController.h"
#import "Picnote.h"

@interface SaveViewController ()

@end

@implementation SaveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // HERE
    //make a ImageView outlet and set uncomment the code below;

    //self.imageView.image = self.imageTaken.image;

    //set text field to uneditable then editable when the edit button is pressed
}


#pragma mark- Action

- (IBAction)onSaveButtonTapped:(id)sender
{
    //here we need to save both the picture and the text to that instance of an entity object and hook the action up

    Picnote *picnote = [NSEntityDescription insertNewObjectForEntityForName:@"Picnote" inManagedObjectContext:self.managedObjectContext];

    NSData *data = UIImagePNGRepresentation(self.imageTaken);
    picnote.photo = data;
//    picnote.comment = whatever the textview strings is
    [self.managedObjectContext save:nil];
}

@end
