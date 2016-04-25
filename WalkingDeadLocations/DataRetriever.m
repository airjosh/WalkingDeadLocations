//
//  DataRetriever.m
//  WalkingDeadLocations
//
//  Created by MCS on 3/31/16.
//  Copyright © 2016 MCS. All rights reserved.
//

#import "DataRetriever.h"
#import "SpotDetailCell.h"
#import "AppDelegate.h"
#import "Location.h"
#import "GPSPoint.h"
#import "ConnectionWrapper.h"
#import "DBLocation.h"
#import "DBGPSPoint.h"



@interface DataRetriever()<ConnectionWrapperDelegate>

@property (strong, nonatomic) ConnectionWrapper *connectionWrapper;

@end


@implementation DataRetriever

-(instancetype)init{
    self = [super init];
    
    if (self) {
        self.connectionWrapper = [[ConnectionWrapper alloc] init];
        self.connectionWrapper.delegate = self;
    }
    return self;
}

//- (void) dataRetriever: (DataRetriever *) dataRetriever didFinishSetUpInformation:(NSArray *)dataArray{
//    
//}


- (void) downloadDataFromURLString: (NSString *) urlString{
    
//    [self performSelectorOnMainThread:@selector(saveData:) withObject:nil waitUntilDone:NO];
    
    [self.connectionWrapper downloadDataFromURLString:urlString];
}

#pragma mark - ConnectionWrapperDelegate

-(void)connectionWrapper:(ConnectionWrapper *)connectionWrapper didFinishDownloadingDataWithLocations:(NSDictionary *)locations{
    
    // code to save the data here
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        
//    });
    
    
    dispatch_async(dispatch_queue_create("saveDBQueue", 0), ^{
        [self saveData:locations];
    });
//    [self.delegate dataRetriever:self didRetrieveInformationWithDictionary:locations];
}

-(void)connectionWrapper:(ConnectionWrapper *)connectionWrapper didNotFinishDownloadingDataWithError:(NSError *)error{
    [self.delegate dataRetriever:self didNotRetrieveInformationWithError: error];
}

- (void)saveData: (NSDictionary *)infoDictionary{

    // get the reference to the application to acces the DB
    AppDelegate * appDelegate = [[UIApplication sharedApplication]delegate];
    
    // access to the data through the reference of the application
    NSManagedObjectContext * context = [appDelegate managedObjectContext];
    
    NSDictionary * dictSeasonsList = [[NSDictionary alloc] initWithDictionary:infoDictionary];
    NSArray * arrSeasons = [NSMutableArray arrayWithArray:[dictSeasonsList allKeys]];
    
    arrSeasons = [arrSeasons sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSArray *currentSeason = [[NSArray alloc] init];
    for (NSString *season in arrSeasons) {
        currentSeason = [dictSeasonsList objectForKey:season];
        for (Location *currentLocation in currentSeason) {
            
            NSMutableArray *pathMutArray = [[NSMutableArray alloc] initWithCapacity:40];
            if(currentLocation.path != NULL || currentLocation.path.count > 0){
                
                for(int i = 0; i<currentLocation.path.count; i++){
                    NSNumber *log = [NSNumber numberWithDouble:[[currentLocation.path[i] longitude] doubleValue]];
                    NSNumber *lat = [NSNumber numberWithDouble:[[currentLocation.path[i] latitude] doubleValue]];
                    NSManagedObject * newPath = [NSEntityDescription insertNewObjectForEntityForName:@"DBGPSPointPath" inManagedObjectContext:context];
                    
                    [newPath setValue:lat forKey:@"latitude"];
                    [newPath setValue:log forKey:@"longitude"];
                    [pathMutArray addObject:newPath];
                }
            }
            
            NSSet    *pathSet  = [NSSet setWithArray: [pathMutArray copy]];
            NSNumber *longitud = [NSNumber numberWithDouble:[currentLocation.point.longitude doubleValue]];
            NSNumber *latitud  = [NSNumber numberWithDouble:[currentLocation.point.latitude doubleValue]];
            
            NSManagedObject * newGPS = [NSEntityDescription insertNewObjectForEntityForName:@"DBGPSPoint" inManagedObjectContext:context];
            [newGPS setValue:latitud forKey:@"latitude"];
            [newGPS setValue:longitud forKey:@"longitude"];
            
            NSManagedObject * newSpot = [NSEntityDescription insertNewObjectForEntityForName:@"DBLocation" inManagedObjectContext:context];
            
            [newSpot setValue:currentLocation.descriptionLocation forKey:@"descriptionLocation"];
            [newSpot setValue:currentLocation.name forKey:@"name"];
            [newSpot setValue:pathSet forKey:@"path"];
//            [newSpot setValue:[[NSUUID UUID] UUIDString]  forKey:@"locationId"];
            [newSpot setValue:currentLocation.locationId   forKey:@"locationId"];
//            [newSpot setValue:[NSNumber numberWithBool:NO] forKey:@"visited"];
            [newSpot setValue:currentLocation.visited forKey:@"visited"];
            [newSpot setValue:[NSSet setWithObject:newGPS] forKey:@"point"];
            [newSpot setValue:season forKey:@"season"];
            
            // create the error object in case if we have to use it
//            NSError * aError;
            
            // try for error
//            if (![context save:&aError ]) {
//                
//                UIAlertController * alert=   [UIAlertController
//                                              alertControllerWithTitle:@"Save Action"
//                                              message:@"Fail"
//                                              preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction* okAlert = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//                [alert addAction:okAlert];
//            }
            
        }// fin for
    }
    
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self.delegate dataRetriever:self didRetrieveInformationWithDictionary:infoDictionary];
    });
    
    
}// end of saveData for testing


