//
//  TR_RepairProgressInfoCell.m
//  WXSystem
//
//  Created by admin on 2019/11/18.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_RepairProgressInfoCell.h"


#define CELL_COUNT   4

@interface TR_RepairProgressInfoCell ()
@property (weak, nonatomic) IBOutlet UILabel *repairTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *repairContentLab;
@property (weak, nonatomic) IBOutlet UILabel *repairPictureTitle;
@property (weak, nonatomic) IBOutlet UIView *repairPictureView;

@end


@implementation TR_RepairProgressInfoCell
+(CGFloat)getProgressCellHeightServiceContent:(NSString*)serviceContent servicePic:(NSArray*)servicePic{
    CGFloat cellHeight = 57.5;
    CGFloat opinionH =  [serviceContent yh_heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:(KScreenWidth-52.5)];
    cellHeight+=opinionH;
    NSInteger ccListRow = servicePic.count%CELL_COUNT==0?servicePic.count/CELL_COUNT:servicePic.count/CELL_COUNT+1;
    CGFloat picH =  ccListRow*60 + 10* (ccListRow-1) + 5*2;
    cellHeight+=picH;
    return cellHeight;
}
#pragma mark-------UIDATA----
- (void)showCellSection:(NSInteger)section serviceModel:(TR_ServicePgrDetialModel*)serviceModel{
    if (section==1) {
        self.repairTitleLab.text=@"维修前情况";
        self.repairPictureTitle.text=@"维修前图片";
        self.repairContentLab.text = serviceModel.beforeService;
        [self addProgressInstructionsPictureList:serviceModel.beforePicUrls];
    }if (section==2) {
        self.repairTitleLab.text=@"维修后情况";
        self.repairPictureTitle.text=@"维修后图片";
        self.repairContentLab.text = serviceModel.afterService;
        [self addProgressInstructionsPictureList:serviceModel.afterPicUrls];
    }
}
- (void)addProgressInstructionsPictureList:(NSArray*)pcitureList{
    //移除，防止重用
    NSMutableArray *menus = [NSMutableArray new];
    [self.repairPictureView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i<pcitureList.count; i++) {
        UIButton *peopleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.repairPictureView addSubview:peopleBtn];
        peopleBtn.sd_layout.heightIs(60)
        .widthIs(60);
        NSString * picURl =[NSString stringWithFormat:@"%@%@",[GVUserDefaults standardUserDefaults].fileUrl,pcitureList[i]];
        [peopleBtn sd_setImageWithURL:[NSURL URLWithString:picURl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"timg (1)"]];
        peopleBtn.tag=i;
        [menus addObject:peopleBtn];
        [peopleBtn addTarget:self action:@selector(seeBigPic:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.repairPictureView setupAutoWidthFlowItems:[menus copy] withPerRowItemsCount:CELL_COUNT verticalMargin:10 horizontalMargin:13 verticalEdgeInset:5 horizontalEdgeInset:0];
    NSInteger ccListRow = pcitureList.count%CELL_COUNT==0?pcitureList.count/CELL_COUNT:pcitureList.count/CELL_COUNT+1;
    CGFloat h =  ccListRow*60 + 10* (ccListRow-1) + 5*2;
    self.repairPictureView.sd_layout.heightIs(h);
    [self.repairPictureView updateLayout];
}
-(void)seeBigPic:(UIButton*)sender{
    BLOCK_EXEC(self.showBigPic,sender.tag);
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle=UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
