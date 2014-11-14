//
//  SynchronousViewController.m
//  Part of the ASIHTTPRequest sample project - see http://allseeing-i.com/ASIHTTPRequest for details
//
//  Created by Ben Copsey on 07/11/2008.
//  Copyright 2008 All-Seeing Interactive. All rights reserved.
//

#import "SynchronousViewController.h"
#import "ASIHTTPRequest.h"
#import "DetailCell.h"
#import "InfoCell.h"

@implementation SynchronousViewController


/*
 *ASIHTTPRequest 数据请求, 简单的模型,
 *requestWithURL 加载请求url, 
 *initWithURL 默认为GET方法的http方法
 *startSynchronous 同步请求
 *startAsynchronous 异步请求
 ***************************
 *[request responseHeaders] 请求回应http头
 *[request responseString] 请求回应内容
 */

#pragma mark ==同步请求数据==
// Runs a request synchronously
- (IBAction)simpleURLFetch:(id)sender
{
	NSURL *url = [NSURL URLWithString:[urlField text]];

	// Create a request
	// You don't normally need to retain a synchronous request, but we need to in this case because we'll need it later if we reload the table data
	[self setRequest:[ASIHTTPRequest requestWithURL:url]];
	
	//Customise our user agent, for no real reason
	[request addRequestHeader:@"User-Agent" value:@"ASIHTTPRequest"];

    /*
     *startSynchronous,同步请求数据,会阻塞主线程
     *[request responseString] 得到返回数据
     */
	// Start the request
	[request startSynchronous];
    //[request startAsynchronous];
    
    //NSString *str = [request responseString];
    //NSLog(@"--%@", str);
	
	// Request has now finished
	[[self tableView] reloadData];
}

/*
Most of the code below here relates to the table view, and isn't that interesting
*/

- (void)viewDidLoad
{
	[super viewDidLoad];
	[[[self navigationBar] topItem] setTitle:@"Synchronous Requests"];

    //to test ssl
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 45, 80, 45)];
    [btn setTitle:@"ssl-test" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(testSSLCer) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)testSSLCer
{
    // This url requires we present a client certificate to connect to it
//    NSURL *url = [NSURL URLWithString:@"https://clientcertificate.allseeing-i.com:8080/ASIHTTPRequest/tests/first"];
//    
//    // First, let's attempt to connect to the url without supplying a certificate
//    //ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
//    request = [ASIHTTPRequest requestWithURL:url];
//    // We have to turn off validation for these tests, as the server has a self-signed certificate
//    [request setValidatesSecureCertificate:NO];
//    [request startSynchronous];
//
//    NSLog(@"...response %@ %d", request.responseString, request.responseStatusCode);
    // Now, let's grab the certificate (included in the resources of the test app)
    SecIdentityRef identity = NULL;
    SecTrustRef trust = NULL;
    NSData *PKCS12Data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"client" ofType:@"p12"]];
    
    [SynchronousViewController extractIdentity:&identity andTrust:&trust fromPKCS12Data:PKCS12Data];
    
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:@"https://clientcertificate.allseeing-i.com:8080/ASIHTTPRequest/tests/first"]];
    
    NSLog(@"... identity %@", identity);
    // In this case, we have no need to add extra certificates, just the one inside the indentity will be used
    [request setClientCertificateIdentity:identity];
    [request setAuthenticationScheme:@"https"];
    [request setValidatesSecureCertificate:NO];
    [request startSynchronous];
    
    NSLog(@"...response %@ %d", request.responseString, request.responseStatusCode);
}

