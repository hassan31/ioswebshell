/*
 * Copyright (C) 2013 Tek Counsel LLC
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 
 * Used with permission, and based on http://iphonedevelopertips.com/graphics/how-to-scale-an-image-using-an-objective-c-category.html
 */


#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface UIImage (scale)

-(UIImage*)scaleToSize:(CGSize)size;
-(UIImage*)scaleToHalfSize;
-(UIImage*)scaleDownBy:(double)divider;
-(UIImage *)scaleToThumb;
-(UIImage *)roundCorners:(UIImageView*)imageView;
-(UIImage *)rotateByDegrees:(CGFloat)degrees;
+(UIImage*) capture:(UIView*)view;

@end