# Java Interview Questions

---


1. Which of the following are valid definitions of an application's ```main()``` method?

```java
a) public static void main();
b) public static void main( String args );
c) public static void main( String args[] );
d) public static void main( Graphics g );
e) public static boolean main( String args[] );
```


2. If ```MyProg.java``` were compiled as an application and then run from the command line as:

```java
java MyProg I like tests
```
              
what would be the value of args[ 1 ] inside the main( ) method?

a) MyProg
b) "I"
c) "like"
d) 3
e) 4
f) null until a value is assigned


3. Which of the following are Java keywords?

a) array
b) boolean
c) Integer
d) protect
e) super


4. After the declaration:

char[] c = new char[100];

what is the value of c[50]?

a) 50
b) 49
c) '\u0000'
d) '\u0020'
e) " "
f) cannot be determined
g) always null until a value is assigned


5. After the declaration:

int x;

the range of x is:

a) -231 to 231-1
b) -216 to 216 - 1
c) -232 to 232
d) -216 to 216
e) cannot be determined; it depends on the machine


6. Which identifiers are valid?

a) _xpoints
b) r2d2
c) bBb$
d) set-flow
e) thisisCrazy


7. Represent the number 6 as a hexadecimal literal.




8. Which of the following statements assigns "Hello Java" to the String variable s?

a) String s = "Hello Java";
b) String s[] = "Hello Java";
c) new String s = "Hello Java";
d) String s = new String("Hello Java");


9. An integer, x has a binary value (using 1 byte) of 10011100. What is the binary value of z after these statements:

int y = 1 << 7;
int z = x & y;


a) 1000 0001
b) 1000 0000
c) 0000 0001
d) 1001 1101
e) 1001 1100


10. Which statements are accurate:

a) >> performs signed shift while >>> performs an unsigned shift.
b) >>> performs a signed shift while >> performs an unsigned shift.
c) << performs a signed shift while <<< performs an insigned shift.
d) <<< performs a signed shift while << performs an unsigned shift.


11. The statement ...

String s = "Hello" + "Java";

yields the same value for s as ...

String s = "Hello";
String s2= "Java";
s.concat( s2 );

True
False


12. If you compile and execute an application with the following code in its main() method:

    String s = new String( "Computer" );

    if( s == "Computer" )
    System.out.println( "Equal A" );
    if( s.equals( "Computer" ) )
    System.out.println( "Equal B" );
    a) It will not compile because the String class does not support the = = operator.
    b) It will compile and run, but nothing is printed.
    c) "Equal A" is the only thing that is printed.
    d) "Equal B" is the only thing that is printed.
    e) Both "Equal A" and "Equal B" are printed.


13. Consider the two statements:

    1. boolean passingScore = false && grade == 70;
    2. boolean passingScore = false & grade == 70;
       The expression

grade == 70

is evaluated:

a) in both 1 and 2
b) in neither 1 nor 2
c) in 1 but not 2
d) in 2 but not 1
e) invalid because false should be FALSE


14. Given the variable declarations below:

byte myByte;
int myInt;
long myLong;
char myChar;
float myFloat;
double myDouble;

Which one of the following assignments would need an explicit cast?

a) myInt = myByte;
b) myInt = myLong;
c) myByte = 3;
d) myInt = myChar;
e) myFloat = myDouble;
f) myFloat = 3;
g) myDouble = 3.0;



15. Consider this class example:

class MyPoint
{  void myMethod()
{  int x, y;
x = 5; y = 3;
System.out.print( " ( " + x + ", " + y + " ) " );
switchCoords( x, y );
System.out.print( " ( " + x + ", " + y + " ) " );
}
void switchCoords( int x, int y )
{  int temp;
temp = x;
x = y;
y = temp;
System.out.print( " ( " + x + ", " + y + " ) " );
}
}
What is printed to standard output if myMethod() is executed?

a) (5, 3) (5, 3) (5, 3)
b) (5, 3) (3, 5) (3, 5)
c) (5, 3) (3, 5) (5, 3)


16. To declare an array of 31 floating point numbers representing snowfall for each day of March in Gnome, Alaska, which declarations would be valid?

a) double snow[] = new double[31];
b) double snow[31] = new array[31];
c) double snow[31] = new array;
d) double[] snow = new double[31];


17. If arr[] contains only positive integer values, what does this function do?

public int guessWhat( int arr[] )
{  int x= 0;
for( int i = 0; i < arr.length; i++ )
x = x < arr[i] ? arr[i] : x;
return x;
}
a) Returns the index of the highest element in the array
b) Returns true/false if there are any elements that repeat in the array
c) Returns how many even numbers are in the array
d) Returns the highest element in the array
e) Returns the number of question marks in the array


18. Consider the code below:

