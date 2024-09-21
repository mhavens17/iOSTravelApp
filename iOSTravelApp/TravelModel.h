//
//  TravelModel.h
//  iOSTravelApp
//
//  Created by Max Havens on 9/20/24.
//

//#ifndef TravelModel_h
//#define TravelModel_h

// TravelModel.h
#import <Foundation/Foundation.h>

@interface TravelModel : NSObject

@property (nonatomic, strong) NSString *destinationName;
@property (nonatomic, strong) NSString *descriptionText;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSNumber *rating;

- (instancetype)initWithName:(NSString *)name
                 description:(NSString *)descriptionText
                     imageURL:(NSString *)imageURL
                      rating:(NSNumber *)rating;

@end

//#endif /* TravelModel_h */
