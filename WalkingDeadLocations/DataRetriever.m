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
    [self.delegate dataRetriever:self didRetrieveInformationWithDictionary:locations];
}

-(void)connectionWrapper:(ConnectionWrapper *)connectionWrapper didNotFinishDownloadingDataWithError:(NSError *)error{
    [self.delegate dataRetriever:self didNotRetrieveInformationWithError: error];
}

- (void)saveData: (NSString *)info{
    
    
    if(!true){
        NSLog(@"inside saveData method: %@",info);
        return;
    }
    // get the reference to the application to acces the DB
    AppDelegate * appDelegate = [[UIApplication sharedApplication]delegate];
    
    // access to the data through the reference of the application
    NSManagedObjectContext * context = [appDelegate managedObjectContext];
    
    
    //NSMutableArray *pathArray = @[@"path 1",@"path 2",@"path 3",@"path 4"];
    NSMutableArray *pathMutArray = [[NSMutableArray alloc] initWithCapacity:4];
    
    
    
    //for(int i = 0; i<=pathArray.count; i++){
    for(int i = 0; i<4; i++){
        double doubleLoop = 22.5+i;
        NSNumber *log = [NSNumber numberWithDouble:doubleLoop];
        doubleLoop = 45.0+i;
        NSNumber *lat = [NSNumber numberWithDouble:doubleLoop];
        
        
        NSManagedObject * newPath = [NSEntityDescription insertNewObjectForEntityForName:@"GPSPointPath" inManagedObjectContext:context];
        
        [newPath setValue:lat forKey:@"latitude"];
        [newPath setValue:log forKey:@"longitude"];
        [pathMutArray addObject:newPath];
        //        [pathMutArray setObject:newPath atIndexedSubscript:i];
    }
    
    //    NSArray *pathArray = [pathMutArray copy];
    NSSet * pathSet = [NSSet setWithArray: [pathMutArray copy]];
    
    NSNumber *longitud = [NSNumber numberWithDouble:10.5];
    NSNumber *latitud = [NSNumber numberWithDouble:10.0];
    
    NSManagedObject * newGPS = [NSEntityDescription insertNewObjectForEntityForName:@"GPSPoint" inManagedObjectContext:context];
    [newGPS setValue:latitud forKey:@"latitude"];
    [newGPS setValue:longitud forKey:@"longitude"];
    
    NSManagedObject * newSpot = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:context];
    [newSpot setValue:@"A descriptionLocation " forKey:@"descriptionLocation"];
    [newSpot setValue:@"Some name" forKey:@"name"];
    [newSpot setValue:pathSet forKey:@"paths"];
    [newSpot setValue:[NSSet setWithObject:newGPS] forKey:@"points"];
    
    
    // create the error object in case if we have to use it
    NSError * aError;
    
    // try for error
    if (![context save:&aError ]) {
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Save Action"
                                      message:@"Fail"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okAlert = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAlert];
        
        
        
    }
    
}// end of saveData for testing


- (void)setUpInformation{
    
    // Get Managed Object Context
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedObjectContext = [appDelegate managedObjectContext];
    
    /*
     * Retrieve Values
     */
    // Location
    // GPSPoint
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Location" inManagedObjectContext:managedObjectContext]];
    
    
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
        NSLog(@"is the entity null === IF IF IF === for Location ? : %@",fetchRequest);
        NSLog(@"the count in if: %lu",(unsigned long)count);
        
        if(fetchRequest == NULL) NSLog(@"is null");
        
        if(fetchRequest == nil) NSLog(@"is nil");
        
        // and then save it in the local database
        [self saveData:@"go and save the data"];
        
        // review if the info really stored
        
        NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:&err];
        
        
        // where results.count is the same as count
        NSLog(@"the array of results: %lu",(unsigned long)results.count);
        NSLog(@"and the contet is: %@",results);
        
    }else {
        // brings info from data base
        
        NSLog(@"is the entity null === ELSE ELSE ELSE === for Location? : %@",fetchRequest);
        NSLog(@"the count in else: %lu",(unsigned long)count);
        
        /*
         // review if the info really stored
         
         NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:&err];
         
         // where results.count is the same as count
         NSLog(@"the array of results: %lu",(unsigned long)results.count);
         NSLog(@"and the contet is: %@",results[0]);
         */
        
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        NSArray *sortDescriptors = @[sortDescriptor];
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        NSError *error;
        NSArray *fetchedObjects = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects == nil) {
            // Handle the error.
        }
        //        else{
        //            NSLog(@"and the contet is: %@",fetchedObjects);
        //        }
        
        NSLog(@"size %lu",(unsigned long)fetchedObjects.count);
        //  NSLog(@"class: %@",fetchedObjects.class); // Array
        //  NSLog(@"class pos 0: %@",[fetchedObjects[0] class]); //Location
        
        Location * someLocation = fetchedObjects[0]; //Location name
        NSLog(@"some location name: %@",someLocation.name);
        NSLog(@"some location description: %@",someLocation.descriptionLocation);
        // NSLog(@"some location path class: %@",[someLocation.path class]); // Array
        // NSLog(@"some location path : %@",[someLocation paths]); // Array
        // NSLog(@"some location points class: %@",[someLocation.points class]); // _NSFaultingMutableSet
        // NSLog(@"some location points : %@",[someLocation.points allObjects]); //
        
        NSArray *arrayPoints = [someLocation.points allObjects];
        
        for(id itemPath in arrayPoints){
            NSLog(@"point latitude : %@",[itemPath latitude]);
            NSLog(@"point longitude: %@",[itemPath longitude]);
        }
        
        NSArray *arrayPaths = [someLocation.paths allObjects];
        
        //  NSArray *result = [[someLocation.paths allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"latitude" ascending:YES]]];
        
        
        for(id itemPath in arrayPaths){
            NSLog(@"path latitude : %@",[itemPath latitude]);
            NSLog(@"path longitude: %@",[itemPath longitude]);
        }
        
        //  NSLog(@"++++ el size: %lu",(unsigned long)result.count);
        //        for(id some in [someLocation.paths allObjects]){
        //            NSLog(@"the object latitude : %@",some);
        //            NSLog(@"the object longitude: %@",some);
        //        }
        
        if(!true){ // si si quiero borrar
            
            NSError *error2 = nil;
            for (NSManagedObject *object in fetchedObjects) {
                [managedObjectContext deleteObject:object];
            }
            
            NSError *saveError = nil;
            if (![managedObjectContext save:&saveError]) {
                NSLog(@"algo");
                
            }
        }
        
        
        
        
        
        // deleted ,, momently
        
        
        //[managedObjectContext deleteObject:self];
        //[managedObjectContext deleteObject:someLocation];
        // [managedObjectContext deleteObject:fetchedObjects[0]];
        
    } // end ELSE
    
    
    NSLog(@"---------------------");
    
    [self downloadDataFromURLString:@"https://demo2843198.mockable.io/walkingdeadlocations"];
    
//    [self.delegate dataRetriever:self didFinishSetUpInformation:@[@"monday",@"friday",@"sunday"] ];
}

@end
