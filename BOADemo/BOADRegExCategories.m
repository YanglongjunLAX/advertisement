//
//  RegExCategories.m
//
//  https://github.com/bendytree/Objective-C-RegEx-Categories
//
//
//  The MIT License (MIT)
// 
//  Copyright (c) 2013 Josh Wright <@BendyTree>
// 
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import "BOADRegExCategories.h"

@implementation NSRegularExpression (BOADObjectiveCRegexCategories)

- (id) BOAD_initWithPattern:(NSString*)pattern
{
    return [self initWithPattern:pattern options:0 error:nil];
}

+ (NSRegularExpression*) BOAD_rx:(NSString*)pattern
{
    return [[self alloc] BOAD_initWithPattern:pattern];
}

+ (NSRegularExpression*) BOAD_rx:(NSString*)pattern ignoreCase:(BOOL)ignoreCase
{
    return [[self alloc] initWithPattern:pattern options:ignoreCase?NSRegularExpressionCaseInsensitive:0 error:nil];
}

+ (NSRegularExpression*) BOAD_rx:(NSString*)pattern options:(NSRegularExpressionOptions)options
{
    return [[self alloc] initWithPattern:pattern options:options error:nil];
}

- (BOOL) BOAD_isMatch:(NSString*)matchee
{
    return [self numberOfMatchesInString:matchee options:0 range:NSMakeRange(0, matchee.length)] > 0;
}

- (int) BOAD_indexOf:(NSString*)matchee
{
    NSRange range = [self rangeOfFirstMatchInString:matchee options:0 range:NSMakeRange(0, matchee.length)];
    return range.location == NSNotFound ? -1 : (int)range.location;
}

- (NSArray*) BOAD_split:(NSString *)str
{
    NSRange range = NSMakeRange(0, str.length);
    
    //get locations of matches
    NSMutableArray* matchingRanges = [NSMutableArray array];
    NSArray* matches = [self matchesInString:str options:0 range:range];
    for(NSTextCheckingResult* match in matches) {
        [matchingRanges addObject:[NSValue valueWithRange:match.range]];
    }
    
    //invert ranges - get ranges of non-matched pieces
    NSMutableArray* pieceRanges = [NSMutableArray array];
    
    //add first range
    [pieceRanges addObject:[NSValue valueWithRange:NSMakeRange(0,
      (matchingRanges.count == 0 ? str.length : [matchingRanges[0] rangeValue].location))]];
    
    //add between splits ranges and last range
    for(NSUInteger i=0; i<matchingRanges.count; i++){
        BOOL isLast = i+1 == matchingRanges.count;
        unsigned long startLoc = [matchingRanges[i] rangeValue].location + [matchingRanges[i] rangeValue].length;
        unsigned long endLoc = isLast ? str.length : [matchingRanges[i+1] rangeValue].location;
        [pieceRanges addObject:[NSValue valueWithRange:NSMakeRange(startLoc, endLoc-startLoc)]];
    }
    
    //use split ranges to select pieces
    NSMutableArray* pieces = [NSMutableArray array];
    for(NSValue* val in pieceRanges) {
        //NSRange range = [val rangeValue];
        NSString* piece = [str substringWithRange:[val rangeValue]];
        [pieces addObject:piece];
    }
    
    return pieces;
}

- (NSString*) BOAD_replace:(NSString*)string with:(NSString*)replacement
{
    return [self stringByReplacingMatchesInString:string options:0 range:NSMakeRange(0, string.length) withTemplate:replacement];
}

