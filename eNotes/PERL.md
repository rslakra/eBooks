# PERL (Practical Extraction and Report Language) OR (Pathological Electric Rubbish Lister) By Lerry Well

---

## PERL-CGI (Common Gateway Interface) PROGRAMMING


### Brief Overview of CGI Programming

The Internet has become the most important communication medium in the world. Long before Java, there was the Common Gateway Interface (CGI) for short. The CGI has been used for many years as a facility for passing information from a web page to a program that can process the information. CGI does not care what browser you are suing; even non-graphical Linux type software will work.

Unlike Java and its most proprietary cousins, CGI is not a programming language, nor does it load itself onto the visitor’s machine to run. CGI is, as its name spells out, an interface, a set of rules. It resides on the web-server computer, providing a way for the page to communicate in a rough fashion with the server. CGI allows you to write programs to deal with the page in any language – including PERL.

The first Hypertext Transfer protocol (HTTP) servers were written for UNIX, too, and freely distributed among system administrators who wanted to try out the World Wide Web. CGI was developed as a standard of communication on these systems. In a sense, PERL and HTTP and CGI all become standards for doing web works.

### What is CGI, Anyway?

CGI as a concept has been applied to many systems other than links between web servers and application programs. For example, it would provide a clean and near – universal interface for database servers and their clients without the barriers introduced by proprietary systems. Software manufactures sometimes seem to worry about making sure that you only do business with them, but a common gateway from one system to another provides a standard of sorts to which the manufacturers have to adhere; if they can’t deal with it, no one will buy their applications.

Where HTML gives the World Wide Web its look, CGI makes it functional. It is what its name implies a Common Gateway between the web server and applications that can be useful to the server but does not run as a part of it. CGI is the only way the server can communicate with those other applications, such as a database.

### A Common Gateway

In technical terms, a gateway is an interface, or an application that allows two systems to pass information between them. E.g. microsoft’s old mail program and its newer exchange are limited to sending mail only to other microsoft mail users. A separate product provides a simple mail transfer protocol (SMTP) gateway so that mail can be sent to and received from the Internet.

Likewise with your web server, It does not know PERL from Adam, but through the mechanism of CGI it can handle requests from clients, or visitors to your site, and pass the results back.

Because the server is only following a set of rules for passing information, it does not know or care what you use in the background to process what it sends you. The functions are totally independent of one another. Thus, you can write CGI programs in any programming language. The only requirement is that the information you send back has to be formatted in a way that the server recognizes.

### The CGI Environment

To the operating system, whether it is Windows or Unix, the environment is a block of memory where variable names can be store as string values, such as 
```shell
path=c:/bin;c:/usr/in;c:/usr/local/bin
```

Programs can get into this block of memory, too. What makes this facility especially useful is that the environment is in global memory, which means that anything there is accessible by other programs running at the same time.

The web sever fills in a standard list of environment variables when it runs; it fills in others when requests are made of it. Because the web server runs all the time, anything it places in the environment can be read by another program such as your per script, in the other program knows the names of the variables to read.

You can not run CGI applications without a web server, so you need to be connected to or working on a machine that has the server software in place and operating.

**For Example**

```shell
#! User/bin/Perl (Comment)
print	"Hello, Mr. Lakra!","\n";
#end "Hello.pl"
```


**To Run**

```shell
perl Hello.pl (Press Enter Key)
```
	

- Scaler variables always begin with **$** (Dollar) sign.

**For Example**

**1. First Way**

```shell
#! Hello.pl
    $hello = “Hello, Mr. Lakra!”; # String Variables
    $timearound = 2; # Numeric Variable
    print $hello, “for the “, $timearound,”nd time!”,”\n”;
#end
```

**2. Second Way**

```shell
print “Hello for the ${timearound}nd times!”;
```
	

- List like arrays and can be of mix data types like int and character and variables begin with @ character

**For Examples**

```shell
@ Numbers = (1,2,3,4,5,6);
$ One number = $ Numbers [0];
@ Numbers = (1..6);

@ List1 = (‘Red’,’Green’,’Blue’);
@ List2 = (‘’,’Yellow’,@ List1);
@ List3 = (Null (empty)
```



- MIME – Multipurpose Interrupt Mail Extensions
- Perl’s Inventor – ‘Lerry Well’
  
- Require statement – used to open the files and reads in your program.


**For Example**

```shell
# helloend.pl
Sub HTML-footer
{
    print “\n”,”</BODY>”,”\n”;
    print “</HTML>”,”\n”;
} #end of html footer
```


```shell
#hellowww.pl
require “HTML-footer”; #call in the file
print “\n”,”<HTML>”,”\n”;
print “<HEAD>”,”\n”;
&HTML-footer
#end
```

```shell
# helloHead.pl
Sub HTML-header
{
    print “\n”,”<HTML>”,”\n”;
    print “\n”,”<HEAD>”,”\n”;
    print “\n”,”<TITLE>”,”@ -“,”</TITLE>”;
    print “\n”,“<BODY>”,”\n”;
} #end of html footer
```


```shell
#hellowww.pl
require “HTML-header”;
require “HTML-footer”;
&HTML-header(“Mr. RSL, CGI – Programming”);
print “\n”,”Hello, Mr. Lakra!”,”\n”;
&HTML-footer;
#end of htmlwww.pl
```


- To see the dialog between a Browser, and an HTTP Server
```shell
telnet <URL of your website> 80 (Enter Key)
ftp – 21	ftp connection	finger – 79 - finger server connection
telnet-23	telnet connection	http-80 	webserver connection
imtp-25	(mail) connection pop3-110 	pop3 post office
```

- Get ```/scripts/Perl-cgi/hellowww.pl HTTP/1.0``` Press <Enter> Twice

- Post Statement

To send the large amount of data to the server to be processed by a CGI program.


---

# Author
- Rohtash Lakra
