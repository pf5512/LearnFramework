//
//  SynchronousViewController.h
//  Part of the ASIHTTPRequest sample project - see http://allseeing-i.com/ASIHTTPRequest for details
//
//  Created by Ben Copsey on 07/11/2008.
//  Copyright 2008 All-Seeing Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SampleViewController.h"
#import <Security/Security.h>

@class ASIHTTPRequest;

@interface SynchronousViewController : SampleViewController {
	ASIHTTPRequest *request;
	UITextField *urlField;
	UITextView *responseField;
	UIButton *goButton;

}
- (IBAction)simpleURLFetch:(id)sender;

@property (retain, nonatomic) ASIHTTPRequest *request;

+ (BOOL)extractIdentity:(SecIdentityRef *)outIdentity andTrust:(SecTrustRef*)outTrust fromPKCS12Data:(NSData *)inPKCS12Data;

@end
