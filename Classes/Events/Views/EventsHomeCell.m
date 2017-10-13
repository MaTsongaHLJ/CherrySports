//
//  EventsHomeCell.m
//  CherrySports
//
//  Created by dkb on 16/11/10.
//  Copyright © 2016年 dkb. All rights reserved.
//

#import "EventsHomeCell.h"
#import <CoreText/CoreText.h>
#import "CountDownView.h"

@interface EventsHomeCell ()
/** 上阴影*/
@property (nonatomic, strong) UIView *topLine;
/** backImage*/
@property (nonatomic, strong) UIImageView *backImage;
/** 下阴影*/
@property (nonatomic, strong) UIView *bottomLine;

/** title*/
@property (nonatomic, strong) UILabel *title;
/** sub*/
@property (nonatomic, strong) UILabel *time;
/** 倒计时View*/
@property (nonatomic, strong) CountDownView *countDownView;

@property (nonatomic, assign) long long int countDownTime;

/** 定时器*/
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation EventsHomeCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews
{
    [self.contentView addSubview:self.topLine];
    [self.contentView addSubview:self.backImage];
    [self.contentView addSubview:self.bottomLine];
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.time];
    [self.contentView addSubview:self.status];
    [self.contentView addSubview:self.countDownView];
    [self.contentView addSubview:self.theEnd];
}

- (void)setEventsModel:(EventsModel *)eventsModel
{
    _eventsModel = eventsModel;
    // 计数小于0 并且类型的时候 隐藏倒计时
    if ([eventsModel.tGameState isEqualToString:@"3"] || [eventsModel.tGameState isEqualToString:@"4"] || eventsModel.countDownMilli <= 0) {
        self.countDownView.hidden = YES;
    }
    else
    {
        // 手动调用通知的回调
        self.countDownView.hidden = NO;
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a = [dat timeIntervalSince1970]*1000;
//        NSInteger sysTime = (NSInteger)a;     
        _countDownTime = eventsModel.endMilli - a;  //1506751349866  1502947056682.584
//        NSLog(@"cell中获取当前系统时间 - %zd", _countDownTime);
        [self SetcountDownTime];
    }
    NSURL *url = [NSURL URLWithString:[AppTools httpsWithStr:eventsModel.tImgPath]];
    [_backImage sd_setImageWithURL:url placeholderImage:PLACEHOLDW options:SDWebImageAllowInvalidSSLCertificates];
    
    _title.text = eventsModel.tGameName;
    
    NSString *string = [eventsModel.tGameBegin substringToIndex:16];
    _time.text = [NSString stringWithFormat:@"比赛时间：%@", string];

}

- (void)SetcountDownTime
{
    /// 计算倒计时
    NSString *time = [NSString stringWithFormat:@"%lld", _countDownTime/1000];
    NSInteger countDown = time.integerValue;
    //    NSLog(@"timeInterval = %zd", kCountDownManager.timeInterval);
    
    /// 重新赋值
    NSInteger ms = countDown;
    NSInteger ss = 1;
    NSInteger mi = ss * 60;
    NSInteger hh = mi * 60;
    NSInteger dd = hh * 24;
    
    // 剩余的
    NSInteger day = ms / dd;// 天
    NSInteger hour = (ms - day * dd) / hh;// 时
    NSInteger minute = (ms - day * dd - hour * hh) / mi;// 分
    NSInteger second = (ms - day * dd - hour * hh - minute * mi) / ss;// 秒
    NSLog(@"%zd天 %zd小时 %zd分钟 = %zd秒", day, hour, minute, second);
    NSLog(@"毫秒 = %zd", _countDownTime);
    int number = 5.0f;
    CGFloat dayWidth;
    if (day > 99) {
        self.countDownView.dayImage.image = [UIImage imageNamed:@"evevts_three_countdown"];
        dayWidth = 98/2;
        
    }else if (day > 0 && day < 99) {
        self.countDownView.dayImage.image = [UIImage imageNamed:@"evevts_home_countdown"];
        dayWidth = 33.5;
    }else{
        self.countDownView.dayImage.image = [UIImage imageNamed:@"evevts_home_countdown_zero"];
        dayWidth = 33.5;
    }
//    NSDictionary *dic = @{@"dayWidth":[NSString stringWithFormat:@"%f", dayWidth]};
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"dayWidth" object:dic];
    
    if (day == 0 && hour == 0) {
        self.countDownView.hourImage.image = [UIImage imageNamed:@"evevts_home_countdown_zero"];
    }else{
        self.countDownView.hourImage.image = [UIImage imageNamed:@"evevts_home_countdown"];
    }
    if (day == 0 && hour == 0 && minute == 0) {
        self.countDownView.minuesImage.image = [UIImage imageNamed:@"evevts_home_countdown_zero"];
    }else{
        self.countDownView.minuesImage.image = [UIImage imageNamed:@"evevts_home_countdown"];
    }
    
    
    if (day < 10) {
        NSString *days = [NSString stringWithFormat:@"0%zd",day];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:days];
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
        [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0, [attributedString length])];
        
        self.countDownView.dayLabel.attributedText = attributedString;
    }else{
        NSString *days = [NSString stringWithFormat:@"%zd",day];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:days];
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
        [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0, [attributedString length])];
        
        self.countDownView.dayLabel.attributedText = attributedString;
    }
    if (hour < 10) {
        NSString *hours = [NSString stringWithFormat:@"0%zd",hour];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:hours];
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
        [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0, [attributedString length])];
        
        self.countDownView.hourLabel.attributedText = attributedString;
        
    }else{
        NSString *hours = [NSString stringWithFormat:@"%zd",hour];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:hours];
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
        [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0, [attributedString length])];
        
        self.countDownView.hourLabel.attributedText = attributedString;
    }
    if (minute < 10) {
        NSString *minues = [NSString stringWithFormat:@"0%zd",minute];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:minues];
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
        [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0, [attributedString length])];
        
        self.countDownView.minuesLabel.attributedText = attributedString;
    }else{
        NSString *minues = [NSString stringWithFormat:@"%zd",minute];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:minues];
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
        [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0, [attributedString length])];
        
        self.countDownView.minuesLabel.attributedText = attributedString;
    }
}