+ (BOOL)extractIdentity:(SecIdentityRef *)outIdentity andTrust:(SecTrustRef*)outTrust fromPKCS12Data:(NSData *)inPKCS12Data
{
    OSStatus securityError = errSecSuccess;
    
    NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObject:@"" forKey:(id)kSecImportExportPassphrase];
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    securityError = SecPKCS12Import((CFDataRef)inPKCS12Data,(CFDictionaryRef)optionsDictionary,&items);
    
    //假如ssl证书带有密码
    //    CFStringRef password = CFSTR(@"SSL-PASSWORD");
    //    const void *keys[] = { kSecImportExportPassphrase};
    //    const void *values[] = {password};
    //    CFDictionaryRef optionsDictionary = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    //    securityError = SecPKCS12Import((CFDataRef)inPKCS12Data, optionsDictionary, &items);
    
    if (securityError == 0) { 
        CFDictionaryRef myIdentityAndTrust = CFArrayGetValueAtIndex (items, 0);
        const void *tempIdentity = NULL;
        tempIdentity = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemIdentity);
        *outIdentity = (SecIdentityRef)tempIdentity;
        const void *tempTrust = NULL;
        tempTrust = CFDictionaryGetValue (myIdentityAndTrust, kSecImportItemTrust);
//        tempTrust = addAnchorToTrust((void *)&tempTrust, (void *)&tempIdentity);
//        *outTrust = changeHostForTrust((void *)&tempTrust);
        *outTrust = (SecTrustRef)tempTrust;
    } else {
        NSLog(@"Failed with error code %d",(int)securityError);
        return NO;
    }
    
    return YES;
}

SecTrustRef changeHostForTrust(SecTrustRef trust)
{
    CFMutableArrayRef newTrustPolicies = CFArrayCreateMutable(
                                                              kCFAllocatorDefault, 0, &kCFTypeArrayCallBacks);
    
    SecPolicyRef sslPolicy = SecPolicyCreateSSL(true, CFSTR("www.example.com"));
    
    CFArrayAppendValue(newTrustPolicies, sslPolicy);
    
#ifdef MAC_BACKWARDS_COMPATIBILITY
    /* This technique works in OS X (v10.5 and later) */
    
    SecTrustSetPolicies(trust, newTrustPolicies);
    CFRelease(oldTrustPolicies);
    
    return trust;
#else
    /* This technique works in iOS 2 and later, or
     OS X v10.7 and later */
    
    CFMutableArrayRef certificates = CFArrayCreateMutable(
                                                          kCFAllocatorDefault, 0, &kCFTypeArrayCallBacks);
    
    /* Copy the certificates from the original trust object */
    CFIndex count = SecTrustGetCertificateCount(trust);
    CFIndex i=0;
    for (i = 0; i < count; i++) {
        SecCertificateRef item = SecTrustGetCertificateAtIndex(trust, i);
        CFArrayAppendValue(certificates, item);
    }
    
    /* Create a new trust object */
    SecTrustRef newtrust = NULL;
    if (SecTrustCreateWithCertificates(certificates, newTrustPolicies, &newtrust) != errSecSuccess) {
        /* Probably a good spot to log something. */
        
        return NULL;
    }
    
    return newtrust;
#endif
}

SecTrustRef addAnchorToTrust(SecTrustRef trust, SecCertificateRef trustedCert)
{
#ifdef PRE_10_6_COMPAT
    CFArrayRef oldAnchorArray = NULL;
    
    /* In OS X prior to 10.6, copy the built-in
     anchors into a new array. */
    if (SecTrustCopyAnchorCertificates(&oldAnchorArray) != errSecSuccess) {
        /* Something went wrong. */
        return NULL;
    }
    
    CFMutableArrayRef newAnchorArray = CFArrayCreateMutableCopy(
                                                                kCFAllocatorDefault, 0, oldAnchorArray);
    CFRelease(oldAnchorArray);
#else
    /* In iOS and OS X v10.6 and later, just create an empty
     array. */
    CFMutableArrayRef newAnchorArray = CFArrayCreateMutable (
                                                             kCFAllocatorDefault, 0, &kCFTypeArrayCallBacks);
#endif
    
    CFArrayAppendValue(newAnchorArray, trustedCert);
    
    SecTrustSetAnchorCertificates(trust, newAnchorArray);
    
#ifndef PRE_10_6_COMPAT
    /* In iOS or OS X v10.6 and later, reenable the
     built-in anchors after adding your own.
     */
    SecTrustSetAnchorCertificatesOnly(trust, false);
#endif
    
    return trust;
}

