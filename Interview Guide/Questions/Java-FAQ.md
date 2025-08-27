# Java Interview Questions

---

1. String Question
```java
public class Test14{
    
    static String s ="Instance";
    
    public static void method(String s){
        s+="Add";
    }
    
    public static void main(String a[]){
        Test14 t = new Test14();
        s = "New Instance";
        String s = "Local";
        method(s);
        System.out.println(s);
        System.out.println(t.s);
    }
}
```

Question 3.

Which of the follwing is true about static modifier.




A.	static can be applied to : instance variables, methods,
code Segments and classes.

B.	a static method cannot be overridden.

C.	inner classes can be both static & private.

D.	a static reference cannot be made through non static
method or code block.

E.	abstract & static both can be applied together to a
method.

Answer : B C D why not A


Question 8.

Given the follwowing which are correct declarations for main method, the method that is invoked by the Java Runtime first



A.	public static void main(String s){}

B.	static public void main(String [] arg){}

C.	public static void main(String[] s){}

D.	public static void Main(String[] args){}

E.	All the above

Answer : C D

Question 19.

Select the valid primitive assignments of the following.



A.	int i = 10;
char c = i;

B.	float f;
long l = 100L;
f = l;

C.	short s = 20;
char c = s;

D.	byte b = 20;
char c = b;

E.	short s1 = 10;
short s2 = 20;
short result = s1*s2;



Answer : A B

Question 21.

Given the following classes, defined in same file named SubClass.java

	class BaseClass{
	  static void sayHello(){
		System.out.println("Hi pal!!!, I am BaseClass");
	  }
	}
	
	public class SubClass extends BaseClass{
	  static void sayHello(){
		System.out.println("Hi pal!!!, I am SubClass");
	  }
	  
	  public static void main(String [] arg){

		BaseClass bc = new SubClass();
		bc.sayHello();
	  }
	}

What happens when we compile and run SubClass.java?




A.	Does't compile as you cannot override static methods.

B.	Compiles but fails at runtime.

C.	Compiles and runs successfully with output :
Hi Pal!!!, I am BaseClass

D.	Compiles and runs successfully with output :
Hi Pal!!!, I am SubClass


Answer : C
Question 25.

Select the code segments(assuming is part of valid class) below that compile and run correctly with output :  We are Equal



A.	float f1 = 1.2F;
float f2 = 1.2F;
if( f1.equals(f2))
System.out.println("We are Equal");

B.	Object o = new Object();
String s = new String();
if(s.equals(o))
System.out.println("We are Equal");

C.	char c = 'a';
Character cc = new Character('a');
if( cc.equals(c))
System.out.println("We are Equal");

D.	String s1 = "OK";
String s2 = new String(s1);
if( s1.equals(s2))
System.out.println("We are Equal");

E.	String s1 = new String("OK");
StringBuffer s2 = new StringBuffer(s1);
if(s1.equals(s2))
System.out.println("We are Equal");

F.	Boolean b1 = new Boolean(true);
Boolean b2 = new Boolean(true);
if(b1.equals(b2))
System.out.println("We are Equal");



Answer D F

Question 27.

Given the following class definition in a file named MyClass.java,

import java.io.IOException;

public class MyClass{
int i;
public void amethod(){

	try{
		i = 10;
		i++;
		throw new IOException();
		i--;
	}
	catch( IOException e){
		i++;
	}
	finally{
		i--;
		System.out.println("i is : "+i);
	}

     }      //end of amethod()
    
      public static void main(String[] args){
           MyClass mc = new MyClass();
           mc.amethod();
      }    //end of main

}     //end of class MyClass

What happens when we try to compile and run MyClass.java.



A.	Code does't compile because of error Statement not
reached.

B.	Code doesn't compiles because IOException cann't be
thrown explicitly

C.	Code compiles &  runs with output
i is : 11

D.	Code compiles & runs with no output.
Answer A

Question 28.

Given the following classes declaration in the same file MyClass1.java

package mypackage;

public class MyClass1{
//Some Valid Code
}

protected class MyClass2{
//Some Valid Code
}




A.	Two classes can never be declared in the same file.

B.	The code Does't compile as the top most class is
protected.

C.	The code compiles & MyClass2 can only be instantiated
in it's sub classes.

