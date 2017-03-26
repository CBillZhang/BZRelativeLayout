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

-(void)addRule:(RelativeRule)rule{
    [self addRule:rule view:nil margin:0];
}

-(void)addRule:(RelativeRule)rule view:(UIView *)view{
    [self addRule:rule view:view margin:0];
}

-(void)addRule:(RelativeRule)rule margin:(CGFloat)margin{
    [self addRule:rule view:nil margin:margin];
}

-(void)addRule:(RelativeRule)rule view:(UIView *)view margin:(CGFloat)margin{
    if (rule == RelativeRuleStartOf || rule == RelativeRuleAboveOf || rule == RelativeRuleEndOf || rule == RelativeRuleBelowOf || rule == RelativeRuleAlignStart || rule == RelativeRuleAlignTop || rule == RelativeRuleAlignEnd || rule == RelativeRuleAlignBottom || rule == RelativeRuleCenterHorizontalOf || rule == RelativeRuleCenterVerticalOf || rule == RelativeRuleCenterOf) {
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
                RelativeRule relativeRule = [[rule objectForKey:RULE] integerValue];
                [view mas_updateConstraints:^(MASConstraintMaker *make) {
                    switch (relativeRule) {
                        case RelativeRuleStartOf:
                            make.right.equalTo(((UIView*)rule[RULEVIEW]).mas_left).with.offset(ruleMargin);
                            break;
                        case RelativeRuleAboveOf:
                        {
                            UIView *v = rule[RULEVIEW];
                            if ([v isKindOfClass:[UITabBar class]]) {
                                make.bottom.equalTo([self findDecorViewController].mas_bottomLayoutGuideTop).with.offset(ruleMargin);
                            }else{
                                make.bottom.equalTo(v.mas_top).with.offset(ruleMargin);
                            }
                        }
                            break;
                        case RelativeRuleEndOf:
                            make.left.equalTo(((UIView*)rule[RULEVIEW]).mas_right).with.offset(ruleMargin);
                            break;
                        case RelativeRuleBelowOf:
                        {
                            UIView *v = rule[RULEVIEW];
                            if ([v isKindOfClass:[UINavigationBar class]]) {
                                make.top.equalTo([self findDecorViewController].mas_topLayoutGuideBottom).with.offset(ruleMargin);
                            }else{
                                make.top.equalTo(v.mas_bottom).with.offset(ruleMargin);
                            }
                        }
                            break;
                        case RelativeRuleAlignStart:
                            make.left.equalTo(rule[RULEVIEW]).with.offset(ruleMargin);
                            break;
                        case RelativeRuleAlignTop:
                            make.top.equalTo(rule[RULEVIEW]).with.offset(ruleMargin);
                            break;
                        case RelativeRuleAlignEnd:
                            make.right.equalTo(rule[RULEVIEW]).with.offset(ruleMargin);
                            break;
                        case RelativeRuleAlignBottom:
                            make.bottom.equalTo(rule[RULEVIEW]).with.offset(ruleMargin);
                            break;
                        case RelativeRuleAlignParentStart:
                            make.left.equalTo(view.superview).with.offset(ruleMargin);
                            break;
                        case RelativeRuleAlignParentTop:
                            make.top.equalTo(view.superview).with.offset(ruleMargin);
                            break;
                        case RelativeRuleAlignParentEnd:
                            make.right.equalTo(view.superview).with.offset(ruleMargin);
                            break;
                        case RelativeRuleAlignParentBottom:
                            make.bottom.equalTo(view.superview).with.offset(ruleMargin);
                            break;
                        case RelativeRuleCenterHorizontalOf:
                            make.centerX.equalTo(rule[RULEVIEW]);
                            break;
                        case RelativeRuleCenterVerticalOf:
                            make.centerY.equalTo(rule[RULEVIEW]);
                            break;
                        case RelativeRuleCenterOf:
                            make.center.equalTo(rule[RULEVIEW]);
                            break;
                        case RelativeRuleCenterHorizontalInParent:
                            make.centerX.equalTo(view.superview);
                            break;
                        case RelativeRuleCenterVerticalInParent:
                            make.centerY.equalTo(view.superview);
                            break;
                        case RelativeRuleCenterInParent:
                            make.center.equalTo(view.superview);
                            break;
                        case RelativeRuleBaseline:
                            make.baseline.equalTo(((UIView*)rule[RULEVIEW]));
                            break;
                    }
                }];
            }
        }else{
            for (NSDictionary *rule in rules) {
                CGFloat ruleMargin = [rule[RULEMARGIN] floatValue];
                RelativeRule relativeRule = [[rule objectForKey:RULE] integerValue];
                switch (relativeRule) {
                    case RelativeRuleStartOf:
                        [view setBzOrigin:CGPointMake((((UIView*)rule[RULEVIEW]).bzLeft-view.frame.size.width)+ruleMargin, view.bzTop)];
                        break;
                    case RelativeRuleAboveOf:
                        [view setBzOrigin:CGPointMake(view.bzLeft, (((UIView*)rule[RULEVIEW]).bzTop-view.frame.size.height)+ruleMargin)];
                        break;
                    case RelativeRuleEndOf:
                        [view setBzOrigin:CGPointMake((((UIView*)rule[RULEVIEW]).bzRight)+ruleMargin, view.bzTop)];
                        break;
                    case RelativeRuleBelowOf:
                        [view setBzOrigin:CGPointMake(view.bzLeft, (((UIView*)rule[RULEVIEW]).bzBottom)+ruleMargin)];
                        break;
                    case RelativeRuleAlignStart:
                        [view setBzOrigin:CGPointMake((((UIView*)rule[RULEVIEW]).bzLeft)+ruleMargin, view.bzTop)];
                        break;
                    case RelativeRuleAlignTop:
                        [view setBzOrigin:CGPointMake(view.bzLeft, (((UIView*)rule[RULEVIEW]).bzTop)+ruleMargin)];
                        break;
                    case RelativeRuleAlignEnd:
                        [view setBzOrigin:CGPointMake((((UIView*)rule[RULEVIEW]).bzRight-view.frame.size.width)+ruleMargin, view.bzTop)];
                        break;
                    case RelativeRuleAlignBottom:
                        [view setBzOrigin:CGPointMake(view.bzLeft, (((UIView*)rule[RULEVIEW]).bzBottom-view.frame.size.height)+ruleMargin)];
                        break;
                    case RelativeRuleAlignParentStart:
                        [view setBzOrigin:CGPointMake(ruleMargin, view.bzTop)];
                        break;
                    case RelativeRuleAlignParentTop:
                        [view setBzOrigin:CGPointMake(view.bzLeft, ruleMargin)];
                        break;
                    case RelativeRuleAlignParentEnd:
                        [view setBzOrigin:CGPointMake((view.superview.frame.size.width-view.frame.size.width)+ruleMargin, view.bzTop)];
                        break;
                    case RelativeRuleAlignParentBottom:
                        [view setBzOrigin:CGPointMake(view.bzLeft, (view.superview.frame.size.height-view.frame.size.height)+ruleMargin)];
                        break;
                    case RelativeRuleCenterHorizontalOf:
                        [view setBzOrigin:CGPointMake((((UIView*)rule[RULEVIEW]).frame.size.width/2-view.frame.size.width/2), view.bzTop)];
                        break;
                    case RelativeRuleCenterVerticalOf:
                        [view setBzOrigin:CGPointMake(view.bzLeft, (((UIView*)rule[RULEVIEW]).frame.size.height/2 - view.frame.size.height/2))];
                        break;
                    case RelativeRuleCenterOf:
                        [view setBzOrigin:CGPointMake((((UIView*)rule[RULEVIEW]).frame.size.width/2-view.frame.size.width/2), (((UIView*)rule[RULEVIEW]).frame.size.height/2 - view.frame.size.height/2))];
                        break;
                    case RelativeRuleCenterHorizontalInParent:
                        [view setBzOrigin:CGPointMake((view.superview.frame.size.width/2-view.frame.size.width/2), view.bzTop)];
                        break;
                    case RelativeRuleCenterVerticalInParent:
                        [view setBzOrigin:CGPointMake(view.bzLeft, (view.superview.frame.size.height/2 - view.frame.size.height/2))];
                        break;
                    case RelativeRuleCenterInParent:
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
