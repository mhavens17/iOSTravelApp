//NOW UNUSED...NOW USES TRIPMANAGER


//
//  TravelModel.h
//  iOSTravelApp
//
//  Created by Max Havens on 9/20/24.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TravelModel : NSObject

@property (strong, nonatomic, readonly) NSArray *destinationNames;

// Shared instance (singleton)
+ (TravelModel *)sharedInstance;

// Methods to retrieve data
- (NSString *)getDestinationNameForIndex:(NSInteger)index;
- (NSString *)getDestinationDescriptionWithName:(NSString *)name;
- (UIImage *)getDestinationImageWithName:(NSString *)name;
- (NSDate *)getDestinationDateWithName:(NSString *)name;
- (NSInteger)numberOfDestinations;

@end
