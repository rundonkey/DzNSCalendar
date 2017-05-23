# DzNSCalendar
iOS-日历(NSCalendar)

![城市有我奋斗的青春.jpg](http://upload-images.jianshu.io/upload_images/1782677-32cf4ef2b8c75c61.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###先说下需求:选择日期弹出日历(跟途牛，携程等差不多就行。。。行)
### 初识NSCalendar到写完日历的感受:
+  懵
+  懵+1
+  什么狗鸡巴
+  如此强大的日历类
+  果然利弊都有，虽然很强大，但是极其耗内存
+  一组表情表示写日历过程中的心情或者每天的心情(同意的猿/媛点赞):
![我的一天.png](http://upload-images.jianshu.io/upload_images/1782677-2cff0a06f8372857.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
#### 先来点湿的(很湿很能吹...)
> NSCalendar官方API:
NSCalendar objects encapsulate information about systems of reckoning time in which the beginning, length, and divisions of a year are defined. They provide information about the calendar and support for calendrical computations such as determining the range of a given calendrical unit and adding units to a given absolute time
> 
>NSCalendar的初始化方法:
常用:    
```
// 可指定日历的算法
NSCalendar  * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
>// currentCalendar取得的值会一直保持在cache中,第一次取得以后如果用户修改该系统日历设定，这个值也不会改变。
NSCalendar  * calendar = [NSCalendar currentCalendar];
//如果用autoupdatingCurrentCalendar，那么每次取得的值都会是当前系统设置的日历的值。 
NSCalendar  * autoupdatingCurrent = [NSCalendar autoupdatingCurrentCalendar];
//- initWithCalendarIdentifier:
 //如果想要用公历的时候，就要将NSDateFormatter的日历设置成公历。否则随着用户的系统设置的改变，取得的日期的格式也会不一样。
    NSCalendar *initCalendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setCalendar:initCalendar];
```
>
  >NSCalendar官方API翻译:
NSCalendar对象封装了有关计算时间的系统的信息，其中定   义了年的开始，长度和分割。它们提供关于日历的信息和对日历计算的支持，例如确定给定的日历单元的范围和将单位添加到给定的绝对时间

  >由此能理解数学英语都辣鸡的我看到它有多懵，NSCalendar功能很强大，还有一点就是我写完日历后，界面会非常卡。最终发现是这个NSCalendar特别特别耗内存。最好能写成全局变量来使用。

###是时候来点干的了(聊一些我工作用到的类和一些封装的方法)
####先上效果图瞅瞅(类似途牛的日历，没有选择后标记)：



![calendarTop.png](http://upload-images.jianshu.io/upload_images/1782677-1579155231d35f3d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![calendarBottom.png](http://upload-images.jianshu.io/upload_images/1782677-aab67db2778de161.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
<p>1.获取当前月份有多少天:</p>
```
-(NSInteger)getCurrentMonthForDays{
    // 创建一个日期类对象(当前月的calendar对象)
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // NSRange是一个结构体，其中location是一个以0为开始的index，length是表示对象的长度。他们都是NSUInteger类型。
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[NSDate date]];
    NSUInteger numberOfDaysInMonth = range.length;
   return numberOfDaysInMonth;
}
```

<p>2获取目标月份的天数:</p>
```
 -(NSInteger)getNextNMonthForDays:(NSDate)date
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    // 调用rangeOfUnit方法:(返回一样是一个结构体)两个参数一个大单位，一个小单位(.length就是天数，.location就是月)
    NSInteger monthNum = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
    return monthNum;
}
```
<p>3.获取一个目标date(包含某个月的1号数据)，或者说获取某个月的1号的date对象</p>
```
    -(NSDate *)getAMonthframDate:(NSDate*)date {
    // 指定日历单位，如日期和月份。(这里指定了年月日，还有其他字段添加单位.特别齐全 ：世纪，年月日时分秒等等等)
    NSCalendarUnit dayInfoUnits  = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    // NSDateComponents封装了日期的组件,年月日时分秒等(个人感觉像是平时用的model模型)
    NSDateComponents *components = [calendar components: dayInfoUnits fromDate:date];
    // 指定1号
    components.day = 1;
    // 指定月份(我这里是获取当前月份的下1个月的1号的date对象,所以用的++，其上个月或者其他同理)
    components.month++；
    // 转成需要的date对象return
    NSDate * nextMonthDate =[calendar dateFromComponents:components];
    return nextMonthDate;
}
```
###### (用到的API基本注释完了下边就不那么多注释了)纯属个人理解，如发现错误的地方请指正，大家共同进步.
<p>              
</p>
<p>4.获取某个月的1号是星期几(必不可少的一个方法，用来布局UI使每月1号与星期队形起来):</p>
```
-(NSInteger)getFirstDayWeekForMonth:(NSDate*)date
{
    // NSCalendarIdentifierGregorian : 指定日历的算法
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // NSDateComponents封装了日期的组件,年月日时分秒等(个人感觉像是平时用的model模型)
    // 调用NSCalendar的components:fromDate:方法返回一个NSDateComponents对象
    // 需要的参数分别components:所需要的日期单位 date:目标月份的date对象
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekday fromDate:date];
    NSLog(@"NSDateComponents是这个样子的:%@",comps);
    // 直接调用自己weekDay属性
    NSInteger weekday = [comps weekday];
    #warning mark --找了很多原因不知道为什么星期数总是比实际快一天,有时间找更好的解决方法（暂时用-1天处理了）
    weekday--;
    NSLog(@"[comps weekday] = %ld",(long)weekday);
    if (weekday == 7) {
        return 0;
    }else return weekday;
}
```

<p>5. 当前时间与之前时间的间隔:</p>
```
/**
 *  @author jaki, 15-09-21 17:09:42
 *  @brief  获取一个标准时间戳与当前时间的时间差
 *  @param tinterval 时间戳
 *  @return 距离当前时间的时间间隔
 */
-(NSString *)getStandardTimeInterval:(NSTimeInterval)interval{
    //进行时间差比较
    //当前时间与1970时间戳(秒为单位)
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    // 当前时间戳-当时时间戳=差值(比如朋友圈动态发表时间为10分钟前(当前时间-发表时间))
    NSTimeInterval timeInterval = time-interval;
    //计算出天、小时、分钟
    int day = timeInterval/(60*60*24);
    int hour = ((long)timeInterval%(60*60*24))/(60*60);
    int minite = ((long)timeInterval%(60*60*24))%(60*60)/60;
    NSMutableString * timeStr = [[NSMutableString alloc]init];
    // 逻辑判断
    if (day!=0) {
        [timeStr appendString:[NSString stringWithFormat:@"%d天前",day]];
    }else{
        if (hour!=0) {
            [timeStr appendString:[NSString stringWithFormat:@"%d小时前",hour]];
        }else{
            if (minite<1) {
                [timeStr appendString:@"刚刚"];
            }else{
                [timeStr appendString:[NSString stringWithFormat:@"%d分钟前",minite]];
            }
        }
    }
    return timeStr;
}
```

<p>6.获取当前系统时间:</p>
```
-(NSString *)getCurrentTime{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    <code>// 格式化系统时间字符串</code>
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * time = [formatter stringFromDate:[NSDate date]];
    return time;
}
```

<p>7.返回年月日时分秒：</p>
```
<code>#pragma mark --- 对比上边就比较简单了不过多啰嗦</code>
-(int)getYear{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:self];
    return (int)dateComponent.year;
    
}
-(int)getMonth{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:self];
    return (int)dateComponent.month;
}
-(int)getDay{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:self];
    return (int)dateComponent.day;
}
-(int)getHour{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:self];
    return (int)dateComponent.hour;
}
-(int)getMinute{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:self];
    return (int)dateComponent.minute;
}
-(int)getSecond{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:self];
    return (int)dateComponent.second;
}
```

<p>8.date对象NSString互相转换:</p>
```
// date对象转换成字符串（最后return根据自己需求处理）
-(NSString * )theTargetDateConversionStr:(NSDate * )date
{
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    NSString *currentDateStr = [dateFormat stringFromDate:date];
    // 根据自己需求处理字符串
    return [currentDateStr substringToIndex:7];
}
// NSString对象转date
-(NSDate* )theTargetStringConversionDate:(NSString *)str
{
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[formatter dateFromString:str];
    return date;
}
```
#####8个方法差不多能够实现一个简单点的日历控件了，88大发,大功告成。2017第一篇，比较偏基础适合我这种菜鸟或者新手，大神路过的话就当娱乐一下了。有错误的话希望多多指点楼主一下



>下面贴一下代码以及实现思路:
#####思路：
>刚知道要写日历的时候是懵逼的，对NSdate还好、NSCalendar完全没有概念。查了挺多资料，也在github找了好几个demo想直接拿过来用，不过不太合适所以决定自己写。试了tableView、跟colelctionView,最后选择collectionView需求是展示当前月跟之后三个月的日历。
#####所以就:
> 区头实现星期View->四个分区->区头区尾配合实现效果，上边聊得几个方法处理DataSource.
#####日历中标记今天的思路是:
实例变量selectedIndex(今天的下标): ---实现->(获取到今天几号，加上今天周几-1就是日历中今天那个cell所在的位置了)
##### 直接截图代码:
都比较基础(自己保存下笔记，也分享给能用到的童鞋)

UICollectionView实现:
![collectionView.png](http://upload-images.jianshu.io/upload_images/1782677-e6bc98fa525b73e8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

DataSource：每个分区返回item数量
![dataSource返回item个数.png](http://upload-images.jianshu.io/upload_images/1782677-aa158a17bb42f1a5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

DataSource: 绘制item

![dateSource绘制Cell.png](http://upload-images.jianshu.io/upload_images/1782677-d1dd0ea8905a1b11.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

DataSource：headerView和footerView以及点击回传数据:
![区头、区尾、点击.png](http://upload-images.jianshu.io/upload_images/1782677-5356d5927a0664e1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

##### 到这我的这个懵逼写日历的过程就完毕了(第一次用makeDown感觉特别好用),下班！
##### Bug神在上请保佑所有正在奋斗的90后程序猿们2017永无bug，保佑老猿们步步高升顺顺利利！
                          > 本人QQ:412282037昵称同简书ID.大家互相学习一块奋斗共同进步!
