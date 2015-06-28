#import "FDFeedObjectTransformer.h"

#import "FDKeypath.h"
#import "FDJSONObjectTransformerAdapter.h"
#import "FDFeedPage.h"


#pragma mark - Class Definition

@implementation FDFeedObjectTransformer


#pragma mark - Constructors

- (id)init
{
	// Abort if base initializer fails.
	if ((self = [super init]) == nil)
	{
		return nil;
	}
	
	NSDateFormatter *dateFormatter = [NSDateFormatter new];
	dateFormatter.locale = [NSLocale localeWithLocaleIdentifier: @"en_US_POSIX"];
	dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation: @"UTC"];
	dateFormatter.dateFormat = @"MM/dd/yyyy HH:mm:ss";
	self.dateFormatter = dateFormatter;
	
	FDJSONObjectTransformerAdapter *feedPageJSONAdapter = [FDJSONObjectTransformerAdapter adapterForClass: [FDFeedPage class]];
	[feedPageJSONAdapter registerRemoteKeyPath: @"meta.page" 
		forLocalKey: @keypath(FDFeedPage, page)];
	[feedPageJSONAdapter registerRemoteKeyPath: @"meta.next" 
		forLocalKey: @keypath(FDFeedPage, nextIdentifier)];
	[feedPageJSONAdapter registerCollectionType: [FDFeedItem class] 
		forPropertyName: @keypath(FDFeedPage, items)];
	[self registerJSONAdapter: feedPageJSONAdapter];
	
	FDJSONObjectTransformerAdapter *feedItemJSONAdapter = [FDJSONObjectTransformerAdapter adapterForClass: [FDFeedItem class]];
	[feedItemJSONAdapter registerRemoteKeyPath: @"id" 
		forLocalKey: @keypath(FDFeedItem, itemID)];
	[self registerJSONAdapter: feedItemJSONAdapter];
	
	// Return initialized instance.
	return self;
}


@end