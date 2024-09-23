#import "TravelModel.h"

@interface TravelModel ()

// Internal properties
@property (strong, nonatomic) NSArray *destinationNames;
@property (strong, nonatomic) NSDictionary *destinationsDict;

@end

@implementation TravelModel

// Shared instance implementation (Singleton pattern)
+ (TravelModel *)sharedInstance {
    static TravelModel *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[TravelModel alloc] init];
    });
    
    return _sharedInstance;
}

// Lazy initialization of destination names array
- (NSArray *)destinationNames {
    if (!_destinationNames) {
        _destinationNames = @[@"Paris", @"Tokyo", @"New York", @"London", @"Sydney", @"Dubai"];
    }
    return _destinationNames;
}

// Lazy initialization of destinations dictionary
- (NSDictionary *)destinationsDict {
    if (!_destinationsDict) {
        // Create the dictionary with all destinations (no images for now)
        _destinationsDict = @{
            @"Paris": @{
                    @"description": @"Description of Paris.",
                    @"date": [NSDate dateWithTimeIntervalSince1970:1625097600] // Example date
            },
            @"Tokyo": @{
                    @"description": @"Description of Tokyo.",
                    @"date": [NSDate dateWithTimeIntervalSince1970:1635696000] // Example date
            },
            @"New York": @{
                    @"description": @"Description of New York.",
                    @"date": [NSDate dateWithTimeIntervalSince1970:1640995200] // Example date
            },
            @"London": @{
                    @"description": @"Description of London.",
                    @"date": [NSDate dateWithTimeIntervalSince1970:1656633600] // Example date
            },
            @"Sydney": @{
                    @"description": @"Description of Sydney.",
                    @"date": [NSDate dateWithTimeIntervalSince1970:1662316800] // Example date
            },
            @"Dubai": @{
                    @"description": @"Description of Dubai.",
                    @"date": [NSDate dateWithTimeIntervalSince1970:1672444800] // Example date
            }
        };
    }
    return _destinationsDict;
}


// Get destination name by index
- (NSString *)getDestinationNameForIndex:(NSInteger)index {
    return self.destinationNames[index];
}

// Get destination description by name
- (NSString *)getDestinationDescriptionWithName:(NSString *)name {
    return self.destinationsDict[name][@"description"];
}

// Get destination image by name
- (UIImage *)getDestinationImageWithName:(NSString *)name {
    return self.destinationsDict[name][@"image"];
}

// New method: Get destination date by name
- (NSDate *)getDestinationDateWithName:(NSString *)name {
    return self.destinationsDict[name][@"date"];
}

// Get the total number of destinations
- (NSInteger)numberOfDestinations {
    return self.destinationNames.count;
}

@end
