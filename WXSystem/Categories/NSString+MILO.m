//
//  NSString+MILO.m
//  MiloFoundation
//
//  Created by candylee on 2017/7/31.
//  Copyright © 2017年 lenk. All rights reserved.
//

#import "NSString+MILO.h"
#import <CommonCrypto/CommonDigest.h>
#import <SystemConfiguration/CaptiveNetwork.h>


@implementation NSString  (MILO)


+(NSString *)convertToJsonData:(NSDictionary *)dict{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

+ (NSInteger)yh_getAPPVersionNumber
{
    NSString *versionString = [kBundleVersionString stringByReplacingOccurrencesOfString:@"." withString:@""];
    return [versionString integerValue];
}


- (NSString *)yh_md5String
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

-(NSString *)yh_checkQiniuImageUrlAppendWebp
{
    if ([self rangeOfString:@"?imageView"].location == NSNotFound
        && [self rangeOfString:@"?imageMogr"].location == NSNotFound) {
        return self;
    }
        return self;
}

- (CGFloat)yh_priceValue
{
    return [[self stringByReplacingOccurrencesOfString:@"," withString:@""] floatValue];
}


- (BOOL)yh_isEmptyAfterTrimmingWhitespaceAndNewlineCharacters
{
    return [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0;
}


- (NSString *)yh_stringByTrimmingWhitespaceAndNewlineCharacters
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


- (NSString *)URLEncodedStringWithCFStringEncoding:(CFStringEncoding)encoding
{
    return  CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)self, NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), encoding));
}


- (NSString *)yh_URLEncodedString
{
    return [self URLEncodedStringWithCFStringEncoding:kCFStringEncodingUTF8];
}


+ (NSString *)stringWithDate:(NSDate *)date dateFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *dateFormat = nil;
    if (format == nil) {
        dateFormat = @"yyyy-MM-dd HH: mm: ss";
    } else {
        dateFormat = format;
    }
    formatter.dateFormat = dateFormat;
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}

+ (NSString *)yh_CheckStringFormatter:(id)string
{
    if (IsNilOrNull(string)) {
        return @"";
    }
    
    if ([string isKindOfClass:[NSString class]]) {
        return string;
    }
    
    if ([string isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)string stringValue];
    }
    
    return @"";
}
// 是否是邮箱
- (BOOL)yh_conformsToEmailFormat
{
    return [self isMatchedByRegex:@".+@.+\\..+"];
}

- (BOOL)yh_conformsToMobileFormat
{
    return [self isMatchedByRegex:@"^1\\d{10}$"];
}
- (BOOL)yh_conformsToLinePhone{
    return [self isMatchedByRegex:@"^\\d{3,4}-\\d{7,8}$"];

}

// 长度是否在一个范围之内
- (BOOL)yh_isLenghGreaterThanOrEqual:(NSInteger)minimum lessThanOrEqual:(NSInteger)maximum
{
    return ([self length] >= minimum) && ([self length] <= maximum);
}


- (NSRange)yh_firstRangeOfURLSubstringi
{
    static NSDataDetector *dataDetector = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataDetector = [NSDataDetector dataDetectorWithTypes:(NSTextCheckingTypeLink | NSTextCheckingTypeLink)
                                                       error:nil];
    });
    
    NSRange range = [dataDetector rangeOfFirstMatchInString:self
                                                    options:0
                                                      range:NSMakeRange(0, [self length])];
    return range;
}


- (NSString *)yh_firstURLSubstring
{
    NSRange range = [self yh_firstRangeOfURLSubstringi];
    if (range.location == NSNotFound) {
        return nil;
    }
    
    return [self substringWithRange:range];
}


- (NSArray *)yh_URLSubstrings
{
    static NSDataDetector *dataDetector = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataDetector = [NSDataDetector dataDetectorWithTypes:(NSTextCheckingTypeLink | NSTextCheckingTypeLink)
                                                       error:nil];
    });
    
    NSArray *matches = [dataDetector matchesInString:self
                                             options:0
                                               range:NSMakeRange(0, [self length])];
    NSMutableArray *substrings = [NSMutableArray arrayWithCapacity:[matches count]];
    for (NSTextCheckingResult *result in matches) {
        [substrings addObject:[result.URL absoluteString]];
    }
    return [NSArray arrayWithArray:substrings];
}


