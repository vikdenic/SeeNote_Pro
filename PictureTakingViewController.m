//
//  PictureTakingViewController.m
//  SeeNote
//
//  Created by Blake Mitchell on 6/5/14.
//  Copyright (c) 2014 Vik and Blake. All rights reserved.
//

#import "PictureTakingViewController.h"
#import "SaveViewController.h"

@interface PictureTakingViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong)IBOutlet UIImageView *imageView;

@end

@implementation PictureTakingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {

        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];

        [myAlertView show];
        //this code shows an error message if the user or in our case, simulator does not have a camera that is available to use
    }
}

//- (IBAction)onTakePhotoButtonPressed:(id)sender

-(void)viewDidAppear:(BOOL)animated
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    //the above code means photo resizing
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;

    [self presentViewController:imagePicker animated:YES completion:NULL];
}

- (IBAction)onSavedToCameraRoll:(UIButton *)sender
{
    void UIImageWriteToSavedPhotosAlbum (UIImage  *image, id completionTarget, SEL completionSelector, void *contextInfo);
}

#pragma mark - Image Picker

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageView.image = chosenImage;

    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [picker dismissViewControllerAnimated:YES completion:NULL];

}

- (IBAction)selectPhotoFromLibrary:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:picker animated:YES completion:NULL];
}

#pragma mark - Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //will need to pass manageObjectContent and all that to make we are passing the object we created 
}

#pragma mark - Unwind Segue

- (IBAction)unwindSegueToPictureTakingViewController:(UIStoryboardSegue *)sender
{
    //coming from SaveViewController
}

@end
