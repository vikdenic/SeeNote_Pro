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

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UITextField *tagTextField;

@end

@implementation SaveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.date = [[NSDate alloc]init];

    self.imageView.image = [[UIImage alloc]init];
    self.imageView.image = self.imageTaken;
//    self.imageView.image = [UIImage imageNamed:@"bob.jpg"];

    NSLog(@"%@",self.imageTaken);

    //set text field to uneditable then editable when the edit button is pressed
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


#pragma mark- Action

- (IBAction)onSaveButtonTapped:(id)sender
{
    //here we need to save both the picture and the text to that instance of an entity object and hook the action up

    Picnote *picnote = [NSEntityDescription insertNewObjectForEntityForName:@"Picnote" inManagedObjectContext:self.managedObjectContextSave];

    NSData *data = UIImagePNGRepresentation(self.imageTaken);
    picnote.photo = data;
    picnote.comment = self.commentTextView.text;
    picnote.category = self.tagTextField.text;
    picnote.date = self.date;
    NSLog(@"PASSED THRU DATE IS %@", picnote.date);

    [self.managedObjectContextSave save:nil];
//    NSLog(@"SAVEVIEW MANOBJCOUNT IS %d",self.managedObjectContextSave.registeredObjects.count);
//    NSLog(@"%@",picnote.photo);
}

@end