arr[0] = new int[4];
arr[1] = new int[3];
arr[2] = new int[2];
arr[3] = new int[1];
for( int n = 0; n < 4; n++ )
System.out.println( /* what goes here? */ );

Which statement below, when inserted as the body of the for loop, would print the number of values in each row?

a) arr[n].length();
b) arr.size;
c) arr.size -1;
d) arr[n][size];
e) arr[n].length;


19. If size = 4, triArray looks like:


int[][] makeArray( int size)
{  int[][] triArray = new int[size] [];
int val=1;
for( int i = 0; i < triArray.length; i++ )
{  triArray[i] = new int[i+1];
for( int j=0; j < triArray[i].length; j++ )
{  triArray[i][j] = val++;
}
}
return triArray;
}

a)
1 2 3 4
5 6 7
8 9
10 b)
1 4 9 16 c)
1 2 3 4 d)
1 2 3 4
5 6 7 8
9 10 11 12
13 14 15 16 e)
1
2 3
4 5 6
7 8 9 10



20. Which of the following are legal declarations of a two-dimensional array of integers?

a) int[5][5]a = new int[][];
b) int a = new int[5,5];
c) int[]a[] = new int[5][5];
d) int[][]a = new[5]int[5];


21. Which of the following are correct methods for initializing the array "dayhigh" with 7 values?

a) int dayhigh = { 24, 23, 24, 25, 25, 23, 21 };
b) int dayhigh[] = { 24, 23, 24, 25, 25, 23, 21 };
c) int[] dayhigh = { 24, 23, 24, 25, 25, 23, 21 };
d) int dayhigh [] = new int[24, 23, 24, 25, 25, 23, 21];
e) int dayhigh = new[24, 23, 24, 25, 25, 23, 21];


22. If you want subclasses to access, but not to override a superclass member method, what keyword should precede the name of the superclass method?




23. If you want a member variable to not be accessible outside the current class at all, what keyword should precede the name of the variable when declaring it?




24. Consider the code below:


public static void main( String args[] )
{  int a = 5;
System.out.println( cube( a ) );
}
int cube( int theNum )
{
return theNum * theNum * theNum;
}

What will happen when you attempt to compile and run this code?

a) It will not compile because cube is already defined in the java.lang.Math class.
b) It will not compile because cube is not static.
c) It will compile, but throw an arithmetic exception.
d) It will run perfectly and print "125" to standard output.


25. Given the variables defined below:

int one = 1;
int two = 2;
char initial = '2';
boolean flag = true;

Which of the following are valid?

a) if( one ){}
b) if( one = two ){}
c) if( one == two ){}
d) if( flag ){}
e) switch( one ){}
f) switch( flag ){}
g) switch( initial ){}


26. If val = 1 in the code below:


switch( val )
{  case 1: System.out.print( "P" );
case 2:
case 3: System.out.print( "Q" );
break;
case 4: System.out.print( "R" );
default: System.out.print( "S" );
}

Which values would be printed?

a) P
b) Q
c) R
d) S


27. Assume that val has been defined as an int for the code below:


if( val > 4 )
{  System.out.println( "Test A" );
}
else if( val > 9 )
{  System.out.println( "Test B" );
}
else System.out.println( "Test C" );

Which values of val will result in "Test C" being printed:

a) val < 0
b) val between 0 and 4
c) val between 4 and 9
d) val > 9
e) val = 0
f) no values for val will be satisfactory

28. What exception might a wait() method throw?




29. For the code:


m = 0;
while( m++ < 2 )
System.out.println( m );

Which of the following are printed to standard output?

a) 0
b) 1
c) 2
d) 3
e) Nothing and an exception is thrown


30. Consider the code fragment below:


outer: for( int i = 1; i <3; i++ )
{  inner: for( j = 1; j < 3; j++ )
{  if( j==2 )
continue outer;
System.out.println( "i = " +i ", j = " + j );
}
}

Which of the following would be printed to standard output?

a) i = 1, j = 1
b) i = 1, j = 2
c) i = 1, j = 3
d) i = 2, j = 1
e) i = 2, j = 2
f) i = 2, j = 3
g) i = 3, j = 1
h) i = 3, j = 2


31. Consider the code below:

void myMethod()
{  try
{  
fragile();
}
catch( NullPointerException npex )
{  
System.out.println( "NullPointerException thrown " );
}
catch( Exception ex )
{  
System.out.println( "Exception thrown " );
}
finally
{  
System.out.println( "Done with exceptions " );
}
System.out.println( "myMethod is done" );
}
What is printed to standard output if fragile() throws an IllegalArgumentException?

a) "NullPointerException thrown"
b) "Exception thrown"
c) "Done with exceptions"
d) "myMethod is done"
e) Nothing is printed