- (NSString *)yh_firstMatchUsingRegularExpression:(NSRegularExpression *)regularExpression
{
    NSRange range = [regularExpression rangeOfFirstMatchInString:self
                                                         options:0
                                                           range:NSMakeRange(0, [self length])];
    if (range.location == NSNotFound) {
        return nil;
    }
    
    return [self substringWithRange:range];
}


- (NSString *)yh_firstMatchUsingRegularExpressionPattern:(NSString *)regularExpressionPattern
{
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regularExpressionPattern
                                                                                       options:NSRegularExpressionCaseInsensitive
                                                                                         error:nil];
    return [self yh_firstMatchUsingRegularExpression:regularExpression];
}


- (BOOL)yh_matchesRegularExpressionPattern:(NSString *)regularExpressionPattern
{
    NSRange fullRange = NSMakeRange(0, [self length]);
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regularExpressionPattern
                                                                                       options:NSRegularExpressionCaseInsensitive
                                                                                         error:nil];
    NSRange range = [regularExpression rangeOfFirstMatchInString:self
                                                         options:0
                                                           range:fullRange];
    if (NSEqualRanges(fullRange, range)) {
        return YES;
    }
    return NO;
}


- (NSRange)yh_rangeOfFirstMatchUsingRegularExpressionPattern:(NSString *)regularExpressionPattern
{
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regularExpressionPattern
                                                                                       options:NSRegularExpressionCaseInsensitive
                                                                                         error:nil];
    NSRange range = [regularExpression rangeOfFirstMatchInString:self
                                                         options:0
                                                           range:NSMakeRange(0, [self length])];
    return range;
}


- (NSString *)yh_stringByReplacingMatchesUsingRegularExpressionPattern:(NSString *)regularExpressionPattern withTemplate:(NSString *)templ
{
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regularExpressionPattern
                                                                                       options:NSRegularExpressionCaseInsensitive
                                                                                         error:nil];
    NSString *string = [regularExpression stringByReplacingMatchesInString:self
                                                                   options:0
                                                                     range:NSMakeRange(0, [self length])
                                                              withTemplate:templ];
    return string;
}


