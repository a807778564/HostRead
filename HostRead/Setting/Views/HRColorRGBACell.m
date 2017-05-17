//
//  HRColorRGBACell.m
//  HostRead
//
//  Created by huangrensheng on 2017/5/17.
//  Copyright © 2017年 kawaii. All rights reserved.
//

#import "HRColorRGBACell.h"

@interface HRColorRGBACell()
@property (nonatomic, strong) UILabel *redLabel;
@property (nonatomic, strong) UITextField *redFiled;
@property (nonatomic, strong) UILabel *greenLabel;
@property (nonatomic, strong) UITextField *greenFiled;
@property (nonatomic, strong) UILabel *blueLabel;
@property (nonatomic, strong) UITextField *blueFiled;
@property (nonatomic, strong) UILabel *alphaLabel;
@property (nonatomic, strong) UISlider *alphaSlider;
@property (nonatomic, strong) UIColor *changeColor;
@end

@implementation HRColorRGBACell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.changeColor = [UIColor whiteColor];
        [self initChildView];
        [self makeCons];
    }
    return self;
}

- (void)initChildView{
    self.redLabel = [[UILabel alloc] initWithFont:[UIFont systemFontOfSize:14] TextColor:RGBA(115, 115, 115, 1) Text:@"R(红)"];
    [self.contentView addSubview:self.redLabel];
    
    self.redFiled = [[UITextField alloc] init];
    self.redFiled.textAlignment = NSTextAlignmentCenter;
    self.redFiled.font = [UIFont systemFontOfSize:13];
    self.redFiled.layer.cornerRadius = 4.0f;
    self.redFiled.layer.borderColor = RGBA(190, 190, 190, 1).CGColor;
    self.redFiled.layer.borderWidth = 1.0f;
    NSAttributedString *pl = [[NSAttributedString alloc] initWithString:@"1~255" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:RGBA(201, 201, 201, 1)}];
    self.redFiled.attributedPlaceholder = pl;
    [self.contentView addSubview:self.redFiled];
    
    self.greenLabel = [[UILabel alloc] initWithFont:[UIFont systemFontOfSize:14] TextColor:RGBA(115, 115, 115, 1) Text:@"G(绿)"];
    [self.contentView addSubview:self.greenLabel];
    
    self.greenFiled = [[UITextField alloc] init];
    self.greenFiled.textAlignment = NSTextAlignmentCenter;
    self.greenFiled.font = [UIFont systemFontOfSize:13];
    self.greenFiled.layer.cornerRadius = 4.0f;
    self.greenFiled.layer.borderColor = RGBA(190, 190, 190, 1).CGColor;
    self.greenFiled.layer.borderWidth = 1.0f;
    self.greenFiled.attributedPlaceholder = pl;
    [self.contentView addSubview:self.greenFiled];
    
    self.blueLabel = [[UILabel alloc] initWithFont:[UIFont systemFontOfSize:14] TextColor:RGBA(115, 115, 115, 1) Text:@"B(蓝)"];
    [self.contentView addSubview:self.blueLabel];
    
    self.blueFiled = [[UITextField alloc] init];
    self.blueFiled.textAlignment = NSTextAlignmentCenter;
    self.blueFiled.font = [UIFont systemFontOfSize:13];
    self.blueFiled.layer.cornerRadius = 4.0f;
    self.blueFiled.layer.borderColor = RGBA(190, 190, 190, 1).CGColor;
    self.blueFiled.layer.borderWidth = 1.0f;
    self.blueFiled.attributedPlaceholder = pl;
    [self.contentView addSubview:self.blueFiled];
    
    self.alphaLabel = [[UILabel alloc] initWithFont:[UIFont systemFontOfSize:14] TextColor:RGBA(115, 115, 115, 1) Text:@"透明度"];
    [self.contentView addSubview:self.alphaLabel];
    
    self.alphaSlider = [[UISlider alloc] init];
    [self.alphaSlider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.alphaSlider setThumbImage:[UIImage imageNamed:@"hr_slider.png"] forState:UIControlStateNormal];
    [self.alphaSlider setMinimumTrackImage:[UIImage imageWithColor:RGBA(217, 247, 182, 1)] forState:UIControlStateNormal];
    [self.contentView addSubview:self.alphaSlider];
    
    [self.redFiled addTarget:self action:@selector(didValueChange:) forControlEvents:UIControlEventEditingChanged];
    [self.greenFiled addTarget:self action:@selector(didValueChange:) forControlEvents:UIControlEventEditingChanged];
    [self.blueFiled addTarget:self action:@selector(didValueChange:) forControlEvents:UIControlEventEditingChanged];
}


