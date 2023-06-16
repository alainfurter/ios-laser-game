//
//  InterceptCalculator.m
//
//  Copyright (c) 2012 Adrian Duyzer
//

#import "InterceptCalculator.h"

// ---------------------------------------------------------------------------------
// https://github.com/BigZaphod/Chameleon/blob/master/UIKit/Classes/UIPopoverView.m

typedef BOOL (^PointFilter)(CGPoint);

typedef struct {
    CGPoint from;
    CGPoint to;
} LineSegment;

static LineSegment LineSegmentMake(CGPoint from, CGPoint to)
{
    LineSegment segment;
    segment.from = from;
    segment.to = to;
    return segment;
}

static BOOL LineSegmentsIntersect(LineSegment line1, LineSegment line2, CGPoint *intersection)
{
    /*
     E = B-A = ( Bx-Ax, By-Ay )
     F = D-C = ( Dx-Cx, Dy-Cy )
     P = ( -Ey, Ex )
     h = ( (A-C) * P ) / ( F * P )
     
     I = C + F*h
     */
    
    const CGPoint A = line1.from;
    const CGPoint B = line1.to;
    const CGPoint C = line2.from;
    const CGPoint D = line2.to;
    
    const CGPoint E = CGPointMake(B.x-A.x, B.y-A.y);
    const CGPoint F = CGPointMake(D.x-C.x, D.y-C.y);
    const CGPoint P = CGPointMake(-E.y, E.x);
    
    const CGPoint AC = CGPointMake(A.x-C.x, A.y-C.y);
    const CGFloat h2 = F.x * P.x + F.y * P.y;
    
    // if h2 is 0, the lines are parallel
    if (h2 != 0) {
        const CGFloat h1 = AC.x * P.x + AC.y * P.y;
        const CGFloat h = h1 / h2;
        
        // if h is exactly 0 or 1, the lines touched on the end - we won't consider that an intersection
        if (h > 0 && h < 1) {
            if (intersection) {
                const CGPoint I = CGPointMake(C.x+F.x*h, C.y+F.y*h);
                intersection->x = I.x;
                intersection->y = I.y;
            }
            return YES;
        }
    }
    
    return NO;
    
}

static CGFloat DistanceBetweenTwoPoints(CGPoint A, CGPoint B)
{
    CGFloat a = B.x - A.x;
    CGFloat b = B.y - A.y;
    return sqrtf((a*a) + (b*b));
}

@implementation InterceptCalculator

// ---------------------------------------------------------------------------------
// From Swiss Transit

+ (double)orthogonalDistanceWithPoint:(CGPoint)point lineStart:(CGPoint)lineStart lineEnd:(CGPoint)lineEnd
{
    double area = 0.0, bottom = 0.0, height = 0.0;
    area = ABS(
               (
                lineStart.x * lineEnd.y
                + lineEnd.x * point.y
                + point.x * lineStart.y
                - lineEnd.x * lineStart.y
                - point.x * lineEnd.y
                - lineStart.x * point.y
                ) / 2.0);
    
    bottom = sqrt(pow(lineStart.x - lineEnd.x, 2) +
                  pow(lineStart.y - lineEnd.y, 2));
    
    height = area / bottom * 2.0;
    
    return height;
}

+ (BOOL)isPointOnLineAndBetweenPoints:(CGPoint)point lineStart:(CGPoint)lineStart lineEnd:(CGPoint)lineEnd {
    CGFloat distanceToLine = [self orthogonalDistanceWithPoint:point lineStart:lineStart lineEnd:lineEnd];
    CGFloat pointToStartDistance = [self findDistanceBetweenPoints:point endpoint:lineStart];
    CGFloat pointToEndDistance = [self findDistanceBetweenPoints:point endpoint:lineEnd];
    CGFloat lineDistance = [self findDistanceBetweenPoints:lineStart endpoint:lineEnd];
    CGFloat distanceDifference = pointToStartDistance + pointToEndDistance - lineDistance;
    BOOL isOnLineBetweenPoints = ((distanceToLine <= 4) && (distanceDifference >= -2.0 && distanceDifference <= 2.0));
    //NSLog(@"Distances: %d / %.1f / %.1f / %.1f / %.1f ", isOnLineBetweenPoints, pointToStartDistance, pointToEndDistance, lineDistance, distanceDifference);
    //NSLog(@"Point to line distance: %d / %.1f / %.1f / %.1f, %.1f / %.1f, %.1f / %.1f, %.1f", isOnLineBetweenPoints, distanceToLine, distanceDifference, point.x, point.y, lineStart.x, lineStart.y, lineEnd.x, lineEnd.y);
    return isOnLineBetweenPoints;
}

