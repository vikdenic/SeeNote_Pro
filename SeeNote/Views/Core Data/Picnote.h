//
//  Picnote.h
//  SeeNote
//
//  Created by Vik Denic on 6/5/14.
//  Copyright (c) 2014 Vik and Blake. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Picnote : NSManagedObject

@property (nonatomic, retain) NSString * path;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSDate * date;

// Stores location doubles (vik)
// Can be retreived via CLLocationCoordinate2DMake (vik)
@property double latitude;
@property double longitude;


@end
