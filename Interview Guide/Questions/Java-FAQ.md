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

2. Which of the following is true about static modifier.

A.	static can be applied to : instance variables, methods,
code Segments and classes.

B.	a static method cannot be overridden.

C.	inner classes can be both static & private.

D.	a static reference cannot be made through non static
method or code block.

E.	abstract & static both can be applied together to a
method.

Answer : B C D why not A


3. Given the following which are correct declarations for main method, the method that is invoked by the Java Runtime first

A.	public static void main(String s){}

B.	static public void main(String [] arg){}

C.	public static void main(String[] s){}

D.	public static void Main(String[] args){}

E.	All the above

Answer : C D

4. Select the valid primitive assignments of the following.

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


5. Given the following classes, defined in same file named ```SubClass.java```

```java
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
```

6. What happens when we compile and run ```SubClass.java```?

A.	Doesn't compile as you cannot override static methods.

B.	Compiles but fails at runtime.

C.	Compiles and runs successfully with output :
Hi Pal!!!, I am BaseClass

D.	Compiles and runs successfully with output :
Hi Pal!!!, I am SubClass

Answer : C
Question 25.

7. Select the code segments(assuming is part of valid class) below that compile and run correctly with output :  We are Equal

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

8. Given the following class definition in a file named ```MyClass.java```,

```java
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
     } //end of amethod()
    
      public static void main(String[] args){
           MyClass mc = new MyClass();
           mc.amethod();
      } //end of main

}     //end of class MyClass
```

What happens when we try to compile and run MyClass.java.

A.	Code doesn't compile because of error Statement not
reached.

B.	Code doesn't compiles because IOException cann't be
thrown explicitly

C.	Code compiles &  runs with output
i is : 11

D.	Code compiles & runs with no output.
Answer A

9. Given the following classes declaration in the same file MyClass1.java

```java
package mypackage;

public class MyClass1{
    //Some Valid Code
}

protected class MyClass2{
    //Some Valid Code
}
```

A.	Two classes can never be declared in the same file.

B.	The code Does't compile as the top most class is
protected.

C.	The code compiles & MyClass2 can only be instantiated
in it's sub classes.

D.	The code compiles & MyClass2 can only be instantiated
by the classes in the package 'mypackage'.
Answer B

10. How many String objects are created when we run the following code.

```java
String s1,s2,s3,s4;
s1 = "Hello";
s2 = s1;
s3 = s2 + "Pal";
s4 = s3;
```

A.	1

B.	2

C.	3

D.	4

E.	We can't say.
Answer C

11. Given that method aMethod() throws BaseException, SubException and RuntimeException of the following exception hierarchy

```text
java.lang.Exception
|
+ - - BaseException
|
+ - - SubException
|
+ - - java.lang.RuntimeException
```

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


12. Select the code segments(assuming is part of valid class) below that compile and run correctly with output: We are Equal

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


13. Read the following piece of code carefully.

```java
public class A {
    A() {
        // your code here
    }
}
```

The class A can be referenced outside the package in which it is defined.
The class A cannot be instantiated outside the package in which it is defined.
The class A cannot be extended outside the package in which it is defined.
The class A can be referenced, instantiated or extended anywhere.
The above code will cause a compiler error. The constructors of public class have to be public.
Answer 1 2 3 but shud b 4


14. Analyze the following code:
```java
public class Test {
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
        }
    }
}
```

The compiler reports an error at line 2
The class will not compile
The value 10 is one of the elements printed to the standard output
The compiler reports an error at line 9

15. Analyze the following code:
```java
public void divide(int a, int b) {
    try {
        int c = a / b;
    } catch (Exception e) {
        System.out.print("Exception ");
    } finally {
        System.out.println("Finally");
    }
}
```

Prints out: Finally
Prints out: Exception
Prints out: Exception Finally
No output

Answer C


16. Given the following code what is the effect of a being 5:

```java
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
```

Generate a runtime error
Throw an ArrayIndexOutOfBoundsException
Print the values: 1, 2, 2, 4
Produces no output

Answer D

17. Which of the following correctly illustrate how an InputStreamReader can be created:

new InputStreamReader(new FileInputStream("data"));
new InputStreamReader(new BufferedReader("data"));
new InputStreamReader(System.in);
new InputStreamReader("data");
new InputStreamReader(new FileReader("data"));

Answer a c

18. What is the effect of adding the sixth element to a vector created in the following manner:

new Vector(5, 10);

An IndexOutOfBounds exception is raised.  
The vector grows in size to a capacity of 10 elements
The vector grows in size to a capacity of 15 elements
Nothing, the vector will have grown when the fifth element was added

Answer C


19. What are possible results and why?

```java
   public class MyThread implements Runnable {

        public void run(){
            System.out.println("run");
            throw new RuntimeException("runtime exception");
        }

        public static void main(String ... s){
            Thread t = new Thread(new MyThread());
            t.start();
            System.out.println("end of main method");
        }
   }
```


