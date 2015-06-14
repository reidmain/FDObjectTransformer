#import "FDURLComponentsTransformerAdapter.h"

@implementation FDURLComponentsTransformerAdapter

- (id)transformObject:(id)object intoClass:(Class)targetClass fromObjectTransformer: (FDObjectTransformer *)objectTransformer;
{
	id transformedObject = nil;
	
	if ([object isKindOfClass: [NSURL class]] == YES)
	{
		transformedObject = [NSURLComponents componentsWithURL: object resolvingAgainstBaseURL:YES];
	}
	else if ([object isKindOfClass: [NSString class]] == YES)
	{
		transformedObject = [NSURLComponents componentsWithString: object];
	}
	
	return transformedObject;
}

@end
