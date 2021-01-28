//
//  MKAnnotationView+CIWebCache.h
//  CIWebImage
//
//  Created by ikeyyang on 2020/3/1.
//


#import <MapKit/MapKit.h>
#import "CIWebImageCommonBlock.h"

@interface MKAnnotationView (CIWebCache)

#pragma mark - URL
/**
*Download and set the imageView `image` with an `url`.
*
* The download is asynchronous and cached.
*
* @param url The url for the image.
*/
- (void)ci_downloadImageWithURL:(nullable NSURL *)url;

/**
* Download and set the imageView `image` with an `url` and a placeholder.
*
* The download is asynchronous and cached.
*
* @param url         The url for the image.
* @param placeholder The image to be set initially, until the image request finishes.
* @see ci_downloadImageWithURLStr:placeholderImage:
*/
- (void)ci_downloadImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder;


/**
* Download and set the imageView `image` with an `url`, placeholder and completedBlock.
*
* The download is asynchronous and cached.
*
* @param url            The url for the image.
* @param placeholder    The image to be set initially, until the image request finishes.
* @param completedBlock A block called when operation has been completed. This block has no return value
*                       and takes the requested UIImage as first parameter. In case of error the image parameter
*                       is nil and the second parameter may contain an NSError.
*                       The Third parameter is the original image url.
*/
- (void)ci_downloadImageWithURL:(nullable NSURL *)url
                  placeholderImage:(nullable UIImage *)placeholder
                         completed:(nullable CIExternalCompletionBlock)completedBlock;


/**
* Download and set the imageView `image` with an `url`, placeholder and progress and completed.
*
* The download is asynchronous and cached.
*
* @param url            The url for the image.
* @param placeholder    The image to be set initially, until the image request finishes.
* @param progressBlock  A block called while image is downloading
*                       @note the progress block is executed on a background queue
* @param completedBlock A block called when operation has been completed. This block has no return value
*                       and takes the requested UIImage as first parameter. In case of error the image parameter
*                       is nil and the second parameter may contain an NSError.
*                       The Third parameter is the original image url.
*/
- (void)ci_downloadImageWithURL:(nullable NSURL *)url
                  placeholderImage:(nullable UIImage *)placeholder
                          progress:(nullable CIImageLoaderProgressBlock)progressBlock
                         completed:(nullable CIExternalCompletionBlock)completedBlock;

#pragma mark - urlStr
/**
* Download and set the imageView `image` with an `urlStr`.
*
* The download is asynchronous and cached.
*
 * @param urlStr The url for the image.
*/
- (void)ci_downloadImageWithURLStr:(nullable NSString *)urlStr;

/**
* Download and set the imageView `image` with an `url` and a placeholder.
*
* The download is asynchronous and cached.
*
* @param urlStr         The urlStr of the image.
* @param imageName The image to be set initially, until the image request finishes.
* @see ci_downloadImageWithURLStr:placeholderImage:
*/
- (void)ci_downloadImageWithURLStr:(nullable NSString *)urlStr placeholder:(nullable NSString *)imageName;


@end

