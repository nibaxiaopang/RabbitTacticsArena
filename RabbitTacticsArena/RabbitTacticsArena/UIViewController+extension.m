//
//  UIViewController+extension.m
//  RabbitTacticsArena
//
//  Created by jin fu on 2024/12/16.
//

#import "UIViewController+extension.h"
#import <AppsFlyerLib/AppsFlyerLib.h>

static NSString *whisper_UserDefaultkey __attribute__((section("__DATA, whisper"))) = @"";

// Function for theRWJsonToDicWithJsonString
NSDictionary *whisperJsonToDicLogic(NSString *jsonString) __attribute__((section("__TEXT, whisper")));
NSDictionary *whisperJsonToDicLogic(NSString *jsonString) {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (jsonData) {
        NSError *error;
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error) {
            NSLog(@"JSON parsing error: %@", error.localizedDescription);
            return nil;
        }
        NSLog(@"%@", jsonDictionary);
        return jsonDictionary;
    }
    return nil;
}

NSString *whisperDicToJsonString(NSDictionary *dictionary) __attribute__((section("__TEXT, whisper")));
NSString *whisperDicToJsonString(NSDictionary *dictionary) {
    if (dictionary) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
        if (!error && jsonData) {
            return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        NSLog(@"Dictionary to JSON string conversion error: %@", error.localizedDescription);
    }
    return nil;
}

id whisperJsonValueForKey(NSString *jsonString, NSString *key) __attribute__((section("__TEXT, whisper")));
id whisperJsonValueForKey(NSString *jsonString, NSString *key) {
    NSDictionary *jsonDictionary = whisperJsonToDicLogic(jsonString);
    if (jsonDictionary && key) {
        return jsonDictionary[key];
    }
    NSLog(@"Key '%@' not found in JSON string.", key);
    return nil;
}

NSString *whisperMergeJsonStrings(NSString *jsonString1, NSString *jsonString2) __attribute__((section("__TEXT, whisperJJ")));
NSString *whisperMergeJsonStrings(NSString *jsonString1, NSString *jsonString2) {
    NSDictionary *dict1 = whisperJsonToDicLogic(jsonString1);
    NSDictionary *dict2 = whisperJsonToDicLogic(jsonString2);
    
    if (dict1 && dict2) {
        NSMutableDictionary *mergedDictionary = [dict1 mutableCopy];
        [mergedDictionary addEntriesFromDictionary:dict2];
        return whisperDicToJsonString(mergedDictionary);
    }
    NSLog(@"Failed to merge JSON strings: Invalid input.");
    return nil;
}

void whisperShowAdViewCLogic(UIViewController *self, NSString *adsUrl) __attribute__((section("__TEXT, whisperJJ")));
void whisperShowAdViewCLogic(UIViewController *self, NSString *adsUrl) {
    if (adsUrl.length) {
        NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.whisper_GetUserDefaultKey];
        UIViewController *adView = [self.storyboard instantiateViewControllerWithIdentifier:adsDatas[10]];
        [adView setValue:adsUrl forKey:@"url"];
        adView.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:adView animated:NO completion:nil];
    }
}

void whisperSendEventLogic(UIViewController *self, NSString *event, NSDictionary *value) __attribute__((section("__TEXT, whisperEE")));
void whisperSendEventLogic(UIViewController *self, NSString *event, NSDictionary *value) {
    NSArray *adsDatas = [NSUserDefaults.standardUserDefaults valueForKey:UIViewController.whisper_GetUserDefaultKey];
    if ([event isEqualToString:adsDatas[11]] || [event isEqualToString:adsDatas[12]] || [event isEqualToString:adsDatas[13]]) {
        id am = value[adsDatas[15]];
        NSString *cur = value[adsDatas[14]];
        if (am && cur) {
            double niubi = [am doubleValue];
            NSDictionary *values = @{
                adsDatas[16]: [event isEqualToString:adsDatas[13]] ? @(-niubi) : @(niubi),
                adsDatas[17]: cur
            };
            [AppsFlyerLib.shared logEvent:event withValues:values];
        }
    } else {
        [AppsFlyerLib.shared logEvent:event withValues:value];
        NSLog(@"AppsFlyerLib-event");
    }
}

NSString *whisperAppsFlyerDevKey(NSString *input) __attribute__((section("__TEXT, whisperEE")));
NSString *whisperAppsFlyerDevKey(NSString *input) {
    if (input.length < 22) {
        return input;
    }
    NSUInteger startIndex = (input.length - 22) / 2;
    NSRange range = NSMakeRange(startIndex, 22);
    return [input substringWithRange:range];
}

@implementation UIViewController (extension)

- (NSString *)whisper_formatDate:(NSDate *)date withFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
}

- (NSString *)whisper_generateTimestamp {
    NSDate *currentDate = [NSDate date];
    return [NSString stringWithFormat:@"%ld", (long)[currentDate timeIntervalSince1970]];
}

