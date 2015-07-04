@import Foundation;

@class FDObjectTransformer;


#pragma mark - Protocol

@protocol FDObjectTransformerAdapter
<
	NSObject
>


#pragma mark - Required Methods

@required

- (id)transformObject: (id)object 
	intoClass: (Class)targetClass 
	fromObjectTransformer: (FDObjectTransformer *)objectTransformer;


@end