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
	feedItemDescriptor.instanceBlock = ^id(id object, Class targetClass)
		{
			if ([object isKindOfClass: [NSDictionary class]] == YES)
			{
				NSString *type = object[@"type"];
				
				if ([type isEqualToString: @"ad"] == YES)
				{
					return [FDFeedAd new];
				}
				else if ([type isEqualToString: @"link"] == YES)
				{
					return [FDFeedLink new];
				}
				else if ([type isEqualToString: @"photo"] == YES)
				{
					return [FDFeedPhoto new];
				}
				else if ([type isEqualToString: @"status"] == YES)
				{
					return [FDFeedStatus new];
				}
			}
			
			return nil;
		};
	[self registerDescriptor: feedItemDescriptor 
		forClass: [FDFeedItem class]];
	
	// Return initialized instance.
	return self;
}


@end