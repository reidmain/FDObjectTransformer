@import Foundation;
#import "FDColor+Creation.h"


#pragma mark - Enumerations

typedef NS_ENUM(NSUInteger, FDTwitchChannelLanguage) {
    FDTwitchChannelLanguageUnknown,
    FDTwitchChannelLanguageEnglish,
    FDTwitchChannelLanguageChinese,
	FDTwitchChannelLanguageTaiwanese,
};


#pragma mark - Class Interface

@interface FDTwitchChannel : NSObject


#pragma mark - Properties

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *displayName;
@property (nonatomic, copy, readonly) NSString *status;
@property (nonatomic, copy, readonly) NSString *gameName;
@property (nonatomic, assign, readonly) BOOL isMature;
@property (nonatomic, assign, readonly) BOOL isPartner;
@property (nonatomic, copy, readonly) NSURL *profileBannerURL;
@property (nonatomic, copy, readonly) UIColor *profileBannerBackgroundColor;
@property (nonatomic, assign, readonly) NSUInteger viewCount;
@property (nonatomic, assign, readonly) NSUInteger followerCount;
@property (nonatomic, copy, readonly) NSDate *createdAt;
@property (nonatomic, copy, readonly) NSDate *updatedAt;
@property (nonatomic, assign, readonly) FDTwitchChannelLanguage language;
@property (nonatomic, assign, readonly) FDTwitchChannelLanguage broadcasterLanguage;


@end