D.	The code compiles & MyClass2 can only be instantiated
by the classes in the package 'mypackage'.
Answer B
uestion 29.

How many String objects are created when we run the following code.

	String s1,s2,s3,s4;
	s1 = "Hello";
	s2 = s1;
	s3 = s2 + "Pal";
	s4 = s3;



A.	1

B.	2

C.	3

D.	4

E.	We can't say.
Answer C

Question 35.

Given that method aMethod() throws BaseException, SubException and RuntimeException of the following exception hierarchy

java.lang.Exception
|
+ - - BaseException
|
+ - - SubException
|
+ - - java.lang.RuntimeException

	Which of the following are legal




A.	public class MyClass {
public void myMethod(){
aMethod();
}
}

B.	public class MyClass{
public void myMethod() throws                                                           BaseException,RuntimeException{
aMethod();
}
}

C.	public class MyClass{
public void myMethod() throws BaseException{
aMethod();
}
}

D.	public class MyClass{
public void myMethod() throws Exception{
aMethod();
}
}

E.	public class MyClass{
public void myMethod() throws RuntimeException {
aMethod();
}
}
Answer C D

Are all wrapper classes in Java 5 immutable ?

Question 47.

Select the code segments(assuming is part of valid class) below that compile and run correctly with output: We are Equal



A.	int i = 10;  
long l = 10L;
if( i == l )
System.out.println("We are Equal");

B.	int i = 10;
Integer ii = new Integer(10);
if( i == ii)
System.out.println("We are Equal");

C.	int i = 10; char c = 10;
if( c == i)
System.out.println("We are Equal");

D.	Integer ii = new Integer(10);
Integer jj = new Integer(10);
if(ii == jj)
System.out.println("We are Equal");

E.	String s1 = "Null";
String s2 = "Null";
if( s1 == s2)
System.out.println("We are Equal");

F.	String s1 = "Null";
String s2 = new String(s1);
if( s1 == s2)
System.out.println("We are Equal");
Answer A C E

Question 75.

Read the following piece of code carefully.


public class A
{
A()
{
}
}
The class A can be referenced outside the package in which it is defined.
The class A cannot be instantiated outside the package in which it is defined.
The class A cannot be extended outside the package in which it is defined.
The class A can be referenced, instantiated or extended anywhere.
The above code will cause a compiler error. The constructors of public class have to be public.
Answer 1 2 3 but shud b 4


7)  public class Test {
    static int total = 10;
    public static void main (String args []) {
    new Test();
    }
    public Test () {
    System.out.println("In test");
    System.out.println(this);
    int temp = this.total;
    if (temp > 5) {
    System.out.println(temp);
    }}}

The compiler reports an error at line 2
The class will not compile
The value 10 is one of the elements printed to the standard output
The compiler reports an error at line 9

13)  public void divide(int a, int b) {
     try {
     int c = a / b;
     }
     catch (Exception e) {
     System.out.print("Exception ");
     } finally {
     System.out.println("Finally");
     }

Prints out: Finally
Prints out: Exception
Prints out: Exception Finally
No output

Answer C

25)  Given the following code what is the effect of a being 5:

public class Test {
public void add(int a) {
loop: for (int i = 1; i < 3; i++){
for (int j = 1; j < 3; j++) {
if (a == 5) {
break loop;
}
System.out.println(i * j);
}
}
}
}

Generate a runtime error
Throw an ArrayIndexOutOfBoundsException
Print the values: 1, 2, 2, 4
Produces no output

Answer D

34)  Which of the following correctly illustrate how an InputStreamReader can be created:

new InputStreamReader(new FileInputStream("data"));
new InputStreamReader(new BufferedReader("data"));
new InputStreamReader(System.in);
new InputStreamReader("data");
new InputStreamReader(new FileReader("data"));
Answer a c

36)  What is the effect of adding the sixth element to a vector created in the following manner:

new Vector(5, 10);

An IndexOutOfBounds exception is raised.  
The vector grows in size to a capacity of 10 elements
The vector grows in size to a capacity of 15 elements
Nothing, the vector will have grown when the fifth element was added

Answer C



# Author

---

* [Rohtash Lakra](https://github.com/rslakra)
