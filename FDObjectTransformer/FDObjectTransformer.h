@import Foundation;
#import "FDColor+Creation.h"
#import "FDObjectTransformerAdapter.h"
#import "FDJSONObjectTransformerAdapter.h"


#pragma mark Constants


#pragma mark - Enumerations


#pragma mark - Class Interface

/**
FDObjectTransformer allows developers to convert an instance of class A into an instance of class B as long as a transformation is defined.

FDObjectTransformer has a number of transformations that it comes with out of the box:
Anything to NSString
NSString to NSNumber
NSString to NSDate
NSString to NSURL
NSNumber to a UIColor or NSColor
NSString to a UIColor or NSColor
Anything to NSDictionary
An NSArray to anything. This is a edge case scenario where the array itself is not transformed but every element in the array is instead.
*/
@interface FDObjectTransformer : NSObject


#pragma mark - Properties

/**
The date formatter to use whenever transforming to or from an NSDate.
*/
@property (nonatomic, strong) NSDateFormatter *dateFormatter;


#pragma mark - Constructors


#pragma mark - Instance Methods

/**
Attempt to convert from into an instance of the specified objectClass.

@param objectClass The class that from should be transformed into.
@param from The object to transform.

@return An instance of objectClass if a transformation from the class of from to the object class exists.
*/
- (id)objectOfClass: (Class)objectClass 
	from: (id)from;

- (void)registerAdapter: (id<FDObjectTransformerAdapter>)adapter 
	fromClass: (Class)fromClass 
	toClass: (Class)toClass;

- (void)registerJSONAdapter:(FDJSONObjectTransformerAdapter *)adapter;


@end