- (NSDictionary *)yh_URLParameters
{
    NSString *urlString = [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSRange rangeOfQuestionMark = [urlString rangeOfString:@"?" options:NSBackwardsSearch];
    if (rangeOfQuestionMark.location == NSNotFound) {
        return nil;
    }
    
    NSString *parametersString = [urlString substringFromIndex:(rangeOfQuestionMark.location + 1)];
    NSArray *pairs = [parametersString componentsSeparatedByString:@"&"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:[pairs count]];
    for (NSString *aPair in pairs) {
        NSArray *keyAndValue = [aPair componentsSeparatedByString:@"="];
        if ([keyAndValue count] == 2) {
            [parameters setObject:keyAndValue[1] forKey:keyAndValue[0]];
        }
    }
    return parameters;
}

- (BOOL)yh_isPureDigital
{
    NSScanner* scan = [NSScanner scannerWithString:self];
    long long val;
    return [scan scanLongLong:&val] && [scan isAtEnd];
}

- (NSString *)yh_splitUrlWithWidth:(NSString *)width height:(NSString *)height mode:(NSString *)mode
{
    CGSize size = CGSizeMake([width integerValue], [height integerValue]);
    //七牛切图规则限制条件
    // !!!处理后的图片w和h参数不能超过9999像素，总像素不得超过24999999（2500w-1）像素。
    // !!!处理前的图片w和h参数不能超过3万像素，总像素不能超过2亿像素。
    CGFloat kMaxSliceWidth = 9999;
    CGFloat kMaxSliceImageSize = 24999999;
    
    //总像素超出限制
    if (size.width * size.height > kMaxSliceImageSize) {
        CGFloat sizeScale = sqrtf(size.width *size.height / kMaxSliceImageSize);
        size.width = floorf(size.width/sizeScale);
        size.height = floorf(size.height/sizeScale);
        
        if (size.width * size.height > kMaxSliceImageSize) {
            size.width = MAX(size.width-1,1);
            size.height = MAX(size.height-1,1);
        }
    }
    
    //长宽超出限制
    if (size.width > kMaxSliceWidth) {
        if (size.height > 0) {
            size.height = floorf(size.height / size.width * kMaxSliceWidth);
        }
        size.width = kMaxSliceWidth;
    }
    if (size.height > kMaxSliceWidth) {
        if (size.width > 0) {
            size.width = floorf(size.width / size.height * kMaxSliceWidth);
        }
        size.height = kMaxSliceWidth;
    }
    
    NSString *newUrlString = [self stringByReplacingOccurrencesOfString:@"{width}" withString:[NSString stringWithFormat:@"%ld", (long)size.width]];
    newUrlString = [newUrlString stringByReplacingOccurrencesOfString:@"{height}" withString:[NSString stringWithFormat:@"%ld", (long)size.height]];
    newUrlString = [newUrlString stringByReplacingOccurrencesOfString:@"{mode}" withString:mode];
    newUrlString = [newUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return newUrlString;
    
    //    return [[[[self stringByReplacingOccurrencesOfString:@"{width}" withString:[NSString stringWithFormat:@"%zd", size.width]] stringByReplacingOccurrencesOfString:@"{height}" withString:[NSString stringWithFormat:@"%zd", size.height]] stringByReplacingOccurrencesOfString:@"{mode}" withString:mode] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSMutableAttributedString *)getColorTime:(NSString *)color font:(CGFloat)font
{
    NSArray *number = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    NSMutableAttributedString *attributeString  = [[NSMutableAttributedString alloc]initWithString:MakeStringNotNil(self)];
    for (int i = 0; i < self.length; i ++) {
        //这里的小技巧，每次只截取一个字符的范围
        NSString *a = [self substringWithRange:NSMakeRange(i, 1)];
        //判断装有0-9的字符串的数字数组是否包含截取字符串出来的单个字符，从而筛选出符合要求的数字字符的范围NSMakeRange
        if ([number containsObject:a]) {
            [attributeString setAttributes:@{NSForegroundColorAttributeName:[UIColor tr_colorwithHexString:color],NSFontAttributeName:[UIFont systemFontOfSize:font],NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleNone]} range:NSMakeRange(i, 1)];
        }
        
    }
    //完成查找数字，最后将带有字体下划线的字符串显示在UILabel上
    return  attributeString;
    
}
- (NSString *)yh_splitUrlWithWidth:(NSString *)width height:(NSString *)height
{
    return [self yh_splitUrlWithWidth:width height:height mode:@"2"];
}

- (NSMutableAttributedString *)yh_attributedStringWithLineSpacing:(CGFloat)lineSpacing lineBreakMode:(NSLineBreakMode)breakMode textAlignment:(NSTextAlignment)alignment
{
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [paragraphStyle setLineBreakMode:breakMode];
    [paragraphStyle setAlignment:alignment];
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName
                          value:paragraphStyle
                          range:NSMakeRange(0, [self length])];
    return attributedStr;
}

-(NSMutableAttributedString *)yh_attributedStringFromStingWithFont:(UIFont *)font withLineSpacing:(CGFloat)lineSpacing withLineBreakMode:(NSLineBreakMode)breakMode
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName:font}];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [paragraphStyle setLineBreakMode:breakMode];
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName
                          value:paragraphStyle
                          range:NSMakeRange(0, [self length])];
    return attributedStr;
}

-(NSMutableAttributedString *)yh_attributedStringFromStingWithFont:(UIFont *)font lineSpacing:(CGFloat)lineSpacing lineBreakMode:(NSLineBreakMode)breakMode alignment:(NSTextAlignment)alignment
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName:font}];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [paragraphStyle setLineBreakMode:breakMode];
    [paragraphStyle setAlignment:alignment];
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName
                          value:paragraphStyle
                          range:NSMakeRange(0, [self length])];
    return attributedStr;
}

