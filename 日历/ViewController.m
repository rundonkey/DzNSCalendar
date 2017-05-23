//
//  ViewController.m
//  日历
//
//  Created by 李志学 on 17/2/17.
//  Copyright © 2017年 张达. All rights reserved.
//

#import "ViewController.h"
#import "Dz_CalendarControl.h"
@interface ViewController ()<DzBaseCalendarViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton * btn = [UIButton new];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(100, 200, 100, 100);
    btn.backgroundColor = [UIColor redColor];
    [btn setTitle:@"日历" forState:(UIControlStateNormal)];
    [btn addTarget:self action:@selector(action) forControlEvents:(UIControlEventTouchUpInside)];
}
-(void)action
{
    Dz_CalendarControl * cld = [Dz_CalendarControl new];
    
    cld.delegate = self;
    [cld toTransmitData:^(Dz_CalenderModel * CalendarModel) {
        NSLog(@"(block)dateModel = %@",CalendarModel);

    }];
    [self.navigationController pushViewController:cld animated:YES];
}
-(void)DzBaseCalendarViewSelectAtDateModel:(Dz_CalenderModel *)dateModel
{
    NSLog(@"(delegate)dateModel = %@",dateModel);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
