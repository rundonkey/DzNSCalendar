//
//  CollectionHeaderViewForSection.m
//  TheTickets
//
//  Created by 李志学 on 17/1/13.
//  Copyright © 2017年 张达. All rights reserved.
//

#import "CollectionHeaderViewForSection.h"

@implementation CollectionHeaderViewForSection
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self ceartView];
    }
    return self;
}
-(void)ceartView
{
    self.yearerLabel = [[UILabel alloc]initWithFrame:self.bounds];
    self.yearerLabel.textColor = [UIColor darkGrayColor];
    self.yearerLabel.textAlignment = NSTextAlignmentCenter;
    self.yearerLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:_yearerLabel];
}
@end