-(CGSize)yh_boundingRectWithSize:(CGSize)size withTextFont:(UIFont *)font withLineSpacing:(CGFloat)lineSpacing withLineBreakMode:(NSLineBreakMode)breakMode
{
    NSMutableAttributedString *attributedText = [self yh_attributedStringFromStingWithFont:font
                                                                           withLineSpacing:lineSpacing withLineBreakMode:breakMode];
    CGSize textSize = CGSizeZero;
    if (attributedText.length > 0) {
        textSize = [attributedText boundingRectWithSize:size
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                context:nil].size;
    }
    return textSize;
}

- (CGFloat)yh_heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width
{
    return ceilf([self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil].size.height);
}


- (CGFloat)yh_singleLineWidthWithFont:(UIFont *)font
{
    return ceilf([self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MIN) options:0 attributes:@{NSFontAttributeName:font} context:nil].size.width);
}

- (CGFloat)yh_singleLineHeightWithFont:(UIFont *)font
{
    return ceilf([self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MIN) options:0 attributes:@{NSFontAttributeName:font} context:nil].size.height);
}
- (NSString *)yh_floatString
{
    if ([self isKindOfClass:[NSString class]]) {
        CGFloat tmp = [self floatValue];
        NSString *str = [NSString stringWithFormat:@"%0.2f",tmp];
        return str;
    } else {
        return @"";
    }
}

- (NSString *)yh_anonymousName
{
    if(self.length == 0) {
        return self;
    }
    
    NSString *username = self;
    if ([username length] == 1||[username length] == 2) {
        NSRange range = NSMakeRange([username length]-1, 1);
        username = [username stringByReplacingCharactersInRange:range withString:@"*"];
        return username;
    } else {
        NSRange range = NSMakeRange(1, username.length-2);
        username = [username stringByReplacingCharactersInRange:range withString:@"***"];
    }
    return username;
}

- (NSString *)yh_stringByRemoveRMBSymbol
{
    return [[self stringByReplacingOccurrencesOfString:@"¥" withString:@""] stringByReplacingOccurrencesOfString:@"￥" withString:@""];
    
}

- (NSString *)yh_anonymousMoblie
{
    if(self.length == 0) {
        return self;
    }
    NSString *anonymousStr = self;
    for (int i = 0; i < anonymousStr.length; i ++) {
        if (anonymousStr.length < 3) {
            break;
        }else{
            if (i >=3 && i < 7) {
                NSRange range = NSMakeRange(i, 1);
                anonymousStr = [anonymousStr stringByReplacingCharactersInRange:range withString:@"*"];
            }
        }
    }
    return anonymousStr;
}

- (NSString *)yh_lastPeople
{
    if (MakeStringNotNil(self).length > 0) {
        NSString *lastPeople = @"";
        CGFloat people = [MakeStringNotNil(self) doubleValue];
        if (people >0 && people <=9999) {
            lastPeople = [NSString stringWithFormat:@"%.0f",people];
        } else if (people >=10000 && people <=99999999) {
            lastPeople = [NSString stringWithFormat:@"%.1f万",people/10000];
        } else if (people >=100000000) {
            lastPeople = [NSString stringWithFormat:@"%.1f亿",people/10000000];
        }
        return lastPeople;
    }
    return @"0";
}

- (NSString *)yh_lastMoney
{
    if (self.length > 0) {
    NSString *lastMoney = @"";
    CGFloat money = [MakeStringNotNil(self) doubleValue];
    if (money >0 && money <=9999) {
        lastMoney = [NSString stringWithFormat:@"%.1f元",money];
    } else if (money >=10000 && money <=99999999) {
        lastMoney = [NSString stringWithFormat:@"%.1f万",money/10000];
    } else if (money >=100000000) {
        lastMoney = [NSString stringWithFormat:@"%.1f亿",money/10000000];
    }
    return lastMoney;
    }
    return @"0元";
}

-(NSString *)yh_replaceString{
    NSString *str = [self stringByReplacingCharactersInRange:NSMakeRange(1, self.length-1) withString:@"**"];
    return str;
}


