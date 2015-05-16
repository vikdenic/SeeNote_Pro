//
//  IndividualPicNoteViewController.m
//  SeeNote
//
//  Created by Blake Mitchell on 6/6/14.
//  Copyright (c) 2014 Vik and Blake. All rights reserved.
//

#import "IndividualPhotoViewController.h"
#import "Picnote.h"
#import "MapViewController.h"

@interface IndividualPhotoViewController () <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UITextField *tagTextField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIButton *theButton1;
@property (weak, nonatomic) IBOutlet UIButton *theButton2;

@property (weak, nonatomic) IBOutlet UIButton *theMapButton1;
@property (weak, nonatomic) IBOutlet UIButton *theMapButton2;

@end

@implementation IndividualPhotoViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.numberForDetermination = 2;
    self.commentTextView.text = @"Write Description Here";

    if (self.theNumber ==1) {
        //means you came from Map
        self.theButton1.hidden = NO;
        self.theButton2.hidden = YES;

        NSData *pngData = [NSData dataWithContentsOfFile:self.thePassedPicNote.path];
        UIImage *image = [UIImage imageWithData:pngData];

        self.imageView.image = image;
        self.commentTextView.text = self.thePassedPicNote.comment;
        self.tagTextField.text = [NSString stringWithFormat:@"Tag: %@",self.thePassedPicNote.category];

        NSDateFormatter *date = [[NSDateFormatter alloc] init];
        [date setDateFormat:@"MM-dd-yyyy"];

        NSString *theDate = [date stringFromDate:self.thePassedPicNote.date];
        self.dateLabel.text = [NSString stringWithFormat:@"🕑 %@", theDate];

        self.latitudeFromIndividual = self.thePassedPicNote.latitude;
        self.longitudeFromIndividual = self.thePassedPicNote.longitude;

        self.theMapButton1.hidden = YES;
        self.theMapButton2.hidden = NO;

    } else {
        //means you came from master
        self.theButton1.hidden = YES;
        self.theButton2.hidden = NO;

        NSData *pngData = [NSData dataWithContentsOfFile:self.picNoteFromMasterToIndividual.path];
        UIImage *image = [UIImage imageWithData:pngData];

        self.imageView.image = image;
        self.commentTextView.text = self.picNoteFromMasterToIndividual.comment;
        self.tagTextField.text = [NSString stringWithFormat:@"Tag: %@",self.picNoteFromMasterToIndividual.category];

        NSDateFormatter *date = [[NSDateFormatter alloc] init];
        [date setDateFormat:@"MM-dd-yyyy"];

        NSString *theDate = [date stringFromDate:self.picNoteFromMasterToIndividual.date];
        self.dateLabel.text = [NSString stringWithFormat:@"🕑 %@", theDate];

        self.latitudeFromIndividual = self.picNoteFromMasterToIndividual.latitude;
        self.longitudeFromIndividual = self.picNoteFromMasterToIndividual.longitude;

        self.theMapButton1.hidden = NO;
    }

    self.deleteButton.alpha = 0;
    self.saveButton.alpha = 0;
    self.editing = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Edit Button


- (IBAction)onEditButtonTapped:(UIButton *)sender {

        //here we should enable the textView for editing and then when the user clicks save, save the new text there.

        self.deleteButton.alpha = 1;
        self.saveButton.alpha = 1;
        self.editButton.alpha = 0;
        //this makes the delete button viewable when the user is editing

}
- (IBAction)onSaveButtonTapped:(UIButton *)sender {
    self.deleteButton.alpha = 0;
    self.saveButton.alpha = 0;
    self.editButton.alpha = 1;
}

- (IBAction)onDeleteButtonTapped:(UIButton *)sender {
    //delete the object, remove it from the managedObjectContent and then reload the tableView on the unwind segue
}

- (IBAction)onMap2ButtonPressed:(UIButton *)sender {
    if (self.numberForDetermination == 2) {
    [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    self.tagTextField.text = nil;
}

@end
