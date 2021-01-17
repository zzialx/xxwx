//
//  TR_RerpairMessageCell.m
//  WXSystem
//
//  Created by admin on 2019/11/14.
//  Copyright © 2019 candy.chen. All rights reserved.
//

#import "TR_RerpairMessageCell.h"

@interface TR_RerpairMessageCell ()
@property(nonatomic,strong)UIView * bgView;
@property(nonatomic,strong)UILabel * titleLab;///<标题
@property(nonatomic,strong)UIView * line;///<线条
@property(nonatomic,strong)UILabel * contentLab;///<内容
@property(nonatomic,strong)UIView * fileView;///<附件
@property(nonatomic,strong)UIView * pictureView;///<图片
@property(nonatomic,strong)UILabel * timeLab;///<时间lable
@property(nonatomic,strong)UIButton * seeBtn;///<查看详情按钮
@property(nonatomic,strong)NSArray * fileList;///<附件列表
@property(nonatomic,strong)NSArray * fileNameArray;///<附件名字列表
@property(nonatomic,strong)NSMutableArray * picList;///<图片列表
@end

@implementation TR_RerpairMessageCell
+ (CGFloat)getCellHeightWithModel:(TR_LesvelMsgModel*)model{
    CGFloat cellHeight = 62.0;
     CGFloat opinionH =  [model.messageInfo yh_heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:(KScreenWidth-60)];
    cellHeight+=opinionH;
    //附件
    if (model.fileUrls.count>0) {
        cellHeight+= 12;
        cellHeight +=  model.fileUrls.count*21 + 10* (model.fileUrls.count/1-1) + 5*2;
    }
    //图片
    if (model.miniPicUrls.count>0) {
        cellHeight+=12;
        NSInteger ccListRow = model.miniPicUrls.count%5==0?model.miniPicUrls.count/5:model.miniPicUrls.count/5+1;
        cellHeight +=  ccListRow*55 + 10* (ccListRow-1) + 5*2;
    }
    //底部按钮
    cellHeight+=35;
    return cellHeight;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor=COLOR_245;
        [self bgView];
        [self titleLab];
        [self line];
        [self contentLab];
        [self fileView];
        [self pictureView];
        [self timeLab];
        [self seeBtn];
    }
    return self;
}
- (void)setMsgModel:(TR_LesvelMsgModel *)msgModel{
    _msgModel = msgModel;
    self.titleLab.text = _msgModel.userName;
    self.contentLab.text = _msgModel.messageInfo;
    CGFloat opinionH =  [_msgModel.messageInfo yh_heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:(KScreenWidth-60)];
    self.contentLab.sd_layout.heightIs(opinionH);
    [self.contentLab updateLayout];
    //文件
    [self addInstructionsFileList:_msgModel.fileUrls fileNameList:_msgModel.fileNames];
    //u图片
    [self addInstructionsPictureList:_msgModel.miniPicUrls];
    self.timeLab.text = _msgModel.messageTime;
    [self.timeLab updateLayout];
}

