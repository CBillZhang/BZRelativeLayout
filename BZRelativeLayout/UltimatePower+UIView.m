//
//  UltimatePower.m
//  BZFramework
//
//  Created by Bill on 16/4/23.
//  Copyright © 2016年 Bill. All rights reserved.
//

#import <objc/runtime.h>
#import <Masonry/Masonry.h>
#import "UltimatePower+UIView.h"

@implementation UIView (BZSize)

-(CGFloat)bzLeft{
    return self.frame.origin.x;
}

-(void)setBzLeft:(CGFloat)bzLeft{
    [self setBzOrigin:CGPointMake(bzLeft, self.bzTop)];
}

- (CGFloat)bzTop {
    return self.frame.origin.y;
}

- (void)setBzTop:(CGFloat)y {
    [self setBzOrigin:CGPointMake(self.bzLeft, y)];
}

- (CGFloat)bzRight {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setBzRight:(CGFloat)right {
    [self setBzOrigin:CGPointMake(right - self.frame.size.width, self.bzTop)];
}

- (CGFloat)bzBottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBzBottom:(CGFloat)bottom {
    [self setBzOrigin:CGPointMake(self.bzLeft, bottom - self.frame.size.height)];
}

- (CGPoint)bzOrigin {
    return self.frame.origin;
}

-(void)setBzOrigin:(CGPoint)bzOrigin {
    if (!CGPointEqualToPoint(self.frame.origin, bzOrigin)) {
        CGRect size = self.frame;
        size.origin = bzOrigin;
        self.frame = size;
    }
}

@end


@implementation UIView (BZRelativeLayout)

static const NSString *RULE = @"rule";
static const NSString *RULEVIEW = @"ruleView";
static const NSString *RULEMARGIN = @"ruleMargin";

-(void)setRules:(NSArray<NSDictionary*> * _Nullable)rules{
    objc_setAssociatedObject(self, @selector(rules), rules, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSArray<NSDictionary*> *)rules{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)addRule:(BZRelativeRule)rule{
    [self addRule:rule view:nil margin:0];
}

-(void)addRule:(BZRelativeRule)rule view:(UIView *)view{
    [self addRule:rule view:view margin:0];
}

-(void)addRule:(BZRelativeRule)rule margin:(CGFloat)margin{
    [self addRule:rule view:nil margin:margin];
}

-(void)addRule:(BZRelativeRule)rule view:(UIView *)view margin:(CGFloat)margin{
    if (rule == BZRelativeRuleStartOf || rule == BZRelativeRuleAboveOf || rule == BZRelativeRuleEndOf || rule == BZRelativeRuleBelowOf || rule == BZRelativeRuleAlignStart || rule == BZRelativeRuleAlignTop || rule == BZRelativeRuleAlignEnd || rule == BZRelativeRuleAlignBottom || rule == BZRelativeRuleCenterHorizontalOf || rule == BZRelativeRuleCenterVerticalOf || rule == BZRelativeRuleCenterOf) {
        if (!view) {
            NSLog(@"You may forget to set the view:%@",view);
            return;
        }
    }
    
    NSMutableArray *rules = (NSMutableArray*)self.rules;
    if (!rules) {
        rules = [NSMutableArray array];
    }
    [rules addObject:[NSDictionary dictionaryWithObjectsAndKeys:@(rule),RULE,[NSNumber numberWithFloat:margin],RULEMARGIN,view,RULEVIEW, nil]];
    self.rules = rules;
    
    if (self.enableAutoLayout) {
        [self applyRelativeSizeRules];
    }else{
        [self setNeedsLayout];
    }
}

-(void)applyRelativeSizeRules{
    UIView *view = self;
    NSArray *rules = self.rules;
    if (rules) {
        if (self.enableAutoLayout) {
            for (NSDictionary *rule in rules) {
                CGFloat ruleMargin = [rule[RULEMARGIN] floatValue];
                BZRelativeRule relativeRule = [[rule objectForKey:RULE] integerValue];
                [view mas_updateConstraints:^(MASConstraintMaker *make) {
                    switch (relativeRule) {
                        case BZRelativeRuleStartOf:
                            make.right.equalTo(((UIView*)rule[RULEVIEW]).mas_left).with.offset(ruleMargin);
                            break;
                        case BZRelativeRuleAboveOf:
                        {
                            UIView *v = rule[RULEVIEW];
                            if ([v isKindOfClass:[UITabBar class]]) {
                                make.bottom.equalTo([self findDecorViewController].mas_bottomLayoutGuideTop).with.offset(ruleMargin);
                            }else{
                                make.bottom.equalTo(v.mas_top).with.offset(ruleMargin);
                            }
                        }
                            break;
                        case BZRelativeRuleEndOf:
                            make.left.equalTo(((UIView*)rule[RULEVIEW]).mas_right).with.offset(ruleMargin);
                            break;
                        case BZRelativeRuleBelowOf:
                        {
                            UIView *v = rule[RULEVIEW];
                            if ([v isKindOfClass:[UINavigationBar class]]) {
                                make.top.equalTo([self findDecorViewController].mas_topLayoutGuideBottom).with.offset(ruleMargin);
                            }else{
                                make.top.equalTo(v.mas_bottom).with.offset(ruleMargin);
                            }
                        }
                            break;
                        case BZRelativeRuleAlignStart:
                            make.left.equalTo(rule[RULEVIEW]).with.offset(ruleMargin);
                            break;
                        case BZRelativeRuleAlignTop:
                            make.top.equalTo(rule[RULEVIEW]).with.offset(ruleMargin);
                            break;
                        case BZRelativeRuleAlignEnd:
                            make.right.equalTo(rule[RULEVIEW]).with.offset(ruleMargin);
                            break;
                        case BZRelativeRuleAlignBottom:
                            make.bottom.equalTo(rule[RULEVIEW]).with.offset(ruleMargin);
                            break;
                        case BZRelativeRuleAlignParentStart:
                            make.left.equalTo(view.superview).with.offset(ruleMargin);
                            break;
                        case BZRelativeRuleAlignParentTop:
                            make.top.equalTo(view.superview).with.offset(ruleMargin);
                            break;
                        case BZRelativeRuleAlignParentEnd:
                            make.right.equalTo(view.superview).with.offset(ruleMargin);
                            break;
                        case BZRelativeRuleAlignParentBottom:
                            make.bottom.equalTo(view.superview).with.offset(ruleMargin);
                            break;
                        case BZRelativeRuleCenterHorizontalOf:
                            make.centerX.equalTo(rule[RULEVIEW]);
                            break;
                        case BZRelativeRuleCenterVerticalOf:
                            make.centerY.equalTo(rule[RULEVIEW]);
                            break;
                        case BZRelativeRuleCenterOf:
                            make.center.equalTo(rule[RULEVIEW]);
                            break;
                        case BZRelativeRuleCenterHorizontalInParent:
                            make.centerX.equalTo(view.superview);
                            break;
                        case BZRelativeRuleCenterVerticalInParent:
                            make.centerY.equalTo(view.superview);
                            break;
                        case BZRelativeRuleCenterInParent:
                            make.center.equalTo(view.superview);
                            break;
                        case BZRelativeRuleBaseline:
                            make.baseline.equalTo(((UIView*)rule[RULEVIEW]));
                            break;
                    }
                }];
            }
        }else{
            for (NSDictionary *rule in rules) {
                CGFloat ruleMargin = [rule[RULEMARGIN] floatValue];
                BZRelativeRule relativeRule = [[rule objectForKey:RULE] integerValue];
                switch (relativeRule) {
                    case BZRelativeRuleStartOf:
                        [view setBzOrigin:CGPointMake((((UIView*)rule[RULEVIEW]).bzLeft-view.frame.size.width)+ruleMargin, view.bzTop)];
                        break;
                    case BZRelativeRuleAboveOf:
                        [view setBzOrigin:CGPointMake(view.bzLeft, (((UIView*)rule[RULEVIEW]).bzTop-view.frame.size.height)+ruleMargin)];
                        break;
                    case BZRelativeRuleEndOf:
                        [view setBzOrigin:CGPointMake((((UIView*)rule[RULEVIEW]).bzRight)+ruleMargin, view.bzTop)];
                        break;
                    case BZRelativeRuleBelowOf:
                        [view setBzOrigin:CGPointMake(view.bzLeft, (((UIView*)rule[RULEVIEW]).bzBottom)+ruleMargin)];
                        break;
                    case BZRelativeRuleAlignStart:
                        [view setBzOrigin:CGPointMake((((UIView*)rule[RULEVIEW]).bzLeft)+ruleMargin, view.bzTop)];
                        break;
                    case BZRelativeRuleAlignTop:
                        [view setBzOrigin:CGPointMake(view.bzLeft, (((UIView*)rule[RULEVIEW]).bzTop)+ruleMargin)];
                        break;
                    case BZRelativeRuleAlignEnd:
                        [view setBzOrigin:CGPointMake((((UIView*)rule[RULEVIEW]).bzRight-view.frame.size.width)+ruleMargin, view.bzTop)];
                        break;
                    case BZRelativeRuleAlignBottom:
                        [view setBzOrigin:CGPointMake(view.bzLeft, (((UIView*)rule[RULEVIEW]).bzBottom-view.frame.size.height)+ruleMargin)];
                        break;
                    case BZRelativeRuleAlignParentStart:
                        [view setBzOrigin:CGPointMake(ruleMargin, view.bzTop)];
                        break;
                    case BZRelativeRuleAlignParentTop:
                        [view setBzOrigin:CGPointMake(view.bzLeft, ruleMargin)];
                        break;
                    case BZRelativeRuleAlignParentEnd:
                        [view setBzOrigin:CGPointMake((view.superview.frame.size.width-view.frame.size.width)+ruleMargin, view.bzTop)];
                        break;
                    case BZRelativeRuleAlignParentBottom:
                        [view setBzOrigin:CGPointMake(view.bzLeft, (view.superview.frame.size.height-view.frame.size.height)+ruleMargin)];
                        break;
                    case BZRelativeRuleCenterHorizontalOf:
                        [view setBzOrigin:CGPointMake((((UIView*)rule[RULEVIEW]).frame.size.width/2-view.frame.size.width/2), view.bzTop)];
                        break;
                    case BZRelativeRuleCenterVerticalOf:
                        [view setBzOrigin:CGPointMake(view.bzLeft, (((UIView*)rule[RULEVIEW]).frame.size.height/2 - view.frame.size.height/2))];
                        break;
                    case BZRelativeRuleCenterOf:
                        [view setBzOrigin:CGPointMake((((UIView*)rule[RULEVIEW]).frame.size.width/2-view.frame.size.width/2), (((UIView*)rule[RULEVIEW]).frame.size.height/2 - view.frame.size.height/2))];
                        break;
                    case BZRelativeRuleCenterHorizontalInParent:
                        [view setBzOrigin:CGPointMake((view.superview.frame.size.width/2-view.frame.size.width/2), view.bzTop)];
                        break;
                    case BZRelativeRuleCenterVerticalInParent:
                        [view setBzOrigin:CGPointMake(view.bzLeft, (view.superview.frame.size.height/2 - view.frame.size.height/2))];
                        break;
                    case BZRelativeRuleCenterInParent:
                        [view setBzOrigin:CGPointMake((view.superview.frame.size.width/2-view.frame.size.width/2), (view.superview.frame.size.height/2 - view.frame.size.height/2))];
                        break;
                    default:break;
                }
            }
        }
    }
}

-(void)layoutSubviews{
    if (!self.enableAutoLayout) {
        [self applyRelativeSizeRules];
    }
}

-(UIViewController*) findDecorViewController{
    UIResponder *target=self.nextResponder;
    while (target) {
        if ([target isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)target;
        }else{
            target = target.nextResponder;
        }
    }
    NSLog(@"Sorry,didn't find it.");
    return nil;
}

#define K_DATA_BY_USER @"bzDataByUser"
static NSString *isEnableAutoLayout = @"bzIsEnableAutoLayout";

-(BOOL)isEnableAutoLayout{
    NSDictionary *dic = objc_getAssociatedObject(self, _cmd);
    return [[dic objectForKey:K_DATA_BY_USER] boolValue]?[[dic objectForKey:isEnableAutoLayout] boolValue]:YES;
}

-(void)setEnableAutoLayout:(BOOL)enableAutoLayout{
    objc_setAssociatedObject(self, @selector(isEnableAutoLayout), @{K_DATA_BY_USER:@YES,isEnableAutoLayout:@(enableAutoLayout)}, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
