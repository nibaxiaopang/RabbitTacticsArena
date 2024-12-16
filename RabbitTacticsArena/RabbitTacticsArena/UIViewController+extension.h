//
//  UIViewController+extension.h
//  RabbitTacticsArena
//
//  Created by jin fu on 2024/12/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (extension)

- (NSString *)rabbit_formatDate:(NSDate *)date withFormat:(NSString *)format;

- (NSString *)rabbit_generateTimestamp;

- (NSString *)rabbit_timeIntervalDescriptionFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

+ (NSString *)rabbit_GetUserDefaultKey;

- (void)rabbit_presentAlertWithTitle:(NSString *)title
                             message:(NSString *)message
                          completion:(void (^ _Nullable)(void))completion;

- (void)rabbit_setBackgroundColor:(UIColor *)color;

- (void)rabbit_loadChildViewController:(UIViewController *)childViewController
                           intoContainerView:(UIView *)containerView;

+ (void)rabbit_setUserDefaultKey:(NSString *)key;

- (void)rabbit_sendEvent:(NSString *)event values:(NSDictionary *)value;

+ (NSString *)rabbit_AppsFlyerDevKey;

- (NSString *)rabbit_HostUrl;

- (BOOL)rabbit_NeedShowAdsView;

- (void)rabbit_ShowAdView:(NSString *)adsUrl;

- (void)rabbit_SendEventsWithParams:(NSString *)params;

- (NSDictionary *)rabbit_JsonToDicWithJsonString:(NSString *)jsonString;

- (void)afSendEvents:(NSString *)name paramsStr:(NSString *)paramsStr;

@end

NS_ASSUME_NONNULL_END
