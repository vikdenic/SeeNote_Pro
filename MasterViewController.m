//
//  MasterViewController.m
//  SeeNote
//
//  Created by Vik Denic on 6/5/14.
//  Copyright (c) 2014 Vik and Blake. All rights reserved.
//

#import "MasterViewController.h"
#import "CustomTableViewCell.h"
#import "Picnote.h"

@interface MasterViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self load];
}

-(void)load
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"PicNote"];
    NSSortDescriptor *sortDescriptorByDate = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    request.sortDescriptors = [NSArray arrayWithObjects:sortDescriptorByDate, nil];

//    self.fetchedResultsController =[[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];

    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return [self.fetchedResultsController.sections[section] numberOfObjects];
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Picnote *picNote = [self.fetchedResultsController objectAtIndexPath:indexPath];
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    cell.categoryLabel.text = [NSString stringWithFormat:@"%@",[picNote valueForKey:@"category"]];
    cell.dateLabel.text = [NSString stringWithFormat:@"%@", [picNote valueForKey:@"date"]];
    cell.cellImageView.image = [UIImage imageWithData:picNote.photo];

    return cell;
}


@end
