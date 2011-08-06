#import <UIKit/UIKit.h>
@class BrowserController;
@class TabSnapshot;
id active;
@interface TabSnapshot : NSObject
{
    struct CGImage *_image;
}


@property(readonly, nonatomic) struct CGImage *image; // @synthesize image=_image;

@end
@interface TabController : NSObject
{


}
- (void)setActiveTabDocument:(id)arg1;
@end
@interface BrowserController
{

}
+ (id)sharedBrowserController;
- (id)snapshotForTabDocument:(id)arg1;
@end
@interface MFMailComposeViewController : UINavigationController
{
}
- (id)_mailComposeController;
- (void)setMessageBody:(id)arg1 isHTML:(BOOL)arg2;
@end
@interface MailComposeController : NSObject {

}
-(void)addInlineAttachmentWithData:(id)data preferredFilename:(id)filename mimeType:(id)type;
@end


%hook BrowserMailComposeViewController
- (void)navigationController:(id)arg1 didShowViewController:(id)arg2 animated:(BOOL)arg3 {

     [self setMessageBody:@"" isHTML:YES];


return %orig;
}
%end
%hook TabController
- (void)setActiveTabDocument:(id)arg1 {
active = arg1;
%orig;
}
%end
%hook MFMailComposeViewController

- (void)setMessageBody:(id)arg1 isHTML:(BOOL)arg2 {
%class BrowserController;
	id controller = [$BrowserController sharedBrowserController];
		id mailController = [self _mailComposeController];

TabSnapshot *snapshot = [controller snapshotForTabDocument:active];
CGImage *cg = snapshot.image;
UIImage *img = [UIImage imageWithCGImage:cg];
     NSData *imageData = UIImageJPEGRepresentation(img, 1);
	 %orig;
[mailController addInlineAttachmentWithData:imageData preferredFilename:@"snapshot.jpg" mimeType:@"image/jpeg"];


}



%end
