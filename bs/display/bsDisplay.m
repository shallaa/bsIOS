//
//  bsDisplay.m
//  bsIOS
//
//  Created by Keiichi Sato on 2014/03/17.
//  Copyright (c) 2014 ProjectBS. All rights reserved.
//

#import "bsDisplay.h"

static NSDictionary *__bsDisplay_keyValues;
static NSMutableDictionary *__bsDisplay_templates;
static NSMutableDictionary *__bsDisplay_styles;

@implementation bsDisplay

@synthesize key = key_;

+ (bsDisplay *)G:(NSString *)name params:(NSString *)params {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    bsLog(nil, bsLogLevelDebug, @"name:%@, params:%@", name, params);
    
    static NSUInteger key = 0;
    NSString *className = [name stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[name substringToIndex:1] capitalizedString]];
    className = [NSString stringWithFormat:@"bs%@", className];
    Class clazz = NSClassFromString(className);
    if (clazz == NULL) {
        clazz = NSClassFromString(name);
        if (clazz == NULL) {
            bsException(NSInvalidArgumentException, @"class name '%@' is undefined", name);
        } else {
            className = name;
        }
    }
    bsDisplay *r = [[clazz alloc] init];
    if (![r isKindOfClass:[bsDisplay class]]) {
        bsException(NSInvalidArgumentException, @"class '%@' is not kind of bsDisplay", className);
    }
    NSString *displayKey = [NSString stringWithFormat:@"%@-%lu", className, (unsigned long)key++];
    params = [NSString stringWithFormat:@"key,%@,%@", displayKey, params];
    [r s:params];
    return r;
}

+ (bsDisplay *)G:(NSString *)name params:(NSString *)params replace:(id)replace {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (params == nil) params = @"";
    params = [bsDisplayUtil paramsTemplate:params replace:replace];
    return [bsDisplay G:name params:params];
}

//Template로부터 객체생성
+ (bsDisplay *)GT:(NSString *)key params:(NSString*)params {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (__bsDisplay_templates[key] == nil) {
        bsException(NSInvalidArgumentException, @"key(=%@) is undefined", key);
    }
    NSDictionary *dic = __bsDisplay_templates[key];
    params = [NSString stringWithFormat:@"%@,%@", dic[@"params"], params];
    bsDisplay *r = [bsDisplay G:dic[@"name"] params:params];
    return r;
}

+ (bsDisplay *)GT:(NSString *)key params:(NSString *)params replace:(id)replace {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (params == nil) {
        params = @"";
    }
    params = [bsDisplayUtil paramsTemplate:params replace:replace];
    return [bsDisplay GT:key params:params];
}

//Style로부터 객체생성
+ (bsDisplay *)G:(NSString *)name styleNames:(NSString *)styleNames params:(NSString *)params {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (params == nil) {
        params = @"";
    }
    if (styleNames && __bsDisplay_styles) {
        NSArray *s = [bsStr col:styleNames];
        __block NSString *p = params;
        [s enumerateObjectsUsingBlock:^(NSString *styleName, NSUInteger idx, BOOL *stop) {
            if ( __bsDisplay_styles[styleName]) {
                p = [NSString stringWithFormat:@"%@,%@", __bsDisplay_styles[styleName], params];
            }
        }];
        params= p;
    }
    bsDisplay *r = [bsDisplay G:name params:params];
    return r;
}

+ (bsDisplay *)G:(NSString *)name styleNames:(NSString *)styleNames params:(NSString *)params replace:(id)replace {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (params == nil) {
        params = @"";
    }
    params = [bsDisplayUtil paramsTemplate:params replace:replace];
    return [bsDisplay G:name styleNames:styleNames params:params];
}

//Template 추가
+ (void)AT:(NSString *)key name:(NSString *)name params:(NSString *)params {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (params == nil) {
        bsException(NSInvalidArgumentException, @"params should be not null");
    }
    if (key == nil) {
        bsException(NSInvalidArgumentException, @"key should be not null");
    }
    NSString *className = [NSString stringWithFormat:@"bs%@", [name capitalizedString]];
    Class clazz = NSClassFromString(className);
    if (clazz == NULL) {
        bsException(NSInvalidArgumentException, @"class name '%@' is undefined", className);
    }
    if ( __bsDisplay_templates == nil) {
        __bsDisplay_templates = [[NSMutableDictionary alloc] init];
    }
    if ( __bsDisplay_templates[key]) {
        bsException(NSInvalidArgumentException, @"Already template is existed. key=%@", key);
    }
    NSArray *p = [bsStr col:params];
    if ([p count] % 2) {
        bsException(NSInvalidArgumentException, @"A count of params should be even. a split string of params is ',' and pattern is 'k, v, k, v, k, v...'. params=%@", params);
    }
    __bsDisplay_templates[key] = @{@"name":name, @"params": params};
}