- (void)setColorType:(NSString *)colorType{
    NSLog(@"[self.redFiled becomeFirstResponder]; %d",[self.redFiled becomeFirstResponder]);
    NSLog(@"[self.redFiled resignFirstResponder]; %d",[self.redFiled resignFirstResponder]);
    _colorType = colorType;
    NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:@"ReadStyle"];
    NSMutableDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if ([colorType isEqualToString:@"主题色"]) {
        
    }else if ([colorType isEqualToString:@"背景色"]) {
        self.changeColor = [dic valueForKey:@"readBack"];
    }else{
        self.changeColor = [dic valueForKey:@"contentColor"];
    }
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;
    [self.changeColor getRed:&red green:&green blue:&blue alpha:&alpha];
    self.redFiled.text = [NSString stringWithFormat:@"%.0f",red*255];
    self.greenFiled.text = [NSString stringWithFormat:@"%.0f",green*255];
    self.blueFiled.text = [NSString stringWithFormat:@"%.0f",blue*255];
    self.alphaSlider.value = alpha;
}

- (void)sliderValueChange:(UISlider *)sli{
    self.changeColor = RGBA([self.redFiled.text floatValue], [self.greenFiled.text floatValue], [self.blueFiled.text floatValue], sli.value);
    [self saveChangeColor];
    self.chColor(self.changeColor);
}

-(void)didValueChange:(UITextField *)text{
    if ([text.text floatValue]>255) {
        text.text = @"255";
    }
    if ([text.text floatValue]<=0) {
        text.text = @"1";
    }
    self.changeColor = RGBA([self.redFiled.text floatValue], [self.greenFiled.text floatValue], [self.blueFiled.text floatValue], self.alphaSlider.value);
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;
    [self.changeColor getRed:&red green:&green blue:&blue alpha:&alpha];
    NSLog(@"R=%.0f G= %.0f B=%.0f A=%.2f",red*255,green*255,blue*255,alpha);
    [self saveChangeColor];
    self.chColor(self.changeColor);
}

- (void)saveChangeColor{
    NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:@"ReadStyle"];
    NSMutableDictionary *aadic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if ([_colorType isEqualToString:@"主题色"]) {
        
    }else if ([_colorType isEqualToString:@"背景色"]) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];//默认阅读模式
        [dic setValue:self.changeColor forKey:@"readBack"];//背景
        [dic setValue:aadic[@"contentColor"] forKey:@"contentColor"];
        NSData *personEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:dic];
        [[NSUserDefaults standardUserDefaults] setValue:personEncodedObject forKey:@"ReadStyle"];
    }else{
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];//默认阅读模式
        [dic setValue:self.changeColor forKey:@"contentColor"];//字体
        [dic setValue:aadic[@"readBack"] forKey:@"readBack"];//背景
        NSData *personEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:dic];
        [[NSUserDefaults standardUserDefaults] setValue:personEncodedObject forKey:@"ReadStyle"];
    }
}

- (void)makeCons{
    __weak typeof(self) weakSelf = self;
    [self.redFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(weakSelf.contentView.mas_trailing).offset(-16);
        make.height.offset(25);
        make.width.offset(44);
        make.top.equalTo(weakSelf.contentView.mas_top);
    }];
    
    [self.redLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.redFiled.mas_centerY);
        make.leading.equalTo(weakSelf.contentView.mas_leading).offset(16);
        make.height.offset(21);
    }];
    
    [self.greenFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(weakSelf.contentView.mas_trailing).offset(-16);
        make.height.offset(25);
        make.width.offset(44);
        make.top.equalTo(weakSelf.redFiled.mas_bottom).offset(10);
    }];
    
    [self.greenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.greenFiled.mas_centerY);
        make.leading.equalTo(weakSelf.contentView.mas_leading).offset(16);
        make.height.offset(21);
    }];
    
    [self.blueFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(weakSelf.contentView.mas_trailing).offset(-16);
        make.height.offset(25);
        make.width.offset(44);
        make.top.equalTo(weakSelf.greenFiled.mas_bottom).offset(10);
    }];
    
    [self.blueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.blueFiled.mas_centerY);
        make.leading.equalTo(weakSelf.contentView.mas_leading).offset(16);
        make.height.offset(21);
    }];
    
    [self.alphaSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(weakSelf.contentView.mas_trailing).offset(-16);
        make.height.offset(35);
        make.top.equalTo(weakSelf.blueFiled.mas_bottom).offset(10);
    }];
    
    [self.alphaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.alphaSlider.mas_centerY);
        make.leading.equalTo(weakSelf.contentView.mas_leading).offset(16);
        make.width.offset(50);
        make.trailing.equalTo(weakSelf.alphaSlider.mas_leading).offset(-10);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