- (NSString*) BOAD_replace:(NSString*)string withBlock:(NSString*(^)(NSString* match))replacer
{
    //no replacer? just return
    if (!replacer) return string;
    
    //copy the string so we can replace subsections
    NSMutableString* result = [string mutableCopy];
    
    //get matches
    NSArray* matches = [self matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    //replace each match (right to left so indexing doesn't get messed up)
    for (int i=(int)matches.count-1; i>=0; i--) {
        NSTextCheckingResult* match = matches[i];
        NSString* matchStr = [string substringWithRange:match.range];
        NSString* replacement = replacer(matchStr);
        [result replaceCharactersInRange:match.range withString:replacement];
    }
    
    return result;
}

- (NSString*) BOAD_replace:(NSString *)string withDetailsBlock:(NSString*(^)(BOADRxMatch* match))replacer
{
    //no replacer? just return
    if (!replacer) return string;
    
    //copy the string so we can replace subsections
    NSMutableString* replaced = [string mutableCopy];
    
    //get matches
    NSArray* matches = [self matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    //replace each match (right to left so indexing doesn't get messed up)
    for (int i=(int)matches.count-1; i>=0; i--) {
        NSTextCheckingResult* result = matches[i];
        BOADRxMatch* match = [self BOAD_resultToMatch:result original:string];
        NSString* replacement = replacer(match);
        [replaced replaceCharactersInRange:result.range withString:replacement];
    }
    
    return replaced;
}

- (NSArray*) BOAD_matches:(NSString*)str
{
    NSMutableArray* matches = [NSMutableArray array];
    
    NSArray* results = [self matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    for (NSTextCheckingResult* result in results) {
        NSString* match = [str substringWithRange:result.range];
        [matches addObject:match];
    }
    
    return matches;
}

- (NSString*) BOAD_firstMatch:(NSString*)str
{
    NSTextCheckingResult* match = [self firstMatchInString:str options:0 range:NSMakeRange(0, str.length)];
    
    if (!match) return nil;
    
    return [str substringWithRange:match.range];
}

- (BOADRxMatch*) BOAD_resultToMatch:(NSTextCheckingResult*)result original:(NSString*)original
{
    BOADRxMatch* match = [[BOADRxMatch alloc] init];
    match.original = original;
    match.range = result.range;
    match.value = result.range.length ? [original substringWithRange:result.range] : nil;
    
    //groups
    NSMutableArray* groups = [NSMutableArray array];
    match.groups = groups;
    for(NSUInteger i=0; i<result.numberOfRanges; i++){
        BOADRxMatchGroup* group = [[BOADRxMatchGroup alloc] init];
        group.range = [result rangeAtIndex:i];
        group.value = group.range.length ? [original substringWithRange:group.range] : nil;
        [groups addObject:group];
    }
    
    return match;
}

- (NSArray*) BOAD_matchesWithDetails:(NSString*)str
{
    NSMutableArray* matches = [NSMutableArray array];
    
    NSArray* results = [self matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    for (NSTextCheckingResult* result in results) {
        [matches addObject:[self BOAD_resultToMatch:result original:str]];
    }
    
    return matches;
}

- (BOADRxMatch*) BOAD_firstMatchWithDetails:(NSString*)str
{
    NSArray* results = [self matchesInString:str options:0 range:NSMakeRange(0, str.length)];
    
    if (results.count == 0)
        return nil;
    
    return [self BOAD_resultToMatch:results[0] original:str];
}

@end



@implementation NSString (BOADObjectiveCRegexCategories)

- (NSRegularExpression*) BOAD_toRx
{
    return [[NSRegularExpression alloc] BOAD_initWithPattern:self];
}

- (NSRegularExpression*) BOAD_toRxIgnoreCase:(BOOL)ignoreCase
{
    return [NSRegularExpression BOAD_rx:self ignoreCase:ignoreCase];
}

- (NSRegularExpression*) BOAD_toRxWithOptions:(NSRegularExpressionOptions)options
{
    return [NSRegularExpression BOAD_rx:self options:options];
}

- (BOOL) BOAD_isMatch:(NSRegularExpression*)rx
{
    return [rx BOAD_isMatch:self];
}

- (int) BOAD_indexOf:(NSRegularExpression*)rx
{
    return [rx BOAD_indexOf:self];
}

- (NSArray*) BOAD_split:(NSRegularExpression*)rx
{
    return [rx BOAD_split:self];
}

- (NSString*) BOAD_replace:(NSRegularExpression*)rx with:(NSString*)replacement
{
    return [rx BOAD_replace:self with:replacement];
}

- (NSString*) BOAD_replace:(NSRegularExpression *)rx withBlock:(NSString*(^)(NSString* match))replacer
{
    return [rx BOAD_replace:self withBlock:replacer];
}

- (NSString*) BOAD_replace:(NSRegularExpression *)rx withDetailsBlock:(NSString*(^)(BOADRxMatch* match))replacer
{
    return [rx BOAD_replace:self withDetailsBlock:replacer];
}

- (NSArray*) BOAD_matches:(NSRegularExpression*)rx
{
    return [rx BOAD_matches:self];
}

- (NSString*) BOAD_firstMatch:(NSRegularExpression*)rx
{
    return [rx BOAD_firstMatch:self];
}

- (NSArray*) BOAD_matchesWithDetails:(NSRegularExpression*)rx
{
    return [rx BOAD_matchesWithDetails:self];
}

- (BOADRxMatch*) BOAD_firstMatchWithDetails:(NSRegularExpression*)rx
{
    return [rx BOAD_firstMatchWithDetails:self];
}

@end



@implementation BOADRxMatch
@synthesize value, range, groups, original;
@end

@implementation BOADRxMatchGroup
@synthesize value, range;
@end