32. Consider the following code sample:

class Tree{}
class Pine extends Tree{}
class Oak extends Tree{}
public class Forest
{  public static void main( String[] args )
{  Tree tree = new Pine();

      if( tree instanceof Pine )
      System.out.println( "Pine" );

      if( tree instanceof Tree )
      System.out.println( "Tree" );

      if( tree instanceof Oak )
      System.out.println( "Oak" );

      else System.out.println( "Oops" );
}
}

Select all choices that will be printed:

a) Pine
b) Tree
c) Forest
d) Oops
e) (nothing printed)

33. Consider the classes defined below:

import java.io.*;
class Super
{
int methodOne( int a, long b ) throws IOException
{ // code that performs some calculations
}
float methodTwo( char a, int b )
{ // code that performs other calculations
}
}
public class Sub extends Super
{

}
Which of the following are legal method declarations to add to the class Sub? Assume that each method is the only one being added.

a) public static void main( String args[] ){}
b) float methodTwo(){}
c) long methodOne( int c, long d ){}
d) int methodOne( int c, long d ) throws ArithmeticException{}
e) int methodOne( int c, long d ) throws FileNotFoundException{}


34. Assume that Sub1 and Sub2 are both subclasses of class Super.

Given the declarations:

Super super = new Super();
Sub1 sub1 = new Sub1();
Sub2 sub2 = new Sub2();

Which statement best describes the result of attempting to compile and execute the following statement:

super = sub1;

a) Compiles and definitely legal at runtime
b) Does not compile
c) Compiles and may be illegal at runtime


35. For the following code:

class Super
{  int index = 5;
public void printVal()
{  System.out.println( "Super" );
}
}
class Sub extends Super
{  int index = 2;
public void printVal()
{  System.out.println( "Sub" );
}
}
public class Runner
{  public static void main( String argv[] )
{  Super sup = new Sub();
System.out.print( sup.index + "," );
sup.printVal();
}
}
What will be printed to standard output?

a) The code will not compile.
b) The code compiles and "5, Super" is printed to standard output.
c) The code compiles and "5, Sub" is printed to standard output.
d) The code compiles and "2, Super" is printed to standard output.
e) The code compiles and "2, Sub" is printed to standard output.
f) The code compiles, but throws an exception.


36. How many objects are eligible for garbage collection once execution has reached the line labeled Line A?

String name;
String newName = "Nick";
newName = "Jason";
name = "Frieda";

String newestName = name;

name = null;
//Line A

a) 0
b) 1
c) 2
d) 3
e) 4


37. Which of the following statements about Java's garbage collection are true?

a) The garbage collector can be invoked explicitly using a Runtime object.
b) The finalize method is always called before an object is garbage collected.
c) Any class that includes a finalize method should invoke its superclass' finalize method.
d) Garbage collection behavior is very predictable.


38. What line of code would begin execution of a thread named myThread?




39. Which methods are required to implement the interface Runnable.

a) wait()
b) run()
c) stop()
d) update()
e) resume()


40. What class defines the wait() method?




41. For what reasons might a thread stop execution?

a) A thread with higher priority began execution.
b) The thread's wait() method was invoked.
c) The thread invoked its yield() method.
d) The thread's pause() method was invoked.
e) The thread's sleep() method was invoked.


42. Which method below can change a String object, s ?

a) equals( s )
b) substring( s )
c) concat( s )
d) toUpperCase( s )
e) none of the above will change s


43. If s1 is declared as:

String s1 = "phenobarbital";

What will be the value of s2 after the following line of code:

String s2 = s1.substring( 3, 5 );


a) null
b) "eno"
c) "enoba"
d) "no"


44. What method(s) from the java.lang.Math class might method() be if the statement

method( -4.4 ) == -4;

is true.

a) round()
b) min()
c) trunc()
d) abs()
e) floor()
f) ceil()


45. Which methods does java.lang.Math include for trigonometric computations?

a) sin()
b) cos()
c) tan()
d) aSin()
e) aCos()
f) aTan()
g) toDegree()


46. This piece of code:

TextArea ta = new TextArea( 10, 3 );

Produces (select all correct statements):

a) a TextArea with 10 rows and up to 3 columns
b) a TextArea with a variable number of columns not less than 10 and 3 rows
c) a TextArea that may not contain more than 30 characters
d) a TextArea that can be edited


47. In the list below, which subclass(es) of Component cannot be directly instantiated:

a) Panel
b) Dialog
c) Container
d) Frame


48. Of the five Component methods listed below, only one is also a method of the class MenuItem. Which one?

a) setVisible( boolean b )
b) setEnabled( boolean b )
c) getSize()
d) setForeground( Color c )
e) setBackground( Color c )