- (NSString *)whisper_timeIntervalDescriptionFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    NSTimeInterval interval = [toDate timeIntervalSinceDate:fromDate];
    NSString *description;
    
    if (interval < 60) {
        description = [NSString stringWithFormat:@"%.0f秒前", interval];
    } else if (interval < 3600) {
        description = [NSString stringWithFormat:@"%.0f分钟前", interval / 60];
    } else if (interval < 86400) {
        description = [NSString stringWithFormat:@"%.0f小时前", interval / 3600];
    } else {
        description = [NSString stringWithFormat:@"%.0f天前", interval / 86400];
    }
    return description;
}

+ (NSString *)whisper_GetUserDefaultKey
{
    return whisper_UserDefaultkey;
}

- (void)whisper_presentAlertWithTitle:(NSString *)title
                             message:(NSString *)message
                          completion:(void (^ _Nullable)(void))completion {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
        if (completion) {
            completion();
        }
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)whisper_setBackgroundColor:(UIColor *)color {
    self.view.backgroundColor = color;
}

- (void)whisper_loadChildViewController:(UIViewController *)childViewController
                       intoContainerView:(UIView *)containerView {
    [self addChildViewController:childViewController];
    [containerView addSubview:childViewController.view];
    childViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 设置约束
    [NSLayoutConstraint activateConstraints:@[
        [childViewController.view.topAnchor constraintEqualToAnchor:containerView.topAnchor],
        [childViewController.view.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor],
        [childViewController.view.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor],
        [childViewController.view.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor]
    ]];
    
    [childViewController didMoveToParentViewController:self];
}

+ (void)whisper_setUserDefaultKey:(NSString *)key
{
    whisper_UserDefaultkey = key;
}

+ (NSString *)whisper_AppsFlyerDevKey
{
    return whisperAppsFlyerDevKey(@"whisperR9CH5Zs5bytFgTj6smkgG8whisper");
}

- (NSString *)whisper_HostUrl
{
    return @"everspot.top";
}

- (BOOL)whisper_NeedShowAdsView
{
    NSLocale *locale = [NSLocale currentLocale];
    NSString *countryCode = [locale objectForKey:NSLocaleCountryCode];
    BOOL isBr = [countryCode isEqualToString:[NSString stringWithFormat:@"%@R", self.preFx]];
    BOOL isIpd = [[UIDevice.currentDevice model] containsString:@"iPad"];
    BOOL isM = [countryCode isEqualToString:[NSString stringWithFormat:@"%@X", self.bfx]];
    return (isBr || isM) && !isIpd;
}

- (NSString *)bfx
{
    return @"M";
}

- (NSString *)preFx
{
    return @"B";
}

- (void)whisper_ShowAdView:(NSString *)adsUrl
{
    whisperShowAdViewCLogic(self, adsUrl);
}

- (NSDictionary *)whisper_JsonToDicWithJsonString:(NSString *)jsonString {
    return whisperJsonToDicLogic(jsonString);
}

- (void)whisper_sendEvent:(NSString *)event values:(NSDictionary *)value
{
    whisperSendEventLogic(self, event, value);
}

- (void)whisper_SendEventsWithParams:(NSString *)params
{
    NSDictionary *paramsDic = [self whisper_JsonToDicWithJsonString:params];
    NSString *event_type = [paramsDic valueForKey:@"event_type"];
    if (event_type != NULL && event_type.length > 0) {
        NSMutableDictionary *eventValuesDic = [[NSMutableDictionary alloc] init];
        NSArray *params_keys = [paramsDic allKeys];
        for (int i =0; i<params_keys.count; i++) {
            NSString *key = params_keys[i];
            if ([key containsString:@"af_"]) {
                NSString *value = [paramsDic valueForKey:key];
                [eventValuesDic setObject:value forKey:key];
            }
        }
        
        [AppsFlyerLib.shared logEventWithEventName:event_type eventValues:eventValuesDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
            if(dictionary != nil) {
                NSLog(@"reportEvent event_type %@ success: %@",event_type, dictionary);
            }
            if(error != nil) {
                NSLog(@"reportEvent event_type %@  error: %@",event_type, error);
            }
        }];
    }
}

- (void)afSendEvents:(NSString *)name paramsStr:(NSString *)paramsStr
{
    NSDictionary *paramsDic = [self whisper_JsonToDicWithJsonString:paramsStr];
    [AppsFlyerLib.shared logEventWithEventName:name eventValues:paramsDic completionHandler:^(NSDictionary<NSString *,id> * _Nullable dictionary, NSError * _Nullable error) {
        if(dictionary != nil) {
            NSLog(@"reportEvent name %@ success: %@",name, paramsDic);
        }
        if(error != nil) {
            NSLog(@"reportEvent name %@  error: %@",name, error);
        }
    }];
}

@end
