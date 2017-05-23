//
//  Dz_CalenderModel.m
//  TheTickets
//
//  Created by 李志学 on 17/1/11.
//  Copyright © 2017年 张达. All rights reserved.
//

#import "Dz_CalenderModel.h"

@implementation Dz_CalenderModel
-(void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
    if ([key isEqualToString:@"depart_date"]) {
        NSString * tiemStr = [self unixTimeForOC1970:[NSString stringWithFormat:@"%@",value]];
        self.month = [tiemStr substringWithRange:NSMakeRange(5, 2)];
        self.year  = [tiemStr substringWithRange:NSMakeRange(0, 4)];
        self.day   = [tiemStr substringWithRange:NSMakeRange(8, 2)];
        self.clear_date = [tiemStr substringWithRange:NSMakeRange(0, 10)];
        self.depart_date = tiemStr;
        NSLog(@"月份:%@",self.month);
    }
}
-(NSString * )unixTimeForOC1970:(NSString *)timeStr
{
    NSTimeInterval UnixT = [timeStr doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:UnixT];//日期
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * time = [NSString stringWithFormat:@"%@ ",[_formatter stringFromDate:date]];
    return time;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
}
@end
