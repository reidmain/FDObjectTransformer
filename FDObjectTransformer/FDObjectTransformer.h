#import <Foundation/Foundation.h>


#pragma mark Constants


#pragma mark - Enumerations


#pragma mark - Class Interface

/**
FDObjectTransformer allows developers to convert an instance of class A into an instance of class B as long as a transformation is defined.

FDObjectTransformer has a number of transformations that it comes with out of the box:
Anything to NSString
*/
@interface FDObjectTransformer : NSObject


#pragma mark - Properties

/**
The date formatter to use whenever transforming to or from a NSDate.
*/
@property (nonatomic, strong) NSDateFormatter *dateFormatter;


#pragma mark - Constructors


#pragma mark - Static Methods


#pragma mark - Instance Methods

/**
Attempt to convert from into an instance of the specified objectClass.

@param objectClass The class that from should be transformed into.
@param from The object to transform.

@return An instance of objectClass if a transformation from the class of from to the object class exists.
*/
- (id)objectOfClass: (Class)objectClass from:(id)from;


@end