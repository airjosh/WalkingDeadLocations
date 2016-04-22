//
//  DBLocation+CoreDataProperties.h
//  WalkingDeadLocations
//
//  Created by MCS on 4/21/16.
//  Copyright © 2016 MCS. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DBLocation.h"

NS_ASSUME_NONNULL_BEGIN

@interface DBLocation (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *descriptionLocation;
@property (nullable, nonatomic, retain) NSString *locationId;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *visited;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *point;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *path;

@end

@interface DBLocation (CoreDataGeneratedAccessors)

- (void)addPointObject:(NSManagedObject *)value;
- (void)removePointObject:(NSManagedObject *)value;
- (void)addPoint:(NSSet<NSManagedObject *> *)values;
- (void)removePoint:(NSSet<NSManagedObject *> *)values;

- (void)addPathObject:(NSManagedObject *)value;
- (void)removePathObject:(NSManagedObject *)value;
- (void)addPath:(NSSet<NSManagedObject *> *)values;
- (void)removePath:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
