//
//  Location+CoreDataProperties.h
//  WalkingDeadLocations
//
//  Created by MCS on 4/21/16.
//  Copyright © 2016 MCS. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Location.h"

NS_ASSUME_NONNULL_BEGIN

@interface Location (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *descriptionLocation;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *locationId;
@property (nullable, nonatomic, retain) NSNumber *visited;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *points;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *paths;

@end

@interface Location (CoreDataGeneratedAccessors)

- (void)addPointsObject:(NSManagedObject *)value;
- (void)removePointsObject:(NSManagedObject *)value;
- (void)addPoints:(NSSet<NSManagedObject *> *)values;
- (void)removePoints:(NSSet<NSManagedObject *> *)values;

- (void)addPathsObject:(NSManagedObject *)value;
- (void)removePathsObject:(NSManagedObject *)value;
- (void)addPaths:(NSSet<NSManagedObject *> *)values;
- (void)removePaths:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
