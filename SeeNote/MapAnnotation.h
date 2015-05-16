//
//  PicNoteAnnotation.h
//  SeeNote
//
//  Created by Blake Mitchell on 6/13/14.
//  Copyright (c) 2014 Vik and Blake. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MapAnnotation : MKPointAnnotation

@property (nonatomic, strong) NSString *picPath;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;

@end
