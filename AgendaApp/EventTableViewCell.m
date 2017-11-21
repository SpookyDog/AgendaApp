//
//  EventTableViewCell.m
//  AgendaApp
//
//  Created by Daniel Vasquez Fernandez on 11/13/17.
//  Copyright © 2017 Daniel Vasquez Fernandez. All rights reserved.
//

#import "EventTableViewCell.h"

@implementation EventTableViewCell

-(UILabel *)lblEventName{
    if(!_lblEventName){
        _lblEventName = [UILabel new];
        [_lblEventName setFont:[UIFont boldSystemFontOfSize:16]];
        _lblEventName.textAlignment = NSTextAlignmentCenter;
        _lblEventName.textColor = [UIColor blackColor];
    }
    return _lblEventName;
}

-(UILabel *)lblDate{
    if(!_lblDate){
        _lblDate = [UILabel new];
        [_lblDate setFont:[UIFont systemFontOfSize:14]];
        _lblDate.textColor = [UIColor lightGrayColor];
    }
    return _lblDate;
}

-(void)setupData{
    self.lblEventName.text = [self.objDM valueForKey:@"eventName"];
    NSDateFormatter* dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MM/dd/yyyy HH:mm"];
    self.lblDate.text = [dateFormatter stringFromDate:[self.objDM valueForKey:@"eventDate"]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self addSubview:self.lblEventName];
        [self addSubview:self.lblDate];
        
        [self.lblEventName makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.top).with.offset(10);
            make.centerX.equalTo(self.centerX);
            make.left.equalTo(self.left).offset(10);
            make.right.equalTo(self.right).offset(-10);
        }];
        
        [self.lblDate makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lblEventName.bottom).offset(5);
            make.centerX.equalTo(self.centerX);
            make.left.equalTo(self.left).offset(10);
            make.right.equalTo(self.right).offset(-10);
        }];
    }
    return self;
}

@end
