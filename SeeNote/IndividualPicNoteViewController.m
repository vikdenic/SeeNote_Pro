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
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation IndividualPicNoteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.deleteButton.alpha = 0;
    self.saveButton.alpha = 0;

    //have the textView with disabled editing until the user clicks the editing button

    self.editing = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Edit Button

- (IBAction)onEditButtonTapped:(id)sender
{

        //here we should enable the textView for editing and then when the user clicks save, save the new text there.

        self.deleteButton.alpha = 1;
        self.saveButton.alpha = 1;
        self.editButton.alpha = 0;
        //this makes the delete button viewable when the user is editing

}
- (IBAction)onSaveButtonTapped:(id)sender {

    self.deleteButton.alpha = 0;
    self.saveButton.alpha = 0;
    self.editButton.alpha = 1;

}

- (IBAction)onDeleteButtonTapped:(id)sender
{
    //delete the object, remove it from the managedObjectContent and then reload the tableView on the unwind segue
}

//leave save code here


@end
