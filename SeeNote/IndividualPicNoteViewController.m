//
//  IndividualPicNoteViewController.m
//  SeeNote
//
//  Created by Blake Mitchell on 6/6/14.
//  Copyright (c) 2014 Vik and Blake. All rights reserved.
//

#import "IndividualPicNoteViewController.h"

@interface IndividualPicNoteViewController ()

@property (nonatomic, weak)IBOutlet UIButton *deleteButton;

@end

@implementation IndividualPicNoteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.deleteButton.alpha = 0;

    //have the textView with disabled editing until the user clicks the editing button
}

#pragma mark - Edit Button

- (IBAction)onEditButtonTapped:(id)sender
{
    //here we should enable the textView for editing and then when the user clicks save, save the new text there.

    self.deleteButton.alpha = 1;
    //this makes the delete button viewable when the user is editing
}

- (IBAction)onDeleteButtonTapped:(id)sender
{
    //delete the object, remove it from the managedObjectContent and then reload the tableView on the unwind segue
}


@end
