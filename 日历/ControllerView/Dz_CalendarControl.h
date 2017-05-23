//
//  Dz_CalendarControl.h
//  TheTickets
//
//  Created by 李志学 on 17/1/11.
//  Copyright © 2017年 张达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dz_CalenderModel.h"
@class Dz_CalenderModel;

typedef void(^changeDateBlock)(Dz_CalenderModel*CalendarModel);
@protocol DzBaseCalendarViewDelegate <NSObject>
-(void)DzBaseCalendarViewSelectAtDateModel:(Dz_CalenderModel *)dateModel;
@end

@interface Dz_CalendarControl : UIViewController
// block
@property(copy,nonatomic)changeDateBlock calendarControlBlock;
//标记数组 用于标记特殊日期 这个数组中存放的必须是YHBaseDateModel 对象
@property(nonatomic,strong)NSArray * markArray;
@property(nonatomic,weak)id<DzBaseCalendarViewDelegate> delegate;

-(void)toTransmitData:(changeDateBlock)block;
@end
