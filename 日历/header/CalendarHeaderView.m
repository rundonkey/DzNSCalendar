//
//  CalendarHeaderView.m
//  TheTickets
//
//  Created by 李志学 on 17/1/11.
//  Copyright © 2017年 张达. All rights reserved.
//

#import "CalendarHeaderView.h"
#define LABWIDTH self.frame.size.width / 7

@interface CalendarHeaderView ()
@property(strong,nonatomic)NSArray * weekArray;
@end
@implementation CalendarHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self ceartHeaderView];
    }
    return self;
}
-(void)ceartHeaderView
{
    _weekArray = [NSArray arrayWithObjects:@"日",@"一",@"二",@"三",@"四",@"五",@"六", nil];
    NSLog(@"%@",_weekArray);
    for (int index = 0; index < 7; index++) {
        UILabel * Lab = [[UILabel alloc]initWithFrame:CGRectMake(index * LABWIDTH, 0, LABWIDTH, self.frame.size.height)];
        Lab.backgroundColor =  [[UIColor lightGrayColor]colorWithAlphaComponent:0.2];
        Lab.text = _weekArray[index];
        Lab.textAlignment = NSTextAlignmentCenter;
        Lab.textColor = [UIColor darkGrayColor];
//        if (index == 0 || index == 6) {
//            Lab.textColor = [UIColor colorWithRed:246/255.0 green:90/255.0 blue:5/255.0 alpha:1 ];
//        }
        [self addSubview:Lab];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