// ---------------------------------------------------------------------------------
// https://github.com/BigZaphod/Chameleon/blob/master/UIKit/Classes/UIPopoverView.m

+ (CGPoint)findLineSegmentsIntersection:(CGPoint)lineAStart lineAEnd:(CGPoint)lineAEnd lineBStart:(CGPoint)lineBStart lineBEnd:(CGPoint)lineBEnd {
    const LineSegment line1 = LineSegmentMake(lineAStart, lineAEnd);
    const LineSegment line2 = LineSegmentMake(lineBStart, lineBEnd);
    
    CGPoint intersection = CGPointZero;
    
    if (LineSegmentsIntersect(line1, line2, &intersection)) {
        //const CGFloat distance = DistanceBetweenTwoPoints(intersection, arrowPoint);
        return intersection;
    } else {
        return CGPointZero;
    }
}

+ (CGFloat)findDistanceBetweenPoints:(CGPoint)startpoint endpoint:(CGPoint)endpoint {
    const CGFloat distance = DistanceBetweenTwoPoints(startpoint, endpoint);
    return distance;
}

// ---------------------------------------------------------------------------------
// http://factore.ca/on-the-floor/166-how-to-calculate-the-point-of-intersection-between-a-line-and-a-bounding-box
// https://github.com/adriand/intercept-calculator

+ (CGPoint)findInterceptFromSource:(CGPoint)source andTouch:(CGPoint)touch withinBounds:(CGRect)bounds
{
    NSMutableArray *intercepts = [[NSMutableArray alloc] init];
    
    // In my intercept_math.rb class, bounds has four coordinates.  Here, however, bounds has an origin and a size, so I need to translate
    // into the coordinate types that I need.
    CGFloat boundsLeftX = bounds.origin.x;
    CGFloat boundsRightX = bounds.size.width;
    CGFloat boundsBottomY = bounds.origin.y;
    CGFloat boundsTopY = bounds.size.height;
    
    // using this method to store the CGPoint structs in the intercepts NSMutableArray: http://stackoverflow.com/a/9606903/105650
    
    // check special case #1: touch is on the same spot as the source
    if (source.x == touch.x && source.y == touch.y) {
        // TODO: fix this special case (I can't return nil, unfortunately)...
        return CGPointMake(-99999.0, -99999.0);
    // check special case #2: vertical line
    } else if (source.x == touch.x) {
        [intercepts addObject:[self CGPointValueFromX:source.x andY:boundsBottomY]];
        [intercepts addObject:[self CGPointValueFromX:source.x andY:boundsTopY]];
    // check special case #3: horizontal line
    } else if (source.y == touch.y) {
        [intercepts addObject:[self CGPointValueFromX:boundsLeftX andY:source.y]];
        [intercepts addObject:[self CGPointValueFromX:boundsRightX andY:source.y]];
    // regular cases
    } else {
        // we want to define a line as y = mx + b
        // 1. find the slope of the line: (y2 - y1) / (x2 - x1)
        CGFloat slope = (touch.y - source.y) / (touch.x - source.x);
        // 2. Substitute slope plus one coordinate (we'll use the source's coordinate) into y = mx + b to find b
        // To find b, the equation y = mx + b can be rewritten as b = y - mx
        CGFloat b = source.y - (slope * source.x);
        // We now have what we need to create the equation y = mx + b.  Now we need to find the intercepts.
        // left vertical intercept - we have x, we must solve for y
        CGFloat y = slope * boundsLeftX + b;
        [intercepts addObject:[self CGPointValueFromX:boundsLeftX andY:y]];
        
        // right vertical intercept - we have x, we must solve for y
        y = slope * boundsRightX + b;
        [intercepts addObject:[self CGPointValueFromX:boundsRightX andY:y]];
        
        // bottom horizontal intercept - we have y, we must solve for x
        // x = (y - b) / m
        CGFloat x = (boundsBottomY - b) / slope;
        [intercepts addObject:[self CGPointValueFromX:x andY:boundsBottomY]];
        
        // top horizontal intercept - we have y, we must solve for x
        x = (boundsTopY - b) / slope;
        [intercepts addObject:[self CGPointValueFromX:x andY:boundsTopY]];
    }
    
    [self filterIntercepts:intercepts byBounds:bounds];
    [self filterInterceptsByDirection:intercepts withSource:source andTouch:touch];
    
    CGPoint interceptPoint = [self pointFromValue:[intercepts objectAtIndex:0]];
    return interceptPoint;
}

