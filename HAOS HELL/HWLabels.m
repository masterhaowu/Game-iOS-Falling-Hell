//
//  HWLabels.m
//  HAOS HELL
//
//  Created by Hao Wu on 5/28/15.
//  Copyright (c) 2015 Hao Wu. All rights reserved.
//

#import "HWLabels.h"

@implementation HWLabels

+(id)labelWithFont:(NSString *)fontName
{
    HWLabels *label = [HWLabels labelNodeWithFontNamed:fontName];
    label.text = @"0";
    label.number = 0;
    label.fontColor = [UIColor blueColor];
    return label;
}

-(void)increment{
    self.number++;
    self.text = [NSString stringWithFormat:@"%i", self.number];
}


-(void)setPoints:(int)points{
    self.number = points;
    self.text = [NSString stringWithFormat:@"%i", self.number];
}

-(void)reset{
    self.number = 0;
    self.text = @"0";
}


@end
