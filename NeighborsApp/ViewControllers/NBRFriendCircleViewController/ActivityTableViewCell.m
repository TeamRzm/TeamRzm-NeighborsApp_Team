//
//  ActivityTableViewCell.m
//  NeighborsApp
//
//  Created by Martin.Ren on 15/4/18.
//  Copyright (c) 2015年 Martin.Ren. All rights reserved.
//

#import "ActivityTableViewCell.h"

@interface ActivityTableViewCell()
{
    EGOImageView *activityBackGoundImageView;
    UIImageView  *leftTagImageView;
    UIView       *bottomView;
    UIView       *activityMaskView;
    UILabel      *titleLabel;
    UILabel      *dateLable;
}

@end

@implementation ActivityTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat) heightWithEntity : (ActivityDateEntity *) _entity
{
    return 20.0f + 150.0f + 32.0f;
}

- (void) configWithEntity : (ActivityDateEntity*) _entity
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //活动海报
    activityBackGoundImageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:_entity.backGounrdUrl]];
    activityBackGoundImageView.frame = CGRectMake(10, 10, kNBR_SCREEN_W - 20, 150);
    activityBackGoundImageView.layer.borderColor = kNBR_ProjectColor_LightGray.CGColor;
    activityBackGoundImageView.layer.borderWidth = 0.5f;
    [self.contentView addSubview:activityBackGoundImageView];
    
    //左上标签
    leftTagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 48.5, 50)];
    
    NSMutableParagraphStyle *contentViewStyle = [[NSMutableParagraphStyle alloc] init];
    contentViewStyle.lineHeightMultiple = 1;
    contentViewStyle.lineSpacing = 4.0f;
    contentViewStyle.paragraphSpacing = 3.0f;
    
    UIFont *contentFont = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:10.0f];
    
    NSDictionary *formatDict = @{
                                 NSFontAttributeName               : contentFont,
                                 NSParagraphStyleAttributeName     : contentViewStyle,
                                 NSForegroundColorAttributeName    : kNBR_ProjectColor_StandWhite,
                                 };
    
//    CGRect contentStringSize = [_entity.leftTagStr boundingRectWithSize:CGSizeMake(CGRectGetWidth(leftTagImageView.frame), 1000)
//                                                                options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
//                                                             attributes:formatDict
//                                                                context:nil];
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:_entity.leftTagStr];
    
    [attString addAttributes:formatDict range:NSMakeRange(0, _entity.leftTagStr.length)];
    
    UILabel *tagStringLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(leftTagImageView.frame), CGRectGetHeight(leftTagImageView.frame))];
    tagStringLabel.font = contentFont;
    tagStringLabel.numberOfLines = 2;
    tagStringLabel.textAlignment = NSTextAlignmentCenter;
    tagStringLabel.textColor = kNBR_ProjectColor_StandWhite;
    tagStringLabel.attributedText = attString;
    [leftTagImageView addSubview:tagStringLabel];
    
    switch (_entity.activityState)
    {
        case ACTIVITY_STATE_RES:
        case ACTIVITY_STATE_STARTING:
            leftTagImageView.image = [UIImage imageNamed:@"activity_01"];
            tagStringLabel.text = [NSString stringWithFormat:@"已开始\n%@", _entity.leftTagStr];
            break;
            
        case ACTIVITY_STATE_END:
            leftTagImageView.image = [UIImage imageNamed:@"activity_02"];
            tagStringLabel.text = [NSString stringWithFormat:@"已结束\n%@", _entity.leftTagStr];
            break;
            
        case ACTIVITY_STATE_VAIL:
            leftTagImageView.image = [UIImage imageNamed:@"activity_03"];
            tagStringLabel.text = [NSString stringWithFormat:@"已过期\n%@", _entity.leftTagStr];
            break;
            
        case ACTIVITY_STATE_UNKOWN:
        default:
            break;
    }
    [activityBackGoundImageView addSubview:leftTagImageView];
    
    //海报下方黑色遮罩
    activityMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(activityBackGoundImageView.frame) - 20.0f, CGRectGetWidth(activityBackGoundImageView.frame), 20)];
    activityMaskView.backgroundColor = [UIColor colorWithRed:0x2E / 255.0f green:0x2E / 255.0f blue:0x2E / 255.0f alpha:.6f];
    [activityBackGoundImageView addSubview:activityMaskView];
    
    UILabel *regDateLable = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, CGRectGetWidth(activityMaskView.frame) - 10, CGRectGetHeight(activityMaskView.frame))];
    regDateLable.textColor = kNBR_ProjectColor_StandWhite;
    regDateLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:11.0f];
    regDateLable.text = [NSString stringWithFormat:@"报名时间：%@",_entity.regDate];
    [activityMaskView addSubview:regDateLable];
    
    UILabel *priceLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(activityMaskView.frame) - 45, 0, 45, CGRectGetHeight(activityMaskView.frame))];
    priceLable.textColor = kNBR_ProjectColor_StandWhite;
    priceLable.font = [UIFont fontWithName:kNBR_DEFAULT_FONT_NAME_BLOD size:11.0f];
    priceLable.textAlignment = NSTextAlignmentCenter;
    [activityMaskView addSubview:priceLable];
    
    if (_entity.price.integerValue > 0)
    {
        priceLable.backgroundColor = UIColorFromRGB(0x359DB);
        priceLable.text = [NSString stringWithFormat:@"¥%@",_entity.price];
    }
    else
    {
        priceLable.backgroundColor = UIColorFromRGB(0x25CB05);
        priceLable.text = @"免费";
    }
    [activityMaskView addSubview:priceLable];
    
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetHeight(activityBackGoundImageView.frame) + 10 - 1, CGRectGetWidth(activityBackGoundImageView.frame), 32.0f)];
    bottomView.layer.borderWidth = 0.5f;
    bottomView.backgroundColor = kNBR_ProjectColor_StandWhite;
    bottomView.layer.borderColor = kNBR_ProjectColor_LightGray.CGColor;
    [self.contentView addSubview:bottomView];
    
    return ;
    
    //标题
}

@end