- (void)dealloc
{
	[request cancel];
	[request release];
	[super dealloc];
}

static NSString *intro = @"Demonstrates fetching a web page synchronously, the HTML source will appear in the box below when the download is complete.  The interface will lock up when you press this button until the operation times out or succeeds. You should avoid using synchronous requests on the main thread, even for the simplest operations.";

- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	int tablePadding = 40;
	int tableWidth = [tableView frame].size.width;
	if (tableWidth > 480) { // iPad
		tablePadding = 110;
	}
	
	UITableViewCell *cell;
	if ([indexPath section] == 0) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"InfoCell"];
		if (!cell) {
			cell = [InfoCell cell];	
		}
		[[cell textLabel] setText:intro];
		[cell layoutSubviews];
		
	} else if ([indexPath section] == 1) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"URLCell"];
		if (!cell) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"URLCell"] autorelease];
			urlField = [[[UITextField alloc] initWithFrame:CGRectZero] autorelease];
			[[cell contentView] addSubview:urlField];	
			goButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
			[goButton setTitle:@"Go!" forState:UIControlStateNormal];
			[goButton addTarget:self action:@selector(simpleURLFetch:) forControlEvents:UIControlEventTouchUpInside];
			[[cell contentView] addSubview:goButton];
		}
		[goButton setFrame:CGRectMake(tableWidth-tablePadding-38,7,20,20)];
		[goButton sizeToFit];
		[urlField setFrame:CGRectMake(10,12,tableWidth-tablePadding-50,20)];
		if ([self request]) {
			[urlField setText:[[[self request] url] absoluteString]];
		} else {
			[urlField setText:@"http://allseeing-i.com"];
		}
		
		
	} else if ([indexPath section] == 2) {
		cell = [tableView dequeueReusableCellWithIdentifier:@"ResponseCell"];
		if (!cell) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ResponseCell"] autorelease];
			responseField = [[[UITextView alloc] initWithFrame:CGRectZero] autorelease];
			[responseField setBackgroundColor:[UIColor clearColor]];
			[[cell contentView] addSubview:responseField];
		}
		[responseField setFrame:CGRectMake(5,5,tableWidth-tablePadding,150)];
		if (request) {
			if ([request error]) {
				[responseField setText:[[request error] localizedDescription]];
			} else if ([request responseString]) {
				[responseField setText:[request responseString]];
			}
		}
		
	} else {
		cell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell"];
		if (!cell) {
			cell = [DetailCell cell];
		}
		NSString *key = [[[request responseHeaders] allKeys] objectAtIndex:[indexPath row]];
		[[cell textLabel] setText:key];
		[[cell detailTextLabel] setText:[[request responseHeaders] objectForKey:key]];
	}
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	return cell;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
	if (section == 3) {
		return (NSInteger)[[request responseHeaders] count];
	} else {
		return 1;
	}
}

- (CGFloat)tableView:(UITableView *)theTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if ([indexPath section] == 0) {
		return [InfoCell neededHeightForDescription:intro withTableWidth:[tableView frame].size.width]+20;
	} else if ([indexPath section] == 1) {
		return 48;
	} else if ([indexPath section] == 2) {
		return 160;
	} else {
		return 34;
	}
}

- (NSString *)tableView:(UITableView *)theTableView titleForHeaderInSection:(NSInteger)section
{
	switch (section) {
		case 0:
			return nil;
		case 1:
			return @"Request URL";
		case 2:
			return @"Response";
		case 3:
			return @"Response Headers";
	}
	return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if ([self request]) {
		return 4;
	} else {
		return 2;
	}
}


@synthesize request;

@end
