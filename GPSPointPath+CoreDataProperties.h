//
//  GPSPointPath+CoreDataProperties.h
//  WalkingDeadLocations
//
//  Created by MCS on 4/21/16.
//  Copyright © 2016 MCS. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "GPSPointPath.h"

NS_ASSUME_NONNULL_BEGIN

@interface GPSPointPath (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *latitude;
@property (nullable, nonatomic, retain) NSNumber *longitude;
@property (nullable, nonatomic, retain) Location *locationPaths;

@end

NS_ASSUME_NONNULL_END
