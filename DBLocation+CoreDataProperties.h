//
//  DBLocation+CoreDataProperties.h
//  WalkingDeadLocations
//
//  Created by MCS on 4/22/16.
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
@property (nullable, nonatomic, retain) NSString *season;
@property (nullable, nonatomic, retain) NSSet<DBGPSPointPath *> *path;
@property (nullable, nonatomic, retain) NSSet<DBGPSPoint *> *point;

@end

@interface DBLocation (CoreDataGeneratedAccessors)

- (void)addPathObject:(DBGPSPointPath *)value;
- (void)removePathObject:(DBGPSPointPath *)value;
- (void)addPath:(NSSet<DBGPSPointPath *> *)values;
- (void)removePath:(NSSet<DBGPSPointPath *> *)values;

- (void)addPointObject:(DBGPSPoint *)value;
- (void)removePointObject:(DBGPSPoint *)value;
- (void)addPoint:(NSSet<DBGPSPoint *> *)values;
- (void)removePoint:(NSSet<DBGPSPoint *> *)values;

@end

NS_ASSUME_NONNULL_END
