//
//  DetailedMapAllPicsNotesViewController.m
//  SeeNote
//
//  Created by Blake Mitchell on 6/12/14.
//  Copyright (c) 2014 Vik and Blake. All rights reserved.
//

#import "DetailedMapAllPicsNotesViewController.h"

@interface DetailedMapAllPicsNotesViewController ()

@property (nonatomic, weak)IBOutlet UIImageView *imageView;

@end

@implementation DetailedMapAllPicsNotesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.imageView.image = self.thePicNote;
}

@end
