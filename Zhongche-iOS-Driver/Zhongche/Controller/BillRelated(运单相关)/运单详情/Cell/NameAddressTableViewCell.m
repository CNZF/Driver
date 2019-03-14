//
//  NameAddressTableViewCell.m
//  Zhongche-ios-driver
//
//  Created by lxy on 2018/5/30.
//  Copyright © 2018年 lxy. All rights reserved.
//

#import "NameAddressTableViewCell.h"

@interface NameAddressTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *startPlace;
@property (weak, nonatomic) IBOutlet UILabel *endPlace;
@property (weak, nonatomic) IBOutlet UILabel *startAddress;
@property (weak, nonatomic) IBOutlet UILabel *endAdress;
@property (weak, nonatomic) IBOutlet UILabel *startName;
@property (weak, nonatomic) IBOutlet UILabel *endName;

@property (weak, nonatomic) IBOutlet UIButton *StartNameBtn;
@property (weak, nonatomic) IBOutlet UIButton *endNameBtn;

@end


@implementation NameAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
       
    }
    return self;
}


- (void)setModel:(ZCTransportOrderModel *)model
{
    _model = model;
    
    if ([model.start_contacts isEqualToString:@""] ||model.start_contacts == nil) {
        self.startName.text =@"李先生";
        [self.StartNameBtn setTitle:@"李先生" forState:UIControlStateNormal];
        model.start_contacts_phone = APP_CUSTOMER_SERVICE;
    }else{
        self.startName.text = model.start_contacts;
        [self.StartNameBtn setTitle:model.start_contacts forState:UIControlStateNormal];
    }
    if ([model.end_contacts isEqualToString:@""] ||model.end_contacts == nil) {
        self.endName.text =@"李先生";
        [self.endNameBtn setTitle:@"李先生" forState:UIControlStateNormal];
        model.end_contacts_phone = APP_CUSTOMER_SERVICE;
    }else{
        self.startName.text = model.start_contacts;
        [self.StartNameBtn setTitle:model.end_contacts forState:UIControlStateNormal];
    }
    
    if ([model.start_region_name isEqualToString:@""] || model.start_region_name == nil) {
        self.startPlace.text = @" ";
    }else{
        self.startPlace.text = model.start_region_name;
    }
    
    if ([model.end_region_name isEqualToString:@""] || model.end_region_name == nil) {
        self.endPlace.text = @" ";
    }else{
        self.endPlace.text = model.end_region_name;
    }
    
    
    if ([model.start_address isEqualToString:@""] || model.start_address == nil) {
        self.startAddress.text = @" ";
    }else{
        self.startAddress.text = model.start_address;
    }
    
    if ([model.end_address isEqualToString:@""] || model.end_address == nil) {
        self.endAdress.text = @" ";
    }else{
        self.endAdress.text = model.end_address;
    }
//    self.endPlace.text = model.end_region_name;
//    self.startAddress.text = model.start_address;
//    self.endAdress.text = model.end_address;
}
- (IBAction)pressBeginCall:(id)sender {
    if (self.block) {
        self.block(0);
    }
}
- (IBAction)pressEndCall:(id)sender {
    if (self.block) {
        self.block(1);
    }
}




@end
