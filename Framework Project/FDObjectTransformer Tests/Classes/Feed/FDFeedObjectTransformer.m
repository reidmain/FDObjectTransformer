#import "FDFeedObjectTransformer.h"

#import "FDKeypath.h"
#import "FDObjectDescriptor.h"
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
	
	FDObjectDescriptor *feedPageDescriptor = [FDObjectDescriptor new];
	[feedPageDescriptor registerRemoteKeyPath: @"meta.page" 
		forLocalKey: @keypath(FDFeedPage, page)];
	[feedPageDescriptor registerRemoteKeyPath: @"meta.next" 
		forLocalKey: @keypath(FDFeedPage, nextIdentifier)];
	[feedPageDescriptor registerCollectionType: [FDFeedItem class] 
		forPropertyName: @keypath(FDFeedPage, items)];
	[self registerDescriptor: feedPageDescriptor forClass: [FDFeedPage class]];
	
	FDObjectDescriptor *feedItemDescriptor = [FDObjectDescriptor new];
	[feedItemDescriptor registerRemoteKeyPath: @"id" 
		forLocalKey: @keypath(FDFeedItem, itemID)];
	feedItemDescriptor.classClusterBlock = ^ Class (id from, Class targetClass)
		{
			if ([from isKindOfClass: [NSDictionary class]] == YES)
			{
				NSString *type = from[@"type"];
				
				if ([type isEqualToString: @"ad"] == YES)
				{
					targetClass = [FDFeedAd class];
				}
				else if ([type isEqualToString: @"link"] == YES)
				{
					targetClass = [FDFeedLink class];
				}
				else if ([type isEqualToString: @"photo"] == YES)
				{
					targetClass = [FDFeedPhoto class];
				}
				else if ([type isEqualToString: @"status"] == YES)
				{
					targetClass = [FDFeedStatus class];
				}
			}
			
			return targetClass;
		};
	[self registerDescriptor: feedItemDescriptor 
		forClass: [FDFeedItem class]];
	
	// Return initialized instance.
	return self;
}


@end