#import "bsDisplay.h"

/*
#define dlayer   [bsDisplayLayer center]
#define dlparentA( parent, parentName ) [dlayer parentA:(parent) parentName:(parentName)]
#define dlparentD( parentName ) [dlayer parentD:(parentName)]
#define dllayerG( layerName, parentName ) [dlayer layerG:(layerName) parentName:(parentName)]
#define dllayersG( layerNames, parentName ) [dlayer layersG:(layerNames) parentName:(parentName)]
#define dllayerA( layerName, hidden, parentName ) [dlayer layerA:(layerName) hidden:(hidden) parentName:(parentName)]
#define dllayersA( layerNames, hidden, parentName ) [dlayer layersA:(layerNames) hidden:(hidden) parentName:(parentName)]
#define dllayerD( layerName, parentName ) [dlayer layerD:(layerName) parentName:(parentName)]
#define dllayersD( layerNames, parentName ) [dlayer layersD:(layerNames) parentName:(parentName)]
*/
@interface bsDisplayLayer : NSObject {
    
    NSMutableDictionary *parents_;
}

+ (bsDisplayLayer *)center;
- (void)parentA:(bsDisplay *)parent parentName:(NSString *)parentName;
- (void)parentD:(NSString *)parentName;
- (bsDisplay*)parentG:(NSString *)parentName;
- (void)parentS:(NSString *)parentName params:(NSString *)params;
- (void)parentS:(NSString *)parentName params:(NSString *)params replace:(id)replace;
- (bsDisplay *)layerG:(NSString *)layerName parentName:(NSString *)parentName;
- (NSArray *)layersG:(NSString *)layerNames parentName:(NSString *)parentName;
- (bsDisplay *)layerA:(NSString *)layerName hidden:(BOOL)hidden parentName:(NSString *)parentName;
- (NSArray *)layersA:(NSString*)layerNames hidden:(BOOL)hidden parentName:(NSString *)parentName;
- (bsDisplay *)layerD:(NSString *)layerName parentName:(NSString *)parentName;
- (NSArray *)layersD:(NSString *)layerNames parentName:(NSString *)parentName;
- (void)layerS:(NSString *)layerName parentName:(NSString *)parentName params:(NSString*)params;
- (void)layerS:(NSString *)layerName parentName:(NSString *)parentName params:(NSString *)params replace:(id)replace;
- (void)layerChildD:(NSString *)layerName parentName:(NSString *)parentName childKeys:(NSString *)childKeys;

@end
