//
//  ListTableViewCell.m
//  VideoPlayer
//
//  Created by ispeak on 2017/12/8.
//  Copyright © 2017年 ydd. All rights reserved.
//

#import "ListTableViewCell.h"
@interface ListTableViewCell()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *urlLabel;

@end

@implementation ListTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, YViewW(self) / 3, YViewH(self))];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_nameLabel];
        
        _urlLabel = [[UILabel alloc] initWithFrame:CGRectMake(YViewW(self) / 3 + 8, 0, YViewW(self) / 3 * 2 - 8, YViewH(self))];
        _urlLabel.font = [UIFont systemFontOfSize:14];
        _urlLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_urlLabel];
        
    }
    return self;
}

- (void)setMode:(VideoListMode *)mode
{
    _nameLabel.text = [NSString stringWithFormat:@"%@:", mode.name];
    _urlLabel.text = [NSString stringWithFormat:@"%@", mode.playerURL];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
