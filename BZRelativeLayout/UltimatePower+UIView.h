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

typedef NS_ENUM(NSInteger, BZRelativeRule){
    //Must set a view
    BZRelativeRuleStartOf,
    BZRelativeRuleAboveOf,
    BZRelativeRuleEndOf,
    BZRelativeRuleBelowOf,
    
    BZRelativeRuleAlignStart,
    BZRelativeRuleAlignTop,
    BZRelativeRuleAlignEnd,
    BZRelativeRuleAlignBottom,
    
    //Ignore view
    BZRelativeRuleAlignParentStart,
    BZRelativeRuleAlignParentTop,
    BZRelativeRuleAlignParentEnd,
    BZRelativeRuleAlignParentBottom,
    
    //Ignore view,margin
    BZRelativeRuleCenterHorizontalOf,
    BZRelativeRuleCenterVerticalOf,
    BZRelativeRuleCenterOf,
    
    BZRelativeRuleCenterHorizontalInParent,
    BZRelativeRuleCenterVerticalInParent,
    BZRelativeRuleCenterInParent,
    
    BZRelativeRuleBaseline//Only works on AutoLayout
};

@property(nonatomic,getter = isEnableAutoLayout) BOOL enableAutoLayout;//Default is YES

@property (nonatomic,nullable) NSArray<NSDictionary*> *rules;

-(void) addRule:(BZRelativeRule)rule;

-(void) addRule:(BZRelativeRule)rule view:(nullable UIView*) view;

-(void) addRule:(BZRelativeRule)rule margin:(CGFloat) margin;

-(void) addRule:(BZRelativeRule)rule view:(nullable UIView*) view margin:(CGFloat) margin;

@end
