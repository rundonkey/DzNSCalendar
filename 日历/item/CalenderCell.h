//
//  CalenderCell.h
//  TheTickets
//
//  Created by 李志学 on 17/1/11.
//  Copyright © 2017年 张达. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalenderCell : UICollectionViewCell

@property(strong,nonatomic)NSData * date;
@property(assign,nonatomic)BOOL   * isSelected;

@property (weak, nonatomic) IBOutlet UILabel *calenderLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *isToday;

@end