// 平铺上阴影
- (UIView *)topLine
{
    if (!_topLine)
    {
        UIImage *backImage = [UIImage imageNamed:@"events_cell_topLine"];
        UIColor *bc = [UIColor colorWithPatternImage:backImage];
        _topLine = [UIView new];
        _topLine.backgroundColor = bc;
    }
    return _topLine;
}

-(UIImageView *)backImage
{
    if (!_backImage) {
        _backImage =[AppTools CreateImageViewImageName:@"ss01.png"];
//        _backImage.contentMode = UIViewContentModeScaleAspectFill;
//        _backImage.clipsToBounds = YES;
    }
    return _backImage;
}

// 平铺下阴影
- (UIView *)bottomLine
{
    if (!_bottomLine)
    {
        UIImage *backImage = [UIImage imageNamed:@"events_cell_buttomLine"];
        UIColor *bc = [UIColor colorWithPatternImage:backImage];
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = bc;
    }
    return _bottomLine;
}

- (UILabel *)title
{
    if (!_title) {
        _title = [AppTools createLabelText:@"MaXi-Race China 国际足球赛" Color:TEXT_COLOR_DARK Font:16 TextAlignment:NSTextAlignmentLeft];
//        _title.backgroundColor =[UIColor yellowColor];
    }
    return _title;
}

- (UILabel *)time
{
    if (!_time) {
        _time = [AppTools createLabelText:@"比赛时间：11月26日" Color:TEXT_COLOR_LIGHT Font:12 TextAlignment:NSTextAlignmentLeft];
//        _time.backgroundColor =[UIColor blueColor];
    }
    return _time;
}

- (UILabel *)status
{
    if (!_status) {
        _status = [AppTools createLabelText:@"进行中... ..." Color:TEXT_COLOR_RED Font:12 TextAlignment:NSTextAlignmentLeft];
    }
    return _status;
}

- (CountDownView *)countDownView
{
    if (!_countDownView) {
        _countDownView = [CountDownView new];
//        _countDownView.backgroundColor = [UIColor greenColor];
    }
    return _countDownView;
}

- (UILabel *)theEnd
{
    if (!_theEnd) {
        _theEnd = [AppTools createLabelText:@"报名已结束" Color:TEXT_COLOR_DARK Font:14 TextAlignment:NSTextAlignmentRight];
        _theEnd.hidden = YES;
    }
    return _theEnd;
}

#pragma mark --布局子控件
-(void)layoutSubviews
{
    [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(2);
    }];
    
    [_backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(_topLine.mas_bottom);
        make.height.mas_equalTo(150);
    }];
    
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(_backImage.mas_bottom);
        make.height.mas_equalTo(2);
    }];
    
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        if (IS_IPHONE_5 || IS_IPHONE_4) {
            make.top.mas_equalTo(_bottomLine.mas_bottom).mas_offset(8.5);
        }else{
            make.top.mas_equalTo(_bottomLine.mas_bottom).mas_offset(6.5);
        }
        make.left.mas_equalTo(20);
        make.width.mas_equalTo(SCREEN_WIDTH-185);
    }];
    
    [_time mas_makeConstraints:^(MASConstraintMaker *make) {
        if (IS_IPHONE_5 || IS_IPHONE_4) {
            make.top.mas_equalTo(_title.mas_bottom).mas_offset(8);
        }else{
            make.top.mas_equalTo(_title.mas_bottom).mas_offset(6);
        }
        make.left.equalTo(_title);
    }];
    
    [_countDownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.equalTo(_title.mas_right).offset(3);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(32);
    }];
    
    [_status mas_makeConstraints:^(MASConstraintMaker *make) {
        if (IS_IPHONE_4 || IS_IPHONE_5) {
            make.top.equalTo(_title.mas_top).offset(-5);
        }else{
            make.top.equalTo(_title.mas_top).offset(-4);
        }
        make.centerX.equalTo(_countDownView);
    }];
    
    [_theEnd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(_bottomLine.mas_bottom).mas_offset(17);
        make.left.equalTo(_title.mas_right).offset(15);
    }];
    
    [super layoutSubviews];
}


@end