+ (NSString *)digitUppercase:(NSString *)numString {
    if(numString.length == 0){
        return @"";
    }
    double numberals = [numString doubleValue];
    NSArray *numberchar = @[@"零",@"壹",@"贰",@"叁",@"肆",@"伍",@"陆",@"柒",@"捌",@"玖"];
    NSArray *inunitchar = @[@"",@"拾",@"佰",@"仟"];
    NSArray *unitname = @[@"",@"万",@"亿",@"万亿"];
    //金额乘以100转换成字符串（去除圆角分数值）
    NSString *valstr=[NSString stringWithFormat:@"%.2f",numberals];
    NSString *prefix;
    NSString *suffix;
    if (valstr.length<=2) {
        prefix=@"零元";
        if (valstr.length==0) {
            suffix=@"零角零分";
        } else if (valstr.length==1) {
            suffix=[NSString stringWithFormat:@"%@分",[numberchar objectAtIndex:[valstr intValue]]];
        } else {
            NSString *head=[valstr substringToIndex:1];
            NSString *foot=[valstr substringFromIndex:1];
            suffix = [NSString stringWithFormat:@"%@角%@分",[numberchar objectAtIndex:[head intValue]],[numberchar  objectAtIndex:[foot intValue]]];
        }
    } else {
        prefix=@"";
        suffix=@"";
        NSInteger flag = valstr.length - 2;
        NSString *head=[valstr substringToIndex:flag - 1];
        NSString *foot=[valstr substringFromIndex:flag];
        if (head.length>13) {
            return@"数值太大（最大支持13位整数），无法处理";
        }
        //处理整数部分
        NSMutableArray *ch=[[NSMutableArray alloc]init];
        for (int i = 0; i < head.length; i++) {
            NSString * str=[NSString stringWithFormat:@"%x",[head characterAtIndex:i]-'0'];
            [ch addObject:str];
        }
        int zeronum=0;
        
        for (int i=0; i<ch.count; i++) {
            int index=(ch.count -i-1)%4;//取段内位置
            NSInteger indexloc=(ch.count -i-1)/4;//取段位置
            if ([[ch objectAtIndex:i]isEqualToString:@"0"]) {
                zeronum++;
            } else {
                if (zeronum!=0) {
                    if (index!=3) {
                        prefix=[prefix stringByAppendingString:@"零"];
                    }
                    zeronum=0;
                }
                prefix=[prefix stringByAppendingString:[numberchar objectAtIndex:[[ch objectAtIndex:i]intValue]]];
                prefix=[prefix stringByAppendingString:[inunitchar objectAtIndex:index]];
            }
            if (index ==0 && zeronum<4) {
                prefix=[prefix stringByAppendingString:[unitname objectAtIndex:indexloc]];
            }
        }
        prefix =[prefix stringByAppendingString:@"元"];
        //处理小数位
        if ([foot isEqualToString:@"00"]) {
            suffix =[suffix stringByAppendingString:@"整"];
        }  else if ([foot hasPrefix:@"0"]) {
            NSString *footch=[NSString stringWithFormat:@"%x",[foot characterAtIndex:1]-'0'];
            suffix=[NSString stringWithFormat:@"%@分",[numberchar objectAtIndex:[footch intValue] ]];
        } else {
            NSString *headch=[NSString stringWithFormat:@"%x",[foot characterAtIndex:0]-'0'];
            NSString *footch=[NSString stringWithFormat:@"%x",[foot characterAtIndex:1]-'0'];
            suffix=[NSString stringWithFormat:@"%@角%@分",[numberchar objectAtIndex:[headch intValue]],[numberchar  objectAtIndex:[footch intValue]]];
        }
    }
    return [prefix stringByAppendingString:suffix];
}

- (NSString *)addUnit:(NSString *)unit {
    if ([self isEqualToString:@""] || [unit isEqualToString:@""]) {
        return [NSString stringWithFormat:@"%@", self];
    }
    return [NSString stringWithFormat:@"%@ %@", self, unit];
}

- (CGSize)sizeWithFontSize:(CGFloat)fontSize maxSize:(CGSize)maxSize {
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]} context:nil].size;
}