// This method iterates through the intercepts and send each intercept point into the block.
// The block should return either YES or NO.  If it returns YES, the point is ultimately
// removed from the intercepts.
+ (void)filterIntercepts:(NSMutableArray *)intercepts usingFilterBlock:(PointFilter)filterBlock
{
    NSMutableArray *objectsToRemove = [[NSMutableArray alloc] init];
    CGPoint interceptPoint;
    for (NSValue *pointValue in intercepts) {
        interceptPoint = [self pointFromValue:pointValue];
        if (filterBlock(interceptPoint))
            [objectsToRemove addObject:pointValue];
    }
    [intercepts removeObjectsInArray:objectsToRemove];    
}

+ (void)filterIntercepts:(NSMutableArray *)intercepts byBounds:(CGRect)bounds
{
    // to be a valid intercept, the x value cannot exceed the bounds of the left and right verticals,
    // and the y value cannot exceed the bounds of the bottom and top horizontals
    [self filterIntercepts:intercepts usingFilterBlock:^BOOL(CGPoint point) {
        return (point.x < bounds.origin.x || point.x > (bounds.size.width) || point.y < bounds.origin.y || point.y > bounds.size.height);
    }];
}

// we must determine the correct intercept based on the intended direction of the projectile
+ (void)filterInterceptsByDirection:(NSMutableArray *)intercepts withSource:(CGPoint)source andTouch:(CGPoint)touch
{
    // we must establish the direction that was intended for the touch
    // if the difference between the touch's x and the source's x is positive, then any intercept with an x position that
    // is less than the source's y position is invalid
    CGFloat xDelta = touch.x - source.x;
    if (xDelta >= 0.0) {
        [self filterIntercepts:intercepts usingFilterBlock:^BOOL(CGPoint point) {
            return (point.x < source.x); 
        }];
    } else {
        [self filterIntercepts:intercepts usingFilterBlock:^BOOL(CGPoint point) {
            return (point.x >= source.x); 
        }];        
    }
    
    CGFloat yDelta = touch.y - source.y;
    if (yDelta >= 0.0) {
        [self filterIntercepts:intercepts usingFilterBlock:^BOOL(CGPoint point) {
            return (point.y < source.y); 
        }];
    } else {
        [self filterIntercepts:intercepts usingFilterBlock:^BOOL(CGPoint point) {
            return (point.y >= source.y);
        }];        
    }
}
         
+ (NSValue *)CGPointValueFromX:(CGFloat)x andY:(CGFloat)y
{
    CGPoint point = CGPointMake(x, y);
    return [self valueFromCGPoint:point];
}

+ (NSValue *)valueFromCGPoint:(CGPoint)point
{
    return [NSValue valueWithBytes:&point objCType:@encode(CGPoint)];
}

+ (CGPoint)pointFromValue:(NSValue *)pointValue
{
    CGPoint point;
    [pointValue getValue:&point];
    return point;
}

@end
