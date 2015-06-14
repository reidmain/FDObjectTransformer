@import Foundation;

#pragma mark Forward Declarations


#pragma mark - Protocol

@protocol FDObjectTransformerAdapter


#pragma mark - Required Methods

@required

- (id)transformObject:(id)object intoClass:(Class)targetClass;


#pragma mark - Optional Methods

@optional


@end