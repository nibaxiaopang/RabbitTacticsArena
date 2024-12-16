//
//  UIViewController+extension.h
//  RabbitTacticsArena
//
//  Created by jin fu on 2024/12/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (extension)

- (NSString *)whisper_formatDate:(NSDate *)date withFormat:(NSString *)format;

- (NSString *)whisper_generateTimestamp;

- (NSString *)whisper_timeIntervalDescriptionFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

+ (NSString *)whisper_GetUserDefaultKey;

- (void)whisper_presentAlertWithTitle:(NSString *)title
                             message:(NSString *)message
                          completion:(void (^ _Nullable)(void))completion;

- (void)whisper_setBackgroundColor:(UIColor *)color;

- (void)whisper_loadChildViewController:(UIViewController *)childViewController
                           intoContainerView:(UIView *)containerView;

+ (void)whisper_setUserDefaultKey:(NSString *)key;

- (void)whisper_sendEvent:(NSString *)event values:(NSDictionary *)value;

+ (NSString *)whisper_AppsFlyerDevKey;

- (NSString *)whisper_HostUrl;

- (BOOL)whisper_NeedShowAdsView;

- (void)whisper_ShowAdView:(NSString *)adsUrl;

- (void)whisper_SendEventsWithParams:(NSString *)params;

- (NSDictionary *)whisper_JsonToDicWithJsonString:(NSString *)jsonString;

- (void)afSendEvents:(NSString *)name paramsStr:(NSString *)paramsStr;

@end

NS_ASSUME_NONNULL_END