//Style 추가
+ (void)AS:(NSString *)styleName params:(NSString *)params {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (styleName == nil || params == nil) {
        bsException(NSInvalidArgumentException, @"styleName or params is null");
    }
    @synchronized( __bsDisplay_styles) {
        if (__bsDisplay_styles == nil) {
            __bsDisplay_styles = [[NSMutableDictionary alloc] init];
        }
        if (__bsDisplay_styles[styleName]) {
            bsException(NSInvalidArgumentException, @"Already this styleName(=%@) is defined", styleName);
        }
        NSArray *p = [bsStr col:params];
        if ([p count] % 2) {
            bsException(NSInvalidArgumentException, @"A count of params should be even. a split string of params is ',' and pattern is 'k, v, k, v, k, v...'. params=%@", params);
        }
        __bsDisplay_styles[styleName] = params;
    }
}

- (id)init {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    if (self = [super init]) {
        [self ready];
    }
    return self;
}

- (void)ready {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    //layoutConstraints_ = [[NSMutableDictionary alloc] init];
    if (__bsDisplay_keyValues == nil) {
        __bsDisplay_keyValues =
        @{@"key": @kbsDisplayKey, @"x": @kbsDisplayX, @"y": @kbsDisplayY, //@"cx": @kbsDisplayCX, @"cy": @kbsDisplayCY,
          @"w": @kbsDisplayW, @"h": @kbsDisplayH, @"width": @kbsDisplayW, @"height": @kbsDisplayH,
          @"bg": @kbsDisplayBG, @"bgcolor": @kbsDisplayBG, @"background-color": @kbsDisplayBG,
          @"opacity": @kbsDisplayOpacity, @"alpha":@kbsDisplayOpacity,  @"hidden": @kbsDisplayHidden,
          @"border-color": @kbsDisplayBorderColor, @"border-width": @kbsDisplayBorderWidth, @"border-radius": @kbsDisplayBorderRadius,
          @"shadow-color": @kbsDisplayShadowColor, @"shadow-opacity": @kbsDisplayShadowOpacity,
          @"shadow-radius": @kbsDisplayShadowRadius, @"shadow-offset": @kbsDisplayShadowOffset,
          @"tag": @kbsDisplayTag, @"interaction": @kbsDisplayInteraction
          };
    }
    key_ = @"";
    borderColor_ = [UIColor blackColor];
    borderWidth_ = 0;
    borderRadius_ = 0;
    shadowColor_ = [UIColor blackColor];
    shadowOpacity_ = 0;
    shadowRadius_ = 0;
    shadowOffset_ = CGSizeMake(2, 2);
    self.frame = CGRectMake(0, 0, 100, 100);
    self.backgroundColor = [UIColor clearColor];
    self.alpha = 1.0;
    self.hidden = NO;
    self.tag = 0;
    [bsDisplayUtil clearLayerWithView:self];
}

- (id)g:(NSString *)key {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    NSInteger num = [[__bsDisplay_keyValues objectForKey:key] integerValue];
    id value = nil;
    switch (num) {
        case kbsDisplayKey: value = key_; break;
        case kbsDisplayX: value = @(self.frame.origin.x); break;
        case kbsDisplayY: value = @(self.frame.origin.y); break;
            //case kbsDisplayCX: value = @(self.center.x); break;
            //case kbsDisplayCY: value = @(self.center.y); break;
        case kbsDisplayW: value = @(self.frame.size.width); break;
        case kbsDisplayH: value = @(self.frame.size.height); break;
        case kbsDisplayBG: value = self.backgroundColor; break;
        case kbsDisplayOpacity: value = @(self.alpha); break;
        case kbsDisplayHidden: value = @(self.hidden); break;
        case kbsDisplayBorderColor: value = borderColor_; break;
        case kbsDisplayBorderWidth: value = @(borderWidth_); break;
        case kbsDisplayBorderRadius: value = @(borderRadius_); break;
        case kbsDisplayShadowColor: value = shadowColor_; break;
        case kbsDisplayShadowOpacity: value = @(shadowOpacity_); break;
        case kbsDisplayShadowRadius: value = @(shadowRadius_); break;
        case kbsDisplayShadowOffset: value = [bsSize G:shadowOffset_]; break;
        case kbsDisplayTag: value = @(self.tag); break;
        case kbsDisplayInteraction: value = @(self.userInteractionEnabled); break;
        default:
            value = [self __g:key];
            break;
    }
    return value;
}