+ (NSString *)compareStartDate:(NSString *)start endDate:(NSString *)end
{
    //创建两个日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [dateFormatter dateFromString:start];
    NSDate *endDate = [dateFormatter dateFromString:end];
    
    //利用NSCalendar比较日期的差异
    NSCalendar *calendar = [NSCalendar currentCalendar];
    /**
     * 要比较的时间单位,常用如下,可以同时传：
     *    NSCalendarUnitDay : 天
     *    NSCalendarUnitYear : 年
     *    NSCalendarUnitMonth : 月
     *    NSCalendarUnitHour : 时
     *    NSCalendarUnitMinute : 分
     *    NSCalendarUnitSecond : 秒
     */
    NSCalendarUnit unit = NSCalendarUnitDay;//只比较天数差异
    //比较的结果是NSDateComponents类对象
    NSDateComponents *delta = [calendar components:unit fromDate:startDate toDate:endDate options:0];
    //打印
    NSLog(@"%@",delta);
    //获取其中的"天"
    NSLog(@"%ld",delta.day);
    NSString *string = [NSString stringWithFormat:@"%ld",delta.day];
    return string;
}

//比较两个日期的大小  日期格式为2016-08-14 08：46：20
+ (NSString *)compareDate:(NSString*)aDate withDate:(NSString*)bDate formatter:(NSString*)formatter
{
    NSString * aa = @"";
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:formatter];
    NSDate *dta = [[NSDate alloc] init];
    NSDate *dtb = [[NSDate alloc] init];
    
    dta = [dateformater dateFromString:aDate];
    dtb = [dateformater dateFromString:bDate];
    NSComparisonResult result = [dta compare:dtb];
    if (result == NSOrderedSame){
        aa = @"0";
    }else if (result==NSOrderedAscending) {
       //endDate比startDate大
        aa = @"1";
        
    }else if (result==NSOrderedDescending){
         //endDate比startDate小
        aa = @"-1";
    }
    return aa;
}
+ (NSString*)getUserModelUserName:(NSString*)userName{
    NSString * userLogoName=@"";
    userName= [userName stringByReplacingOccurrencesOfString:@" " withString:@""];
    userLogoName = userName.length>2?[userName substringFromIndex:userName.length-2]:userName;
    return userLogoName;
}
+ (UIImage *)zd_imageWithsize:(CGSize)size
                         text:(NSString *)text font:(NSInteger)font
                     circular:(BOOL)isCircular
{
    UIColor * color = HEAD_COLOR;
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // circular
    if (isCircular) {
        CGPathRef path = CGPathCreateWithEllipseInRect(rect, NULL);
        CGContextAddPath(context, path);
        CGContextClip(context);
        CGPathRelease(path);
    }
    
    // color
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    // text
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:font],NSParagraphStyleAttributeName:style,NSForegroundColorAttributeName:[UIColor whiteColor]};
    //将文字绘制上去
    CGSize textSize = [text sizeWithAttributes:dic];
    [text drawInRect:CGRectMake((size.width - textSize.width) / 2, (size.height - textSize.height) / 2, textSize.width, textSize.height) withAttributes:dic];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
+ (BOOL)isPicture:(NSString*)picName{
    BOOL isPic = NO;
    if([picName hasSuffix:@"png"]||[picName hasSuffix:@"jpg"]||[picName hasSuffix:@"PNG"]||[picName hasSuffix:@"gif"]||[picName hasSuffix:@"JPG"]||[picName hasSuffix:@"GIF"]||[picName hasSuffix:@"jpeg"]||[picName hasSuffix:@"JPEG"]){
         isPic = YES;
    }
    return isPic;
}
+ (BOOL)isOutWorkWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude companyLatitude:(CGFloat)companyLatitude companyLongitude:(CGFloat)companyLongitude cardDistance:(NSInteger)cardDistance{
    BOOL isOutWork = NO;
    MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(latitude,longitude));
    MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(companyLatitude,companyLongitude));
    //2.计算距离
    CLLocationDistance meters = MAMetersBetweenMapPoints(point1,point2);
    NSLog(@"距离公司===%f",meters);
    if (meters < cardDistance) {
        //距离公司的距离大于打卡范围，如果打卡的话就是外勤
        isOutWork = YES;
    }
    return isOutWork;
}
+(BOOL)isWifiCardWithPhoneWifiMac:(NSString*)phoneWifiMac companyWifiList:(NSString*)companyWifi{
    BOOL isWifiCompany = NO;
    if ([phoneWifiMac isEqualToString:companyWifi]) {
        isWifiCompany = YES;
    }
    return  isWifiCompany;
}
+ (NSString *)wifiName
{
    NSArray *ifs = (__bridge_transfer NSArray *)CNCopySupportedInterfaces();
    if (!ifs) {
        return nil;
    }
    NSDictionary *info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer NSDictionary *)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
    }
    NSString *wifiName = info[@"SSID"];
    return wifiName;
}

