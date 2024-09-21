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
        _destinationsDict = @{
            @"Paris": @{
                    @"description": @"Description of Paris.",
                    @"image": [UIImage imageNamed:@"paris.jpg"]
            },
            @"Tokyo": @{
                    @"description": @"Description of Tokyo.",
                    @"image": [UIImage imageNamed:@"tokyo.jpg"]
            },
            @"New York": @{
                    @"description": @"Description of New York.",
                    @"image": [UIImage imageNamed:@"nyc.jpg"]
            },
            @"London": @{
                    @"description": @"Description of London.",
                    @"image": [UIImage imageNamed:@"london.jpg"]
            },
            @"Sydney": @{
                    @"description": @"Description of Sydney.",
                    @"image": [UIImage imageNamed:@"sydney.jpg"]
            },
            @"Dubai": @{
                    @"description": @"Description of Dubai.",
                    @"image": [UIImage imageNamed:@"dubai.jpg"]
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

// Get the total number of destinations
- (NSInteger)numberOfDestinations {
    return self.destinationNames.count;
}

@end