- (NSDictionary *)gDic:(NSString *)keys {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    
    NSArray *keyList = [bsStr col:keys];
    NSMutableDictionary *r = [[NSMutableDictionary alloc] init];
    for (NSInteger i = 0, j = [keyList count]; i < j; i++ ) {
        NSString *k = keyList[i];
        id value = [self g:k];
        if (value) {
            r[k] = value;
        }
    }
    return r;
}

- (id)__g:(NSString *)key {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    return @{};
}

- (void)s:(NSString *)params {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    bsLog(nil, bsLogLevelDebug, @"params:%@", params);
    
    if (params == nil) return;
    NSArray *p = [bsStr col:params];
    if ([p count] == 1) return;
    NSMutableArray *remain = [NSMutableArray array];
    if ([p count] % 2) {
        bsException(NSInvalidArgumentException, @"A count of params should be even. a split string of params is ',' and pattern is 'k, v, k, v, k, v...'. params=%@", params);
    }
    BOOL frameChange = NO;
    BOOL borderChange = NO;
    BOOL shadowChange = NO;
    //BOOL centerChagne = NO;
    //CGPoint c = self.center;
    CGRect f = self.frame;
    for (NSInteger i = 0, j = [p count]; i < j;) {
        
        NSString *k = [(NSString *)p[i++] lowercaseString];
        NSString *v = (NSString *)p[i++];
        bsLog(nil, bsLogLevelDebug, @"k:%@, v:%@", k, v);
        
        NSInteger num = [[__bsDisplay_keyValues objectForKey:k] integerValue];
        switch (num) {
            case kbsDisplayKey: key_ = v; break;
            case kbsDisplayX: f.origin.x = [bsStr FLOAT:v]; frameChange = YES; break;
            case kbsDisplayY: f.origin.y = [bsStr FLOAT:v]; frameChange = YES; break;
            case kbsDisplayW: f.size.width = [bsStr FLOAT:v]; frameChange = YES; break;
            case kbsDisplayH: f.size.height = [bsStr FLOAT:v]; frameChange = YES; break;
                //case kbsDisplayCX: c.x = [bsStr FLOAT:v]; centerChagne = YES; break;
                //case kbsDisplayCY: c.y = [bsStr FLOAT:v]; centerChagne = YES; break;
            case kbsDisplayBG: self.backgroundColor = [bsStr color:v]; break;
            case kbsDisplayOpacity: self.alpha = [bsStr FLOAT:v]; break;
            case kbsDisplayHidden: self.hidden = [bsStr BOOLEAN:v]; break;
            case kbsDisplayBorderColor: borderColor_ = [bsStr color:v]; borderChange = YES; break;
            case kbsDisplayBorderWidth: borderWidth_ = [bsStr FLOAT:v]; borderChange = YES; break;
            case kbsDisplayBorderRadius: borderRadius_ = [bsStr FLOAT:v]; borderChange = YES; break;
            case kbsDisplayShadowColor: shadowColor_ = [bsStr color:v]; shadowChange = YES; break;
            case kbsDisplayShadowOpacity: shadowOpacity_ = [bsStr FLOAT:v]; shadowChange = YES; break;
            case kbsDisplayShadowRadius: shadowRadius_ = [bsStr FLOAT:v]; shadowChange = YES; break;
            case kbsDisplayShadowOffset: {
                NSArray *c = [bsStr arg:v];
                if ([c count] != 2) {
                    bsException(NSInvalidArgumentException, @"shadow-offset value %@ is invalid. It should be a value of the form offsetX|offsetY", v);
                }
                shadowOffset_ = CGSizeMake( [c[0] floatValue], [c[1] floatValue] );
            } break;
            case kbsDisplayTag: self.tag = [bsStr INTEGER:v]; break;
            case kbsDisplayInteraction: self.userInteractionEnabled = [bsStr BOOLEAN:v]; break;
            default: [remain addObject:k]; [remain addObject:v]; break;
        }
    }
    if (borderChange) {
        if (borderColor_ == nil) {
            borderColor_ = [UIColor clearColor];
        }
        [bsDisplayUtil borderWithView:self cornerRadius:borderRadius_ borderWidth:borderWidth_ borderColor:[borderColor_ CGColor]];
    }
    if (shadowChange) {
        if (shadowColor_ == nil) {
            shadowColor_ = [UIColor clearColor];
        }
        [bsDisplayUtil shadowWithView:self cornerRadius:shadowRadius_ opacity:shadowOpacity_ color:[shadowColor_ CGColor] offset:shadowOffset_ path:nil];
    }
    /*
     if( centerChagne ) {
     self.center = c;
     }
     */
    if (frameChange) {
        self.frame = f;
    }
    if ([remain count] > 0) { //이걸 계속 놓을까 고민중.... 만약 Label의 경우 max-size나 min-size가 정해져 있는데 frame.size가 바뀌면 저게 무용지물이 된다. 그렇다고 만약 x, y만 바뀐다면 __s:호출해 부하를 줄필요가 있을까?
        [self __s:remain];
    }
}

