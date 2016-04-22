//
//  ParsingWrapper.m
//  WalkingDeadLocations
//
//  Created by MCS on 3/30/16.
//  Copyright © 2016 MCS. All rights reserved.
//

#import "ParsingWrapper.h"
#import "Location.h"
#import "GPSPoint.h"

@interface ParsingWrapper ()

@property (strong, nonatomic) NSMutableDictionary *dictSeasonLocations;
@property (strong, nonatomic) NSMutableArray *arrCurrentSeasonLocations;

@end

@implementation ParsingWrapper

-(instancetype)init{
    self = [super init];
    if (self) {
        self.dictSeasonLocations = [[NSMutableDictionary alloc] initWithCapacity:6];
        self.arrCurrentSeasonLocations = [[NSMutableArray alloc] initWithCapacity:50];
    }
    
    return self;
}

-(void) parseData: (NSData *) data {
    
    NSError *error;
    
    // Convert JSON data to NSDictionary
    NSDictionary *locData = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingAllowFragments
                                                              error:&error];
    if (error) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.delegate parsingWrapper:self didNotFinishParsingWithError: error];
        });
    }
    
    else{
        NSDictionary *document = [locData objectForKey:@"Document"];
        NSArray *folder = [document objectForKey:@"Folder"];
        
        
        for (NSDictionary *season in folder) {
            NSString *seasonName = [season objectForKey:@"name"];
            
            NSArray *seasonLocations = [season objectForKey:@"Placemark"];
            
            self.arrCurrentSeasonLocations = [[NSMutableArray alloc] initWithCapacity:[seasonLocations count]];
            
            for (NSDictionary *location in seasonLocations) {
                Location *newLocation = [[Location alloc] init];
                newLocation.name = [location objectForKey:@"name"];
                NSDictionary *dictDescription = [location objectForKey:@"description"];
                
                newLocation.descriptionLocation = [dictDescription objectForKey:@"__cdata"];
                
                NSDictionary *currentPoint = [[NSDictionary alloc] initWithDictionary:[location objectForKey:@"Point"]];
                
                if ([[currentPoint allKeys] count] == 0) {
                    NSMutableArray *arrGPSPoints = [[NSMutableArray alloc] initWithCapacity:10];
                    currentPoint = [[NSDictionary alloc] initWithDictionary:[location objectForKey:@"LineString"]];
                    NSString *strPoints = [currentPoint objectForKey:@"coordinates"];
                    NSArray *arrCoordinates = [[NSArray alloc] initWithArray:[strPoints componentsSeparatedByString:@" "]];
                    
                    for (NSString *strPoint in arrCoordinates) {
                        NSArray *arrPoint = [[NSArray alloc] initWithArray:[strPoint componentsSeparatedByString:@","]];
                        if ([arrPoint count] > 2) {
                            GPSPoint *point = [[GPSPoint alloc] init];
                            point.latitude = [NSNumber numberWithDouble:[[arrPoint objectAtIndex:1] doubleValue]];
                            point.longitude = [NSNumber numberWithDouble:[[arrPoint objectAtIndex:0] doubleValue]];
                            [arrGPSPoints addObject:point];
                        }
                    }
                    // TODO change paths
                    // newLocation.path = arrGPSPoints;
                }
                else {
                    NSString *strCoord = [currentPoint objectForKey:@"coordinates"];
                    NSArray *arrCoordinates = [[NSArray alloc] initWithArray:[strCoord componentsSeparatedByString:@","]];
                    
                    if ([arrCoordinates count] > 2) {
                        // TODO change points
                        /*
                        newLocation.point.latitude = [NSNumber numberWithDouble:[[arrCoordinates objectAtIndex:1] doubleValue]];
                        newLocation.point.longitude = [NSNumber numberWithDouble:[[arrCoordinates objectAtIndex:0] doubleValue]];
                        */
                    }
                }
                
                
                [self.arrCurrentSeasonLocations addObject:newLocation];
            }
            [self.dictSeasonLocations setObject:[NSArray arrayWithArray:self.arrCurrentSeasonLocations] forKey:seasonName];
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.delegate parsingWrapper:self didFinishParsingWithLocations: [[NSDictionary alloc] initWithDictionary: self.dictSeasonLocations]];
        });
    }
}

@end

