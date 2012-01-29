#import "BBWeeAppController-Protocol.h"


static NSBundle *_NCSpeedDialWeeAppBundle = nil;

@interface NCSpeedDialController: NSObject <BBWeeAppController> {
	UIView *_view;
	UIImageView *_backgroundView;
	UILabel *label;
	UILabel *numberLabel;
	NSString *numberToWrite;
}
@property (nonatomic, retain) UIView *view;
@end

@implementation NCSpeedDialController
@synthesize view = _view;

+ (void)initialize {
	_NCSpeedDialWeeAppBundle = [[NSBundle bundleForClass:[self class]] retain];
}

- (id)init {
	if((self = [super init]) != nil) {
		
	} return self;
}

- (void)dealloc {
	[_view release];
	[_backgroundView release];
	[super dealloc];
}

- (void)loadFullView {
	// Add subviews to _backgroundView (or _view) here.
	_view = [[UIView alloc] initWithFrame:CGRectMake(2, 0, 316, 71)];
        
        UIImage *bg = [[UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/WeeAppTest.bundle/WeeAppBackground.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:71];
        UIImageView *bgView = [[UIImageView alloc] initWithImage:bg];
        bgView.frame = CGRectMake(0, 0, 316, 71);
        [_view addSubview:bgView];
        [bgView release];
}

-(void)viewDidAppear {
		label = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 258, 55)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.text = @"Speed Dial";
        label.font = [UIFont systemFontOfSize:(CGFloat)30];

        UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getContact)];
        [label setUserInteractionEnabled:YES];
		[label addGestureRecognizer:gesture];
        [_view addSubview:label];
        [label release];

        numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 55, 300, 16)];
        numberLabel.backgroundColor = [UIColor clearColor];
        numberLabel.textColor = [UIColor whiteColor];
        NSFileManager *filemgr;
		NSData *databuffer;
		NSString *fileString;
		filemgr = [NSFileManager defaultManager];	
		databuffer = [filemgr contentsAtPath: @"number.txt"];
		fileString = [[NSString alloc] initWithData:databuffer encoding:NSUTF8StringEncoding];
		numberLabel.adjustsFontSizeToFitWidth=YES;
	    numberLabel.text = fileString;
		[_view addSubview:numberLabel];
		[numberLabel release];

        UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoLight];
        button.frame = CGRectMake(300,50,15,15);
        [button addTarget: self action:@selector(enterNumber) forControlEvents:UIControlEventTouchDown];
        [_view addSubview:button];

        UIImageView *phoneButton = [[UIImageView alloc] initWithFrame: CGRectMake(16, 6, 60, 60)];
        [phoneButton setImage:[UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/NCSpeedDial.bundle/phone.png"]];
        [phoneButton setUserInteractionEnabled:YES];
		[phoneButton addGestureRecognizer:gesture];
        [_view addSubview: phoneButton];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
 
    if([title isEqualToString:@"Cancel"])
    {

    }
    else if([title isEqualToString:@"Continue"])
    {
        UITextField *number = [alertView textFieldAtIndex:0];
        NSString *file_path = @"number.txt"; 
        NSFileHandle *file;
        file = [NSFileHandle fileHandleForUpdatingAtPath: file_path];
		numberToWrite = number.text;
		[file truncateFileAtOffset: 0];
		[numberToWrite writeToFile:file_path atomically:YES encoding:NSUTF8StringEncoding error:nil];
		NSFileManager *filemgr;
		NSData *databuffer;
		NSString *fileString;
		filemgr = [NSFileManager defaultManager];	
		databuffer = [filemgr contentsAtPath: @"number.txt"];
		fileString = [[NSString alloc] initWithData:databuffer encoding:NSUTF8StringEncoding];
		numberLabel.text = fileString;
		

    }
}


- (void)getContact {
	NSFileManager *filemgr;
	NSData *databuffer;
	NSString *fileString;
	filemgr = [NSFileManager defaultManager];	
	databuffer = [filemgr contentsAtPath: @"number.txt"];
	fileString = [[NSString alloc] initWithData:databuffer encoding:NSUTF8StringEncoding];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", fileString]]];
}

- (void) enterNumber {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Enter phone number to add to speed dial"
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Continue", nil];
 
    [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [message textFieldAtIndex:0].keyboardType = UIKeyboardTypePhonePad;
    [message show];
}

- (void)loadPlaceholderView {
	// This should only be a placeholder - it should not connect to any servers or perform any intense
	// data loading operations.
	//
	// All widgets are 316 points wide. Image size calculations match those of the Stocks widget.
	_view = [[UIView alloc] initWithFrame:(CGRect){CGPointZero, {316.f, [self viewHeight]}}];
	_view.autoresizingMask = UIViewAutoresizingFlexibleWidth;

	UIImage *bgImg = [UIImage imageWithContentsOfFile:@"/System/Library/WeeAppPlugins/StocksWeeApp.bundle/WeeAppBackground.png"];
	UIImage *stretchableBgImg = [bgImg stretchableImageWithLeftCapWidth:floorf(bgImg.size.width / 2.f) topCapHeight:floorf(bgImg.size.height / 2.f)];
	_backgroundView = [[UIImageView alloc] initWithImage:stretchableBgImg];
	_backgroundView.frame = CGRectInset(_view.bounds, 2.f, 0.f);
	_backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[_view addSubview:_backgroundView];
}

- (void)unloadView {
	[_view release];
	_view = nil;
	[_backgroundView release];
	_backgroundView = nil;

	// Destroy any additional subviews you added here. Don't waste memory :(.
}

- (float)viewHeight {
	return 71.f;
}

@end
