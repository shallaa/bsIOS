#import <Foundation/Foundation.h>

//아직 불안정하다. 왜냐하면 retain/release가 애매하기 때문이다.
//다른 문제인데... pooling하면 kvo binding시 애를 먹는다... 왜냐하면 바인더 입장에서는 정말 값이 바뀐것인지 알길이 없기 때문이다. 

/*
 bsInt *a = [bsInt pop:3];
 NSLog(@"%d %@", [a g], a.str);
 [bsInt put:a];
 bsInt *b = [bsInt pop:5];
 NSLog(@"%d %@", b.g, a.str);
 [bsInt put:b];
*/

@interface bsPrimitive : NSObject

@property (weak, readonly, getter = str) NSString *str;
@property (weak, readonly, getter = number) NSNumber *number;

@end


@interface bsInt : bsPrimitive {
    
@private
    int _val;
}

@property (readonly, getter = g) int g;

@end


@interface bsUInt : bsPrimitive {
    
@private
    unsigned int _val;
}

@property (readonly, getter = g) unsigned int g;

@end


@interface bsShort : bsPrimitive {
    
@private
    short _val;
}

@property (readonly, getter = g) short g;

@end


@interface bsUShort : bsPrimitive {
    
@private
    unsigned short _val;
}

@property (readonly, getter = g) unsigned short g;

@end


@interface bsBool : bsPrimitive {
    
@private
    BOOL _val;
}

@property (readonly, getter = g) BOOL g;

@end


@interface bsChar : bsPrimitive {
    
@private
    char _val;
}

@property (readonly, getter = g) char g;

@end


@interface bsUChar : bsPrimitive {
    
@private
    unsigned char _val;
}

@property (readonly, getter = g) unsigned char g;

@end


@interface bsInteger : bsPrimitive {
    
@private
    NSInteger _val;
}

@property (readonly, getter = g) NSInteger g;

@end


@interface bsUInteger : bsPrimitive {
    
@private
    NSUInteger _val;
}

@property (readonly, getter = g) NSUInteger g;

@end


@interface bsFloat : bsPrimitive {
    
@private
    float _val;
}

@property (readonly, getter = g) float g;

@end


@interface bsDouble : bsPrimitive {
    
@private
    double _val;
}

@property (readonly, getter = g) double g;

@end


@interface bsLong : bsPrimitive {
    
@private
    long _val;
}

@property (readonly, getter = g) long g;

@end


@interface bsULong : bsPrimitive {
    
@private
    unsigned long _val;
}

@property (readonly, getter = g) unsigned long g;

@end


@interface bsLongLong : bsPrimitive {
    
@private
    long long _val;
}

@property (readonly, getter = g) long long g;

@end


@interface bsULongLong : bsPrimitive {
    
@private
    unsigned long long _val;
}

@property (readonly, getter = g) unsigned long long g;

@end
