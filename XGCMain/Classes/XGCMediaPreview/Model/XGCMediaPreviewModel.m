//
//  XGCMediaPreviewModel.m
//  XGCMain_Example
//
//  Created by 凌志 on 2024/4/22.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import "XGCMediaPreviewModel.h"

@implementation XGCMediaPreviewModel

+ (instancetype)image:(UIImage *)image filePathURL:(NSURL *)filePathURL fileName:(NSString *)fileName suffix:(NSString *)suffix {
    NSDate *date = [NSDate date];
    XGCMediaPreviewModel *model = [[XGCMediaPreviewModel alloc] init];
    model.image = image;
    model.filePathURL = filePathURL;
    if (filePathURL && !fileName) {
        fileName = filePathURL.lastPathComponent.stringByDeletingPathExtension;
    }
    if (filePathURL && !suffix) {
        suffix = filePathURL.pathExtension;
    }
    model.fileName = fileName ?: @(ceil(date.timeIntervalSince1970 * 1000)).description;
    model.suffix = suffix ?: [self imageFormatForImage:image];
    model.creTime = @(ceil(date.timeIntervalSince1970 * 1000)).description;
    return model;
}

+ (instancetype)fileUrl:(NSString *)fileUrl suffix:(nullable NSString *)suffix {
    XGCMediaPreviewModel *model = [[XGCMediaPreviewModel alloc] init];
    model.fileUrl = fileUrl;
    model.fileName = fileUrl.stringByDeletingPathExtension.lastPathComponent;
    model.suffix = fileUrl.pathExtension;
    if (model.suffix.length == 0) {
        model.suffix = suffix;
    }
    return model;
}

+ (NSArray *)mj_ignoredPropertyNames {
    return @[@"image", @"filePathURL"];
}

+ (NSString *)imageFormatForImage:(UIImage *)image {
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    if (!data) {
        return @"png";
    }
    // File signatures table: http://www.garykessler.net/library/file_sigs.html
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
        case 0x42:
            return @"bmp";
        case 0x52: {
            if (data.length >= 12) {
                //RIFF....WEBP
                NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
                if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                    return @"webp";
                }
            }
            break;
        }
        case 0x00: {
            if (data.length >= 12) {
                //....ftypheic ....ftypheix ....ftyphevc ....ftyphevx
                NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(4, 8)] encoding:NSASCIIStringEncoding];
                if ([testString isEqualToString:@"ftypheic"]
                    || [testString isEqualToString:@"ftypheix"]
                    || [testString isEqualToString:@"ftyphevc"]
                    || [testString isEqualToString:@"ftyphevx"]) {
                    return @"heic";
                }
                //....ftypmif1 ....ftypmsf1
                if ([testString isEqualToString:@"ftypmif1"] || [testString isEqualToString:@"ftypmsf1"]) {
                    return @"heif";
                }
            }
            break;
        }
        case 0x25: {
            if (data.length >= 4) {
                //%PDF
                NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(1, 3)] encoding:NSASCIIStringEncoding];
                if ([testString isEqualToString:@"PDF"]) {
                    return @"pdf";
                }
            }
            break;
        }
        case 0x3C: {
            // Check end with SVG tag
            if ([data rangeOfData:[@"</svg>" dataUsingEncoding:NSUTF8StringEncoding] options:NSDataSearchBackwards range: NSMakeRange(data.length - MIN(100, data.length), MIN(100, data.length))].location != NSNotFound) {
                return @"SVG";
            }
            break;
        }
    }
    return @"png";
}

@end
