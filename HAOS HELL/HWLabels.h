//
//  HWLabels.h
//  HAOS HELL
//
//  Created by Hao Wu on 5/28/15.
//  Copyright (c) 2015 Hao Wu. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface HWLabels : SKLabelNode
@property int number;

+(id)labelWithFont: (NSString *)fontName;
-(void)increment;
-(void)setPoints:(int)points;
-(void)reset;


@end
