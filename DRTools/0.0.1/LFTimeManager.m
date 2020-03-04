//
//  LFTimeManager.m
//  NoticeSheet
//
//  Created by libx on 2019/7/26.
//  Copyright © 2019 LF. All rights reserved.
//

#import "LFTimeManager.h"

#define time_inline __inline__ __attribute__((always_inline))

static NSString * const DateFormatStringDefaults = @"YYYY-MM-dd HH:mm:ss";

/// 1代表星期日、如此类推
static time_inline NSString *TimeGetWeekday(long number) {
    switch (number) {
        case 1:
            return @"星期日";
            break;
        case 2:
            return @"星期一";
            break;
        case 3:
            return @"星期二";
            break;
        case 4:
            return @"星期三";
            break;
        case 5:
            return @"星期四";
            break;
        case 6:
            return @"星期五";
            break;
        case 7:
            return @"星期六";
            break;
        default:
            return @"";
            break;
    }
}

/// 获取微信时间（类似：星期六/12:50/3天前/2018-01-01）
static time_inline NSString *TimeGetWXTime(__unsafe_unretained NSDate *messageDate) {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:messageDate];
    NSDate *msgDate = [cal dateFromComponents:components];
    NSString *weekday = TimeGetWeekday(components.weekday);
    components = [cal components:NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    
    // 今天的时间
    if([today isEqualToDate:msgDate] || [today isEqualToDate:[msgDate earlierDate:today]]) {
        return [[LFTimeManager dateFormatter:@"HH:mm"] stringFromDate:messageDate];
    }
    
    // 获取昨天的date
    components.day -= 1;
    NSDate *yestoday = [cal dateFromComponents:components];
    
    // 判断为昨天
    if([yestoday isEqualToDate:msgDate]) {
        return [[LFTimeManager dateFormatter:@"昨天 HH:mm"] stringFromDate:messageDate];
    }
    
    // 获取 前天（包括前天）往前5天的date，
    for (int i = 1; i <= 5; i++) {
        components.day -= 1;
        NSDate *nowdate = [cal dateFromComponents:components];
        if([nowdate isEqualToDate:msgDate]){
            return [[LFTimeManager dateFormatter:[NSString stringWithFormat:@"%@ HH:mm",weekday]] stringFromDate:messageDate];
        }
    }
    return [[LFTimeManager dateFormatter:@"YYYY-MM-dd"] stringFromDate:messageDate];
}

@implementation LFTimeManager

+ (NSString *)getWXTimeFromTimeInterval:(NSTimeInterval)timeInterval {
    return TimeGetWXTime([NSDate dateWithTimeIntervalSince1970:timeInterval]);
}

+ (NSString *)getWXTimeFromTimeString:(NSString *)timeString {
    return TimeGetWXTime([[LFTimeManager dateFormatter:@""] dateFromString:timeString]);
}

+ (NSString *)getTime:(NSTimeInterval)timeInterval dateFormatter:(NSString *)dateFormatter {
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [[LFTimeManager dateFormatter:dateFormatter] stringFromDate:detailDate];
}

+ (NSTimeInterval)getTimeSecond:(NSDate * _Nullable)detailDate {
    if (detailDate) {
        return [[NSDate date] timeIntervalSinceDate:detailDate];
    } else {
        return [[NSDate date] timeIntervalSince1970];
    }
}

+ (NSDateFormatter *)dateFormatter:(NSString *)dateFormatterString {
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.locale = [NSLocale systemLocale];
        formatter.timeZone = [NSTimeZone systemTimeZone];
    });
    if (dateFormatterString.length) {
        formatter.dateFormat = dateFormatterString;
    } else {
        formatter.dateFormat = DateFormatStringDefaults;
    }
    return formatter;
}

@end
