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

@implementation DataRetriever



//- (void) dataRetriever: (DataRetriever *) dataRetriever didFinishSetUpInformation:(NSArray *)dataArray{
//    
//}


- (void) downloadDataFromURLString: (NSString *) urlString{
    
    
}

+(void)saveData: (NSString *)info{
    
    // get the reference to the application to acces the DB
    AppDelegate * appDelegate = [[UIApplication sharedApplication]delegate];
    
    // access to the data through the reference of the application
    NSManagedObjectContext * context = [appDelegate managedObjectContext];
    NSManagedObject * newSpot = [NSEntityDescription insertNewObjectForEntityForName:@"Spots" inManagedObjectContext:context];
    
    [newSpot setValue:@"A content" forKey:@"content"];
    [newSpot setValue:@"Some title" forKey:@"title"];
    [newSpot setValue:@"latitude 1010" forKey:@"latitude"];
    [newSpot setValue:@"longitude 5050" forKey:@"longitude"];

    // create the error object in case if we have to use it
    NSError * aError;
    
    // try for error
    if (![context save:&aError ]) {

        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Save Action"
                                      message:@"Fail"
                                      preferredStyle:UIAlertControllerStyleAlert];
    
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:ok];
        
    
        
    }
    
}

- (void)setUpInformation{
    
    // Get Managed Object Context
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *managedObjectContext = [appDelegate managedObjectContext];
    
    /*
     * Retrieve Values
     */
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Spots" inManagedObjectContext:managedObjectContext]];
    
    
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
        NSLog(@"is the entity null if? : %@",fetchRequest);
        NSLog(@"the count: %lu",(unsigned long)count);
         
      //   [self saveData:@"some"];
        
    }else {
        // brings info from data base
        
        
    }
    
    
    NSLog(@"---------------------");
    
    [self.delegate dataRetriever:self didFinishSetUpInformation:@[@"monday",@"friday",@"sunday"] ];
}

@end