A)
```shell
“run” is printed
java.lang.RuntimeException is thrown
“end of main method” is printed
```

B)
```shell
java.lang.RuntimeException is thrown
“end of main method” is printed
```

C)
```shell
“run” is printed
java.lang.RuntimeException is thrown
```
D)
```shell
“end of main method” is printed
“run” is printed
java.lang.RuntimeException is thrown
```
    
E)
```shell
“run” is printed
“end of main method” is printed
java.lang.RuntimeException is thrown
```


20. What will be printed and why?

```java
public class Test {

    public static void main(String ... s){
        int x = 3;
        doSomethingWithInt(x);
        System.out.println("main x = " + x);//3

        Integer y = new Integer(x);
        doSomethingWithInteger(y);
        System.out.println("main y = " + y);//3
    }

    public static void doSomethingWithInt(int num) {
        System.out.println("doSomething int is " + num++);//3
    }

    public static void doSomethingWithInteger(Integer num) {
        System.out.println("doSomething Integer is " + ++num);//4
    }
}
```

21. What will be printed and why?

```java
public class WrappedString {

    private String value;

    public WrappedString(String value){
        this.value = value;
    }

    public static void main(String ... s){
        Set<Object> set = new HashSet<>();

        set.add(new String("test"));
        set.add("test");

        set.add(new WrappedString("test"));
        set.add(new WrappedString("test"));

        System.out.println("Size of the set is " + set.size());//3
    }
}
```

22. What will be printed and why?

```java
public class Test {

    public static void main(String ... s){
        int i1 = 5;
        int i2 = 5;

        Integer i3 = new Integer(i1);
        Integer i4 = new Integer(i1);

        System.out.println("i1 == i2 - " + (i1 == i2));//true
        System.out.println("i3 == i4 - " + (i3 == i4));//false
    }
}
```

23. What will be printed and why?

```java
class A {
    public void test(){
        System.out.println("A test");
    }
}

class B extends A {
    public void test(){
        System.out.println("B test");
    }
}

public class Test {
    public static void main(String ... s){
        A a = new B();
        a.test(); //B test
        ((B)a).test(); //B test
            
        A a1 = new A();
        a1.test(); //A test
        ((B)a1).test(); //ClassCastException
    }
}
```

24. Is there any problem with below implementations and which one will you prefer in real life?

a)  
```java
void method(ArrayList<Integer> list){
    int sum = 0;
    int maxIndex = 0;
    
    for (int i = 0; i < list.size(); i++) {
      sum += list.get(i);
      maxIndex = i;
    }
    
    System.out.println(sum);
    System.out.println(maxIndex);
}
```

b)  
```java
void method(ArrayList<Integer> list) {
    int sum = 0;
    int maxIndex = 0;
    
    for (Integer item : list) {
      sum+=item;
      maxIndex = list.indexOf(item);
    }
    
    System.out.println(sum);
    System.out.println(maxIndex);
}
```

25. Is there any problem with this code?

```java
public class MyCounter {

    private volatile Integer counter = new Integer(0);

    public void increment() {
        synchronized (counter) {
            counter++;
            System.out.ptintln("Value of a counter is " + getValue());
        }
    }

    public int getValue() {
        return counter;
    }
}
```

26. Could you please implement method which will find min and max elements in the given array of numbers?
    - sort ->

```java
public int[] findMinAndMax() {
    int min = arr[0];
    int max = Integer.MIN_VALUE;
    for(int i = 0 ; i < arr.length; i++){
        if(arr[i] <= min)
            min = arr[i];
            
        if(arr[i] > max)
            max = arr[i];
    }
    
    return new int[]{min, max};
}
```

27. Could you please override equals method for the following class?
```java

class Point2D {
    int x, y;
    
    public boolean equals(Object object) {
        if(object == null)
            return false;
        if(!(object instanceof Point2D))
            return false;
        
        Point2D another = (Point2D)object;
        return (x == another.x && y == another.y);
    }
    
    public int hashCode() {
        return Math.random();
    }
}

Point2D point1 = new Point2D(1,2);
Point2D point2 = new Point2D(1,2);

Set<Point2D> set = new HashSet<>();
set.add(point1);//false
set.contains(point2);

class Point3D extends Point2D {
    int z;
    
    public boolean equals(Object object) {
        if(object == null)
            return false;
        if(!(object instanceof Point3D))
            return false;
        
        Point3D another = (Point3D)object;
        return (super.equals(another) && z == another.z);
    }        
}

//objects
Point2D point2D = new Point2D(1,2);
Point3D point3D = new Point3D(1,2,3);

point2D.equals(point3D); //false
```






# Author

---

* [Rohtash Lakra](https://github.com/rslakra)
