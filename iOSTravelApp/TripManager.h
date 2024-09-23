//
//  TripManager.h
//  iOSTravelApp
//
//  Created by Claudia on 9/22/24.
//

#import <Foundation/Foundation.h>

@class TripModel;

NS_ASSUME_NONNULL_BEGIN

@interface TripManager : NSObject

+ (instancetype)sharedManager;

- (void)saveTripWithDestination:(NSString *)destination
                      startDate:(NSDate *)startDate
                        endDate:(NSDate *)endDate;

- (NSArray<TripModel *> *)getAllTrips;

- (void)updateTrip:(TripModel *)trip;

- (void)deleteTrip:(TripModel *)trip;

- (void)updateItineraryForTrip:(NSUUID *)tripId withItinerary:(NSArray<NSString *> *)itinerary;


@end

NS_ASSUME_NONNULL_END
