#import "TravelModel.h"

@implementation TravelModel

- (instancetype)initWithName:(NSString *)name description:(NSString *)descriptionText imageURL:(NSString *)imageURL rating:(NSNumber *)rating {
    self = [super init];
    if (self) {
        _destinationName = name;
        _descriptionText = descriptionText;
        _imageURL = imageURL;
        _rating = rating;
    }
    return self;
}

@end
