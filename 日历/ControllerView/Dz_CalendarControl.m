//
//  Dz_CalendarControl.m
//  TheTickets
//
//  Created by 李志学 on 17/1/11.
//  Copyright © 2017年 张达. All rights reserved.
//

#import "Dz_CalendarControl.h"
#import "CalendarHeaderView.h"
#import "CalenderCell.h"
#import "CollectionHeaderViewForSection.h"
#import "Dz_CalenderModel.h"
#define  kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface Dz_CalendarControl ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    //星期
    UIView * _headView;
    //日历的展示
    UIView * _bodyViewL;
    UIView * _bodyViewM;
    UIView * _bodyViewR;
    //滑动功能的支持
    UIScrollView * _scrollView;
    NSDate * _today;
    Dz_CalenderModel * _selectModel;
    
    NSCalendar  * calendar;
    NSDate      * currentDate;// 当期日期
    NSInteger     selectedIndex;
}
@property(strong,nonatomic)UICollectionView   * collectionView;
@property(strong,nonatomic)CalendarHeaderView * headerView;
@property(strong,nonatomic)NSMutableArray     * headerViewDataArray;

@property(assign,nonatomic)NSInteger firstWeekday;
@end
static NSString * const colelctionIdenter = @"colelctionIdenter";
static NSString * const collectionHeaderIdenter = @"collectionHeaderIdenter";
@implementation Dz_CalendarControl
#pragma mark -- setter getter
-(NSMutableArray *)headerViewDataArray
{
    if (!_headerViewDataArray) {
        _headerViewDataArray = [NSMutableArray array];
    }
    return _headerViewDataArray;
}
-(CalendarHeaderView *)headerView
{
    if (_headerView == nil) {
        _headerView = [[CalendarHeaderView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 30)];
    }
    return _headerView;
}
// 返回今天日期在日历UI中的位置下标
-(NSInteger)getTheDateInCalendarTodaySubscript
{
    NSDate * amountOf1_Date =[self getAMonthframDate:currentDate months:0];
    NSCalendarUnit dayInfoUnits  = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [calendar components:dayInfoUnits fromDate:currentDate];
    NSLog(@"当前日期的comps=%@ ---- %ld",components,(long)[self getFirstDayWeekForMonth:amountOf1_Date]);
    // 为了对应星期数，前边加了站位cell。所以这里真正下标应该加上星期数(-1不用说了下标从0开始)
    return components.day-1+ [self getFirstDayWeekForMonth:amountOf1_Date];
}
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat itemW = (kScreenWidth - 3) / 7;
        flowLayout.itemSize = CGSizeMake(itemW, itemW);
        flowLayout.minimumInteritemSpacing = 0.5;
        flowLayout.minimumLineSpacing = 0.5;
        flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth, 20);
        flowLayout.footerReferenceSize = CGSizeMake(kScreenWidth, 10);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 30, kScreenWidth, self.view.frame.size.height-30) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        // 注册cell 区头区尾
        [_collectionView registerClass:[CollectionHeaderViewForSection class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:collectionHeaderIdenter];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footView"];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CalenderCell class]) bundle:nil] forCellWithReuseIdentifier:colelctionIdenter];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionView"];
    }
    return _collectionView;
}
#pragma mark -- 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];// 指定日历的算法
    currentDate = [NSDate date];
    selectedIndex = [self getTheDateInCalendarTodaySubscript];
    // colelctionView操作
    [self operationTableView];

}
-(void)operationTableView
{
    self.title = @"门票选择";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.headerView];
}
#pragma mark -- collectionDelegateAndDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section) {
        case 0:{
            // 获取目标月的1月1号date对象（方法自己封装的，适合我这个使用,可以根据上述方法自己修改）
            NSDate * amonthOf1_Date = [self getAMonthframDate:currentDate months:0];
            // 装collectionView头视图需要的数据
            [self.headerViewDataArray addObject:amonthOf1_Date];
            // 目标月的天数+星期数（这天星期几就加几）---目的->布局cell时候能够让每个月1号对应上星期数
            return [self getCurrentMonthForDays] + [self getFirstDayWeekForMonth:amonthOf1_Date];
        }
            break;
        case 1:{
            NSDate * amonthOf1_Date = [self getAMonthframDate:currentDate months:1];
            [self.headerViewDataArray addObject:amonthOf1_Date];
            return [self getNextNMonthForDays:amonthOf1_Date] + [self getFirstDayWeekForMonth:amonthOf1_Date];
        }
            break;
        case 2:{
            NSDate * amonthOf1_Date = [self getAMonthframDate:currentDate months:2];
            [self.headerViewDataArray addObject:amonthOf1_Date];
            return [self getNextNMonthForDays:amonthOf1_Date] + [self getFirstDayWeekForMonth:amonthOf1_Date];
        }
            break;
        case 3:{
            NSDate * amonthOf1_Date = [self getAMonthframDate:currentDate months:3];
            [self.headerViewDataArray addObject:amonthOf1_Date];
            return [self getNextNMonthForDays:amonthOf1_Date] + [self getFirstDayWeekForMonth:amonthOf1_Date];
        }
            break;
        default:
            break;
    }
    return 0;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalenderCell * item = [collectionView dequeueReusableCellWithReuseIdentifier:colelctionIdenter forIndexPath:indexPath];
    item.selectedBackgroundView = [self returnsItemBackgroundView:item.frame type:1];
    switch (indexPath.section)
    {
        case 0:{
            // 某个月的1号Date对象 (这个case中是当前月)
            if (indexPath.item == selectedIndex) {
                item.backgroundView = [self returnsItemBackgroundView:item.frame type:0];
            }
            NSDate * amountOf1_Date =[self getAMonthframDate:currentDate months:0];
            if (indexPath.item < [self getFirstDayWeekForMonth:amountOf1_Date]) {
                UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionView" forIndexPath:indexPath];
                return cell;
            }else{
                /*******/
                /*
                 *  getFirstDayWeekForMonth ->获取目标月份1号是周几
                 *  [self getAMonthframDate:currentDate months:0] ->根据当前日期返回目标月1号的date对象(用来计算1号周几)
                 *  case1,2,3,4 同理!
                *******/
                // 给item赋值indexPath.item - 第一天是周几 就可以知道这个月日期怎么赋值了
                NSInteger number;
                NSString * calenderStr;
                // 方法定义如果是星期天返回0(为了日历布局) 所以这里处理一下
                if ([self getFirstDayWeekForMonth:amountOf1_Date] == 0){
                    calenderStr = [NSString stringWithFormat:@"%ld",(indexPath.item+1)];
                }else{
                 number = [self getFirstDayWeekForMonth:amountOf1_Date];
                 calenderStr = [NSString stringWithFormat:@"%ld",(indexPath.item - number)];
                }
                item.calenderLabel.text = calenderStr;
                item.priceLabel.text = [NSString stringWithFormat:@"¥%@",calenderStr];
                return item;
            }
        }
            break;
        case 1:{
            // 详情注释看case0;
            item.backgroundView = [[UIView alloc]init];//为了解决复用问题
            NSDate * amountOf1_Date =[self getAMonthframDate:currentDate months:1];
            if (indexPath.item<[self getFirstDayWeekForMonth:amountOf1_Date] ) {
                UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionView" forIndexPath:indexPath];
                return cell;
            }else{
                NSInteger number;
                NSString * calenderStr;
                if ([self getFirstDayWeekForMonth:amountOf1_Date] == 0){
                    calenderStr = [NSString stringWithFormat:@"%ld",(indexPath.item+1)];
                }else{
                    number = [self getFirstDayWeekForMonth:amountOf1_Date];
                    calenderStr = [NSString stringWithFormat:@"%ld",((indexPath.item+1) - number)];
                }
                  item.calenderLabel.text = calenderStr;
                  item.priceLabel.text = [NSString stringWithFormat:@"%@元",calenderStr];
                return item;
            }
        }
            break;
        case 2:{
            // 详情注释看case0;
            item.backgroundView = [[UIView alloc]init];//为了解决复用问题
            NSDate * amountOf1_Date =[self getAMonthframDate:currentDate months:2];// 返回某月1号的date对象
            if (indexPath.item<[self getFirstDayWeekForMonth:amountOf1_Date] ) {
                UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionView" forIndexPath:indexPath];
                return cell;
            }else{
                NSInteger number;
                NSString * calenderStr;
                if ([self getFirstDayWeekForMonth:amountOf1_Date] == 0){
                    calenderStr = [NSString stringWithFormat:@"%ld",(indexPath.item+1)];
                }else{
                    number = [self getFirstDayWeekForMonth:amountOf1_Date];
                    calenderStr = [NSString stringWithFormat:@"%ld",((indexPath.item+1) - number)];
                }
                item.calenderLabel.text = calenderStr;
                item.priceLabel.text = [NSString stringWithFormat:@"%@元",calenderStr];
                return item;
            }
        }
            break;
        case 3:{
            // 详情注释看case0;
            item.backgroundView = [[UIView alloc]init];//为了解决复用问题
            NSDate * amountOf1_Date =[self getAMonthframDate:currentDate months:3];// 返回某月1号的date对象
            if (indexPath.item<[self getFirstDayWeekForMonth:amountOf1_Date] ) {
                UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionView" forIndexPath:indexPath];
                return cell;
            }else{
                NSInteger number;
                NSString * calenderStr;
                if ([self getFirstDayWeekForMonth:amountOf1_Date] == 0){
                    calenderStr = [NSString stringWithFormat:@"%ld",(indexPath.item+1)];
                }else{
                    number = [self getFirstDayWeekForMonth:amountOf1_Date];
                    calenderStr = [NSString stringWithFormat:@"%ld",((indexPath.item+1) - number)];
                }
                item.calenderLabel.text = calenderStr;
                item.priceLabel.text = [NSString stringWithFormat:@"%@元",calenderStr];
                return item;
            }
        }
            break;
        default:
            break;
    }
    return nil;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
        //  flowLayout.headerReferenceSize = CGSizeMake(kScreenWidth, 20);
        //  flowLayout.footerReferenceSize = CGSizeMake(kScreenWidth, 10);
        //  结合上边两行注释和UI头视图就能想起来为什么这么写 。为了布局UI
        //  colelctionView头视图（继承UIColelctionReusableView）
    if (kind == UICollectionElementKindSectionHeader) {
        CollectionHeaderViewForSection * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:collectionHeaderIdenter forIndexPath:indexPath];
        headerView.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.2];
        NSLog(@"collectionView分区数:%ld",(long)indexPath.section);
        headerView.yearerLabel.text= [self theTargetDateConversionStr:_headerViewDataArray[indexPath.section]];

        return headerView;
    }else
    {
        UICollectionReusableView * footView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footView" forIndexPath:indexPath];
        footView.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.2];
        if (indexPath.section == 3) {
            footView.backgroundColor = [[UIColor darkGrayColor]colorWithAlphaComponent:0.2];
        }
        return footView;
    };
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Dz_CalenderModel * model = [Dz_CalenderModel new];
    if (_delegate && [_delegate respondsToSelector:@selector(DzBaseCalendarViewSelectAtDateModel:)]) {
        [_delegate DzBaseCalendarViewSelectAtDateModel:model];
    }
    if (_calendarControlBlock) {
     _calendarControlBlock(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --- 工具类
// 传入一个日期返回这个日期的 NSDateComponents对象
-(NSDateComponents *)aCertainDateComponents:(NSDate *)date{
    NSCalendarUnit _dayInfoUnits  = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [calendar components:_dayInfoUnits fromDate:date];
    return components;
}

// 返回一个View，本类中当做item选中后背景View type是1的时候返回棕色，否则红色
-(UIView *)returnsItemBackgroundView:(CGRect)Rect type:(NSInteger)isSelecd
{
    
    CGFloat itemW = (kScreenWidth - 3) / 7;
    UIView * view =[[UIView alloc]initWithFrame:CGRectMake(0,0, itemW, itemW)];
    view.center = CGPointMake(Rect.origin.x/2, Rect.origin.y/2);
    if (isSelecd == 1) {
     view.backgroundColor = [[UIColor brownColor]colorWithAlphaComponent:0.7];
    }else view.backgroundColor = [[UIColor yellowColor]colorWithAlphaComponent:0.5];
    view.layer.cornerRadius = itemW /2;
    return view;
}
/*
 * 日期转字符串
 * date : 需要转换的日期
 */
-(NSString * )theTargetDateConversionStr:(NSDate * )date
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    NSString *currentDateStr = [dateFormat stringFromDate:date];
    // 根据自己需求处理字符串
    return [currentDateStr substringToIndex:7];
}
// 字符串转date
-(NSDate* )theTargetStringConversionDate:(NSString *)str
{
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSString转NSDate
    NSDate *date=[formatter dateFromString:str];
    return date;
}
/*
 *  获取当前月天数
 */
-(NSInteger)getCurrentMonthForDays
{
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSRange range = [currentCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]];
    NSUInteger numberOfDaysInMonth = range.length;
    NSLog(@"nsrange = %@----- %ld",NSStringFromRange(range),range.location);
    return numberOfDaysInMonth;
}
/*
 *  date :当前时间
 *  number:当前月之后几个个月的1号date
 */