49. If a font with variable width is used to construct the string text for a column, the initial size of the column is:

a) determined by the number of characters in the string, multiplied by the width of a character in this font
b) determined by the number of characters in the string, multiplied by the average width of a character in this font
c) exclusively determined by the number of characters in the string
d) undetermined


50. Which of the following methods from the java.awt.Graphics class would be used to draw the outline of a rectangle with a single method call?

a) fillRect()
b) drawRect()
c) fillPolygon()
d) drawPolygon()
e) drawLine()


51. The Container methods add( Component comp ) and add( String name, Component comp ) will throw an IllegalArgumentException if comp is a:

a) button
b) list
c) window
d) textarea
e) container that contains this container


52. Of the following AWT classes, which one(s) are responsible for implementing the components layout?

a) LayoutManager
b) GridBagLayout
c) ActionListener
d) WindowAdapter
e) FlowLayout


53. A component that should resize vertically but not horizontally should be placed in a:

a) BorderLayout in the North or South location
b) FlowLayout as the first component
c) BorderLayout in the East or West location
d) BorderLayout in the Center location
e) GridLayout


54. What type of object is the parameter for all methods of the MouseListener interface?




55. Which of the following statements about event handling in JDK 1.1 and later are true?

a) A class can implement multiple listener interfaces
b) If a class implements a listener interface, it only has to overload the methods it uses
c) All of the MouseMotionAdapter class methods have a void return type.


56. Which of the following describe the sequence of method calls that result in a component being redrawn?

a) invoke paint() directly
b) invoke update which calls paint()
c) invoke repaint() which invokes update(), which in turn invokes paint()
d) invoke repaint() which invokes paint directly


57. Choose all valid forms of the argument list for the FileOutputStream constructor shown below:

a) FileOutputStream( FileDescriptor fd )
b) FileOutputStream( String n, boolean a )
c) FileOutputStream( boolean a )
d) FileOutputStream()
e) FileOutputStream( File f )


58. A "mode" argument such as "r" or "rw" is required in the constructor for the class(es):

a) DataInputStream
b) InputStream
c) RandomAccessFile
d) File
e) None of the above


59. A directory can be created using a method from the class(es):

a) File
b) DataOutput
c) Directory
d) FileDescriptor
e) FileOutputStream


60. If raf is a RandomAccessFile, what is the result of compiling and executing the following code?

raf.seek( raf.length() );

a) The code will not compile.
b) An IOException will be thrown.
c) The file pointer will be positioned immediately before the last character of the file.
d) The file pointer will be positioned immediately after the last character of the file.







Answers to MindQ's Sun Certified Java
Programmer Practice Test


--------------------------------------------------------------------------------

# Answer(s) MindQ Reference
1  c Getting Started
2  c Getting Started
3  b, e Getting Started
4  c Nuts and Bolts
5  a Nuts and Bolts
6  a, b, c, e Nuts and Bolts
7  0x6, 0X6, 0x06, 0X06 Nuts and Bolts
8  a, d Nuts and Bolts
9  b Nuts and Bolts
10  a Nuts and Bolts
11  f Key Java Classes
12  d Key Java Classes
13  d Nuts and Bolts
14  b, e Nuts and Bolts
15  c Getting Started
16  a, d Nuts and Bolts
17  d Nuts and Bolts
18  e Nuts and Bolts
19  e Nuts and Bolts
20  c Nuts and Bolts
21  b, c Nuts and Bolts
22  final Object Oriented Java
23  private Object Oriented Java
24  b Object Oriented Java
25  c, d, e, g Nuts and Bolts
26  a, b Nuts and Bolts
27  a, b, e Nuts and Bolts
28  InterruptedException Key Java Classes
29  b, c Nuts and Bolts
30  a, d Nuts and Bolts
31  b, c, d Key Java Classes
32  a, b, d Object Oriented Java
33  a, b, e Object Oriented Java
34  a Object Oriented Java
35  c Object Oriented Java
36  b Nuts and Bolts
37  a, b, c Nuts and Bolts
38  myThread.start(); Key Java Classes
39  b Key Java Classes
40  Object Key Java Classes
41  a, b, c, e Key Java Classes
42  e Key Java Classes
43  d Key Java Classes
44  a, f Key Java Classes
45  a, b, c Key Java Classes
46  a, d AWT
47  c AWT
48  b AWT
49  b AWT
50  b, d AWT
51  c, e AWT
52  b, e AWT
53  c AWT
54  MouseEvent AWT
55  a, c AWT
56  c AWT
57  a, b, e Key Java Classes
58  c Key Java Classes
59  a Key Java Classes
60  d Key Java Classes


--------------------------------------------------------------------------------





# Author

---

* [Rohtash Lakra](https://github.com/rslakra)
