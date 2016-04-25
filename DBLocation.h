//
//  DBLocation.h
//  WalkingDeadLocations
//
//  Created by MCS on 4/22/16.
//  Copyright © 2016 MCS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DBGPSPoint, DBGPSPointPath;

NS_ASSUME_NONNULL_BEGIN

@interface DBLocation : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "DBLocation+CoreDataProperties.h"
