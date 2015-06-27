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
@property (nonatomic, copy, readonly) NSString *game;
@property (nonatomic, assign, readonly) BOOL mature;
@property (nonatomic, assign, readonly) BOOL partner;
@property (nonatomic, copy, readonly) NSURL *profileBanner;
@property (nonatomic, copy, readonly) FDColor *profileBannerBackgroundColor;
@property (nonatomic, assign, readonly) NSUInteger views;
@property (nonatomic, assign, readonly) NSUInteger followers;
@property (nonatomic, copy, readonly) NSDate *createdAt;
@property (nonatomic, copy, readonly) NSDate *updatedAt;
@property (nonatomic, assign, readonly) FDTwitchChannelLanguage language;
@property (nonatomic, assign, readonly) FDTwitchChannelLanguage broadcasterLanguage;


@end
