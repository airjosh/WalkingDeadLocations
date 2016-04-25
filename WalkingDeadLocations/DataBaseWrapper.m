//
//  DataBaseWrapper.m
//  WalkingDeadLocations
//
//  Created by MCS on 4/22/16.
//  Copyright © 2016 MCS. All rights reserved.
//

#import "DataBaseWrapper.h"
#import "AppDelegate.h"
#import "DBLocation.h"
#import "Location.h"
#import "GPSPoint.h"

@implementation DataBaseWrapper


+ (void) updateIsVisited:(NSNumber*)isVisited withLocationId:(NSString*)locationId{
    // Get Managed Object Context
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedObjectContext = [appDelegate managedObjectContext];
    
    /*
     * Retrieve Values
     */
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"DBLocation" inManagedObjectContext:managedObjectContext]];
    
    [fetchRequest setIncludesSubentities:NO]; //Omit subentities. Default is YES (i.e. include subentities)
    
    NSError *err;
    NSUInteger count = [managedObjectContext countForFetchRequest:fetchRequest error:&err];
    if(count == NSNotFound) {
        //Handle error
        NSLog(@"ns not found");
        return;
    }
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"locationId == %@", locationId]];
    NSError *error;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    DBLocation *dbLocation = fetchedObjects[0];
    [dbLocation setValue:isVisited forKey:@"visited"];
    
    NSError * aError;
    
    // try for error
    if (![managedObjectContext save:&aError ]) {
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Update Action"
                                      message:@"Fail"
                                      preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okAlert = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAlert];
    }
    else {
        NSLog(@"DB update successful");
    }
    
}

+ (Location *) getLocationWithId: (NSString*)locationId{
   
    // Get Managed Object Context
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedObjectContext = [appDelegate managedObjectContext];
    
    /*
     * Retrieve Values
     */
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"DBLocation" inManagedObjectContext:managedObjectContext]];
    
    [fetchRequest setIncludesSubentities:NO]; //Omit subentities. Default is YES (i.e. include subentities)
    
    NSError *err;
    NSUInteger count = [managedObjectContext countForFetchRequest:fetchRequest error:&err];
    if(count == NSNotFound) {
        //Handle error
        NSLog(@"ns not found");
        return NULL;
    }
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"locationId == %@", locationId]];
    NSError *error;
    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    
    NSError * aError;
    
    // try for error
    if (![managedObjectContext save:&aError ]) {
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Update Action"
                                      message:@"Fail"
                                      preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okAlert = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAlert];
    }
    
    DBLocation *locationDB = fetchedObjects[0];
    
    
    Location * requestLocation = [[Location alloc] init];
    
    NSMutableArray * tmpArray = [[NSMutableArray alloc] init];
    
    if ([locationDB.path count] > 0) {
        NSArray * tmp = [locationDB.path allObjects];
        for (int i = 0; i<[locationDB.path count]; i++) {
            GPSPoint *tmpGPS = [[GPSPoint alloc] init];
            tmpGPS.latitude = [tmp[i] latitude];
            tmpGPS.longitude = [tmp[i] longitude];
            [tmpArray addObject:tmpGPS];
        }
    }
    if ([tmpArray count] > 0) {
        requestLocation.path = [NSArray arrayWithArray:tmpArray];
    }
    else {
        requestLocation.point = (GPSPoint*)[[locationDB.point allObjects] firstObject];
    }
    requestLocation.locationId = locationDB.locationId;
    requestLocation.name = locationDB.name;
    requestLocation.descriptionLocation = locationDB.descriptionLocation;
    
    requestLocation.visited = locationDB.visited;
    
    return requestLocation;
}

@end