- (void)setUpInformation{
    
    dispatch_block_t block = ^
    {
        @synchronized(self){
            
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
            
            if(count <= 0){
                // brings info from URL
                
                NSLog(@"Not info found in database. Retrieve from URL.");
                [self downloadDataFromURLString:@"https://demo2843198.mockable.io/walkingdeadlocations"];
                managedObjectContext = nil;
                fetchRequest = nil;
                appDelegate = nil;
            }else {
                // brings info from data base
                NSLog(@"brings info from data base");
                NSMutableDictionary * locations = [[NSMutableDictionary alloc] init];
                
                NSArray *keys = [NSArray arrayWithObjects:@"Season 1", @"Season 2",@"Season 3",@"Season 4",@"Season 5",@"Season 6", nil];
                for (NSString *key in keys) {
                    
                    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"season == %@", key]];
                    NSError *error;
                    NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
                    if (fetchedObjects == nil) {
                        // Handle the error.
                        NSLog(@"error on retrieve info from the database: %@",error);
                        return;
                    }
                    
                    NSMutableArray *objects = [[NSMutableArray alloc]init ];
                    
                    for(DBLocation * locationDB in fetchedObjects){
                        
                        Location * someLocation = [[Location alloc] init];
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
                            someLocation.path = [NSArray arrayWithArray:tmpArray];
                        }
                        else {
                            someLocation.point = (GPSPoint*)[[locationDB.point allObjects] firstObject];
                        }
                        someLocation.locationId = locationDB.locationId;
                        someLocation.name = locationDB.name;
                        someLocation.descriptionLocation = locationDB.descriptionLocation;
                        
                        someLocation.visited = locationDB.visited;
                        
                        [objects addObject:someLocation];
                    }
                    
                    [locations setObject:objects forKey:key];
                }
                
                [self.delegate dataRetriever:self didRetrieveInformationWithDictionary:[NSDictionary dictionaryWithDictionary:locations]];
                
            } // end ELSE
                        
            NSLog(@"---------------------");

        }
    };
    
    if ([NSThread isMainThread])
    {
        block();
    }
    else
    {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
    
    
}// end of setUpInformation

@end
