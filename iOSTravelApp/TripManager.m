//
//  TripManager.m
//  iOSTravelApp
//
//  Created by Claudia on 9/22/24.
//

#import "TripManager.h"
#import "iOSTravelApp-Swift.h"

@implementation TripManager

+ (instancetype)sharedManager {
    static TripManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)saveTripWithDestination:(NSString *)destination startDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    TripModel *newTrip = [[TripModel alloc] initWithDestination:destination
                                                      startDate:startDate
                                                        endDate:endDate
                                                     isFavorite:NO
                                                      itinerary:@[]
                                                    packingList:@[]];
    NSMutableArray *trips = [self getAllTripsAsMutableArray];
    [trips addObject:newTrip];
    [self saveTripsToDisk:trips];
}


- (NSArray<TripModel *> *)getAllTrips {
    return [self getAllTripsAsMutableArray];
}

- (void)updateTrip:(TripModel *)trip {
    NSMutableArray *trips = [self getAllTripsAsMutableArray];
    NSUInteger index = [trips indexOfObjectPassingTest:^BOOL(TripModel *obj, NSUInteger idx, BOOL *stop) {
        return [obj.id isEqual:trip.id];
    }];
    
    if (index != NSNotFound) {
        trips[index] = trip;
        [self saveTripsToDisk:trips];
    }
}

- (void)deleteTrip:(TripModel *)trip {
    NSMutableArray *trips = [self getAllTripsAsMutableArray];
    [trips removeObject:trip];
    [self saveTripsToDisk:trips];
}

#pragma mark - Private Methods

- (NSMutableArray<TripModel *> *)getAllTripsAsMutableArray {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedTrips"];
    if (data) {
        NSError *error = nil;
        NSArray *trips = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (!error && [trips isKindOfClass:[NSArray class]]) {
            NSMutableArray *tripModels = [NSMutableArray array];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
            
            for (NSDictionary *tripDict in trips) {
                NSDate *startDate = [dateFormatter dateFromString:tripDict[@"startDate"]];
                NSDate *endDate = [dateFormatter dateFromString:tripDict[@"endDate"]];
                
                TripModel *trip = [[TripModel alloc] initWithDestination:tripDict[@"destination"]
                                                               startDate:startDate
                                                                 endDate:endDate
                                                              isFavorite:[tripDict[@"isFavorite"] boolValue]
                                                               itinerary:tripDict[@"itinerary"]
                                                             packingList:tripDict[@"packingList"]];
                [tripModels addObject:trip];
            }
            return tripModels;
        }
    }
    return [NSMutableArray array];
}

- (void)saveTripsToDisk:(NSArray<TripModel *> *)trips {
    NSMutableArray *tripsArray = [NSMutableArray array];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    
    for (TripModel *trip in trips) {
        [tripsArray addObject:@{
            @"id": [trip.id UUIDString],
            @"destination": trip.destination,
            @"startDate": [dateFormatter stringFromDate:trip.startDate],
            @"endDate": [dateFormatter stringFromDate:trip.endDate],
            @"isFavorite": @(trip.isFavorite),
            @"itinerary": trip.itinerary,
            @"packingList": trip.packingList
        }];
    }
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:tripsArray options:0 error:&error];
    if (!error) {
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"savedTrips"];
    } else {
        NSLog(@"Error saving trips: %@", error.localizedDescription);
    }
}

- (void)updateItineraryForTrip:(NSUUID *)tripId withItinerary:(NSArray<NSString *> *)itinerary {
    // Get the mutable array of all trips
    NSMutableArray *trips = [self getAllTripsAsMutableArray];
    
    // Find the trip by its unique ID
    NSUInteger index = [trips indexOfObjectPassingTest:^BOOL(TripModel *obj, NSUInteger idx, BOOL *stop) {
        return [obj.id isEqual:tripId];
    }];
    
    // If trip is found, update the itinerary
    if (index != NSNotFound) {
        TripModel *trip = trips[index];
        trip.itinerary = itinerary; // Update the itinerary
        [self saveTripsToDisk:trips]; // Save all trips back to disk
    } else {
        NSLog(@"Trip not found to update itinerary.");
    }
}


@end