+ (NSString *)wifiMac
{
    NSArray *ifs = CFBridgingRelease(CNCopySupportedInterfaces());
    id info = nil;
    for (NSString *ifname in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((CFStringRef) ifname);
        if (info && [info count]) {
            break;
        }
    }
    NSDictionary *dic = (NSDictionary *)info;
    NSString *bssid = [dic objectForKey:@"BSSID"];
    NSMutableString * mac = [[NSMutableString alloc]init];
    NSArray * strArray = [bssid componentsSeparatedByString:@":"];
    for (int i =0; i<strArray.count; i++) {
        NSString * dataStr = @"";
        NSString * mac_ip = strArray[i];
        if (mac_ip.length==1) {
            dataStr = [NSString stringWithFormat:@"0%@",mac_ip];
        }else{
            dataStr = mac_ip;
        }
        if (i==0) {
             [mac appendString:[NSString stringWithFormat:@"%@",dataStr]];
        }else{
             [mac appendString:[NSString stringWithFormat:@":%@",dataStr]];
        }
       
    }

    NSString * wifiMac  = [NSString stringWithFormat:@"%@",mac];
    wifiMac = [wifiMac stringByReplacingOccurrencesOfString:@"\x10" withString:@""];
    return wifiMac;
}

+(NSString*)getCurrentTimeFromDate{
    NSDate * date = [NSDate date];
    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    //NSDate转NSString
    NSString *currentDateString=[dateFormatter stringFromDate:date];
    return currentDateString;
}
+(NSString*)getCurrentTimeFromDate1{
    NSDate * date = [NSDate date];
    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    //NSDate转NSString
    NSString *currentDateString=[dateFormatter stringFromDate:date];
    return currentDateString;
}
+(NSString*)getCurrentTimeFromDate2{
    NSDate * date = [NSDate date];
    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //NSDate转NSString
    NSString *currentDateString=[dateFormatter stringFromDate:date];
    return currentDateString;
}
+ (NSString *)returndate:(NSNumber *)num{
    NSString * str1=[NSString stringWithFormat:@"%@",num];
    NSInteger x = [str1 integerValue];
    NSDate * date1 = [NSDate dateWithTimeIntervalSince1970:x/1000];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"HH:mm:ss"];
    dateformatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSString* dateStr =[dateformatter stringFromDate:date1];
    return dateStr;
}
+ (NSString *)returnserverdate:(NSNumber *)num{
    NSString * str1=[NSString stringWithFormat:@"%@",num];
    NSInteger x = [str1 integerValue];
    NSDate * date1 = [NSDate dateWithTimeIntervalSince1970:x/1000];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"yyyy-MM-ddHH:mm:ss"];
    dateformatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    NSString* dateStr =[dateformatter stringFromDate:date1];
    return dateStr;
}
+(NSDate*)dateFromString:(NSString*)string{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-ddHH:mm:ss"];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];//
    //NSString转NSDate
    NSDate * date  = [formatter dateFromString:string];
    return date;
}
#pragma mark-----时间处理
+ (NSDate*)wortDateFromString:(NSString*)string{
    //设置转换格式
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-ddHH:mm:ss"];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    //NSString转NSDate
    NSDate *date=[formatter dateFromString:string];
    return date;
}
+ (long long)getDateTimeTOMilliSeconds:(NSDate *)datetime{
    NSTimeInterval interval = [datetime timeIntervalSince1970];
//    NSLog(@"转换的时间戳=%f",interval);
    long long totalMilliseconds = interval*1000 ;
//    NSLog(@"totalMilliseconds=%llu",totalMilliseconds);
    return totalMilliseconds;
}

