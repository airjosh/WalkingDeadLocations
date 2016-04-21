//
//  CustomMKPointAnnotation.h
//  WalkingDeadLocations
//
//  Created by MCS on 4/21/16.
//  Copyright © 2016 MCS. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface CustomMKPointAnnotation : MKPointAnnotation

@property (strong, nonatomic) NSString *annotationIdentifier;

@end