- (void)showMessageInfo{
    BLOCK_EXEC(self.seeMessageInfo,self.msgModel.messageId);
}
- (void)addInstructionsFileList:(NSArray*)fileList fileNameList:(NSArray*)fileNameList{
    //移除，防止重用
    self.fileList = [NSMutableArray arrayWithCapacity:0];
    self.fileList = [NSMutableArray arrayWithArray:fileList];
    self.fileNameArray=[NSMutableArray arrayWithCapacity:0];
    self.fileNameArray=[NSMutableArray arrayWithArray:fileNameList];
    [self.fileView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSMutableArray *menus = [NSMutableArray new];
    for (int i = 0; i<fileList.count; i++) {
        UIButton *fileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.fileView addSubview:fileBtn];
        fileBtn.sd_layout.heightIs(21);
        [menus addObject:fileBtn];
        [fileBtn setImage:[UIImage imageNamed:[self getFileLogoName:fileList[i]]] forState:UIControlStateNormal];
        [fileBtn setTitle:@"" forState:UIControlStateNormal];
        [fileBtn setTitle:fileNameList[i] forState:UIControlStateNormal];
        [fileBtn setTitleColor:UICOLOR_RGBA(58, 124, 210) forState:UIControlStateNormal];
        fileBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;// 水平左对齐
        fileBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;// 垂直居中对齐
        fileBtn.titleLabel.font=FONT_TEXT(15);
        fileBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        fileBtn.titleEdgeInsets = UIEdgeInsetsMake(0, fileBtn.imageView.frame.size.width+3, 0, 0);
        fileBtn.tag = i;
        [fileBtn addTarget:self action:@selector(openFileContent:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.fileView setupAutoWidthFlowItems:[menus copy] withPerRowItemsCount:1 verticalMargin:10 horizontalMargin:10 verticalEdgeInset:5 horizontalEdgeInset:0];
    CGFloat h =    ( fileList.count/1)*21 + 10* (fileList.count/1-1) + 5*2;
    if (h>0) {
        self.fileView.sd_layout.heightIs(h);
    }else{
        self.fileView.sd_layout.heightIs(0)
        .topSpaceToView(self.contentLab, 0);
    }
    [self.fileView updateLayout];
}

- (void)openFileContent:(UIButton*)sender{
    NSString * file=@"";
    NSString * fileName = @"";
    if (self.fileList.count>0) {
        file= self.fileList[sender.tag];
    }if (self.fileNameArray.count>0) {
        fileName = self.fileNameArray[sender.tag];
    }
    BLOCK_EXEC(self.seeFileInfo,[NSString stringWithFormat:@"%@%@",[GVUserDefaults standardUserDefaults].fileUrl,file],fileName);
}
- (void)addInstructionsPictureList:(NSArray*)pcitureList{
    //移除，防止重用
    NSMutableArray *menus = [NSMutableArray new];
    [self.pictureView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i<pcitureList.count; i++) {
        UIButton *peopleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.pictureView addSubview:peopleBtn];
        peopleBtn.sd_layout.heightIs(55)
        .widthIs(55);
        [peopleBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",  [GVUserDefaults standardUserDefaults].fileUrl ,pcitureList[i]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"timg (1)"]];
        peopleBtn.tag=i;
        [menus addObject:peopleBtn];
        [peopleBtn addTarget:self action:@selector(seeBigPic:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.pictureView setupAutoWidthFlowItems:[menus copy] withPerRowItemsCount:5 verticalMargin:10 horizontalMargin:13 verticalEdgeInset:5 horizontalEdgeInset:0];
    NSInteger ccListRow = pcitureList.count%5==0?pcitureList.count/5:pcitureList.count/5+1;
    CGFloat h =  ccListRow*55 + 10* (ccListRow-1) + 5*2;
    if (ccListRow>0) {
        self.pictureView.sd_layout.heightIs(h);
    }else{
         self.pictureView.sd_layout.heightIs(0)
        .topSpaceToView(self.fileView, 0);
    }
    [self.pictureView updateLayout];
}
- (void)seeBigPic:(UIButton*)sender{
    BLOCK_EXEC(self.showBigPic,sender.tag);
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (UILabel*)titleLab{
    if(IsNilOrNull(_titleLab)){
        _titleLab=[[UILabel alloc]init];
        [self.bgView addSubview:_titleLab];
        _titleLab.sd_layout.leftSpaceToView(self.bgView, 15)
        .rightSpaceToView(self.bgView, 15)
        .topSpaceToView(self.bgView, 15)
        .heightIs(23);
        _titleLab.font=FONT_TEXT(15);
        _titleLab.textColor=COLOR_51;
    }
    return _titleLab;
}
- (UIView*)line{
    if (IsNilOrNull(_line)) {
        _line=[UIView new];
        [self.bgView addSubview:_line];
        _line.backgroundColor=UICOLOR_RGBA(221, 221, 221);
        _line.sd_layout.leftSpaceToView(self.bgView, 15)
        .rightSpaceToView(self.bgView, 15)
        .topSpaceToView(self.titleLab, 13.5)
        .heightIs(0.5);
    }
    return _line;
}
- (UILabel*)contentLab{
    if(IsNilOrNull(_contentLab)){
        _contentLab=[[UILabel alloc]init];
        [self.bgView addSubview:_contentLab];
        _contentLab.sd_layout.leftSpaceToView(self.bgView, 15)
        .rightSpaceToView(self.bgView, 15)
        .topSpaceToView(self.line, 10)
        .heightIs(18);
        _contentLab.font=FONT_TEXT(15);
        _contentLab.textColor=COLOR_102;
        _contentLab.numberOfLines=0;
    }
    return _contentLab;
}
- (UIView*)fileView{
    if (IsNilOrNull(_fileView)) {
        _fileView=[UIView new];
        [self.bgView addSubview:_fileView];
        _fileView.sd_layout.leftSpaceToView(self.bgView, 15)
        .topSpaceToView(self.contentLab,10)
        .rightSpaceToView(self.bgView, 15)
        .heightIs(0);
    }
    return _fileView;
}
- (UIView*)pictureView{
    if (IsNilOrNull(_pictureView)) {
        _pictureView=[UIView new];
        [self.bgView addSubview:_pictureView];
        _pictureView.sd_layout.leftSpaceToView(self.bgView, 15)
         .topSpaceToView(self.fileView,10)
        .rightSpaceToView(self.bgView, 15)
        .heightIs(0);
    }
    return _pictureView;
}
- (UILabel*)timeLab{
    if (IsNilOrNull(_timeLab)) {
        _timeLab=[[UILabel alloc]init];
        [self.bgView addSubview:_timeLab];
        _timeLab.sd_layout.leftSpaceToView(self.bgView, 15)
        .topSpaceToView(self.pictureView, 10)
        .heightIs(18)
        .widthIs(130);
        _timeLab.font=FONT_TEXT(13);
        _timeLab.textColor=COLOR_153;
    }
    return _timeLab;
}
- (UIButton*)seeBtn{
    if (IsNilOrNull(_seeBtn)) {
        _seeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [self.bgView addSubview:_seeBtn];
        _seeBtn.sd_layout.rightSpaceToView(self.bgView, 15)
        .widthIs(54)
        .heightIs(18)
        .centerYEqualToView(_timeLab);
        [_seeBtn setTitle:@"查看详情" forState:UIControlStateNormal];
        [_seeBtn setTitleColor:COLOR_153 forState:UIControlStateNormal];
        _seeBtn.titleLabel.font= FONT_TEXT(13);
        [_seeBtn addTarget:self action:@selector(showMessageInfo) forControlEvents:UIControlEventTouchUpInside];
    }
    return _seeBtn;
}
- (UIView*)bgView{
    if (IsNilOrNull(_bgView)) {
        _bgView=[[UIView alloc]init];
        [self.contentView addSubview:_bgView];
        _bgView.backgroundColor=UIColor.whiteColor;
        _bgView.sd_layout.leftSpaceToView(self.contentView, 15)
        .rightSpaceToView(self.contentView, 15)
        .topSpaceToView(self.contentView, 0)
        .bottomSpaceToView(self.contentView, 0);
    }
    return _bgView;
}
- (NSString*)getFileLogoName:(NSString*)name{
    NSString * fileLogoName=@"wufashibie";
    if ([NSString isPicture:name]) {
        fileLogoName = @"tupian";
    }if ([name containsString:@"doc"]||[name containsString:@"DOC"]) {
        fileLogoName=@"wordlogo";
    }if ([name containsString:@"ppt"]||[name containsString:@"PPT"]) {
        fileLogoName=@"pptlogo";
    }if ([name containsString:@"pdf"]||[name containsString:@"PDF"]) {
        fileLogoName=@"pdflogo";
    }if ([name containsString:@"excel"]||[name containsString:@"xlsx"]) {
        fileLogoName=@"biaogelogo";
    }
    return fileLogoName;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