/**
 early_leave 早退
 formal 异常
 out_work 外勤
 normal 正常
 later 迟到
 @param serverState 服务器状态值
 */
+ (NSString*)getCardStateImgWithServerState:(NSString*)serverState{
    NSString * stateImg = @"";
    switch (serverState.integerValue) {
         case 104:
         case 107:
            stateImg = @"later";
            break;
         case 105:
         case 202:
         case 101:
         case 106:
         case 108:
         case 109:
         case 205:
         case 206:
            stateImg = @"normal";
            break;
        case 204:
        case 207:
            stateImg = @"early_leave";
            break;
        default:
            break;
    }
    return stateImg;
}
+ (BOOL)checkPassword:(NSString *) password
{
    
    NSString *pattern = @"^(?![a-zA-Z]+$)(?![A-Z0-9]+$)(?![A-Z\\W_]+$)(?![a-z0-9]+$)(?![a-z\\W_]+$)(?![0-9\\W_]+$)[a-zA-Z0-9\\W_]{6,20}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
    
}
+ (BOOL)openLocationService{
     BOOL isOPen = NO;
    if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
           isOPen = YES;
    }
    return isOPen;
}
+ (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
+(NSAttributedString *)titleLabText:(NSString *)title keyWords:(NSString*)keyWords{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:title];
    //匹配搜索关键字，并且改变颜色
    if(keyWords.length >0)
    {
        [title enumerateStringsMatchedByRegex:keyWords usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
            [attributeString addAttribute:NSForegroundColorAttributeName value:UICOLOR_RGBA(76, 159, 255) range:*capturedRanges];
            
        }];
    }
    return attributeString;
}
/**
 *  将阿拉伯数字转换为中文数字
 */
+(NSString *)translationArabicNum:(NSInteger)arabicNum
{
    NSString *arabicNumStr = [NSString stringWithFormat:@"%ld",(long)arabicNum];
    NSArray *arabicNumeralsArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
    NSArray *chineseNumeralsArray = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"零"];
    NSArray *digits = @[@"个",@"十",@"百",@"千",@"万",@"十",@"百",@"千",@"亿",@"十",@"百",@"千",@"兆"];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjects:chineseNumeralsArray forKeys:arabicNumeralsArray];
    
    if (arabicNum < 20 && arabicNum > 9) {
        if (arabicNum == 10) {
            return @"十";
        }else{
            NSString *subStr1 = [arabicNumStr substringWithRange:NSMakeRange(1, 1)];
            NSString *a1 = [dictionary objectForKey:subStr1];
            NSString *chinese1 = [NSString stringWithFormat:@"十%@",a1];
            return chinese1;
        }
    }else{
        NSMutableArray *sums = [NSMutableArray array];
        for (int i = 0; i < arabicNumStr.length; i ++)
        {
            NSString *substr = [arabicNumStr substringWithRange:NSMakeRange(i, 1)];
            NSString *a = [dictionary objectForKey:substr];
            NSString *b = digits[arabicNumStr.length -i-1];
            NSString *sum = [a stringByAppendingString:b];
            if ([a isEqualToString:chineseNumeralsArray[9]])
            {
                if([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]])
                {
                    sum = b;
                    if ([[sums lastObject] isEqualToString:chineseNumeralsArray[9]])
                    {
                        [sums removeLastObject];
                    }
                }else
                {
                    sum = chineseNumeralsArray[9];
                }
                
                if ([[sums lastObject] isEqualToString:sum])
                {
                    continue;
                }
            }
            
            [sums addObject:sum];
        }
        NSString *sumStr = [sums  componentsJoinedByString:@""];
        NSString *chinese = [sumStr substringToIndex:sumStr.length-1];
        return chinese;
    }
}

@end