-(NSDate *)getAMonthframDate:(NSDate*)date months:(NSInteger)number{

    NSCalendarUnit _dayInfoUnits  = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [calendar components:_dayInfoUnits fromDate:date];
    components.day = 1;
    if (number!=0) {
      components.month += number;
    }
    NSDate * nextMonthDate =[calendar dateFromComponents:components];
    return nextMonthDate;
}
/*
 * 获取某个月一共多少天
 * date 要获取的月份的date
 */
-(NSInteger)getNextNMonthForDays:(NSDate * )date
{
    NSInteger monthNum =[[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
//     = (NSInteger)[date YHBaseNumberOfDaysInCurrentMonth];
    return monthNum;
}
/**
 *  获取某个月的1号是星期几
 *  date 目标月的date
 **/
-(NSInteger)getFirstDayWeekForMonth:(NSDate*)date
{
#warning mark -- 有待优化，不知道为什么星期数总是比真实多一天（暂时用➖一天处理了）
//    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // 指定日历的算法 NSCalendarIdentifierGregorian,NSGregorianCalendar
    // NSDateComponent 可以获得日期的详细信息，即日期的组成
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday fromDate:date];
    NSLog(@"comps是这个样子的:%@",comps);
    NSInteger weekday = [comps weekday];
    weekday--;
    NSLog(@"[comps weekday] = %ld",(long)weekday);
    if (weekday == 7) {
        return 0;
    }else return weekday;
}
-(void)toTransmitData:(changeDateBlock)block
{
    _calendarControlBlock = block;
}

@end