- (void)s:(NSString *)params replace:(id)replace {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    params = [bsDisplayUtil paramsTemplate:params replace:replace];
    [self s:params];
}

- (NSArray *)__s:(NSArray *)params {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    return params;
}

/*
 -(void)autolayout:(NSString *)formats views:(NSDictionary *)views {
 [self autolayout:formats views:views options:0];
 }
 -(void)autolayout:(NSString *)formats views:(NSDictionary *)views options:(NSLayoutFormatOptions)opts {
 NSArray *f = [bsStr col:formats];
 if( [f count] % 2 != 0 ) {
 bsException(NSInvalidArgumentException, @"A count of formats should be even. a split string of params is ',' and pattern is 'k, v, k, v, k, v...'. params=%@", formats);
 }
 [views enumerateKeysAndObjectsUsingBlock:^(id key, UIView* view, BOOL *stop) {
 view.translatesAutoresizingMaskIntoConstraints = NO;
 }];
 for (int i = 0, j = [f count]; i < j; ) {
 NSString *k = (NSString*)f[i++];
 NSString *v = (NSString*)f[i++];
 NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:v options:opts metrics:nil views:views];
 if( layoutConstraints_[k] ) {
 [self removeConstraints:layoutConstraints_[k]];
 }
 layoutConstraints_[k] = constraints;
 [self addConstraints:constraints];
 }
 }
 */

#pragma mark - child

- (NSString *)create:(NSString *)name params:(NSString *)params {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    bsDisplay *o = [bsDisplay G:name params:params];
    [self addSubview:o];
    return o.key;
}

- (NSString *)create:(NSString *)name params:(NSString *)params replace:(id)replace {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    bsDisplay *o = [bsDisplay G:name params:params replace:replace];
    [self addSubview:o];
    return o.key;
}

- (NSString *)createT:(NSString *)key params:(NSString *)params {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    bsDisplay *o = [bsDisplay GT:key params:params];
    [self addSubview:o];
    return o.key;
}

- (NSString *)createT:(NSString *)key params:(NSString *)params replace:(id)replace {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    bsDisplay *o = [bsDisplay GT:key params:params replace:replace];
    [self addSubview:o];
    return o.key;
}

- (NSString *)create:(NSString *)name styleNames:(NSString *)styleNames params:(NSString *)params {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    bsDisplay *o = [bsDisplay G:name styleNames:styleNames params:params];
    [self addSubview:o];
    return o.key;
}

- (NSString *)create:(NSString *)name styleNames:(NSString *)styleNames params:(NSString *)params replace:(id)replace {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    bsDisplay *o = [bsDisplay G:name styleNames:styleNames params:params replace:replace];
    [self addSubview:o];
    return o.key;
}

- (bsDisplay *)childG:(NSString *)key {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    __block bsDisplay *c = nil;
    [self.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[bsDisplay class]] && [((bsDisplay *)obj).key isEqualToString:key]) {
            c = (bsDisplay *)obj;
            *stop = YES;
        }
    }];
    return c;
}

- (void)childA:(bsDisplay *)child {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    [self addSubview:child];
}

- (void)childD:(NSString *)key {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    if ([key isEqualToString:@"*"]) {
        NSArray *childs = self.subviews;
        [childs enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
            [obj removeFromSuperview];
        }];
    } else {
        bsDisplay *child = [self childG:key];
        if (child) {
            [child removeFromSuperview];
        }
    }
}

- (void)childS:(NSString *)key params:(NSString *)params {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    bsDisplay *child = [self childG:key];
    if (child) {
        [child s:params];
    }
}

- (void)childS:(NSString *)key params:(NSString *)params replace:(id)replace {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
    bsDisplay *child = [self childG:key];
    if (child) {
        [child s:params replace:replace];
    }
}

/*
 - (void)removeFromSuperview {
 [super removeFromSuperview];
 objc_removeAssociatedObjects(self);
 }
 */

- (void)dealloc {
    
    bsLog(nil, bsLogLevelTrace, @"%s", __PRETTY_FUNCTION__);
}

@end
