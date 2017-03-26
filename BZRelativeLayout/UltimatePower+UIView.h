//
//  UltimatePower.h
//  BZFramework
//
//  Created by Bill on 16/4/23.
//  Copyright © 2016年 Bill. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (BZSize)

@property(nonatomic) CGFloat bzLeft;
@property(nonatomic) CGFloat bzTop;
@property(nonatomic) CGFloat bzRight;
@property(nonatomic) CGFloat bzBottom;

@property(nonatomic) CGPoint bzOrigin;

@end


@interface UIView (BZRelativeLayout)

typedef NS_ENUM(NSInteger, RelativeRule){
    //Must set a view
    RelativeRuleStartOf,
    RelativeRuleAboveOf,
    RelativeRuleEndOf,
    RelativeRuleBelowOf,
    
    RelativeRuleAlignStart,
    RelativeRuleAlignTop,
    RelativeRuleAlignEnd,
    RelativeRuleAlignBottom,
    
    //Ignore view
    RelativeRuleAlignParentStart,
    RelativeRuleAlignParentTop,
    RelativeRuleAlignParentEnd,
    RelativeRuleAlignParentBottom,
    
    //Ignore view,margin
    RelativeRuleCenterHorizontalOf,
    RelativeRuleCenterVerticalOf,
    RelativeRuleCenterOf,
    
    RelativeRuleCenterHorizontalInParent,
    RelativeRuleCenterVerticalInParent,
    RelativeRuleCenterInParent,
    
    RelativeRuleBaseline//Only works on AutoLayout
};

@property(nonatomic,getter = isEnableAutoLayout) BOOL enableAutoLayout;//Default is YES

@property (nonatomic,nullable) NSArray<NSDictionary*> *rules;

-(void) addRule:(RelativeRule)rule;

-(void) addRule:(RelativeRule)rule view:(nullable UIView*) view;

-(void) addRule:(RelativeRule)rule margin:(CGFloat) margin;

-(void) addRule:(RelativeRule)rule view:(nullable UIView*) view margin:(CGFloat) margin;

@end
