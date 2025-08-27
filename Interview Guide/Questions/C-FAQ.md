# Java Interview Questions

---

1. Virtual Functions

A virtual function allows derived classes to replace the implementation provided by the base class. The compiler makes sure the replacement is always called whenever the object in question is actually of the derived class, even if the object is accessed by a base pointer rather than a derived pointer. This allows algorithms in the base class to be replaced in the derived class, even if users don't know about the derived class.

The derived class can either fully replace ("override") the base class member function, or the derived class can partially replace ("augment") the base class member function. The latter is accomplished by having the derived class member function call the base class member function, if desired.

---

2. Virtual Destructor


Virtual distructor is essential if you implement inheritance. It's used in base class. It guarantees that for all classes derived from the base class all destructors will be called (in proper order). It allows polymorphic behavior. 
Take a look at the snippet below:
```text
#include "stdio.h"

class BaseClass
{
int id;
public:
BaseClass() { printf("BaseClass()\n"); }
virtual ~BaseClass() { printf("~BaseClass()\n"); } //    !!!
};

class Class1 : public BaseClass
{
int id;
public:
Class1() { printf("Class1()\n"); }
~Class1() {	printf("~Class1()\n"); }
};

class Class2 : public Class1
{
    int id;
    
    public:
        Class2() { 
            printf("Class2()\n");
        }
        
        ~Class2() { 
            printf("~Class2()\n"); 
        }
};


int main(int argc, char* argv[])
{
    BaseClass *p = new Class2;
    delete p;

	return 0;
}
```

Output for the case without virtual destructor is:
```text
BaseClass()
Class1()
Class2()
~BaseClass()
```

Output for the case with virtual destructor is:
```text
BaseClass()
Class1()
Class2()
~Class2()
~Class1()
~BaseClass()
```

You see what can happen if destructor should call delete for some object/array used in the class?
Resume: use virtual destructor to ensure proper memory clearing in case of inheritance.

---

3. Virtual Inheritance


Just below the top of the diamond, not at the join-class.

To avoid the duplicated base class subobject that occurs with the "dreaded diamond", you should use the virtual keyword in the inheritance part of the classes that derive directly from the top of the diamond:

```text

class Base {
public:
...
protected:
int data_;
};

class Der1 : public virtual Base {
public:             ^^^^^^^—this is the key
...
};

class Der2 : public virtual Base {
public:             ^^^^^^^—this is the key
...
};

class Join : public Der1, public Der2 {
public:
void method()
{
data_ = 1;  ← good: this is now unambiguous
}
};

int main()
{
Join* j = new Join();
Base* b = j;   ← good: this is now unambiguous
}
```

Because of the virtual keyword in the base-class portion of Der1 and Der2, an instance of Join will have have only a single Base subobject. This eliminates the ambiguities. This is usually better than using full qualification as described in the previous FAQ.

For emphasis, the virtual keyword goes in the hierarchy above Der1 and Der2. It doesn't help to put the virtual keyword in the Join class itself. In other words, you have to know that a join class will exist when you are creating class Der1 and Der2.

```text
                          Base
                          /  \
                         /    \
                virtual /      \ virtual
                     Der1      Der2
                        \      /
                         \    /
                          \  /
                          Join 
```

--------------------------------------------------------------------
what is the exact order of constructors in a multiple and/or virtual inheritance situation?

The very first constructors to be executed are the virtual base classes anywhere in the hierarchy. They are executed in the order they appear in a depth-first left-to-right traversal of the graph of base classes, where left to right refer to the order of appearance of base class names.

After all virtual base class constructors are finished, the construction order is generally from base class to derived class. The details are easiest to understand if you imagine that the very first thing done in the derived class's ctor is to call the base class's ctor (hint: that's the way most compilers actually do it). So if class D inherits multiply from B1 and B2, the constructor for B1 executes first, then the constructor for B2, then the constructor for D. This rule is applied recursively; for example, if B1 inherits from B1a and B1b, and B2 inherits from B2a and B2b, then the final order is B1a, B1b, B1, B2a, B2b, B2, D.

Note that the order B1 and then B2 (or B1a then B1b) is determined by the order that the base classes appear in the declaration of the class, not in the order that the initializer appears in the derived class's initialization list

--------------------------------------------------------------------
4. V-Table


--------------------------------------------------------------------
5. Singleton Class and How to Make the Implementation

A Single object of the Class is instantiated.

// Test whether N::operator new is different from ::operator new
#include <new>
#include <cstdlib>

bool success;

namespace N{
void* operator new(size_t n){
success = true;
return std::malloc(n);
}
}

void *operator new(size_t n)throw(std::bad_alloc)
{
static bool entered = false;
if(entered)
throw std::bad_alloc();
entered = true;
void *result = N::operator new(n);
entered = false;
return result;
}

int main()
{
try{
new int;
}catch(...){
return 1;
}
return success?0:1;
}



include <iostream>

using namespace std;

class Singleton
{
private:
static bool instanceFlag;
static Singleton *single;
Singleton()
{
//private constructor
}
public:
static Singleton* getInstance();
void method();
~Singleton()
{
instanceFlag = false;
}
};

bool Singleton::instanceFlag = false;
Singleton* Singleton::single = NULL;
Singleton* Singleton::getInstance()
{
if(! instanceFlag)
{
single = new Singleton();
instanceFlag = true;
return single;
}
else
{
return single;
}
}

void Singleton::method()
{
cout << "Method of the singleton class" << endl;
}

int main()
{
Singleton *sc1,*sc2;
sc1 = Singleton::getInstance();
sc1->method();
sc2 = Singleton::getInstance();
sc2->method();

    return 0;
}
--------------------------------------------------------------------
6. Static Member Function.

   A Static Member Function is one which is called before creation of an Object or After Deleting an Object. By Default the Operator New and Delete Overloading are taken as Static by the Compiler.

Refer Singleton Class Example.
  
--------------------------------------------------------------------
7. Passing by Reference

An alias (an alternate name) for an object.

References are frequently used for pass-by-reference:


void swap(int& i, int& j)
{
int tmp = i;
i = j;
j = tmp;
}

int main()
{
int x, y;
...
swap(x,y);
...
}
Here i and j are aliases for main's x and y respectively. In other words, i is x — not a pointer to x, nor a copy of x, but x itself. Anything you do to i gets done to x, and vice versa.

OK. That's how you should think of references as a programmer. Now, at the risk of confusing you by giving you a different perspective, here's how references are implemented. Underneath it all, a reference i to object x is typically the machine address of the object x. But when the programmer says i++, the compiler generates code that increments x. In particular, the address bits that the compiler uses to find x are not changed. A C programmer will think of this as if you used the C style pass-by-pointer, with the syntactic variant of (1) moving the & from the caller into the callee, and (2) eliminating the *s. In other words, a C programmer will think of i as a macro for (*p), where p is a pointer to x (e.g., the compiler automatically dereferences the underlying pointer; i++ is changed to (*p)++; i = 7 is automatically changed to *p = 7).

Important note: Even though a reference is often implemented using an address in the underlying assembly language, please do not think of a reference as a funny looking pointer to an object. A reference is the object. It is not a pointer to the object, nor a copy of the object. It is the object.

--------------------------------------------------------------------

8. Operator Overloading preferably Binary + Operator.

    
--------------------------------------------------------------------
9. List of Operators which are all not to be overloaded

Most can be overloaded. The only C operators that can't be are . and ?: (and sizeof, which is technically an operator). C++ adds a few of its own operators, most of which can be overloaded except :: and .*.

Here's an example of the subscript operator (it returns a reference). First without operator overloading:


class Array {
public:
int& elem(unsigned i)        { if (i > 99) error(); return data[i]; }
private:
int data[100];
};

int main()
{
Array a;
a.elem(10) = 42;
a.elem(12) += a.elem(13);
...
}
Now the same logic is presented with operator overloading:


class Array {
public:
int& operator[] (unsigned i) { if (i > 99) error(); return data[i]; }
private:
int data[100];
};

int main()
{
Array a;
a[10] = 42;
a[12] += a[13];
...
}
   	
--------------------------------------------------------------------
10. Operator New Overloading


Pooled Memory Allocation
~~~~~~~~~~~~~~~~~~~~~~~~

Most large C++ programs make use of dynamically allocated memory. This is especially true of EDA applications (simulators and tools for VLSI chip design), where the designer can never safely set an upper limit on application size. In many cases large amounts of dynamically allocated memory is consumed by interconnected objects which are not themselves very large. The time consumed allocating objects can be minimized, but is unavoidable. A significant amount of processing time can also be consumed traversing the dynamic data structures and returning them to the system using the default C++ delete function. Time consuming memory recovery can be avoided by using a pool based memory allocator. 

A pool based memory allocator allocates large blocks of memory and then allocates smaller objects from these blocks. When it is time to recover memory, the entire pool is deallocated at once. This usually involves returning only a few large memory blocks to the system. This greatly reduces the time consumed by memory recovery. 

Object Allocation and Initialization 
If a C++ object is allocated from a memory pool, its constructor will not be called by default. This can sometimes be handled by initializing the object with an explicit call to the constructor. For example: 


  my_class *pMyClass;

  pMyClass = (my_class *)pool.GetMem( sizeof( my_class ) );
  *pMyClass = my_class();  // invoke the constructor

This approach has several problems. The constructor invokation above creates a temporary instance of the class my_class. This class is then copied into the memory pointed to by pMyClass. After the class is copied, the destructor for my_class will be called. If memory allocation takes place in the constructor and deallocation takes place in the destructor, there can be a problem. For example, if the class pointed to by pMyClass is initialized with a pointer the memory allocated by the my_class constructor, this same memory will be deallocated by the destructor. When the assignment completes, the class pointed to by pMyClass will point to deallocated memory, which is not what the programmer intended. 

The problem above can be handled by adding init and dealloc class functions which can be called explicitly to allocate memory. The init function can be called after the class constructor copy. 

  my_class *pMyClass;

  pMyClass = (my_class *)pool.GetMem( sizeof( my_class ) );
  *pMyClass = my_class();  // invoke the constructor

  pMyClass->init();  // allocateion memory

Unfortunately, the scheme outlined above is totally inadequate if the class have virtual functions. The class constructor will not initialize the virtual function table with the appropriate function addresses. 

Overloading New 
~~~~~~~~~~~~~~~

Since at least 1993 C++ has defined a way to overload the new operator for a given class. By providing an overloaded verion of new for a class (e.g., my_class above), there will be a simple and natural way to allocate an object from a memory pool and initialize it properly. The overloaded new function allocates memory from the memory pool and the C++ compiler generates code to initialize the virtual function table and to invoke the class constructor. 

The C++ code below has a base class (cleverly named base) and a derived class base_one. The base class has an overloaded version of new, which takes two arguments: the number of bytes to allocate and a pointer to a memory pool allocation object. The compiler automatically plugs in the type size (the first argument to the overloaded new). The call to new then takes the form 

    pClass = new( user args ) type

which is expanded into a call to the overloaded new function 

    void *operator new( type size, user args );

For more details see section 5.3.3 of the ANSI C++ standard. 


class base {
public:
    base() { }

    void *operator new( unsigned int num_bytes, pool *mem)
    {
	return mem->GetMem( num_bytes);
    }

    virtual void pr(void) = 0;
};


class base_one : public base {
private:
    int a;
public:
    base_one() {}

    void pr(void) 
    {
       // local print
    }
};


main()
{
    base *pB1;
    pool mem;

    pB1 = new( &mem ) base_one;
    pB1->pr();
}


In this example there is a memory allocation type pool. This is passed as an argument to new, which uses the GetMem class function to allocate memory. 

A complete test case, demonstrating overloading of the new operator to allocate a class with virtual functions is shown here. 

Portability Issues 
The complexity of C++ and the obscurity of the language standard in some areas takes the problems encountered in portability to new levels. 

With older compilers from HP and IBM, use of the "positional new", where the operator new is passed a memory pool argument, as shown above, requires an overloaded version of the default new as well. Note that this is not required by Solaris C++ or current releases of HP or IBM C++. In the code shown below, the first function overloads the default version of operator new. Since this class will allocate memory from a pool, this version should never be used and contains an assert. The second version of the new operator allocates memory from the memory pool. 


#ifdef _BRAIN_DAMAGED_IBM_
    // IBM requires that the operator new size argument be unsigned long
    void *operator new( unsigned long num_bytes )
#else
    void *operator new( unsigned int num_bytes )
#endif
    {
	assert( FALSE );
	return NULL;
    }

#ifdef _BRAIN_DAMAGED_IBM_
    void *operator new( unsigned long num_bytes, pool *mem )
#else
    void *operator new( unsigned int num_bytes, pool *mem )
#endif
    {
	return mem->GetMem( num_bytes );
    } // operator new

    // There is no delete, since memory is recovered through
    // deallocation of the memory pool      
    void operator delete( void * ) { /* do nothing */ } 


Detailed Example
~~~~~~~~~~~~~~~~

/*

   This is a test for the overloaded "new" operator.
   This is described in section 5.3.3 of the ANSI
   C++ standard.  This test compiles under Sun Solaris
   and on Windows NT with the Visual C++ 4.1 compiler.

   When executed, this test should print:   

      constructor for base_one called
      constructor for base_two called
      constructor for base_three called
      constructor for base_four called
      one
      kind = one
      a = 1
      two
      kind = two
      a = 2, b = 3
      three
      kind = three
      a = 4, b = 5, c = 6
      four
      kind = four
      a = 7, b = 8, c = 9, d = 10


 */


#include <string.h>
#include <stdlib.h>
#include <stdio.h>


class pool {
public:
    void *GetMem( unsigned int num_bytes )
    {
        return malloc( num_bytes );
    }
};


enum { bad_sub,
       one,
       two,
       three,
       four };

class base {
public:
    unsigned int kind;

    base( unsigned int k) { kind = k; }

    void pr_kind()
    {
        printf("kind = ");
        switch ( kind ) {
        case one:
            printf("one\n");
            break;
        case two:
            printf("two\n");
            break;
        case three:
            printf("three\n");
            break;
        case four:
            printf("four\n");
            break;
        default:
            printf("bad_sub\n");
        }
    }


    void *operator new( unsigned int num_bytes, pool *mem)
    {
        
        return mem->GetMem( num_bytes);
    }

    virtual void pr(void) = 0;
};


class base_one : public base {
private:
    int a;
public:
    base_one( unsigned int k = bad_sub ) : base( k ) 
    {
        printf("constructor for base_one called\n");
        a = 1;
    }
    ~base_one(void)
    {
        printf("destructor for base_one called\n");
    }
    void pr(void) 
    {
        printf("one\n");
        pr_kind();
        printf("a = %d\n", a );
    }
};

class base_two : public base {
private:
    int a, b;
public:
    base_two( unsigned int k  = bad_sub ) : base( k ) 
    {
        printf("constructor for base_two called\n");
        a = 2;
        b = 3;
    }
    ~base_two(void)
    {
        printf("destructor for base_two called\n");
    }
    void pr(void) 
    {
        printf("two\n");
        pr_kind();
        printf("a = %d, b = %d\n", a, b );
    }
};

class base_three : public base {
private:
    int a, b, c;
public:
    base_three( unsigned int k  = bad_sub ) : base( k ) 
    {
        printf("constructor for base_three called\n");
        a = 4;
        b = 5;
        c = 6;
    }
    ~base_three(void)
    {
        printf("destructor for base_three called\n");
    }
    void pr(void) 
    {
        printf("three\n");
        pr_kind();
        printf("a = %d, b = %d, c = %d\n", a, b, c );
    }
};

class base_four : public base {
private:
    int a, b, c, d;
public:
    base_four( unsigned int k  = bad_sub ) : base( k ) 
    {
        printf("constructor for base_four called\n");
        a = 7;
        b = 8;
        c = 9;
        d = 10;
    }
    ~base_four(void)
    {
        printf("destructor for base_four called\n");
    }
    void pr(void) 
    {
        printf("four\n");
        pr_kind();
        printf("a = %d, b = %d, c = %d, d = %d\n", a, b, c, d );
    }
};



main()
{
    base *pB1;
    base *pB2;
    base *pB3;
    base *pB4;
    pool mem;

    pB1 = new( &mem ) base_one( one );
    pB2 = new( &mem ) base_two( two );
    pB3 = new( &mem ) base_three( three );
    pB4 = new( &mem ) base_four( four );

    pB1->pr();
    pB2->pr();
    pB3->pr();
    pB4->pr();

}

--------------------------------------------------------------------
11. SetNewHandler and _PNH structure.

In some circumstances, corrective action can be taken during memory allocation and the request can be fulfilled. To gain control when the global operator new function fails, use the _set_new_handler function (defined in NEW.H) as follows:

#include <stdio.h>
#include <new.h>

// Define a function to be called if new fails to allocate memory.
int MyNewHandler( size_t size )
{
    clog << "Allocation failed. Coalescing heap." << endl;

    // Call a fictitious function to recover some heap space.
    return CoalesceHeap();
}

void main()
{
    // Set the failure handler for new to be MyNewHandler.
    _set_new_handler( MyNewHandler );

    int *pi = new int[BIG_NUMBER];
}

In the preceding example, the first statement in main sets the new handler to MyNewHandler. The second statement tries to allocate a large block of memory using the new operator. When the allocation fails, control is transferred to MyNewHandler. The argument passed to MyNewHandler is the number of bytes requested. The value returned from MyNewHandler is a flag indicating whether allocation should be retried: a nonzero value indicates that allocation should be retried, and a zero value indicates that allocation has failed.

MyNewHandler prints a warning message and takes corrective action. If MyNewHandler returns a nonzero value, the new operator retries the allocation. When MyNewHandler returns a 0 the new operator stops trying and returns a zero value to the program.

The _set_new_handler function returns the address of the previous new handler. Therefore, if a new handler needs to be installed for a short time, the previous new handler can be reinstalled using code such as the following:

#include <new.h>

...

_PNH old_handler = _set_new_handler( MyNewHandler );

// Code that requires MyNewHandler.
...

// Reinstall previous new handler.
_set_new_handler( old_handler );

A call to _set_new_handler with an argument of 0 causes the new handler to be removed. There is no default new handler.

The new handler you specify can have any name, but it must be a function returning type int (nonzero indicates the new handler succeeded, and zero indicates that it failed).

If a user-defined operator new is provided, the new handler functions are not automatically called on failure.

The prototype for _set_new_handler and the type _PNH is defined in NEW.H:

_PNH _set_new_handler( _PNH );

The type _PNH is a pointer to a function that returns type int and takes a single argument of type size_t.

--------------------------------------------------------------------
12. What is Namespace

namespace [identifier] { namespace-body }

A namespace declaration identifies and assigns a name to a declarative region.

The identifier in a namespace declaration must be unique in the declarative region in which it is used. The identifier is the name of the namespace and is used to reference its members.

The declarative region of a namespace declaration is its namespace-body.

--------------------------------------------------------------------
13. Class Inheritance using Private, Public and Protected modes.

    ----------------------------------------------------
                       		Member State 
    ----------------------------------------------------
    Inheritance		Private    Public     Protected
	Mode			   (becomes)  (becomes)
    ----------------------------------------------------	
    Private		N.A	   Private    Private	
 
    Public		N.A        Public     Protected

    Protected   	N.A        Protected  Protected
--------------------------------------------------------------------
14. Abstract base Class

At the design level, an abstract base class (ABC) corresponds to an abstract concept. If you asked a mechanic if he repaired vehicles, he'd probably wonder what kind-of vehicle you had in mind. Chances are he doesn't repair space shuttles, ocean liners, bicycles, or nuclear submarines. The problem is that the term "vehicle" is an abstract concept (e.g., you can't build a "vehicle" unless you know what kind of vehicle to build). In C++, class Vehicle would be an ABC, with Bicycle, SpaceShuttle, etc, being derived classes (an OceanLiner is-a-kind-of-a Vehicle). In real-world OO, ABCs show up all over the place. 

At the programming language level, an ABC is a class that has one or more pure virtual member functions. You cannot make an object (instance) of an ABC. 

--------------------------------------------------------------------
15. Pure virtual function

A member function declaration that turns a normal class into an abstract class (i.e., an ABC). You normally only implement it in a derived class. 

Some member functions exist in concept; they don't have any reasonable definition. E.g., suppose I asked you to draw a Shape at location (x,y) that has size 7. You'd ask me "what kind of shape should I draw?" (circles, squares, hexagons, etc, are drawn differently). In C++, we must indicate the existence of the draw() member function (so users can call it when they have a Shape* or a Shape&), but we recognize it can (logically) be defined only in derived classes: 


 class Shape {
 public:
   virtual void draw() const = 0;  // = 0 means it is "pure virtual"
   ...
 }; 

This pure virtual function makes Shape an ABC. If you want, you can think of the "= 0;" syntax as if the code were at the NULL pointer. Thus Shape promises a service to its users, yet Shape isn't able to provide any code to fulfill that promise. This forces any actual object created from a [concrete] class derived from Shape to have the indicated member function, even though the base class doesn't have enough information to actually define it yet. 

Note that it is possible to provide a definition for a pure virtual function, but this usually confuses novices and is best avoided until later

--------------------------------------------------------------------
16. Friend Functions

Friend functions are not considered class members; they are normal external functions that are given special access privileges. Friends are not in the class’s scope, and they are not called using the member-selection operators (. and –>) unless they are members of another class. The following example shows a Point class and an overloaded operator, operator+. (This example primarily illustrates friends, not overloaded operators. For more information about overloaded operators, see Overloaded Operators in Chapter 12.)

#include <iostream.h>

// Declare class Point.
class Point
{
public:
    // Constructors
    Point() { _x = _y = 0; }
    Point( unsigned x, unsigned y ) { _x = x; _y = y; }
    // Accessors
    unsigned x() { return _x; }
    unsigned y() { return _y; }
    void     Print() { cout << "Point(" << _x << ", " << _y << ")"
                            << endl; }

    // Friend function declarations
    friend Point operator+( Point& pt, int nOffset );
    friend Point operator+( int nOffset, Point& pt );

private:
    unsigned _x;
    unsigned _y;
};

// Friend-function definitions
//
// Handle Point + int expression.
Point operator+( Point& pt, int nOffset )
{
    Point ptTemp = pt;
    // Change private members _x and _y directly.
    ptTemp._x += nOffset;
    ptTemp._y += nOffset;

    return ptTemp;
}

// Handle int + Point expression.
Point operator+( int nOffset, Point& pt )
{
    Point ptTemp = pt;
    // Change private members _x and _y directly.
    ptTemp._x += nOffset;
    ptTemp._y += nOffset;

    return ptTemp;
}

// Test overloaded operator.
void main()
{
    Point pt( 10, 20 );
    pt.Print();

    pt = pt + 3;     // Point + int
    pt.Print();

    pt = 3 + pt;     // int + Point
    pt.Print();
}

When the expression pt + 3 is encountered in the main function, the compiler determines whether an appropriate user-defined operator+ exists. In this case, the function operator+( Point pt, int nOffset ) matches the operands, and a call to the function is issued. In the second case (the expression 3 + pt), the function operator+( Point pt, int nOffset ) matches the supplied operands. Therefore,  supplying these two forms of operator+ preserves the commutative properties of the + operator.

A user-defined operator+ can be written as a member function, but it takes only one explicit argument: the value to be added to the object. As a result, the commutative properties of addition cannot be correctly implemented with member functions; they must use friend functions instead.

Notice that both versions of the overloaded operator+ function are declared as friends in class Point. Both declarations are necessary — when friend declarations name overloaded functions or operators, only the particular functions specified by the argument types become friends. Suppose a third operator+ function were declared as follows:

Point &operator+( Point &pt, Point &pt );

The operator+ function in the preceding example is not a friend of class Point, simply because it has the same name as two other functions that are declared as friends.

Because friend declarations are unaffected by access specifiers, they can be declared in any section of the class declaration.

--------------------------------------------------------------------
17. Friend Classes

--------------------------------------------------------------------
18. Difference between a Structure and a Class.

The members and base classes of a struct are public by default, while in class, they default to private. Note: you should make your base classes explicitly public, private, or protected, rather than relying on the defaults. 

struct and class are otherwise functionally equivalent. 

OK, enough of that squeaky clean techno talk. Emotionally, most developers make a strong distinction between a class and a struct. A struct simply feels like an open pile of bits with very little in the way of encapsulation or functionality. A class feels like a living and responsible member of society with intelligent services, a strong encapsulation barrier, and a well defined interface. Since that's the connotation most people already have, you should probably use the struct keyword if you have a class that has very few methods and has public data (such things do exist in well designed systems!), but otherwise you should probably use the class keyword. 
   

--------------------------------------------------------------------
19. Difference between inline functions and preprocessor Macros (#Define)


Unlike #define macros, inline functions avoid infamous macro errors since inline functions 	always evaluate every argument exactly once. In other words, invoking an inline function is 	semantically just like invoking a regular function, only faster: 


 // A macro that returns the absolute value of i

 #define unsafe(i)  \
         ( (i) >= 0 ? (i) : -(i) )
 
 // An inline function that returns the absolute value of i
 inline
 int safe(int i)
 {
   return i >= 0 ? i : -i;
 }
 
 int f();
 
 void userCode(int x)
 {
   int ans;
 
   ans = unsafe(x++);   // Error! x is incremented twice
   ans = unsafe(f());   // Danger! f() is called twice
 
   ans = safe(x++);     // Correct! x is incremented once
   ans = safe(f());     // Correct! f() is called once
 } 

Also unlike macros, argument types are checked, and necessary conversions are performed correctly. 

--------------------------------------------------------------------
20.Is there another way to tell the compiler to make a member function inline instead of stating the inline key word?


define the member function in the class body itself: 

 class Fred {
 public:
   void f(int i, char c)
     {
       ...
     }
 }; 

Although this is easier on the person who writes the class, it's harder on all the readers since it mixes "what" a class does with "how" it does them. Because of this mixture, we normally prefer to define member functions outside the class body with the inline keyword. The insight that makes sense of this: in a reuse-oriented world, there will usually be many people who use your class, but there is only one person who builds it (yourself); therefore you should do things that favor the many rather than the few
--------------------------------------------------------------------

21. Can we Delete a memory allocated by malloc or Is it possible to free a memory allocated by new.

No! 

It is perfectly legal, moral, and wholesome to use malloc() and delete in the same program, or to use new and free() in the same program. But it is illegal, immoral, and despicable to call free() with a pointer allocated via new, or to call delete on a pointer allocated via malloc(). 

Beware! I occasionally get e-mail from people telling me that it works OK for them on machine X and compiler Y. Just because they don't see bad symptoms in a simple test case doesn't mean it won't crash in the field. Even if they know it won't crash on their particular compiler doesn't mean it will work safely on another compiler, another platform, or even another version of the same compiler. 

Beware! Sometimes people say, "But I'm just working with an array of char." Nonetheless do not mix malloc() and delete on the same pointer, or new and free() on the same pointer! If you allocated via p = new char[n], you must use delete[] p; you must not use free(p). Or if you allocated via p = malloc(n), you must use free(p); you must not use delete[] p or delete p! Mixing these up could cause a catastrophic failure at runtime if the code was ported to a new machine, a new compiler, or even a new version of the same compiler. 

You have been warned. 

--------------------------------------------------------------------

22. Difference between New and Malloc


Constructors/destructors, type safety, overridability. 

Constructors/destructors: unlike malloc(sizeof(Fred)), new Fred() calls Fred's constructor. Similarly, delete p calls *p's destructor. 
Type safety: malloc() returns a void* which isn't type safe. new Fred() returns a pointer of the right type (a Fred*). 
Overridability: new is an operator that can be overridden by a class, while malloc() is not overridable on a per-class basis. 

--------------------------------------------------------------------
23.Is there any difference between List x; and List x();?


A big difference! 

Suppose that List is the name of some class. Then function f() declares a local List object called 
x: 

 void f()
 {
   List x;     // Local object named x (of class List)
   ...
 } 

But function g() declares a function called x() that returns a List: 


 void g()
 {
   List x();   // Function named x (that returns a List)
   ...
 } 

--------------------------------------------------------------------

24.Can one constructor of a class call another constructor of the same class to initialize the this object?

No. 

Let's work an example. Suppose you want your constructor Foo::Foo(char) to call another constructor of the same class, say Foo::Foo(char,int), in order that Foo::Foo(char,int) would help initialize the this object. Unfortunately there's no way to do this in C++. 

Some people do it anyway. Unfortunately it doesn't do what they want. For example, the line Foo(x, 0); does not call Foo::Foo(char,int) on the this object. Instead it calls Foo::Foo(char,int) to initialize a temporary, local object (not this), then it immediately destructs that temporary when control flows over the ;. 

 class Foo {
 public:
   Foo(char x);
   Foo(char x, int y);
   ...
 };
 
 Foo::Foo(char x)
 {
   ...
   Foo(x, 0);  // this line does NOT help initialize the this object!!
   ...
 } 

You can sometimes combine two constructors is via a default parameter: 

 class Foo {
 public:
   Foo(char x, int y=0);  // this line combines the two constructors
   ...
 }; 

If that doesn't work, e.g., if there isn't an appropriate default parameter that combines the two constructors, sometimes you can share their common code in a private init() member function: 


 class Foo {
 public:
   Foo(char x);
   Foo(char x, int y);
   ...
 private:
   void init(char x, int y);
 };
 
 Foo::Foo(char x)
 {
   init(x, int(x) + 7);
   ...
 }
 
 Foo::Foo(char x, int y)
 {
   init(x, y);
   ...
 }
 
 void Foo::init(char x, int y)
 {
   ...
 } 

--------------------------------------------------------------------
Is the default constructor for Fred always Fred::Fred()?

No. A "default constructor" is a constructor that can be called with no arguments. One example of this is a constructor that takes no parameters: 


 class Fred {
 public:
   Fred();   // Default constructor: can be called with no args
   ...
 }; 
Another example of a "default constructor" is one that can take arguments, provided they are given default values: 


 class Fred {
 public:
   Fred(int i=3, int j=5);   // Default constructor: can be called with no args
   ...
 }; 

--------------------------------------------------------------------

25. Which constructor gets called when I create an array of Fred objects?

Fred's default constructor (except as discussed below). 

There is no way to tell the compiler to call a different constructor (except as discussed below). If your class Fred doesn't have a default constructor, attempting to create an array of Fred objects is trapped as an error at compile time. 


 class Fred {
 public:
   Fred(int i, int j);
   ...assume there is no default constructor in class Fred...
 };
 
 int main()
 {
   Fred a[10];               // ERROR: Fred doesn't have a default constructor
   Fred* p = new Fred[10];   // ERROR: Fred doesn't have a default constructor
   ...
 } 
However if you are constructing an object of the standard std::vector<Fred> rather than an array of Fred (which you probably should be doing anyway since arrays are evil), you don't have to have a default constructor in class Fred, since you can give the std::vector a Fred object to be used to initialize the elements: 


 #include <vector>
 
 int main()
 {
   std::vector<Fred> a(10, Fred(5,7));
   // The 10 Fred objects in std::vector a will be initialized with Fred(5,7).
   ...
 } 
Even though you ought to use a std::vector rather than an array, there are times when an array might be the right thing to do, and for those, there is the "explicit initialization of arrays" syntax. Here's how it looks: 


 class Fred {
 public:
   Fred(int i, int j);
   ...assume there is no default constructor in class Fred...
 };
 
 int main()
 {
   Fred a[10] = {
     Fred(5,7), Fred(5,7), Fred(5,7), Fred(5,7), Fred(5,7),
     Fred(5,7), Fred(5,7), Fred(5,7), Fred(5,7), Fred(5,7)
   };
 
   // The 10 Fred objects in array a will be initialized with Fred(5,7).
   ...
 } 
Of course you don't have to do Fred(5,7) for every entry — you can put in any numbers you want, even parameters or other variables. The point is that this syntax is (a) doable but (b) not as nice as the std::vector syntax. Remember this: arrays are evil — unless there is a compelling reason to use an array, use a std::vector instead. 

--------------------------------------------------------------------

27. Should my constructors use "initialization lists" or "assignment"?

Initialization lists. In fact, constructors should initialize all member objects in the initialization list. 

For example, this constructor initializes member object x_ using an initialization list: Fred::Fred() : x_(whatever) { }. The most common benefit of doing this is improved performance. For example, if the expression whatever is the same as member variable x_, the result of the whatever expression is constructed directly inside x_ — the compiler does not make a separate copy of the object. Even if the types are not the same, the compiler is usually able to do a better job with initialization lists than with assignments. 

The other (inefficient) way to build constructors is via assignment, such as: Fred::Fred() { x_ = whatever; }. In this case the expression whatever causes a separate, temporary object to be created, and this temporary object is passed into the x_ object's assignment operator. Then that temporary object is destructed at the ;. That's inefficient. 

As if that wasn't bad enough, there's another source of inefficiency when using assignment in a constructor: the member object will get fully constructed by its default constructor, and this might, for example, allocate some default amount of memory or open some default file. All this work could be for naught if the whatever expression and/or assignment operator causes the object to close that file and/or release that memory (e.g., if the default constructor didn't allocate a large enough pool of memory or if it opened the wrong file). 

Conclusion: All other things being equal, your code will run faster if you use initialization lists rather than assignment. 

Note: There is no performance difference if the type of x_ is some built-in/intrinsic type, such as int or char* or float. But even in these cases, my personal preference is to set those data members in the initialization list rather than via assignment for consistency. Another symmetry argument in favor of using initialization lists even for built-in/intrinsic types: non-static const data members can't be assigned a value in the constructor, so for symmetry it makes sense to initialize everything in the initialization list. 

--------------------------------------------------------------------

28. Should you use the this pointer in the constructor?

Some people feel you should not use the this pointer in a constructor because the object is not fully formed yet. However you can use this in the constructor (in the {body} and even in the initialization list) if you are careful. 

Here is something that always works: the {body} of a constructor (or a function called from the constructor) can reliably access the data members declared in a base class and/or the data members declared in the constructor's own class. This is because all those data members are guaranteed to have been fully constructed by the time the constructor's {body} starts executing. 

Here is something that never works: the {body} of a constructor (or a function called from the constructor) cannot get down to a derived class by calling a virtual member function that is overridden in the derived class. If your goal was to get to the overridden function in the derived class, you won't get what you want. Note that you won't get to the override in the derived class independent of how you call the virtual member function: explicitly using the this pointer (e.g., this->method()), implicitly using the this pointer (e.g., method()), or even calling some other function that calls the virtual member function on your this object. The bottom line is this: even if the caller is constructing an object of a derived class, during the constructor of the base class, your object is not yet of that derived class. You have been warned. 

Here is something that sometimes works: if you pass any of the data members in this object to another data member's initializer, you must make sure that the other data member has already been initialized. The good news is that you can determine whether the other data member has (or has not) been initialized using some straightforward language rules that are independent of the particular compiler you're using. The bad news it that you have to know those language rules (e.g., base class sub-objects are initialized first (look up the order if you have multiple and/or virtual inheritance!), then data members defined in the class are initialized in the order in which they appear in the class declaration). If you don't know these rules, then don't pass any data member from the this object (regardless of whether or not you explicitly use the this keyword) to any other data member's initializer! And if you do know the rules, please be careful. 

--------------------------------------------------------------------

29. What is the "Named Constructor Idiom"?

A technique that provides more intuitive and/or safer construction operations for users of your class. 

The problem is that constructors always have the same name as the class. Therefore the only way to differentiate between the various constructors of a class is by the parameter list. But if there are lots of constructors, the differences between them become somewhat subtle and error prone. 

With the Named Constructor Idiom, you declare all the class's constructors in the private or protected sections, and you provide public static methods that return an object. These static methods are the so-called "Named Constructors." In general there is one such static method for each different way to construct an object. 

For example, suppose we are building a Point class that represents a position on the X-Y plane. Turns out there are two common ways to specify a 2-space coordinate: rectangular coordinates (X+Y), polar coordinates (Radius+Angle). (Don't worry if you can't remember these; the point isn't the particulars of coordinate systems; the point is that there are several ways to create a Point object.) Unfortunately the parameters for these two coordinate systems are the same: two floats. This would create an ambiguity error in the overloaded constructors: 


 class Point {
 public:
   Point(float x, float y);     // Rectangular coordinates
   Point(float r, float a);     // Polar coordinates (radius and angle)
   // ERROR: Overload is Ambiguous: Point::Point(float,float)
 };
 
 int main()
 {
   Point p = Point(5.7, 1.2);   // Ambiguous: Which coordinate system?
   ...
 } 
One way to solve this ambiguity is to use the Named Constructor Idiom: 


 #include <cmath>               // To get sin() and cos()
 
 class Point {
 public:
   static Point rectangular(float x, float y);      // Rectangular coord's
   static Point polar(float radius, float angle);   // Polar coordinates
   // These static methods are the so-called "named constructors"
   ...
 private:
   Point(float x, float y);     // Rectangular coordinates
   float x_, y_;
 };
 
 inline Point::Point(float x, float y)
 : x_(x), y_(y) { }
 
 inline Point Point::rectangular(float x, float y)
 { return Point(x, y); }
 
 inline Point Point::polar(float radius, float angle)
 { return Point(radius*cos(angle), radius*sin(angle)); } 
Now the users of Point have a clear and unambiguous syntax for creating Points in either coordinate system: 


 int main()
 {
   Point p1 = Point::rectangular(5.7, 1.2);   // Obviously rectangular
   Point p2 = Point::polar(5.7, 1.2);         // Obviously polar
   ...
 } 
Make sure your constructors are in the protected section if you expect Point to have derived classes. 

The Named Constructor Idiom can also be used to make sure your objects are always created via new. 

--------------------------------------------------------------------

30. Why can't I initialize my static member data in my constructor's initialization list?

Because you must explicitly define your class's static data members. 

Fred.h: 


 class Fred {
 public:
   Fred();
   ...
 private:
   int i_;
   static int j_;
 }; 
Fred.cpp (or Fred.C or whatever): 


 Fred::Fred()
   : i_(10)  // OK: you can (and should) initialize member data this way
   , j_(42)  // Error: you cannot initialize static member data like this
 {
   ...
 }
 
 // You must define static data members this way:
 int Fred::j_ = 42; 

--------------------------------------------------------------------

31. Why are classes with static data members getting linker errors?

Because static data members must be explicitly defined in exactly one compilation unit. If you didn't do this, you'll probably get an "undefined external" linker error. For example: 


 // Fred.h
 
 class Fred {
 public:
   ...
 private:
   static int j_;   // Declares static data member Fred::j_
   ...
 }; 
The linker will holler at you ("Fred::j_ is not defined") unless you define (as opposed to merely declare) Fred::j_ in (exactly) one of your source files: 


 // Fred.cpp
 
 #include "Fred.h"
 
 int Fred::j_ = some_expression_evaluating_to_an_int;
 
 // Alternatively, if you wish to use the implicit 0 value for static ints:
 // int Fred::j_; 
The usual place to define static data members of class Fred is file Fred.cpp (or Fred.C or whatever source file extension you use). 
--------------------------------------------------------------------

31. What's the "static initialization order fiasco"?

A subtle way to kill your project. 

The static initialization order fiasco is a very subtle and commonly misunderstood aspect of C++. Unfortunately it's very hard to detect — the errors occur before main() begins. 

In short, suppose you have two static objects x and y which exist in separate source files, say x.cpp and y.cpp. Suppose further that the initialization for the y object (typically the y object's constructor) calls some method on the x object. 

That's it. It's that simple. 

The tragedy is that you have a 50%-50% chance of dying. If the compilation unit for x.cpp happens to get initialized first, all is well. But if the compilation unit for y.cpp get initialized first, then y's initialization will get run before x's initialization, and you're toast. E.g., y's constructor could call a method on the x object, yet the x object hasn't yet been constructed. 

I hear they're hiring down at McDonalds. Enjoy your new job flipping burgers. 

If you think it's "exciting" to play Russian Roulette with live rounds in half the chambers, you can stop reading here. On the other hand if you like to improve your chances of survival by preventing disasters in a systematic way, you probably want to read the next FAQ. 

Note: The static initialization order fiasco can also, in some cases, apply to built-in/intrinsic types
--------------------------------------------------------------------
32.How can I handle a constructor that fails?  Updated! 

Constructors don't have a return type, so it's not possible to use return codes. The best way to signal constructor failure is therefore to throw an exception. If you don't have the option of using exceptions, the "least bad" work-around is to put the object into a "zombie" state by setting an internal status bit so the object acts sort of like it's dead even though it is technically still alive. 

The idea of a "zombie" object has a lot of down-side. You need to add a query ("inspector") member function to check this "zombie" bit so users of your class can find out if their object is truly alive, or if it's a zombie (i.e., a "living dead" object), and just about every place you construct one of your objects (including within a larger object or an array of objects) you need to check that status flag via an if statement. You'll also want to add an if to your other member functions: if the object is a zombie, do a no-op or perhaps something more obnoxious. 

In practice the "zombie" thing gets pretty ugly. Certainly you should prefer exceptions over zombie objects, but if you do not have the option of using exceptions, zombie objects might be the "least bad" alternative

--------------------------------------------------------------------
33.How can I handle a destructor that fails?

Write a message to a log-file. But do not throw an exception! 


The C++ rule is that you must never throw an exception from a destructor that is being called during the "stack unwinding" process of another exception. For example, if someone says throw Foo(), the stack will be unwound so all the stack frames between the throw Foo() and the } catch (Foo e) { will get popped. This is called stack unwinding. 

During stack unwinding, all the local objects in all those stack frames are destructed. If one of those destructors throws an exception (say it throws a Bar object), the C++ runtime system is in a no-win situation: should it ignore the Bar and end up in the } catch (Foo e) { where it was originally headed? Should it ignore the Foo and look for a } catch (Bar e) { handler? There is no good answer — either choice loses information. 

So the C++ language guarantees that it will call terminate() at this point, and terminate() kills the process. Bang you're dead. 

The easy way to prevent this is never throw an exception from a destructor. But if you really want to be clever, you can say never throw an exception from a destructor while processing another exception. But in this second case, you're in a difficult situation: the destructor itself needs code to handle both throwing an exception and doing "something else", and the caller has no guarantees as to what might happen when the destructor detects an error (it might throw an exception, it might do "something else"). So the whole solution is harder to write. So the easy thing to do is always do "something else". That is, never throw an exception from a destructor. 

Of course the word never should be "in quotes" since there is always some situation somewhere where the rule won't hold. But certainly at least 99% of the time this is a good rule of thumb. 

--------------------------------------------------------------------
34.How should I handle resources if my constructors may throw exceptions?

Every data member inside your object should clean up its own mess. 

If a constructor throws an exception, the object's destructor is not run. If your object has already done something that needs to be undone (such as allocating some memory, opening a file, or locking a semaphore), this "stuff that needs to be undone" must be remembered by a data member inside the object. 

For example, rather than allocating memory into a raw Fred* data member, put the allocated memory into a "smart pointer" member object, and the destructor of this smart pointer will delete the Fred object when the smart pointer dies. The template std::auto_ptr is an example of such as "smart pointer." You can also write your own reference counting smart pointer. You can also use smart pointers to "point" to disk records or objects on other machines. 

By the way, if you think your Fred class is going to be allocated into a smart pointer, be nice to your users and create a typedef within your Fred class: 


 #include <memory>
 
 class Fred {
 public:
   typedef std::auto_ptr<Fred> Ptr;
   ...
 }; 
That typedef simplifies the syntax of all the code that uses your objects: your users can say Fred::Ptr instead of std::auto_ptr<Fred>: 


 #include "Fred.h"
 
 void f(std::auto_ptr<Fred> p);  // explicit but verbose
 void f(Fred::Ptr           p);  // simpler
 
 void g()
 {
   std::auto_ptr<Fred> p1( new Fred() );  // explicit but verbose
   Fred::Ptr           p2( new Fred() );  // simpler
   ...
 } 

--------------------------------------------------------------------
35.How do I change the string-length of an array of char to prevent memory leaks even if/when someone throws an exception?

If what you really want to do is work with strings, don't use an array of char in the first place, since arrays are evil. Instead use an object of some string-like class. 

For example, suppose you want to get a copy of a string, fiddle with the copy, then append another string to the end of the fiddled copy. The array-of-char approach would look something like this: 


 void userCode(const char* s1, const char* s2)
 {
   char* copy = new char[strlen(s1) + 1];    // make a copy
   strcpy(copy, s1);                         //   of s1...
 
   // use a try block to prevent memory leaks if we get an exception
   // note: we need the try block because we used a "dumb" char* above
   try {
 
     ...insert code here that fiddles with copy...
 
     char* copy2 = new char[strlen(copy) + strlen(s2) + 1];  // append s2
     strcpy(copy2, copy);                                    //   onto the
     strcpy(copy2 + strlen(copy), s2);                       //   end of
     delete[] copy;                                          //   copy...
     copy = copy2;
 
     ...insert code here that fiddles with copy again...
 
   } catch (...) {
     delete[] copy;   // we got an exception; prevent a memory leak
     throw;           // re-throw the current exception
   }
 
   delete[] copy;     // we did not get an exception; prevent a memory leak
 } 
Using char*s like this is tedious and error prone. Why not just use an object of some string class? Your compiler probably supplies a string-like class, and it's probably just as fast and certainly it's a lot simpler and safer than the char* code that you would have to write yourself. For example, if you're using the std::string class from the standardization committee, your code might look something like this: 


 #include <string>           // Let the compiler see std::string
 
 void userCode(const std::string& s1, const std::string& s2)
 {
   std::string copy = s1;    // make a copy of s1
   ...insert code here that fiddles with copy...
   copy += s2;               // append s2 onto the end of copy
   ...insert code here that fiddles with copy again...
 } 
The char* version requires you to write around three times more code than you would have to write with the std::string version. Most of the savings came from std::string's automatic memory management: in the std::string version, we didn't need to write any code... 

to reallocate memory when we grow the string. 
to delete[] anything at the end of the function. 
to catch and re-throw any exceptions. 

--------------------------------------------------------------------
36.What is the "Named Parameter Idiom"?

It's a fairly useful way to exploit method chaining. 

The fundamental problem solved by the Named Parameter Idiom is that C++ only supports positional parameters. For example, a caller of a function isn't allowed to say, "Here's the value for formal parameter xyz, and this other thing is the value for formal parameter pqr." All you can do in C++ (and C and Java) is say, "Here's the first parameter, here's the second parameter, etc." The alternative, called named parameters and implemented in the language Ada, is especially useful if a function takes a large number of mostly default-able parameters. 

Over the years people have cooked up lots of workarounds for the lack of named parameters in C and C++. One of these involves burying the parameter values in a string parameter then parsing this string at run-time. This is what's done in the second parameter of fopen(), for example. Another workaround is to combine all the boolean parameters in a bit-map, then the caller or's a bunch of bit-shifted constants together to produce the actual parameter. This is what's done in the second parameter of open(), for example. These approaches work, but the following technique produces caller-code that's more obvious, easier to write, easier to read, and is generally more elegant. 

The idea, called the Named Parameter Idiom, is to change the function's parameters to methods of a newly created class, where all these methods return *this by reference. Then you simply rename the main function into a parameterless "do-it" method on that class. 

We'll work an example to make the previous paragraph easier to understand. 

The example will be for the "open a file" concept. Let's say that concept logically requires a parameter for the file's name, and optionally allows parameters for whether the file should be opened read-only vs. read-write vs. write-only, whether or not the file should be created if it doesn't already exist, whether the writing location should be at the end ("append") or the beginning ("overwrite"), the block-size if the file is to be created, whether the I/O is buffered or non-buffered, the buffer-size, whether it is to be shared vs. exclusive access, and probably a few others. If we implemented this concept using a normal function with positional parameters, the caller code would be very difficult to read: there'd be as many as 8 positional parameters, and the caller would probably make a lot of mistakes. So instead we use the Named Parameter Idiom. 

Before we go through the implementation, here's what the caller code might look like, assuming you are willing to accept all the function's default parameters: 


 File f = OpenFile("foo.txt"); 
That's the easy case. Now here's what it might look like if you want to change a bunch of the parameters. 


 File f = OpenFile("foo.txt").
            readonly().
            createIfNotExist().
            appendWhenWriting().
            blockSize(1024).
            unbuffered().
            exclusiveAccess(); 
Notice how the "parameters", if it's fair to call them that, are in random order (they're not positional) and they all have names. So the programmer doesn't have to remember the order of the parameters, and the names are (hopefully) obvious. 

So here's how to implement it: first we create a new class (OpenFile) that houses all the parameter values as private data members. Then all the methods (readonly(), blockSize(unsigned), etc.) return *this (that is, they return a reference to the OpenFile object, allowing the method calls to be chained. Finally we make the required parameter (the file's name, in this case) into a normal, positional, parameter on OpenFile's constructor. 


 class File;
 
 class OpenFile {
 public:
   OpenFile(const string& filename);
     // sets all the default values for each data member
   OpenFile& readonly();  // changes readonly_ to true
   OpenFile& createIfNotExist();
   OpenFile& blockSize(unsigned nbytes);
   ...
 private:
   friend File;
   bool readonly_;       // defaults to false [for example]
   ...
   unsigned blockSize_;  // defaults to 4096 [for example]
   ...
 }; 
The only other thing to do is make the constructor for class File to take an OpenFile object: 


 class File {
 public:
   File(const OpenFile& params);
     // vacuums the actual params out of the OpenFile object
 
 ...
 }; 
Note that OpenFile declares File as its friend, that way OpenFile doesn't need a bunch of (otherwise useless) public: get methods. 

Since each member function in the chain returns a reference, there is no copying of objects and the chain is highly efficient. Furthermore, if the various member functions are inline, the generated object code will probably be on par with C-style code that sets various members of a struct. Of course if the member functions are not inline, there may be a slight increase in code size and a slight decrease in performance (but only if the construction occurs on the critical path of a CPU-bound program; this is a can of worms I'll try to avoid opening; read the C++ FAQs book for a rather thorough discussion of the issues), so it may, in this case, be a tradeoff for making the code more reliable

--------------------------------------------------------------------
37. What's the order that local objects are destructed?

In reverse order of construction: First constructed, last destructed. 

In the following example, b's destructor will be executed first, then a's destructor: 


 void userCode()
 {
   Fred a;
   Fred b;
   ...
 } 

--------------------------------------------------------------------
38.What's the order that objects in an array are destructed?

In reverse order of construction: First constructed, last destructed. 

In the following example, the order for destructors will be a[9], a[8], ..., a[1], a[0]: 


 void userCode()
 {
   Fred a[10];
   ...
 } 

--------------------------------------------------------------------
39.Should I explicitly call a destructor on a local variable?

No! 

The destructor will get called again at the close } of the block in which the local was created. This is a guarantee of the language; it happens automagically; there's no way to stop it from happening. But you can get really bad results from calling a destructor on the same object a second time! Bang! You're dead! 

--------------------------------------------------------------------
40.Can I overload the destructor for my class?
No. 

You can have only one destructor for a class Fred. It's always called Fred::~Fred(). It never takes any parameters, and it never returns anything. 

You can't pass parameters to the destructor anyway, since you never explicitly call a destructor (well, almost never). 

--------------------------------------------------------------------
41.What if I want a local to "die" before the close } of the scope in which it was created? Can I call a destructor on a local if I really want to?

No! [For context, please read the previous FAQ]. 

Suppose the (desirable) side effect of destructing a local File object is to close the File. Now suppose you have an object f of a class File and you want File f to be closed before the end of the scope (i.e., the }) of the scope of object f: 


 void someCode()
 {
   File f;
 
   ...insert code that should execute when f is still open...
 
   ← We want the side-effect of f's destructor here!
 
   ...insert code that should execute after f is closed...
 } 
There is a simple solution to this problem. But in the mean time, remember: Do not explicitly call the destructor! 
--------------------------------------------------------------------

42. OK, OK already; I won't explicitly call the destructor of a local; but how do I handle the above situation?

[For context, please read the previous FAQ]. 

Simply wrap the extent of the lifetime of the local in an artificial block {...}: 


 void someCode()
 {
   {
     File f;
     ...insert code that should execute when f is still open...
   }← f's destructor will automagically be called here!
 
   ...insert code here that should execute after f is closed...
 } 


--------------------------------------------------------------------
43.What if I can't wrap the local in an artificial block?

Most of the time, you can limit the lifetime of a local by wrapping the local in an artificial block ({...}). But if for some reason you can't do that, add a member function that has a similar effect as the destructor. But do not call the destructor itself! 

For example, in the case of class File, you might add a close() method. Typically the destructor will simply call this close() method. Note that the close() method will need to mark the File object so a subsequent call won't re-close an already-closed File. E.g., it might set the fileHandle_ data member to some nonsensical value such as -1, and it might check at the beginning to see if the fileHandle_ is already equal to -1: 


 class File {
 public:
   void close();
   ~File();
   ...
 private:
   int fileHandle_;   // fileHandle_ >= 0 if/only-if it's open
 };
 
 File::~File()
 {
   close();
 }
 
 void File::close()
 {
   if (fileHandle_ >= 0) {
     ...insert code to call the OS to close the file...
     fileHandle_ = -1;
   }
 } 
Note that the other File methods may also need to check if the fileHandle_ is -1 (i.e., check if the File is closed). 

Note also that any constructors that don't actually open a file should set fileHandle_ to -1. 

--------------------------------------------------------------------

44. But can I explicitly call a destructor if I've allocated my object with new?

Probably not. 

Unless you used placement new, you should simply delete the object rather than explicitly calling the destructor. For example, suppose you allocated the object via a typical new expression: 


 Fred* p = new Fred(); 
Then the destructor Fred::~Fred() will automagically get called when you delete it via: 


 delete p;  // Automagically calls p->~Fred() 
You should not explicitly call the destructor, since doing so won't release the memory that was allocated for the Fred object itself. Remember: delete p does two things: it calls the destructor and it deallocates the memory. 

--------------------------------------------------------------------

45. What is "placement new" and why would I use it?

There are many uses of placement new. The simplest use is to place an object at a particular location in memory. This is done by supplying the place as a pointer parameter to the new part of a new expression: 


 #include <new>        // Must #include this to use "placement new"
 #include "Fred.h"     // Declaration of class Fred
 
 void someCode()
 {
   char memory[sizeof(Fred)];     // Line #1
   void* place = memory;          // Line #2
 
   Fred* f = new(place) Fred();   // Line #3 (see "DANGER" below)
   // The pointers f and place will be equal
 
   ...
 } 
Line #1 creates an array of sizeof(Fred) bytes of memory, which is big enough to hold a Fred object. Line #2 creates a pointer place that points to the first byte of this memory (experienced C programmers will note that this step was unnecessary; it's there only to make the code more obvious). Line #3 essentially just calls the constructor Fred::Fred(). The this pointer in the Fred constructor will be equal to place. The returned pointer f will therefore be equal to place. 

ADVICE: Don't use this "placement new" syntax unless you have to. Use it only when you really care that an object is placed at a particular location in memory. For example, when your hardware has a memory-mapped I/O timer device, and you want to place a Clock object at that memory location. 

DANGER: You are taking sole responsibility that the pointer you pass to the "placement new" operator points to a region of memory that is big enough and is properly aligned for the object type that you're creating. Neither the compiler nor the run-time system make any attempt to check whether you did this right. If your Fred class needs to be aligned on a 4 byte boundary but you supplied a location that isn't properly aligned, you can have a serious disaster on your hands (if you don't know what "alignment" means, please don't use the placement new syntax). You have been warned. 

You are also solely responsible for destructing the placed object. This is done by explicitly calling the destructor: 


 void someCode()
 {
   char memory[sizeof(Fred)];
   void* p = memory;
   Fred* f = new(p) Fred();
   ...
   f->~Fred();   // Explicitly call the destructor for the placed object
 } 
This is about the only time you ever explicitly call a destructor. 

Note: there is a much cleaner but more sophisticated way of handling the destruction / deletion situation. 


--------------------------------------------------------------------

46. When I write a destructor, do I need to explicitly call the destructors for my member objects?

No. You never need to explicitly call a destructor (except with placement new). 

A class's destructor (whether or not you explicitly define one) automagically invokes the destructors for member objects. They are destroyed in the reverse order they appear within the declaration for the class. 


 class Member {
 public:
   ~Member();
   ...
 };
 
 class Fred {
 public:
   ~Fred();
   ...
 private:
   Member x_;
   Member y_;
   Member z_;
 };
 
 Fred::~Fred()
 {
   // Compiler automagically calls z_.~Member()
   // Compiler automagically calls y_.~Member()
   // Compiler automagically calls x_.~Member()
 } 


--------------------------------------------------------------------

47. When I write a derived class's destructor, do I need to explicitly call the destructor for my base class?

No. You never need to explicitly call a destructor (except with placement new). 

A derived class's destructor (whether or not you explicitly define one) automagically invokes the destructors for base class subobjects. Base classes are destructed after member objects. In the event of multiple inheritance, direct base classes are destructed in the reverse order of their appearance in the inheritance list. 


 class Member {
 public:
   ~Member();
   ...
 };
 
 class Base {
 public:
   virtual ~Base();     // A virtual destructor
   ...
 };
 
 class Derived : public Base {
 public:
   ~Derived();
   ...
 private:
   Member x_;
 };
 
 Derived::~Derived()
 {
   // Compiler automagically calls x_.~Member()
   // Compiler automagically calls Base::~Base()
 } 
Note: Order dependencies with virtual inheritance are trickier. If you are relying on order dependencies in a virtual inheritance hierarchy, you'll need a lot more information than is in this FAQ. 


--------------------------------------------------------------------
48.Is there a way to force new to allocate memory from a specific memory area?

Yes. The good news is that these "memory pools" are useful in a number of situations. The bad news is that I'll have to drag you through the mire of how it works before we discuss all the uses. But if you don't know about memory pools, it might be worthwhile to slog through this FAQ — you might learn something useful! 

First of all, recall that a memory allocator is simply supposed to return uninitialized bits of memory; it is not supposed to produce "objects." In particular, the memory allocator is not supposed to set the virtual-pointer or any other part of the object, as that is the job of the constructor which runs after the memory allocator. Starting with a simple memory allocator function, allocate(), you would use placement new to construct an object in that memory. In other words, the following is morally equivalent to new Foo(): 


 void* raw = allocate(sizeof(Foo));  // line 1
 Foo* p = new(raw) Foo();            // line 2 
Okay, assuming you've used placement new and have survived the above two lines of code, the next step is to turn your memory allocator into an object. This kind of object is called a "memory pool" or a "memory arena." This lets your users have more than one "pool" or "arena" from which memory will be allocated. Each of these memory pool objects will allocate a big chunk of memory using some specific system call (e.g., shared memory, persistent memory, stack memory, etc.; see below), and will dole it out in little chunks as needed. Your memory-pool class might look something like this: 


 class Pool {
 public:
   void* alloc(size_t nbytes);
   void dealloc(void* p);
 private:
   ...data members used in your pool object...
 };
 
 void* Pool::alloc(size_t nbytes)
 {
   ...your algorithm goes here...
 }
 
 void Pool::dealloc(void* p)
 {
   ...your algorithm goes here...
 } 
Now one of your users might have a Pool called pool, from which they could allocate objects like this: 


 Pool pool;
 ...
 void* raw = pool.alloc(sizeof(Foo));
 Foo* p = new(raw) Foo(); 
Or simply: 


 Foo* p = new(pool.alloc(sizeof(Foo))) Foo(); 
The reason it's good to turn Pool into a class is because it lets users create N different pools of memory rather than having one massive pool shared by all users. That allows users to do lots of funky things. For example, if they have a chunk of the system that allocates memory like crazy then goes away, they could allocate all their memory from a Pool, then not even bother doing any deletes on the little pieces: just deallocate the entire pool at once. Or they could set up a "shared memory" area (where the operating system specifically provides memory that is shared between multiple processes) and have the pool dole out chunks of shared memory rather than process-local memory. Another angle: many systems support a non-standard function often called alloca() which allocates a block of memory from the stack rather than the heap. Naturally this block of memory automatically goes away when the function returns, eliminating the need for explicit deletes. Someone could use alloca() to give the Pool its big chunk of memory, then all the little pieces allocated from that Pool act like they're local: they automatically vanish when the function returns. Of course the destructors don't get called in some of these cases, and if the destructors do something nontrivial you won't be able to use these techniques, but in cases where the destructor merely deallocates memory, these sorts of techniques can be useful. 

Okay, assuming you survived the 6 or 8 lines of code needed to wrap your allocate function as a method of a Pool class, the next step is to change the syntax for allocating objects. The goal is to change from the rather clunky syntax new(pool.alloc(sizeof(Foo))) Foo() to the simpler syntax new(pool) Foo(). To make this happen, you need to add the following two lines of code just below the definition of your Pool class: 


 inline void* operator new(size_t nbytes, Pool& pool)
 {
   return pool.alloc(nbytes);
 } 
Now when the compiler sees new(pool) Foo(), it calls the above operator new and passes sizeof(Foo) and pool as parameters, and the only function that ends up using the funky pool.alloc(nbytes) method is your own operator new. 

Now to the issue of how to destruct/deallocate the Foo objects. Recall that the brute force approach sometimes used with placement new is to explicitly call the destructor then explicitly deallocate the memory: 


 void sample(Pool& pool)
 {
   Foo* p = new(pool) Foo();
   ...
   p->~Foo();        // explicitly call dtor
   pool.dealloc(p);  // explicitly release the memory
 } 
This has several problems, all of which are fixable: 

The memory will leak if Foo::Foo() throws an exception. 
The destruction/deallocation syntax is different from what most programmers are used to, so they'll probably screw it up. 
Users must somehow remember which pool goes with which object. Since the code that allocates is often in a different function from the code that deallocates, programmers will have to pass around two pointers (a Foo* and a Pool*), which gets ugly fast (example, what if they had an array of Foos each of which potentially came from a different Pool; ugh). 
We will fix them in the above order. 

Problem #1: plugging the memory leak. When you use the "normal" new operator, e.g., Foo* p = new Foo(), the compiler generates some special code to handle the case when the constructor throws an exception. The actual code generated by the compiler is functionally similar to this: 


 // This is functionally what happens with Foo* p = new Foo()
 
 Foo* p;
 
 // don't catch exceptions thrown by the allocator itself
 void* raw = operator new(sizeof(Foo));
 
 // catch any exceptions thrown by the ctor
 try {
   p = new(raw) Foo();  // call the ctor with raw as this
 }
 catch (...) {
   // oops, ctor threw an exception
   operator delete(raw);
   throw;  // rethrow the ctor's exception
 } 
The point is that the compiler deallocates the memory if the ctor throws an exception. But in the case of the "new with parameter" syntax (commonly called "placement new"), the compiler won't know what to do if the exception occurs so by default it does nothing: 


 // This is functionally what happens with Foo* p = new(pool) Foo():
 
 void* raw = operator new(sizeof(Foo), pool);
 // the above function simply returns "pool.alloc(sizeof(Foo))"
 
 Foo* p = new(raw) Foo();
 // if the above line "throws", pool.dealloc(raw) is NOT called 
So the goal is to force the compiler to do something similar to what it does with the global new operator. Fortunately it's simple: when the compiler sees new(pool) Foo(), it looks for a corresponding operator delete. If it finds one, it does the equivalent of wrapping the ctor call in a try block as shown above. So we would simply provide an operator delete with the following signature (be careful to get this right; if the second parameter has a different type from the second parameter of the operator new(size_t, Pool&), the compiler doesn't complain; it simply bypasses the try block when your users say new(pool) Foo()): 


 void operator delete(void* p, Pool& pool)
 {
   pool.dealloc(p);
 } 
After this, the compiler will automatically wrap the ctor calls of your new expressions in a try block: 


 // This is functionally what happens with Foo* p = new(pool) Foo()
 
 Foo* p;
 
 // don't catch exceptions thrown by the allocator itself
 void* raw = operator new(sizeof(Foo), pool);
 // the above simply returns "pool.alloc(sizeof(Foo))"
 
 // catch any exceptions thrown by the ctor
 try {
   p = new(raw) Foo();  // call the ctor with raw as this
 }
 catch (...) {
   // oops, ctor threw an exception
   operator delete(raw, pool);  // that's the magical line!!
   throw;  // rethrow the ctor's exception
 } 
In other words, the one-liner function operator delete(void* p, Pool& pool) causes the compiler to automagically plug the memory leak. Of course that function can be, but doesn't have to be, inline. 

Problems #2 ("ugly therefore error prone") and #3 ("users must manually associate pool-pointers with the object that allocated them, which is error prone") are solved simultaneously with an additional 10-20 lines of code in one place. In other words, we add 10-20 lines of code in one place (your Pool header file) and simplify an arbitrarily large number of other places (every piece of code that uses your Pool class). 

The idea is to implicitly associate a Pool* with every allocation. The Pool* associated with the global allocator would be NULL, but at least conceptually you could say every allocation has an associated Pool*. Then you replace the global operator delete so it looks up the associated Pool*, and if non-NULL, calls that Pool's deallocate function. For example, if(!) the normal deallocator used free(), the replacment for the global operator delete would look something like this: 


 void operator delete(void* p)
 {
   if (p != NULL) {
     Pool* pool = /* somehow get the associated 'Pool*' */;
     if (pool == null)
       free(p);
     else
       pool->dealloc(p);
   }
 } 
If you're not sure if the normal deallocator was free(), the easiest approach is also replace the global operator new with something that uses malloc(). The replacement for the global operator new would look something like this (note: this definition ignores a few details such as the new_handler loop and the throw std::bad_alloc() that happens if we run out of memory): 


 void* operator new(size_t nbytes)
 {
   if (nbytes == 0)
     nbytes = 1;  // so all alloc's get a distinct address
   void* raw = malloc(nbytes);
   ...somehow associate the NULL 'Pool*' with 'raw'...
   return raw;
 } 
The only remaining problem is to associate a Pool* with an allocation. One approach, used in at least one commercial product, is to use a std::map<void*,Pool*>. In other words, build a look-up table whose keys are the allocation-pointer and whose values are the associated Pool*. For reasons I'll describe in a moment, it is essential that you insert a key/value pair into the map only in operator new(size_t,Pool&). In particular, you must not insert a key/value pair from the global operator new (e.g., you must not say, poolMap[p] = NULL in the global operator new). Reason: doing that would create a nasty chicken-and-egg problem — since std::map probably uses the global operator new, it ends up inserting a new entry every time inserts a new entry, leading to infinite recursion — bang you're dead. 

Even though this technique requires a std::map look-up for each deallocation, it seems to have acceptable performance, at least in many cases. 

Another approach that is faster but might use more memory and is a little trickier is to prepend a Pool* just before all allocations. For example, if nbytes was 24, meaning the caller was asking to allocate 24 bytes, we would allocate 28 (or 32 if you think the machine requires 8-byte alignment for things like doubles and/or long longs), stuff the Pool* into the first 4 bytes, and return the pointer 4 (or 8) bytes from the beginning of what you allocated. Then your global operator delete backs off the 4 (or 8) bytes, finds the Pool*, and if NULL, uses free() otherwise calls pool->dealloc(). The parameter passed to free() and pool->dealloc() would be the pointer 4 (or 8) bytes to the left of the original parameter, p. If(!) you decide on 4 byte alignment, your code would look something like this (although as before, the following operator new code elides the usual out-of-memory handlers): 


 void* operator new(size_t nbytes)
 {
   if (nbytes == 0)
     nbytes = 1;                    // so all alloc's get a distinct address
   void* ans = malloc(nbytes + 4);  // overallocate by 4 bytes
   *(Pool**)ans = NULL;             // use NULL in the global new
   return (char*)ans + 4;           // don't let users see the Pool*
 }
 
 void* operator new(size_t nbytes, Pool& pool)
 {
   if (nbytes == 0)
     nbytes = 1;                    // so all alloc's get a distinct address
   void* ans = pool.alloc(nbytes + 4); // overallocate by 4 bytes
   *(Pool**)ans = &pool;            // put the Pool* here
   return (char*)ans + 4;           // don't let users see the Pool*
 }
 
 void operator delete(void* p)
 {
   if (p != NULL) {
     p = (char*)p - 4;              // back off to the Pool*
     Pool* pool = *(Pool**)p;
     if (pool == null)
       free(p);                     // note: 4 bytes left of the original p
     else
       pool->dealloc(p);            // note: 4 bytes left of the original p
   }
 } 
Naturally the last few paragraphs of this FAQ are viable only when you are allowed to change the global operator new and operator delete. If you are not allowed to change these global functions, the first three quarters of this FAQ is still applicable

--------------------------------------------------------------------
49. What is "self assignment"?

Self assignment is when someone assigns an object to itself. For example, 


 #include "Fred.hpp"    // Declares class Fred
 
 void userCode(Fred& x)
 {
   x = x;   // Self-assignment
 } 
Obviously no one ever explicitly does a self assignment like the above, but since more than one pointer or reference can point to the same object (aliasing), it is possible to have self assignment without knowing it: 


 #include "Fred.hpp"    // Declares class Fred
 
 void userCode(Fred& x, Fred& y)
 {
   x = y;   // Could be self-assignment if &x == &y
 }
 
 int main()
 {
   Fred z;
   userCode(z, z);
   ...
 } 


--------------------------------------------------------------------

50. Why should I worry about "self assignment"?

If you don't worry about self assignment, you'll expose your users to some very subtle bugs that have very subtle and often disastrous symptoms. For example, the following class will cause a complete disaster in the case of self-assignment: 


 class Wilma { };
 
 class Fred {
 public:
   Fred()                : p_(new Wilma())      { }
   Fred(const Fred& f)   : p_(new Wilma(*f.p_)) { }
  ~Fred()                { delete p_; }
   Fred& operator= (const Fred& f)
     {
       // Bad code: Doesn't handle self-assignment!
       delete p_;                // Line #1
       p_ = new Wilma(*f.p_);    // Line #2
       return *this;
     }
 private:
   Wilma* p_;
 }; 
If someone assigns a Fred object to itself, line #1 deletes both this->p_ and f.p_ since *this and f are the same object. But line #2 uses *f.p_, which is no longer a valid object. This will likely cause a major disaster. 

The bottom line is that you the author of class Fred are responsible to make sure self-assignment on a Fred object is innocuous. Do not assume that users won't ever do that to your objects. It is your fault if your object crashes when it gets a self-assignment. 


Aside: the above Fred::operator= (const Fred&) has a second problem: If an exception is thrown while evaluating new Wilma(*f.p_) (e.g., an out-of-memory exception or an exception in Wilma's copy constructor), this->p_ will be a dangling pointer — it will point to memory that is no longer valid. This can be solved by allocating the new objects before deleting the old objects. 

--------------------------------------------------------------------
51. OK, OK, already; I'll handle self-assignment. How do I do it?

You should worry about self assignment every time you create a class. This does not mean that you need to add extra code to all your classes: as long as your objects gracefully handle self assignment, it doesn't matter whether you had to add extra code or not. 

If you do need to add extra code to your assignment operator, here's a simple and effective technique: 


 Fred& Fred::operator= (const Fred& f)
 {
   if (this == &f) return *this;   // Gracefully handle self assignment
 
   // Put the normal assignment duties here...
 
   return *this;
 } 
This explicit test isn't always necessary. For example, if you were to fix the assignment operator in the previous FAQ to handle exceptions thrown by new and/or exceptions thrown by the copy constructor of class Wilma, you might produce the following code. Note that this code has the (pleasant) side effect of automatically handling self assignment as well: 


 Fred& Fred::operator= (const Fred& f)
 {
   // This code gracefully (albeit implicitly) handles self assignment
   Wilma* tmp = new Wilma(*f.p_);   // It would be OK if an exception got thrown here
   delete p_;
   p_ = tmp;
   return *this;
 } 
In cases like the previous example (where self assignment is harmless but inefficient), some programmers want to improve the efficiency of self assignment by adding an otherwise unnecessary test, such as "if (this == &f) return *this;". It is generally the wrong tradeoff to make self assignment more efficient by making the non-self assignment case less efficient. For example, adding the above if test to the Fred assignment operator would make the non-self assignment case slightly less efficient (an extra (and unnecessary) conditional branch). If self assignment actually occured once in a thousand times, the if would waste cycles 99.9% of the time

--------------------------------------------------------------------
52.How do I create a subscript operator for a Matrix class?

Use operator() rather than operator[]. 

When you have multiple subscripts, the cleanest way to do it is with operator() rather than with operator[]. The reason is that operator[] always takes exactly one parameter, but operator() can take any number of parameters (in the case of a rectangular matrix, two paramters are needed). 

For example: 


 class Matrix {
 public:
   Matrix(unsigned rows, unsigned cols);
   double& operator() (unsigned row, unsigned col);
   double  operator() (unsigned row, unsigned col) const;
   ...
  ~Matrix();                              // Destructor
   Matrix(const Matrix& m);               // Copy constructor
   Matrix& operator= (const Matrix& m);   // Assignment operator
   ...
 private:
   unsigned rows_, cols_;
   double* data_;
 };
 
 inline
 Matrix::Matrix(unsigned rows, unsigned cols)
   : rows_ (rows),
     cols_ (cols),
     data_ (new double[rows * cols])
 {
   if (rows == 0 || cols == 0)
     throw BadIndex("Matrix constructor has 0 size");
 }
 
 inline
 Matrix::~Matrix()
 {
   delete[] data_;
 }
 
 inline
 double& Matrix::operator() (unsigned row, unsigned col)
 {
   if (row >= rows_ || col >= cols_)
     throw BadIndex("Matrix subscript out of bounds");
   return data_[cols_*row + col];
 }
 
 inline
 double Matrix::operator() (unsigned row, unsigned col) const
 {
   if (row >= rows_ || col >= cols_)
     throw BadIndex("const Matrix subscript out of bounds");
   return data_[cols_*row + col];
 } 

Then you can access an element of Matrix m using m(i,j) rather than m[i][j]: 

 int main()
 {
   Matrix m(10,10);
   m(5,8) = 106.15;
   std::cout << m(5,8);
   ...
 } 

--------------------------------------------------------------------
53.Should I design my classes from the outside (interfaces first) or from the inside (data first)?
From the outside! 

A good interface provides a simplified view that is expressed in the vocabulary of a user. In the case of OO software, the interface is normally the set of public methods of either a single class or a tight group of classes. 

First think about what the object logically represents, not how you intend to physically build it. For example, suppose you have a Stack class that will be built by containing a LinkedList: 


 class Stack {
 public:
   ...
 private:
   LinkedList list_;
 }; 
Should the Stack have a get() method that returns the LinkedList? Or a set() method that takes a LinkedList? Or a constructor that takes a LinkedList? Obviously the answer is No, since you should design your interfaces from the outside-in. I.e., users of Stack objects don't care about LinkedLists; they care about pushing and popping. 

Now for another example that is a bit more subtle. Suppose class LinkedList is built using a linked list of Node objects, where each Node object has a pointer to the next Node: 


 class Node { /*...*/ };
 
 class LinkedList {
 public:
   ...
 private:
   Node* first_;
 }; 
Should the LinkedList class have a get() method that will let users access the first Node? Should the Node object have a get() method that will let users follow that Node to the next Node in the chain? In other words, what should a LinkedList look like from the outside? Is a LinkedList really a chain of Node objects? Or is that just an implementation detail? And if it is just an implementation detail, how will the LinkedList let users access each of the elements in the LinkedList one at a time? 

The key insight is the realization that a LinkedList is not a chain of Nodes. That may be how it is built, but that is not what it is. What it is is a sequence of elements. Therefore the LinkedList abstraction should provide a "LinkedListIterator" class as well, and that "LinkedListIterator" might have an operator++ to go to the next element, and it might have a get()/set() pair to access its value stored in the Node (the value in the Node element is solely the responsibility of the LinkedList user, which is why there is a get()/set() pair that allows the user to freely manipulate that value). 

Starting from the user's perspective, we might want our LinkedList class to support operations that look similar to accessing an array using pointer arithmetic: 


 void userCode(LinkedList& a)
 {
   for (LinkedListIterator p = a.begin(); p != a.end(); ++p)
     std::cout << *p << '\n';
 } 
To implement this interface, LinkedList will need a begin() method and an end() method. These return a "LinkedListIterator" object. The "LinkedListIterator" will need a method to go forward, ++p; a method to access the current element, *p; and a comparison operator, p != a.end(). 

The code follows. The important thing to notice is that LinkedList does not have any methods that let users access Nodes. Nodes are an implementation technique that is completely buried. This makes the LinkedList class safer (no chance a user will mess up the invariants and linkages between the various nodes), easier to use (users don't need to expend extra effort keeping the node-count equal to the actual number of nodes, or any other infrastructure stuff), and more flexible (by changing a single typedef, users could change their code from using LinkedList to some other list-like class and the bulk of their code would compile cleanly and hopefully with improved performance characteristics). 


 #include <cassert>    // Poor man's exception handling
 
 class LinkedListIterator;
 class LinkedList;
 
 class Node {
   // No public members; this is a "private class"
   friend LinkedListIterator;   // A friend class
   friend LinkedList;
   Node* next_;
   int elem_;
 };
 
 class LinkedListIterator {
 public:
   bool operator== (LinkedListIterator i) const;
   bool operator!= (LinkedListIterator i) const;
   void operator++ ();   // Go to the next element
   int& operator*  ();   // Access the current element
 private:
   LinkedListIterator(Node* p);
   Node* p_;
   friend LinkedList;  // so LinkedList can construct a LinkedListIterator
 };
 
 class LinkedList {
 public:
   void append(int elem);    // Adds elem after the end
   void prepend(int elem);   // Adds elem before the beginning
   ...
   LinkedListIterator begin();
   LinkedListIterator end();
   ...
 private:
   Node* first_;
 }; 
Here are the methods that are obviously inlinable (probably in the same header file): 


 inline bool LinkedListIterator::operator== (LinkedListIterator i) const
 {
   return p_ == i.p_;
 }
 
 inline bool LinkedListIterator::operator!= (LinkedListIterator i) const
 {
   return p_ != i.p_;
 }
 
 inline void LinkedListIterator::operator++()
 {
   assert(p_ != NULL);  // or if (p_==NULL) throw ...
   p_ = p_->next_;
 }
 
 inline int& LinkedListIterator::operator*()
 {
   assert(p_ != NULL);  // or if (p_==NULL) throw ...
   return p_->elem_;
 }
 
 inline LinkedListIterator::LinkedListIterator(Node* p)
   : p_(p)
 { }
 
 inline LinkedListIterator LinkedList::begin()
 {
   return first_;
 }
 
 inline LinkedListIterator LinkedList::end()
 {
   return NULL;
 } 
Conclusion: The linked list had two different kinds of data. The values of the elements stored in the linked list are the responsibility of the user of the linked list (and only the user; the linked list itself makes no attempt to prohibit users from changing the third element to 5), and the linked list's infrastructure data (next pointers, etc.), whose values are the responsibility of the linked list (and only the linked list; e.g., the linked list does not let users change (or even look at!) the various next pointers). 

Thus the only get()/set() methods were to get and set the elements of the linked list, but not the infrastructure of the linked list. Since the linked list hides the infrastructure pointers/etc., it is able to make very strong promises regarding that infrastructure (e.g., if it was a doubly linked list, it might guarantee that every forward pointer was matched by a backwards pointer from the next Node). 

So, we see here an example of where the values of some of a class's data is the responsibility of users (in which case the class needs to have get()/set() methods for that data) but the data that the class wants to control does not necessarily have get()/set() methods. 

Note: the purpose of this example is not to show you how to write a linked-list class. In fact you should not "roll your own" linked-list class since you should use one of the "container classes" provided with your compiler. Ideally you'll use one of the standard container classes such as the std::list<T> template. 

--------------------------------------------------------------------

54. How can I overload the prefix and postfix forms of operators ++ and --?
Via a dummy parameter. 

Since the prefix and postfix ++ operators can have two definitions, the C++ language gives us two different signatures. Both are called operator++(), but the prefix version takes no parameters and the postfix version takes a dummy int. (Although this discussion revolves around the ++ operator, the -- operator is completely symmetric, and all the rules and guidelines that apply to one also apply to the other.) 


 class Number {
 public:
   Number& operator++ ();    // prefix ++
   Number  operator++ (int); // postfix ++
 }; 
Note the different return types: the prefix version returns by reference, the postfix version by value. If that's not immediately obvious to you, it should be after you see the definitions (and after you remember that y = x++ and y = ++x set y to different things). 


 Number& Number::operator++ ()
 {
   ...
   return *this;
 }
 
 Number Number::operator++ (int)
 {
   Number ans = *this;
   ++(*this);  // or just call operator++()
   return ans;
 } 
The other option for the postfix version is to return nothing: 


 class Number {
 public:
   Number& operator++ ();
   void    operator++ (int);
 };
 
 Number& Number::operator++ ()
 {
   ...
   return *this;
 }
 
 void Number::operator++ (int)
 {
   ++(*this);  // or just call operator++()
 } 
However you must *not* make the postfix version return the 'this' object by reference; you have been warned. 

Here's how you use these operators: 


 Number x = /* ... */;
 ++x;  // calls Number::operator++(), i.e., calls x.operator++()
 x++;  // calls Number::operator++(int), i.e., calls x.operator++(0) 
Assuming the return types are not 'void', you can use them in larger expressions: 


 Number x = /* ... */;
 Number y = ++x;  // y will be the new value of x
 Number z = x++;  // z will be the old value of x 

--------------------------------------------------------------------

55. Which is more efficient: i++ or ++i?

++i is sometimes faster than, and is never slower than, i++. 

For intrinsic types like int, it doesn't matter: ++i and i++ are the same speed. For class types like iterators or the previous FAQ's Number class, ++i very well might be faster than i++ since the latter might make a copy of the this object. 

The overhead of i++, if it is there at all, won't probably make any practical difference unless your app is CPU bound. For example, if your app spends most of its time waiting for someone to click a mouse, doing disk I/O, network I/O, or database queries, then it won't hurt your performance to waste a few CPU cycles. However it's just as easy to type ++i as i++, so why not use the former unless you actually need the old value of i. 

So if you're writing i++ as a statement rather than as part of a larger expression, why not just write ++i instead? You never lose anything, and you sometimes gain something. Old line C programmers are used to writing i++ instead of ++i. E.g., they'll say, for (i = 0; i < 10; i++) .... Since this uses i++ as a statement, not as a part of a larger expression, then you might want to use ++i instead. For symmetry, I personally advocate that style even when it doesn't improve speed, e.g., for intrinsic types and for class types with postfix operators that return void. 

Obviously when i++ appears as a part of a larger expression, that's different: it's being used because it's the only logically correct solution, not because it's an old habit you picked up while programming in C. 


--------------------------------------------------------------------

57.Do friends violate encapsulation?

No! If they're used properly, they enhance encapsulation. 

You often need to split a class in half when the two halves will have different numbers of instances or different lifetimes. In these cases, the two halves usually need direct access to each other (the two halves used to be in the same class, so you haven't increased the amount of code that needs direct access to a data structure; you've simply reshuffled the code into two classes instead of one). The safest way to implement this is to make the two halves friends of each other. 

If you use friends like just described, you'll keep private things private. People who don't understand this often make naive efforts to avoid using friendship in situations like the above, and often they actually destroy encapsulation. They either use public data (grotesque!), or they make the data accessible between the halves via public get() and set() member functions. Having a public get() and set() member function for a private datum is OK only when the private datum "makes sense" from outside the class (from a user's perspective). In many cases, these get()/set() member functions are almost as bad as public data: they hide (only) the name of the private datum, but they don't hide the existence of the private datum. 

Similarly, if you use friend functions as a syntactic variant of a class's public access functions, they don't violate encapsulation any more than a member function violates encapsulation. In other words, a class's friends don't violate the encapsulation barrier: along with the class's member functions, they are the encapsulation barrier. 

(Many people think of a friend function as something outside the class. Instead, try thinking of a friend function as part of the class's public interface. A friend function in the class declaration doesn't violate encapsulation any more than a public member function violates encapsulation: both have exactly the same authority with respect to accessing the class's non-public parts.) 


--------------------------------------------------------------------
58.What are some advantages/disadvantages of using friend functions?

They provide a degree of freedom in the interface design options. 

Member functions and friend functions are equally privileged (100% vested). The major difference is that a friend function is called like f(x), while a member function is called like x.f(). Thus the ability to choose between member functions (x.f()) and friend functions (f(x)) allows a designer to select the syntax that is deemed most readable, which lowers maintenance costs. 

The major disadvantage of friend functions is that they require an extra line of code when you want dynamic binding. To get the effect of a virtual friend, the friend function should call a hidden (usually protected) virtual member function. This is called the Virtual Friend Function Idiom. For example: 


 class Base {
 public:
   friend void f(Base& b);
   ...
 protected:
   virtual void do_f();
   ...
 };
 
 inline void f(Base& b)
 {
   b.do_f();
 }
 
 class Derived : public Base {
 public:
   ...
 protected:
   virtual void do_f();  // "Override" the behavior of f(Base& b)
   ...
 };
 
 void userCode(Base& b)
 {
   f(b);
 } 
The statement f(b) in userCode(Base&) will invoke b.do_f(), which is virtual. This means that Derived::do_f() will get control if b is actually a object of class Derived. Note that Derived overrides the behavior of the protected virtual member function do_f(); it does not have its own variation of the friend function, f(Base&). 


--------------------------------------------------------------------
59.What does it mean that "friendship isn't inherited, transitive, or reciprocal"?

Just because I grant you friendship access to me doesn't automatically grant your kids access to me, doesn't automatically grant your friends access to me, and doesn't automatically grant me access to you. 

I don't necessarily trust the kids of my friends. The privileges of friendship aren't inherited. Derived classes of a friend aren't necessarily friends. If class Fred declares that class Base is a friend, classes derived from Base don't have any automatic special access rights to Fred objects. 
I don't necessarily trust the friends of my friends. The privileges of friendship aren't transitive. A friend of a friend isn't necessarily a friend. If class Fred declares class Wilma as a friend, and class Wilma declares class Betty as a friend, class Betty doesn't necessarily have any special access rights to Fred objects. 
You don't necessarily trust me simply because I declare you my friend. The privileges of friendship aren't reciprocal. If class Fred declares that class Wilma is a friend, Wilma objects have special access to Fred objects but Fred objects do not automatically have special access to Wilma objects
--------------------------------------------------------------------

60.Should my class declare a member function or a friend function?

Use a member when you can, and a friend when you have to. 

Sometimes friends are syntactically better (e.g., in class Fred, friend functions allow the Fred parameter to be second, while members require it to be first). Another good use of friend functions are the binary infix arithmetic operators. E.g., aComplex + aComplex should be defined as a friend rather than a member if you want to allow aFloat + aComplex as well (member functions don't allow promotion of the left hand argument, since that would change the class of the object that is the recipient of the member function invocation). 

In other cases, choose a member function over a friend function

--------------------------------------------------------------------

61.Does delete p delete the pointer p, or the pointed-to-data *p?
The pointed-to-data. 

The keyword should really be delete_the_thing_pointed_to_by. The same abuse of English occurs when freeing the memory pointed to by a pointer in C: free(p) really means free_the_stuff_pointed_to_by(p). 

--------------------------------------------------------------------

62.Do I need to check for NULL after p = new Fred()?

No! (But if you have an old compiler, you may have to force the new operator to throw an exception if it runs out of memory.) 

It turns out to be a real pain to always write explicit NULL tests after every new allocation. Code like the following is very tedious: 


 Fred* p = new Fred();
 if (p == NULL)
   throw std::bad_alloc(); 
If your compiler doesn't support (or if you refuse to use) exceptions, your code might be even more tedious: 


 Fred* p = new Fred();
 if (p == NULL) {
   std::cerr << "Couldn't allocate memory for a Fred" << std::endl;
   abort();
 } 
Take heart. In C++, if the runtime system cannot allocate sizeof(Fred) bytes of memory during p = new Fred(), a std::bad_alloc exception will be thrown. Unlike malloc(), new never returns NULL! 

Therefore you should simply write: 


 Fred* p = new Fred();   // No need to check if p is NULL 
However, if your compiler is old, it may not yet support this. Find out by checking your compiler's documentation under "new". If you have an old compiler, you may have to force the compiler to have this behavior. 

--------------------------------------------------------------------

63. How can I convince my (older) compiler to automatically check new to see if it returns NULL?

Eventually your compiler will. 

If you have an old compiler that doesn't automagically perform the NULL test, you can force the runtime system to do the test by installing a "new handler" function. Your "new handler" function can do anything you want, such as throw an exception, delete some objects and return (in which case operator new will retry the allocation), print a message and abort() the program, etc. 

Here's a sample "new handler" that prints a message and throws an exception. The handler is installed using std::set_new_handler(): 


 #include <new>       // To get std::set_new_handler
 #include <cstdlib>   // To get abort()
 #include <iostream>  // To get std::cerr
 
 class alloc_error : public std::exception {
 public:
   alloc_error() : exception() { }
 };
 
 void myNewHandler()
 {
   // This is your own handler.  It can do anything you want.
   throw alloc_error();
 }
 
 int main()
 {
   std::set_new_handler(myNewHandler);   // Install your "new handler"
   ...
 } 
After the std::set_new_handler() line is executed, operator new will call your myNewHandler() if/when it runs out of memory. This means that new will never return NULL: 


 Fred* p = new Fred();   // No need to check if p is NULL 
Note: If your compiler doesn't support exception handling, you can, as a last resort, change the line throw ...; to: 


 std::cerr << "Attempt to allocate memory failed!" << std::endl;
 abort(); 
Note: If some global/static object's constructor uses new, it won't use the myNewHandler() function since that constructor will get called before main() begins. Unfortunately there's no convenient way to guarantee that the std::set_new_handler() will be called before the first use of new. For example, even if you put the std::set_new_handler() call in the constructor of a global object, you still don't know if the module ("compilation unit") that contains that global object will be elaborated first or last or somewhere inbetween. Therefore you still don't have any guarantee that your call of std::set_new_handler() will happen before any other global's constructor gets invoked. 

--------------------------------------------------------------------

64. Do I need to check for NULL before delete p?
No! 

The C++ language guarantees that delete p will do nothing if p is equal to NULL. Since you might get the test backwards, and since most testing methodologies force you to explicitly test every branch point, you should not put in the redundant if test. 

Wrong: 


 if (p != NULL)
   delete p; 
Right: 


 delete p; 

--------------------------------------------------------------------

65. What are the two steps that happen when I say delete p?
delete p is a two-step process: it calls the destructor, then releases the memory. The code generated for delete p is functionally similar to this (assuming p is of type Fred*): 


 // Original code: delete p;
 if (p != NULL) {
   p->~Fred();
   operator delete(p);
 } 
The statement p->~Fred() calls the destructor for the Fred object pointed to by p. 

The statement operator delete(p) calls the memory deallocation primitive, void operator delete(void* p). This primitive is similar in spirit to free(void* p). (Note, however, that these two are not interchangeable; e.g., there is no guarantee that the two memory deallocation primitives even use the same heap!) 

--------------------------------------------------------------------
66. In p = new Fred(), does the Fred memory "leak" if the Fred constructor throws an exception?
No. 

If an exception occurs during the Fred constructor of p = new Fred(), the C++ language guarantees that the memory sizeof(Fred) bytes that were allocated will automagically be released back to the heap. 

Here are the details: new Fred() is a two-step process: 

sizeof(Fred) bytes of memory are allocated using the primitive void* operator new(size_t nbytes). This primitive is similar in spirit to malloc(size_t nbytes). (Note, however, that these two are not interchangeable; e.g., there is no guarantee that the two memory allocation primitives even use the same heap!). 
It constructs an object in that memory by calling the Fred constructor. The pointer returned from the first step is passed as the this parameter to the constructor. This step is wrapped in a try ... catch block to handle the case when an exception is thrown during this step. 
Thus the actual generated code is functionally similar to: 


 // Original code: Fred* p = new Fred();
 Fred* p = (Fred*) operator new(sizeof(Fred));
 try {
   new(p) Fred();       // Placement new
 } catch (...) {
   operator delete(p);  // Deallocate the memory
   throw;               // Re-throw the exception
 } 
The statement marked "Placement new" calls the Fred constructor. The pointer p becomes the this pointer inside the constructor, Fred::Fred(). 

--------------------------------------------------------------------
67. How do I allocate / unallocate an array of things?
Use p = new T[n] and delete[] p: 


 Fred* p = new Fred[100];
 ...
 delete[] p; 
Any time you allocate an array of objects via new (usually with the [n] in the new expression), you must use [] in the delete statement. This syntax is necessary because there is no syntactic difference between a pointer to a thing and a pointer to an array of things (something we inherited from C). 

--------------------------------------------------------------------
68. What if I forget the [] when deleteing array allocated via new T[n]?

All life comes to a catastrophic end. 

It is the programmer's —not the compiler's— responsibility to get the connection between new T[n] and delete[] p correct. If you get it wrong, neither a compile-time nor a run-time error message will be generated by the compiler. Heap corruption is a likely result. Or worse. Your program will probably die. 
--------------------------------------------------------------------
69. Can I drop the [] when deleteing array of some built-in type (char, int, etc)?

No! 

Sometimes programmers think that the [] in the delete[] p only exists so the compiler will call the appropriate destructors for all elements in the array. Because of this reasoning, they assume that an array of some built-in type such as char or int can be deleted without the []. E.g., they assume the following is valid code: 


 void userCode(int n)
 {
   char* p = new char[n];
   ...
   delete p;     // ← ERROR! Should be delete[] p !
 } 
But the above code is wrong, and it can cause a disaster at runtime. In particular, the code that's called for delete p is operator delete(void*), but the code that's called for delete[] p is operator delete[](void*). The default behavior for the latter is to call the former, but users are allowed to replace the latter with a different behavior (in which case they would normally also replace the corresponding new code in operator new[](size_t)). If they replaced the delete[] code so it wasn't compatible with the delete code, and you called the wrong one (i.e., if you said delete p rather than delete[] p), you could end up with a disaster at runtime. 

--------------------------------------------------------------------
70. After p = new Fred[n], how does the compiler know there are n objects to be destructed during delete[] p?

Short answer: Magic. 

Long answer: The run-time system stores the number of objects, n, somewhere where it can be retrieved if you only know the pointer, p. There are two popular techniques that do this. Both these techniques are in use by commercial grade compilers, both have tradeoffs, and neither is perfect. These techniques are: 

Over-allocate the array and put n just to the left of the first Fred object. 
Use an associative array with p as the key and n as the value. 
--------------------------------------------------------------------

71. Is it legal (and moral) for a member function to say delete this?

As long as you're careful, it's OK for an object to commit suicide (delete this). 

Here's how I define "careful": 

You must be absolutely 100% positive sure that this object was allocated via new (not by new[], nor by placement new, nor a local object on the stack, nor a global, nor a member of another object; but by plain ordinary new). 
You must be absolutely 100% positive sure that your member function will be the last member function invoked on this object. 
You must be absolutely 100% positive sure that the rest of your member function (after the delete this line) doesn't touch any piece of this object (including calling any other member functions or touching any data members). 
You must be absolutely 100% positive sure that no one even touches the this pointer itself after the delete this line. In other words, you must not examine it, compare it with another pointer, compare it with NULL, print it, cast it, do anything with it. 
Naturally the usual caveats apply in cases where your this pointer is a pointer to a base class when you don't have a virtual destructor. 

--------------------------------------------------------------------
72. How do I allocate multidimensional arrays using new?

There are many ways to do this, depending on how flexible you want the array sizing to be. On one extreme, if you know all the dimensions at compile-time, you can allocate multidimensional arrays statically (as in C): 


 class Fred { /*...*/ };
 void someFunction(Fred& fred);
 
 void manipulateArray()
 {
   const unsigned nrows = 10;  // Num rows is a compile-time constant
   const unsigned ncols = 20;  // Num columns is a compile-time constant
   Fred matrix[nrows][ncols];
 
   for (unsigned i = 0; i < nrows; ++i) {
     for (unsigned j = 0; j < ncols; ++j) {
       // Here's the way you access the (i,j) element:
       someFunction( matrix[i][j] );
 
       // You can safely "return" without any special delete code:
       if (today == "Tuesday" && moon.isFull())
         return;     // Quit early on Tuesdays when the moon is full
     }
   }
 
   // No explicit delete code at the end of the function either
 } 
More commonly, the size of the matrix isn't known until run-time but you know that it will be rectangular. In this case you need to use the heap ("freestore"), but at least you are able to allocate all the elements in one freestore chunk. 


 void manipulateArray(unsigned nrows, unsigned ncols)
 {
   Fred* matrix = new Fred[nrows * ncols];
 
   // Since we used a simple pointer above, we need to be VERY
   // careful to avoid skipping over the delete code.
   // That's why we catch all exceptions:
   try {
 
     // Here's how to access the (i,j) element:
     for (unsigned i = 0; i < nrows; ++i) {
       for (unsigned j = 0; j < ncols; ++j) {
         someFunction( matrix[i*ncols + j] );
       }
     }
 
     // If you want to quit early on Tuesdays when the moon is full,
     // make sure to do the delete along ALL return paths:
     if (today == "Tuesday" && moon.isFull()) {
       delete[] matrix;
       return;
     }
 
     ...insert code here to fiddle with the matrix...
 
   }
   catch (...) {
     // Make sure to do the delete when an exception is thrown:
     delete[] matrix;
     throw;    // Re-throw the current exception
   }
 
   // Make sure to do the delete at the end of the function too:
   delete[] matrix;
 } 
Finally at the other extreme, you may not even be guaranteed that the matrix is rectangular. For example, if each row could have a different length, you'll need to allocate each row individually. In the following function, ncols[i] is the number of columns in row number i, where i varies between 0 and nrows-1 inclusive. 


 void manipulateArray(unsigned nrows, unsigned ncols[])
 {
   typedef Fred* FredPtr;
 
   // There will not be a leak if the following throws an exception:
   FredPtr* matrix = new FredPtr[nrows];
 
   // Set each element to NULL in case there is an exception later.
   // (See comments at the top of the try block for rationale.)
   for (unsigned i = 0; i < nrows; ++i)
     matrix[i] = NULL;
 
   // Since we used a simple pointer above, we need to be
   // VERY careful to avoid skipping over the delete code.
   // That's why we catch all exceptions:
   try {
 
     // Next we populate the array.  If one of these throws, all
     // the allocated elements will be deleted (see catch below).
     for (unsigned i = 0; i < nrows; ++i)
       matrix[i] = new Fred[ ncols[i] ];
 
     // Here's how to access the (i,j) element:
     for (unsigned i = 0; i < nrows; ++i) {
       for (unsigned j = 0; j < ncols[i]; ++j) {
         someFunction( matrix[i][j] );
       }
     }
 
     // If you want to quit early on Tuesdays when the moon is full,
     // make sure to do the delete along ALL return paths:
     if (today == "Tuesday" && moon.isFull()) {
       for (unsigned i = nrows; i > 0; --i)
         delete[] matrix[i-1];
       delete[] matrix;
       return;
     }
 
     ...insert code here to fiddle with the matrix...
 
   }
   catch (...) {
     // Make sure to do the delete when an exception is thrown:
     // Note that some of these matrix[...] pointers might be
     // NULL, but that's okay since it's legal to delete NULL.
     for (unsigned i = nrows; i > 0; --i)
       delete[] matrix[i-1];
     delete[] matrix;
     throw;    // Re-throw the current exception
   }
 
   // Make sure to do the delete at the end of the function too.
   // Note that deletion is the opposite order of allocation:
   for (unsigned i = nrows; i > 0; --i)
     delete[] matrix[i-1];
   delete[] matrix;
 } 
Note the funny use of matrix[i-1] in the deletion process. This prevents wrap-around of the unsigned value when i goes one step below zero. 

Finally, note that pointers and arrays are evil. It is normally much better to encapsulate your pointers in a class that has a safe and simple interface. The following FAQ shows how to do this. 

--------------------------------------------------------------------
73. But the previous FAQ's code is SOOOO tricky and error prone! Isn't there a simpler way?
Yep. 

The reason the code in the previous FAQ was so tricky and error prone was that it used pointers, and we know that pointers and arrays are evil. The solution is to encapsulate your pointers in a class that has a safe and simple interface. For example, we can define a Matrix class that handles a rectangular matrix so our user code will be vastly simplified when compared to the the rectangular matrix code from the previous FAQ: 


 // The code for class Matrix is shown below...
 void someFunction(Fred& fred);
 
 void manipulateArray(unsigned nrows, unsigned ncols)
 {
   Matrix matrix(nrows, ncols);   // Construct a Matrix called matrix
 
   for (unsigned i = 0; i < nrows; ++i) {
     for (unsigned j = 0; j < ncols; ++j) {
       // Here's the way you access the (i,j) element:
       someFunction( matrix(i,j) );
 
       // You can safely "return" without any special delete code:
       if (today == "Tuesday" && moon.isFull())
         return;     // Quit early on Tuesdays when the moon is full
     }
   }
 
   // No explicit delete code at the end of the function either
 } 
The main thing to notice is the lack of clean-up code. For example, there aren't any delete statements in the above code, yet there will be no memory leaks, assuming only that the Matrix destructor does its job correctly. 

Here's the Matrix code that makes the above possible: 


 class Matrix {
 public:
   Matrix(unsigned nrows, unsigned ncols);
   // Throws a BadSize object if either size is zero
   class BadSize { };
 
   // Based on the Law Of The Big Three:
  ~Matrix();
   Matrix(const Matrix& m);
   Matrix& operator= (const Matrix& m);
 
   // Access methods to get the (i,j) element:
   Fred&       operator() (unsigned i, unsigned j);
   const Fred& operator() (unsigned i, unsigned j) const;
   // These throw a BoundsViolation object if i or j is too big
   class BoundsViolation { };
 
 private:
   Fred* data_;
   unsigned nrows_, ncols_;
 };
 
 inline Fred& Matrix::operator() (unsigned row, unsigned col)
 {
   if (row >= nrows_ || col >= ncols_) throw BoundsViolation();
   return data_[row*ncols_ + col];
 }
 
 inline const Fred& Matrix::operator() (unsigned row, unsigned col) const
 {
   if (row >= nrows_ || col >= ncols_) throw BoundsViolation();
   return data_[row*ncols_ + col];
 }
 
 Matrix::Matrix(unsigned nrows, unsigned ncols)
   : data_  (new Fred[nrows * ncols]),
     nrows_ (nrows),
     ncols_ (ncols)
 {
   if (nrows == 0 || ncols == 0)
     throw BadSize();
 }
 
 Matrix::~Matrix()
 {
   delete[] data_;
 } 
Note that the above Matrix class accomplishes two things: it moves some tricky memory management code from the user code (e.g., main()) to the class, and it reduces the overall bulk of program. The latter point is important. For example, assuming Matrix is even mildly reusable, moving complexity from the users [plural] of Matrix into Matrix itself [singular] is equivalent to moving complexity from the many to the few. Anyone who's seen Star Trek 2 knows that the good of the many outweighs the good of the few... or the one

--------------------------------------------------------------------

74.Why should I use container classes rather than simple arrays?

Because arrays are evil. 

Let's assume the best case scenario: you're an experienced C programmer, which almost by definition means you're pretty good at working with arrays. You know you can handle the complexity; you've done it for years. And you're smart — the smartest on the team — the smartest in the whole company. But even given all that, please read this entire FAQ and think very carefully about it before you go into "business as usual" mode. 

Fundamentally it boils down to this simple fact: C++ is not C. That means (this might be painful for you!!) you'll need to set aside some of your hard earned wisdom from your vast experience in C. The two languages simply are different. The "best" way to do something in C is not always the same as the "best" way to do it in C++. If you really want to program in C, please do yourself a favor and program in C. But if you want to be really good at C++, then learn the C++ ways of doing things. You may be a C guru, but if you're just learning C++, you're just learning C++ — you're a newbie. (Ouch; I know that had to hurt. Sorry.) 

Here's what you need to realize about containers vs. arrays: 

Container classes make programmers more productive. So if you insist on using arrays while those around are willing to use container classes, you'll probably be less productive than they are (even if you're smarter and more experienced than they are!). 
Container classes let programmers write more robust code. So if you insist on using arrays while those around are willing to use container classes, your code will probably have more bugs than their code (even if you're smarter and more experienced). 
And if you're so smart and so experienced that you can use arrays as fast and as safe as they can use container classes, someone else will probably end up maintaining your code and they'll probably introduce bugs. Or worse, you'll be the only one who can maintain your code so management will yank you from development and move you into a full-time maintenance role — just what you always wanted! 
Here are some specific problems with arrays: 

Subscripts don't get checked to see if they are out of bounds. (Note that some container classes, such as std::vector, have methods to access elements with or without bounds checking on subscripts.) 
Arrays often require you to allocate memory from the heap (see below for examples), in which case you must manually make sure the allocation is eventually deleted (even when someone throws an exception). When you use container classes, this memory management is handled automatically, but when you use arrays, you have to manually write a bunch of code (and unfortunately that code is often subtle and tricky) to deal with this. For example, in addition to writing the code that destroys all the objects and deletes the memory, arrays often also force you you to write an extra try block with a catch clause that destroys all the objects, deletes the memory, then re-throws the exception. This is a real pain in the neck, as shown here. When using container classes, things are much easier. 
You can't insert an element into the middle of the array, or even add one at the end, unless you allocate the array via the heap, and even then you must allocate a new array and copy the elements. 
Container classes give you the choice of passing them by reference or by value, but arrays do not give you that choice: they are always passed by reference. If you want to simulate pass-by-value with an array, you have to manually write code that explicitly copies the array's elements (possibly allocating from the heap), along with code to clean up the copy when you're done with it. All this is handled automatically for you if you use a container class. 
If your function has a non-static local array (i.e., an "auto" array), you cannot return that array, whereas the same is not true for objects of container classes. 
Here are some things to think about when using containers: 

Different C++ containers have different strengths and weaknesses, but for any given job there's usually one of them that is better — clearer, safer, easier/cheaper to maintain, and often more efficient — than an array. For instance, 
You might consider a std::map instead of manually writing code for a lookup table. 
A std::map might also be used for a sparse array or sparse matrix. 
A std::vector is the most array-like of the standard container classes, but it also offers various extra features such as bounds checking via the at() member function, insertions/removals of elements, automatic memory management even if someone throws an exception, ability to be passed both by reference and by value, etc. 
A std::string is almost always better than an array of char (you can think of a std::string as a "container class" for the sake of this discussion). 
Container classes aren't best for everything, and sometimes you may need to use arrays. But that should be very rare, and if/when it happens: 
Please design your container class's public interface in such a way that the code that uses the container class is unaware of the fact that there is an array inside. 
The goal is to "bury" the array inside a container class. In other words, make sure there is a very small number of lines of code that directly touch the array (just your own methods of your container class) so everyone else (the users of your container class) can write code that doesn't depend on there being an array inside your container class. 
To net this out, arrays really are evil. You may not think so if you're new to C++. But after you write a big pile of code that uses arrays (especially if you make your code leak-proof and exception-safe), you'll learn — the hard way. Or you'll learn the easy way by believing those who've already done things like that. The choice is yours. 

--------------------------------------------------------------------

75. How can I make a perl-like associative array in C++?

Use the standard class template std::map<Key,Val>: 


 #include <string>
 #include <map>
 #include <iostream>
 
 int main()
 {
   // age is a map from string to int
   std::map<std::string, int, std::less<std::string> >  age;
 
   age["Fred"] = 42;                     // Fred is 42 years old
   age["Barney"] = 37;                   // Barney is 37
 
   if (todayIsFredsBirthday())           // On Fred's birthday,
     ++ age["Fred"];                     //    increment Fred's age
 
   std::cout << "Fred is " << age["Fred"] << " years old\n";
   ...
 } 

--------------------------------------------------------------------

76. Is the storage for a std::vector<T> guaranteed to be contiguous?
Yes. 

This means you the following technique is safe: 


 #include <vector>
 #include "Foo.h"  /* get class Foo */
 
 // old-style code that wants an array
 void f(Foo* array, unsigned numFoos);
 
 void g()
 {
   std::vector<Foo> v;
   ...
   f(&v[0], v.size());  ← safe
 } 
In general, it means you are guaranteed that &v[0] + n == &v[n], where v is a std::vector<T> and n is an integer in the range 0 .. v.size()-1. 

However v.begin() is not guaranteed to be a T*, which means v.begin() is not guaranteed to be the same as &v[0]: 


 void g()
 {
   std::vector<Foo> v;
   ...
   f(v.begin(), v.size());  ← Error!! Not Guaranteed!!
     ^^^^^^^^^-- cough, choke, gag; not guaranteed to be the same as &v[0]
 } 
Do NOT email me and tell me that v.begin() == &v[0] on your particular version of your particular compiler on your particular platform. I don't care, plus that would show that you've totally missing the point. The point is to help you know the kind of code that is guaranteed to work correctly on all standard-conforming implementations, not to study the vagaries of particular implementations. 

Caveat: the above guarantee is currently in the technical corrigendum of the standard and has not, as of this date, officially become a part of the standard. However it will be ratified Real Soon Now. In the mean time, the practically important thing is that existing implementations make the storage contiguous, so safe to assume that &v[0] + n == &v[n]. 
--------------------------------------------------------------------


77. How can I build a <favorite container> of objects of different types?

You can't, but you can fake it pretty well. In C/C++ all arrays are homogeneous (i.e., the elements are all the same type). However, with an extra layer of indirection you can give the appearance of a heterogeneous container (a heterogeneous container is a container where the contained objects are of different types). 

There are two cases with heterogeneous containers. 

The first case occurs when all objects you want to store in a container are publicly derived from a common base class. You can then declare/define your container to hold pointers to the base class. You indirectly store a derived class object in a container by storing the object's address as an element in the container. You can then access objects in the container indirectly through the pointers (enjoying polymorphic behavior). If you need to know the exact type of the object in the container you can use dynamic_cast<> or typeid(). You'll probably need the Virtual Constructor Idiom to copy a container of disparate object types. The downside of this approach is that it makes memory management a little more problematic (who "owns" the pointed-to objects? if you delete these pointed-to objects when you destroy the container, how can you guarantee that no one else has a copy of one of these pointers? if you don't delete these pointed-to objects when you destroy the container, how can you be sure that someone else will eventually do the deleteing?). It also makes copying the container more complex (may actually break the container's copying functions since you don't want to copy the pointers, at least not when the container "owns" the pointed-to objects). 

The second case occurs when the object types are disjoint — they do not share a common base class. The approach here is to use a handle class. The container is a container of handle objects (by value or by pointer, your choice; by value is easier). Each handle object knows how to "hold on to" (i.e. ,maintain a pointer to) one of the objects you want to put in the container. You can use either a single handle class with several different types of pointers as instance data, or a hierarchy of handle classes that shadow the various types you wish to contain (requires the container be of handle base class pointers). The downside of this approach is that it opens up the handle class(es) to maintenance every time you change the set of types that can be contained. The benefit is that you can use the handle class(es) to encapsulate most of the ugliness of memory management and object lifetime. Thus using handle objects may be beneficial even in the first case. 
--------------------------------------------------------------------

78. How can I insert/access/change elements from a linked list/hashtable/etc?

The most important thing to remember is this: don't roll your own from scratch unless there is a compelling reason to do so. In other words, instead of creating your own list or hashtable, use one of the standard class templates such as std::vector<T> or std::list<T> or whatever. 

Assuming you have a compelling reason to build your own container, here's how to handle inserting (or accessing, changing, etc.) the elements. 

To make the discussion concrete, I'll discuss how to insert an element into a linked list. This example is just complex enough that it generalizes pretty well to things like vectors, hash tables, binary trees, etc. 

A linked list makes it easy insert an element before the first or after the last element of the list, but limiting ourselves to these would produce a library that is too weak (a weak library is almost worse than no library). This answer will be a lot to swallow for novice C++'ers, so I'll give a couple of options. The first option is easiest; the second and third are better. 

Empower the List with a "current location," and member functions such as advance(), backup(), atEnd(), atBegin(), getCurrElem(), setCurrElem(Elem), insertElem(Elem), and removeElem(). Although this works in small examples, the notion of a current position makes it difficult to access elements at two or more positions within the list (e.g., "for all pairs x,y do the following..."). 
Remove the above member functions from List itself, and move them to a separate class, ListPosition. ListPosition would act as a "current position" within a list. This allows multiple positions within the same list. ListPosition would be a friend of class List, so List can hide its innards from the outside world (else the innards of List would have to be publicized via public member functions in List). Note: ListPosition can use operator overloading for things like advance() and backup(), since operator overloading is syntactic sugar for normal member functions. 
Consider the entire iteration as an atomic event, and create a class template that embodies this event. This enhances performance by allowing the public access member functions (which may be virtual functions) to be avoided during the access, and this access often occurs within an inner loop. Unfortunately the class template will increase the size of your object code, since templates gain speed by duplicating code. For more, see [Koenig, "Templates as interfaces," JOOP, 4, 5 (Sept 91)], and [Stroustrup, "The C++ Programming Language Third Edition," under "Comparator"]. 
--------------------------------------------------------------------

79. What's the idea behind templates?

A template is a cookie-cutter that specifies how to cut cookies that all look pretty much the same (although the cookies can be made of various kinds of dough, they'll all have the same basic shape). In the same way, a class template is a cookie cutter for a description of how to build a family of classes that all look basically the same, and a function template describes how to build a family of similar looking functions. 

Class templates are often used to build type safe containers (although this only scratches the surface for how they can be used). 
--------------------------------------------------------------------

80. What's the syntax / semantics for a "class template"?

Consider a container class Array that acts like an array of integers: 


 // This would go into a header file such as "Array.h"
 class Array {
 public:
   Array(int len=10)                  : len_(len), data_(new int[len]) { }
  ~Array()                            { delete[] data_; }
   int len() const                    { return len_;     }
   const int& operator[](int i) const { return data_[check(i)]; }
         int& operator[](int i)       { return data_[check(i)]; }
   Array(const Array&);
   Array& operator= (const Array&);
 private:
   int  len_;
   int* data_;
   int  check(int i) const
     { if (i < 0 || i >= len_) throw BoundsViol("Array", i, len_);
       return i; }
 }; 
Repeating the above over and over for Array of float, of char, of std::string, of Array-of-std::string, etc, will become tedious. 


 // This would go into a header file such as "Array.h"
 template<class T>
 class Array {
 public:
   Array(int len=10)                : len_(len), data_(new T[len]) { }
  ~Array()                          { delete[] data_; }
   int len() const                  { return len_;     }
   const T& operator[](int i) const { return data_[check(i)]; }
         T& operator[](int i)       { return data_[check(i)]; }
   Array(const Array<T>&);
   Array<T>& operator= (const Array<T>&);
 private:
   int len_;
   T*  data_;
   int check(int i) const
     { if (i < 0 || i >= len_) throw BoundsViol("Array", i, len_);
       return i; }
 }; 
Unlike template functions, template classes (instantiations of class templates) need to be explicit about the parameters over which they are instantiating: 


 int main()
 {
   Array<int>           ai;
   Array<float>         af;
   Array<char*>         ac;
   Array<std::string>   as;
   Array< Array<int> >  aai;
   ...
 } 
Note the space between the two >'s in the last example. Without this space, the compiler would see a >> (right-shift) token instead of two >'s. 
--------------------------------------------------------------------

81. What's the syntax / semantics for a "function template"?

Consider this function that swaps its two integer arguments: 


 void swap(int& x, int& y)
 {
   int tmp = x;
   x = y;
   y = tmp;
 } 
If we also had to swap floats, longs, Strings, Sets, and FileSystems, we'd get pretty tired of coding lines that look almost identical except for the type. Mindless repetition is an ideal job for a computer, hence a function template: 


 template<class T>
 void swap(T& x, T& y)
 {
   T tmp = x;
   x = y;
   y = tmp;
 } 
Every time we used swap() with a given pair of types, the compiler will go to the above definition and will create yet another "template function" as an instantiation of the above. E.g., 


 int main()
 {
   int         i,j;  /*...*/  swap(i,j);  // Instantiates a swap for int
   float       a,b;  /*...*/  swap(a,b);  // Instantiates a swap for float
   char        c,d;  /*...*/  swap(c,d);  // Instantiates a swap for char
   std::string s,t;  /*...*/  swap(s,t);  // Instantiates a swap for std::string
   ...
 } 
Note: A "template function" is the instantiation of a "function template". 
--------------------------------------------------------------------

82. How do I explicitly select which version of a function template should get called?

When you call a function template, the compiler tries to deduce the template type. Most of the time it can do that successfully, but every once in a while you may want to help the compiler deduce the right type — either because it cannot deduce the type at all, or perhaps because it would deduce the wrong type. 

For example, you might be calling a function template that doesn't have any parameters of its template argument types, or you might want to force the compiler to do certain promotions on the arguments before selecting the correct function template. In these cases you'll need to explicitly tell the compiler which instantiation of the function template should be called. 

Here is a sample function template where the template parameter T does not appear in the function's parameter list. In this case the compiler cannot deduce the template parameter types when the function is called. 


 template<class T>
 void f()
 {
   ...
 } 
To call this function with T being an int or a std::string, you could say: 


 #include <string>
 
 void sample()
 {
   f<int>();          // type T will be int in this call
   f<std::string>();  // type T will be std::string in this call
 } 
Here is another function whose template parameters appear in the function's list of formal parameters (that is, the compiler can deduce the template type from the actual arguments): 


 template<class T>
 void g(T x)
 {
   ...
 } 
Now if you want to force the actual arguments to be promoted before the compiler deduces the template type, you can use the above technique. E.g., if you simply called g(42) you would get g<int>(42), but if you wanted to pass 42 to g<long>(), you could say this: g<long>(42). (Of course you could also promote the parameter explicitly, such as either g(long(42)) or even g(42L), but that ruins the example.) 

Similarly if you said g("xyz") you'd end up calling g<char*>(char*), but if you wanted to call the std::string version of g<>() you could say g<std::string>("xyz"). (Again you could also promote the argument, such as g(std::string("xyz")), but that's another story.) 

--------------------------------------------------------------------
83. What is a "parameterized type"?

Another way to say, "class templates." 

A parameterized type is a type that is parameterized over another type or some value. List<int> is a type (List) parameterized over another type (int). 
--------------------------------------------------------------------

84. What is "genericity"?

Yet another way to say, "class templates." 

Not to be confused with "generality" (which just means avoiding solutions which are overly specific), "genericity" means class templates. 

--------------------------------------------------------------------
85. Why can't I separate the definition of my templates class from it's declaration and put it inside a .cpp file?

If all you want to know is how to fix this situation, read the next FAQ. But in order to understand why things are the way they are, first accept these facts: 

A template is not a class or a function. A template is a "pattern" that the compiler uses to generate a family of classes or functions. 
In order for the compiler to generate the code, it must see both the template definition (not just declaration) and the specific types/whatever used to "fill in" the template. For example, if you're trying to use a Foo<int>, the compiler must see both the Foo template and the fact that you're trying to make a specific Foo<int>. 
Your compiler probably doesn't remember the details of one .cpp file while it is compiling another .cpp file. It could, but most do not and if you are reading this FAQ, it almost definitely does not. BTW this is called the "separate compilation model." 
Now based on those facts, here's an example that shows why things are the way they are. Suppose you have a template Foo defined like this: 


 template<class T>
 class Foo {
 public:
   Foo();
   void someMethod(T x);
 private:
   T x;
 }; 
Along with similar definitions for the member functions: 


 template<class T>
 Foo<T>::Foo()
 {
   ...
 }
 
 template<class T>
 void Foo<T>::someMethod(T x)
 {
   ...
 } 
Now suppose you have some code in file Bar.cpp that uses Foo<int>: 


 // Bar.cpp
 
 void blah_blah_blah()
 {
   ...
   Foo<int> f;
   f.someMethod(5);
   ...
 } 
Clearly somebody somewhere is going to have to use the "pattern" for the constructor definition and for the someMethod() definition and instantiate those when T is actually int. But if you had put the definition of the constructor and someMethod() into file Foo.cpp, the compiler would see the template code when it compiled Foo.cpp and it would see Foo<int> when it compiled Bar.cpp, but there would never be a time when it saw both the template code and Foo<int>. So by rule #2 above, it could never generate the code for Foo<int>::someMethod(). 

A note to the experts: I have obviously made several simplifications above. This was intentional so please don't complain too loudly. If you know the difference between a .cpp file and a compilation unit, the difference between a class template and a template class, and the fact that templates really aren't just glorified macros, then don't complain: this particular question/answer wasn't aimed at you to begin with. I simplified things so newbies would "get it," even if doing so offends some experts. 
--------------------------------------------------------------------
86. How can I avoid linker errors with my template functions?

Tell your C++ compiler which instantiations to make while it is compiling your template function's .cpp file. 

As an example, consider the header file foo.h which contains the following template function declaration: 


 // file "foo.h"
 template<class T>
 extern void foo(); 
Now suppose file foo.cpp actually defines that template function: 


 // file "foo.cpp"
 #include <iostream>
 #include "foo.h"
 
 template<class T>
 void foo()
 {
   std::cout << "Here I am!\n";
 } 
Suppose file main.cpp uses this template function by calling foo<int>(): 


 // file "main.cpp"
 #include "foo.h"
 
 int main()
 {
   foo<int>();
   ...
 } 
If you compile and (try to) link these two .cpp files, most compilers will generate linker errors. There are three solutions for this. The first solution is to physically move the definition of the template function into the .h file, even if it is not an inline function. This solution may (or may not!) cause significant code bloat, meaning your executable size may increase dramatically (or, if your compiler is smart enough, may not; try it and see). 

The other solution is to leave the definition of the template function in the .cpp file and simply add the line template void foo<int>(); to that file: 


 // file "foo.cpp"
 #include <iostream>
 #include "foo.h"
 
 template<class T> void foo()
 {
   std::cout << "Here I am!\n";
 }
 
 template void foo<int>(); 
If you can't modify foo.cpp, simply create a new .cpp file such as foo-impl.cpp as follows: 


 // file "foo-impl.cpp"
 #include "foo.cpp"
 
 template void foo<int>(); 
Notice that foo-impl.cpp #includes a .cpp file, not a .h file. If that's confusing, click your heels twice, think of Kansas, and repeat after me, "I will do it anyway even though it's confusing." You can trust me on this one. But if you don't trust me or are simply curious, the rationale is given earlier. 
--------------------------------------------------------------------

87. How can I avoid linker errors with my template classes?

Tell your C++ compiler which instantiations to make while it is compiling your template class's .cpp file. 

(If you've already read the previous FAQ, this answer is completely symmetric with that one, so you can probably skip this answer.) 

As an example, consider the header file Foo.h which contains the following template class. Note that method Foo<T>::f() is inline and methods Foo<T>::g() and Foo<T>::h() are not. 


 // file "Foo.h"
 template<class T>
 class Foo {
 public:
   void f();
   void g();
   void h();
 };
 
 template<class T>
 inline
 void Foo<T>::f()
 {
   ...
 } 
Now suppose file Foo.cpp actually defines the non-inline methods Foo<T>::g() and Foo<T>::h(): 


 // file "Foo.cpp"
 #include <iostream>
 #include "Foo.h"
 
 template<class T>
 void Foo<T>::g()
 {
   std::cout << "Foo<T>::g()\n";
 }
 
 template<class T>
 void Foo<T>::h()
 {
   std::cout << "Foo<T>::h()\n";
 } 
Suppose file main.cpp uses this template class by creating a Foo<int> and calling its methods: 


 // file "main.cpp"
 #include "Foo.h"
 
 int main()
 {
   Foo<int> x;
   x.f();
   x.g();
   x.h();
   ...
 } 
If you compile and (try to) link these two .cpp files, most compilers will generate linker errors. There are three solutions for this. The first solution is to physically move the definition of the template functions into the .h file, even if they are not inline functions. This solution may (or may not!) cause significant code bloat, meaning your executable size may increase dramatically (or, if your compiler is smart enough, may not; try it and see). 

The other solution is to leave the definition of the template function in the .cpp file and simply add the line template Foo<int>; to that file: 


 // file "Foo.cpp"
 #include <iostream>
 #include "Foo.h"
 
 ...definition of Foo<T>::f() is unchanged -- see above...
 ...definition of Foo<T>::g() is unchanged -- see above...
 
 template Foo<int>; 
If you can't modify Foo.cpp, simply create a new .cpp file such as Foo-impl.cpp as follows: 


 // file "Foo-impl.cpp"
 #include "Foo.cpp"
 
 template Foo<int>; 
Notice that Foo-impl.cpp #includes a .cpp file, not a .h file. If that's confusing, click your heels twice, think of Kansas, and repeat after me, "I will do it anyway even though it's confusing." You can trust me on this one. But if you don't trust me or are simply curious, the rationale is given earlier. 
--------------------------------------------------------------------

88.But the above Matrix class is specific to Fred! Isn't there a way to make it generic?

Yep; just use templates: 

Here's how this can be used: 


 #include "Fred.hpp"     // To get the definition for class Fred
 
 // The code for Matrix<T> is shown below...
 void someFunction(Fred& fred);
 
 void manipulateArray(unsigned nrows, unsigned ncols)
 {
   Matrix<Fred> matrix(nrows, ncols);   // Construct a Matrix<Fred> called matrix
 
   for (unsigned i = 0; i < nrows; ++i) {
     for (unsigned j = 0; j < ncols; ++j) {
       // Here's the way you access the (i,j) element:
       someFunction( matrix(i,j) );
 
       // You can safely "return" without any special delete code:
       if (today == "Tuesday" && moon.isFull())
         return;     // Quit early on Tuesdays when the moon is full
     }
   }
 
   // No explicit delete code at the end of the function either
 } 
Now it's easy to use Matrix<T> for things other than Fred. For example, the following uses a Matrix of std::string (where std::string is the standard string class): 


 #include <string>
 
 void someFunction(std::string& s);
 
 void manipulateArray(unsigned nrows, unsigned ncols)
 {
   Matrix<std::string> matrix(nrows, ncols);   // Construct a Matrix<std::string>
 
   for (unsigned i = 0; i < nrows; ++i) {
     for (unsigned j = 0; j < ncols; ++j) {
       // Here's the way you access the (i,j) element:
       someFunction( matrix(i,j) );
 
       // You can safely "return" without any special delete code:
       if (today == "Tuesday" && moon.isFull())
         return;     // Quit early on Tuesdays when the moon is full
     }
   }
 
   // No explicit delete code at the end of the function either
 } 
You can thus get an entire family of classes from a template. For example, Matrix<Fred>, Matrix<std::string>, Matrix< Matrix<std::string> >, etc. 

Here's one way that the template can be implemented: 


 template<class T>  // See section on templates for more
 class Matrix {
 public:
   Matrix(unsigned nrows, unsigned ncols);
   // Throws a BadSize object if either size is zero
   class BadSize { };
 
   // Based on the Law Of The Big Three:
  ~Matrix();
   Matrix(const Matrix<T>& m);
   Matrix<T>& operator= (const Matrix<T>& m);
 
   // Access methods to get the (i,j) element:
   T&       operator() (unsigned i, unsigned j);
   const T& operator() (unsigned i, unsigned j) const;
   // These throw a BoundsViolation object if i or j is too big
   class BoundsViolation { };
 
 private:
   T* data_;
   unsigned nrows_, ncols_;
 };
 
 template<class T>
 inline T& Matrix<T>::operator() (unsigned row, unsigned col)
 {
   if (row >= nrows_ || col >= ncols_) throw BoundsViolation();
   return data_[row*ncols_ + col];
 }
 
 template<class T>
 inline const T& Matrix<T>::operator() (unsigned row, unsigned col) const
 {
   if (row >= nrows_ || col >= ncols_) throw BoundsViolation();
   return data_[row*ncols_ + col];
 }
 
 template<class T>
 inline Matrix<T>::Matrix(unsigned nrows, unsigned ncols)
   : data_  (new T[nrows * ncols])
   , nrows_ (nrows)
   , ncols_ (ncols)
 {
   if (nrows == 0 || ncols == 0)
     throw BadSize();
 }
 
 template<class T>
 inline Matrix<T>::~Matrix()
 {
   delete[] data_;
 } 

--------------------------------------------------------------------

89 What's another way to build a Matrix template?

Use the standard vector template, and make a vector of vector. 

The following uses a vector<vector<T> > (note the space between the two > symbols). 


 #include <vector>
 
 template<class T>  // See section on templates for more
 class Matrix {
 public:
   Matrix(unsigned nrows, unsigned ncols);
   // Throws a BadSize object if either size is zero
   class BadSize { };
 
   // No need for any of The Big Three!
 
   // Access methods to get the (i,j) element:
   T&       operator() (unsigned i, unsigned j);
   const T& operator() (unsigned i, unsigned j) const;
   // These throw a BoundsViolation object if i or j is too big
   class BoundsViolation { };
 
 private:
   std::vector<vector<T> > data_;
 };
 
 template<class T>
 inline T& Matrix<T>::operator() (unsigned row, unsigned col)
 {
   if (row >= nrows_ || col >= ncols_) throw BoundsViolation();
   return data_[row][col];
 }
 
 template<class T>
 inline const T& Matrix<T>::operator() (unsigned row, unsigned col) const
 {
   if (row >= nrows_ || col >= ncols_) throw BoundsViolation();
   return data_[row][col];
 }
 
 template<class T>
 Matrix<T>::Matrix(unsigned nrows, unsigned ncols)
   : data_ (nrows)
 {
   if (nrows == 0 || ncols == 0)
     throw BadSize();
   for (unsigned i = 0; i < nrows; ++i)
     data_[i].resize(ncols);
 } 
--------------------------------------------------------------------

90. Does C++ have arrays whose length can be specified at run-time?

Yes, in the sense that the standard library has a std::vector template that provides this behavior. 

No, in the sense that built-in array types need to have their length specified at compile time. 

Yes, in the sense that even built-in array types can specify the first index bounds at run-time. E.g., comparing with the previous FAQ, if you only need the first array dimension to vary then you can just ask new for an array of arrays, rather than an array of pointers to arrays: 


 const unsigned ncols = 100;           // ncols = number of columns in the array
 
 class Fred { /*...*/ };
 
 void manipulateArray(unsigned nrows)  // nrows = number of rows in the array
 {
   Fred (*matrix)[ncols] = new Fred[nrows][ncols];
   ...
   delete[] matrix;
 } 
You can't do this if you need anything other than the first dimension of the array to change at run-time. 

But please, don't use arrays unless you have to. Arrays are evil. Use some object of some class if you can. Use arrays only when you have to. 

--------------------------------------------------------------------
91. How can I force objects of my class to always be created via new rather than as locals or global/static objects?

Use the Named Constructor Idiom. 

As usual with the Named Constructor Idiom, the constructors are all private or protected, and there are one or more public static create() methods (the so-called "named constructors"), one per constructor. In this case the create() methods allocate the objects via new. Since the constructors themselves are not public, there is no other way to create objects of the class. 


 class Fred {
 public:
   // The create() methods are the "named constructors":
   static Fred* create()                 { return new Fred();     }
   static Fred* create(int i)            { return new Fred(i);    }
   static Fred* create(const Fred& fred) { return new Fred(fred); }
   ...
 
 private:
   // The constructors themselves are private or protected:
   Fred();
   Fred(int i);
   Fred(const Fred& fred);
   ...
 }; 
Now the only way to create Fred objects is via Fred::create(): 


 int main()
 {
   Fred* p = Fred::create(5);
   ...
   delete p;
   ...
 } 
Make sure your constructors are in the protected section if you expect Fred to have derived classes. 

Note also that you can make another class Wilma a friend of Fred if you want to allow a Wilma to have a member object of class Fred, but of course this is a softening of the original goal, namely to force Fred objects to be allocated via new. 

--------------------------------------------------------------------
92. How do I do simple reference counting?

If all you want is the ability to pass around a bunch of pointers to the same object, with the feature that the object will automagically get deleted when the last pointer to it disappears, you can use something like the following "smart pointer" class: 


 // Fred.h
 
 class FredPtr;
 
 class Fred {
 public:
   Fred() : count_(0) /*...*/ { }  // All ctors set count_ to 0 !
   ...
 private:
   friend FredPtr;     // A friend class
   unsigned count_;
   // count_ must be initialized to 0 by all constructors
   // count_ is the number of FredPtr objects that point at this
 };
 
 class FredPtr {
 public:
   Fred* operator-> () { return p_; }
   Fred& operator* ()  { return *p_; }
   FredPtr(Fred* p)    : p_(p) { ++p_->count_; }  // p must not be NULL
  ~FredPtr()           { if (--p_->count_ == 0) delete p_; }
   FredPtr(const FredPtr& p) : p_(p.p_) { ++p_->count_; }
   FredPtr& operator= (const FredPtr& p)
         { // DO NOT CHANGE THE ORDER OF THESE STATEMENTS!
           // (This order properly handles self-assignment)
           ++p.p_->count_;
           if (--p_->count_ == 0) delete p_;
           p_ = p.p_;
           return *this;
         }
 private:
   Fred* p_;    // p_ is never NULL
 }; 
Naturally you can use nested classes to rename FredPtr to Fred::Ptr. 

Note that you can soften the "never NULL" rule above with a little more checking in the constructor, copy constructor, assignment operator, and destructor. If you do that, you might as well put a p_ != NULL check into the "*" and "->" operators (at least as an assert()). I would recommend against an operator Fred*() method, since that would let people accidentally get at the Fred*. 

One of the implicit constraints on FredPtr is that it must only point to Fred objects which have been allocated via new. If you want to be really safe, you can enforce this constraint by making all of Fred's constructors private, and for each constructor have a public (static) create() method which allocates the Fred object via new and returns a FredPtr (not a Fred*). That way the only way anyone could create a Fred object would be to get a FredPtr ("Fred* p = new Fred()" would be replaced by "FredPtr p = Fred::create()"). Thus no one could accidentally subvert the reference counted mechanism. 

For example, if Fred had a Fred::Fred() and a Fred::Fred(int i, int j), the changes to class Fred would be: 


 class Fred {
 public:
   static FredPtr create();              // Defined below class FredPtr {...};
   static FredPtr create(int i, int j);  // Defined below class FredPtr {...};
   ...
 private:
   Fred();
   Fred(int i, int j);
   ...
 };
 
 class FredPtr { /* ... */ };
 
 inline FredPtr Fred::create()             { return new Fred(); }
 inline FredPtr Fred::create(int i, int j) { return new Fred(i,j); } 
The end result is that you now have a way to use simple reference counting to provide "pointer semantics" for a given object. Users of your Fred class explicitly use FredPtr objects, which act more or less like Fred* pointers. The benefit is that users can make as many copies of their FredPtr "smart pointer" objects, and the pointed-to Fred object will automagically get deleted when the last such FredPtr object vanishes. 

If you'd rather give your users "reference semantics" rather than "pointer semantics," you can use reference counting to provide "copy on write". 

--------------------------------------------------------------------
93. How do I provide reference counting with copy-on-write semantics?

Reference counting can be done with either pointer semantics or reference semantics. The previous FAQ shows how to do reference counting with pointer semantics. This FAQ shows how to do reference counting with reference semantics. 

The basic idea is to allow users to think they're copying your Fred objects, but in reality the underlying implementation doesn't actually do any copying unless and until some user actually tries to modify the underlying Fred object. 

Class Fred::Data houses all the data that would normally go into the Fred class. Fred::Data also has an extra data member, count_, to manage the reference counting. Class Fred ends up being a "smart reference" that (internally) points to a Fred::Data. 


 class Fred {
 public:
 
   Fred();                               // A default constructor
   Fred(int i, int j);                   // A normal constructor
 
   Fred(const Fred& f);
   Fred& operator= (const Fred& f);
  ~Fred();
 
   void sampleInspectorMethod() const;   // No changes to this object
   void sampleMutatorMethod();           // Change this object
 
   ...
 
 private:
 
   class Data {
   public:
     Data();
     Data(int i, int j);
     Data(const Data& d);
 
     // Since only Fred can access a Fred::Data object,
     // you can make Fred::Data's data public if you want.
     // But if that makes you uncomfortable, make the data private
     // and make Fred a friend class via friend Fred;
     ...data goes here...
 
     unsigned count_;
     // count_ is the number of Fred objects that point at this
     // count_ must be initialized to 1 by all constructors
     // (it starts as 1 since it is pointed to by the Fred object that created it)
   };
 
   Data* data_;
 };
 
 Fred::Data::Data()              : count_(1) /*init other data*/ { }
 Fred::Data::Data(int i, int j)  : count_(1) /*init other data*/ { }
 Fred::Data::Data(const Data& d) : count_(1) /*init other data*/ { }
 
 Fred::Fred()             : data_(new Data()) { }
 Fred::Fred(int i, int j) : data_(new Data(i, j)) { }
 
 Fred::Fred(const Fred& f)
   : data_(f.data_)
 {
   ++ data_->count_;
 }
 
 Fred& Fred::operator= (const Fred& f)
 {
   // DO NOT CHANGE THE ORDER OF THESE STATEMENTS!
   // (This order properly handles self-assignment)
   ++ f.data_->count_;
   if (--data_->count_ == 0) delete data_;
   data_ = f.data_;
   return *this;
 }
 
 Fred::~Fred()
 {
   if (--data_->count_ == 0) delete data_;
 }
 
 void Fred::sampleInspectorMethod() const
 {
   // This method promises ("const") not to change anything in *data_
   // Other than that, any data access would simply use "data_->..."
 }
 
 void Fred::sampleMutatorMethod()
 {
   // This method might need to change things in *data_
   // Thus it first checks if this is the only pointer to *data_
   if (data_->count_ > 1) {
     Data* d = new Data(*data_);    // Invoke Fred::Data's copy ctor
     -- data_->count_;
     data_ = d;
   }
   assert(data_->count_ == 1);
 
   // Now the method proceeds to access "data_->..." as normal
 } 
If it is fairly common to call Fred's default constructor, you can avoid all those new calls by sharing a common Fred::Data object for all Freds that are constructed via Fred::Fred(). To avoid static initialization order problems, this shared Fred::Data object is created "on first use" inside a function. Here are the changes that would be made to the above code (note that the shared Fred::Data object's destructor is never invoked; if that is a problem, either hope you don't have any static initialization order problems, or drop back to the approach described above): 


 class Fred {
 public:
   ...
 private:
   ...
   static Data* defaultData();
 };
 
 Fred::Fred()
 : data_(defaultData())
 {
   ++ data_->count_;
 }
 
 Fred::Data* Fred::defaultData()
 {
   static Data* p = NULL;
   if (p == NULL) {
     p = new Data();
     ++ p->count_;    // Make sure it never goes to zero
   }
   return p;
 } 
Note: You can also provide reference counting for a hierarchy of classes if your Fred class would normally have been a base class. 
--------------------------------------------------------------------
94. How do I provide reference counting with copy-on-write semantics for a hierarchy of classes?

The previous FAQ presented a reference counting scheme that provided users with reference semantics, but did so for a single class rather than for a hierarchy of classes. This FAQ extends the previous technique to allow for a hierarchy of classes. The basic difference is that Fred::Data is now the root of a hierarchy of classes, which probably cause it to have some virtual functions. Note that class Fred itself will still not have any virtual functions. 

The Virtual Constructor Idiom is used to make copies of the Fred::Data objects. To select which derived class to create, the sample code below uses the Named Constructor Idiom, but other techniques are possible (a switch statement in the constructor, etc). The sample code assumes two derived classes: Der1 and Der2. Methods in the derived classes are unaware of the reference counting. 


 class Fred {
 public:
 
   static Fred create1(const std::string& s, int i);
   static Fred create2(float x, float y);
 
   Fred(const Fred& f);
   Fred& operator= (const Fred& f);
  ~Fred();
 
   void sampleInspectorMethod() const;   // No changes to this object
   void sampleMutatorMethod();           // Change this object
 
   ...
 
 private:
 
   class Data {
   public:
     Data() : count_(1) { }
     Data(const Data& d) : count_(1) { }              // Do NOT copy the 'count_' member!
     Data& operator= (const Data&) { return *this; }  // Do NOT copy the 'count_' member!
     virtual ~Data() { assert(count_ == 0); }         // A virtual destructor
     virtual Data* clone() const = 0;                 // A virtual constructor
     virtual void sampleInspectorMethod() const = 0;  // A pure virtual function
     virtual void sampleMutatorMethod() = 0;
   private:
     unsigned count_;   // count_ doesn't need to be protected
     friend Fred;       // Allow Fred to access count_
   };
 
   class Der1 : public Data {
   public:
     Der1(const std::string& s, int i);
     virtual void sampleInspectorMethod() const;
     virtual void sampleMutatorMethod();
     virtual Data* clone() const;
     ...
   };
 
   class Der2 : public Data {
   public:
     Der2(float x, float y);
     virtual void sampleInspectorMethod() const;
     virtual void sampleMutatorMethod();
     virtual Data* clone() const;
     ...
   };
 
   Fred(Data* data);
   // Creates a Fred smart-reference that owns *data
   // It is private to force users to use a createXXX() method
   // Requirement: data must not be NULL
 
   Data* data_;   // Invariant: data_ is never NULL
 };
 
 Fred::Fred(Data* data) : data_(data)  { assert(data != NULL); }
 
 Fred Fred::create1(const std::string& s, int i) { return Fred(new Der1(s, i)); }
 Fred Fred::create2(float x, float y)            { return Fred(new Der2(x, y)); }
 
 Fred::Data* Fred::Der1::clone() const { return new Der1(*this); }
 Fred::Data* Fred::Der2::clone() const { return new Der2(*this); }
 
 Fred::Fred(const Fred& f)
   : data_(f.data_)
 {
   ++ data_->count_;
 }
 
 Fred& Fred::operator= (const Fred& f)
 {
   // DO NOT CHANGE THE ORDER OF THESE STATEMENTS!
   // (This order properly handles self-assignment)
   ++ f.data_->count_;
   if (--data_->count_ == 0) delete data_;
   data_ = f.data_;
   return *this;
 }
 
 Fred::~Fred()
 {
   if (--data_->count_ == 0) delete data_;
 }
 
 void Fred::sampleInspectorMethod() const
 {
   // This method promises ("const") not to change anything in *data_
   // Therefore we simply "pass the method through" to *data_:
   data_->sampleInspectorMethod();
 }
 
 void Fred::sampleMutatorMethod()
 {
   // This method might need to change things in *data_
   // Thus it first checks if this is the only pointer to *data_
   if (data_->count_ > 1) {
     Data* d = data_->clone();   // The Virtual Constructor Idiom
     -- data_->count_;
     data_ = d;
   }
   assert(data_->count_ == 1);
 
   // Now we "pass the method through" to *data_:
   data_->sampleInspectorMethod();
 } 
Naturally the constructors and sampleXXX methods for Fred::Der1 and Fred::Der2 will need to be implemented in whatever way is appropriate. 
--------------------------------------------------------------------
95. Can you absolutely prevent people from subverting the reference counting mechanism, and if so, should you?

No, and (normally) no. 

There are two basic approaches to subverting the reference counting mechanism: 

The scheme could be subverted if someone got a Fred* (rather than being forced to use a FredPtr). Someone could get a Fred* if class FredPtr has an operator*() that returns a Fred&: FredPtr p = Fred::create(); Fred* p2 = &*p;. Yes it's bizarre and unexpected, but it could happen. This hole could be closed in two ways: overload Fred::operator&() so it returns a FredPtr, or change the return type of FredPtr::operator*() so it returns a FredRef (FredRef would be a class that simulates a reference; it would need to have all the methods that Fred has, and it would need to forward all those method calls to the underlying Fred object; there might be a performance penalty for this second choice depending on how good the compiler is at inlining methods). Another way to fix this is to eliminate FredPtr::operator*() — and lose the corresponding ability to get and use a Fred&. But even if you did all this, someone could still generate a Fred* by explicitly calling operator->(): FredPtr p = Fred::create(); Fred* p2 = p.operator->();. 
The scheme could be subverted if someone had a leak and/or dangling pointer to a FredPtr Basically what we're saying here is that Fred is now safe, but we somehow want to prevent people from doing stupid things with FredPtr objects. (And if we could solve that via FredPtrPtr objects, we'd have the same problem again with them). One hole here is if someone created a FredPtr using new, then allowed the FredPtr to leak (worst case this is a leak, which is bad but is usually a little better than a dangling pointer). This hole could be plugged by declaring FredPtr::operator new() as private, thus preventing someone from saying new FredPtr(). Another hole here is if someone creates a local FredPtr object, then takes the address of that FredPtr and passed around the FredPtr*. If that FredPtr* lived longer than the FredPtr, you could have a dangling pointer — shudder. This hole could be plugged by preventing people from taking the address of a FredPtr (by overloading FredPtr::operator&() as private), with the corresponding loss of functionality. But even if you did all that, they could still create a FredPtr& which is almost as dangerous as a FredPtr*, simply by doing this: FredPtr p; ... FredPtr& q = p; (or by passing the FredPtr& to someone else). 
And even if we closed all those holes, C++ has those wonderful pieces of syntax called pointer casts. Using a pointer cast or two, a sufficiently motivated programmer can normally create a hole that's big enough to drive a proverbial truck through. (By the way, pointer casts are evil.) 

So the lessons here seems to be: (a) you can't prevent espionage no matter how hard you try, and (b) you can easily prevent mistakes. 

So I recommend settling for the "low hanging fruit": use the easy-to-build and easy-to-use mechanisms that prevent mistakes, and don't bother trying to prevent espionage. You won't succeed, and even if you do, it'll (probably) cost you more than it's worth. 

So if we can't use the C++ language itself to prevent espionage, are there other ways to do it? Yes. I personally use old fashioned code reviews for that. And since the espionage techniques usually involve some bizarre syntax and/or use of pointer-casts and unions, you can use a tool to point out most of the "hot spots." 
--------------------------------------------------------------------

96. Can I use a garbage collector in C++?

Yes. 

Compared with the "smart pointer" techniques (see [16.21], the two kinds of garbage collector techniques (see [16.26]) are: 

less portable 
usually more efficient (especially when the average object size is small or in multithreaded environments) 
able to handle "cycles" in the data (reference counting techniques normally "leak" if the data structures can form a cycle) 
sometimes leak other objects (since the garbage collectors are necessarily conservative, they sometimes see a random bit pattern that appears to be a pointer into an allocation, especially if the allocation is large; this can allow the allocation to leak) 
work better with existing libraries (since smart pointers need to be used explicitly, they may be hard to integrate with existing libraries) 

--------------------------------------------------------------------
97. What are the two kinds of garbage collectors for C++?

In general, there seem to be two flavors of garbage collectors for C++: 

Conservative garbage collectors. These know little or nothing about the layout of the stack or of C++ objects, and simply look for bit patterns that appear to be pointers. In practice they seem to work with both C and C++ code, particularly when the average object size is small. Here are some examples, in alphabetical order: 

Boehm-Demers-Weiser collector 
Geodesic Systems collector 
Hybrid garbage collectors. These usually scan the stack conservatively, but require the programmer to supply layout information for heap objects. This requires more work on the programmer's part, but may result in improved performance. Here are some examples, in alphabetical order: 

Attardi and Flagella's CMM 
Bartlett's mostly copying collector 
Since garbage collectors for C++ are normally conservative, they can sometimes leak if a bit pattern "looks like" it might be a pointer to an otherwise unused block. Also they sometimes get confused when pointers to a block actually point outside the block's extent (which is illegal, but some programmers simply must push the envelope; sigh) and (rarely) when a pointer is hidden by a compiler optimization. In practice these problems are not usually serious, however providing the collector with hints about the layout of the objects can sometimes ameliorate these issues. 
--------------------------------------------------------------------
98.What are some ways try / catch / throw can improve software quality?

By eliminating one of the reasons for if statements. 

The commonly used alternative to try / catch / throw is to return a return code (sometimes called an error code) that the caller explicitly tests via some conditional statement such as if. For example, printf(), scanf() and malloc() work this way: the caller is supposed to test the return value to see if the function succeeded. 

Although the return code technique is sometimes the most appropriate error handling technique, there are some nasty side effects to adding unnecessary if statements: 

Degrade quality: It is well known that conditional statements are approximately ten times more likely to contain errors than any other kind of statement. So all other things being equal, if you can eliminate conditionals / conditional statements from your code, you will likely have more robust code. 
Slow down time-to-market: Since conditional statements are branch points which are related to the number of test cases that are needed for white-box testing, unnecessary conditional statements increase the amount of time that needs to be devoted to testing. Basically if you don't exercise every branch point, there will be instructions in your code that will never have been executed under test conditions until they are seen by your users/customers. That's bad. 
Increase development cost: Bug finding, bug fixing, and testing are all increased by unnecessary control flow complexity. 
So compared to error reporting via return-codes and if, using try / catch / throw is likely to result in code that has fewer bugs, is less expensive to develop, and has faster time-to-market. Of course if your organization doesn't have any experiential knowledge of try / catch / throw, you might want to use it on a toy project first just to make sure you know what you're doing — you should always get used to a weapon on the firing range before you bring it to the front lines of a shooting war

--------------------------------------------------------------------
99. How should I handle resources if my constructors may throw exceptions?

Every data member inside your object should clean up its own mess. 

If a constructor throws an exception, the object's destructor is not run. If your object has already done something that needs to be undone (such as allocating some memory, opening a file, or locking a semaphore), this "stuff that needs to be undone" must be remembered by a data member inside the object. 

For example, rather than allocating memory into a raw Fred* data member, put the allocated memory into a "smart pointer" member object, and the destructor of this smart pointer will delete the Fred object when the smart pointer dies. The template std::auto_ptr is an example of such as "smart pointer." You can also write your own reference counting smart pointer. You can also use smart pointers to "point" to disk records or objects on other machines. 

By the way, if you think your Fred class is going to be allocated into a smart pointer, be nice to your users and create a typedef within your Fred class: 


 #include <memory>
 
 class Fred {
 public:
   typedef std::auto_ptr<Fred> Ptr;
   ...
 }; 
That typedef simplifies the syntax of all the code that uses your objects: your users can say Fred::Ptr instead of std::auto_ptr<Fred>: 


 #include "Fred.h"
 
 void f(std::auto_ptr<Fred> p);  // explicit but verbose
 void f(Fred::Ptr           p);  // simpler
 
 void g()
 {
   std::auto_ptr<Fred> p1( new Fred() );  // explicit but verbose
   Fred::Ptr           p2( new Fred() );  // simpler
   ...
 } 

--------------------------------------------------------------------
100.How do I change the string-length of an array of char to prevent memory leaks even if/when someone throws an exception?

If what you really want to do is work with strings, don't use an array of char in the first place, since arrays are evil. Instead use an object of some string-like class. 

For example, suppose you want to get a copy of a string, fiddle with the copy, then append another string to the end of the fiddled copy. The array-of-char approach would look something like this: 


 void userCode(const char* s1, const char* s2)
 {
   char* copy = new char[strlen(s1) + 1];    // make a copy
   strcpy(copy, s1);                         //   of s1...
 
   // use a try block to prevent memory leaks if we get an exception
   // note: we need the try block because we used a "dumb" char* above
   try {
 
     ...insert code here that fiddles with copy...
 
     char* copy2 = new char[strlen(copy) + strlen(s2) + 1];  // append s2
     strcpy(copy2, copy);                                    //   onto the
     strcpy(copy2 + strlen(copy), s2);                       //   end of
     delete[] copy;                                          //   copy...
     copy = copy2;
 
     ...insert code here that fiddles with copy again...
 
   } catch (...) {
     delete[] copy;   // we got an exception; prevent a memory leak
     throw;           // re-throw the current exception
   }
 
   delete[] copy;     // we did not get an exception; prevent a memory leak
 } 
Using char*s like this is tedious and error prone. Why not just use an object of some string class? Your compiler probably supplies a string-like class, and it's probably just as fast and certainly it's a lot simpler and safer than the char* code that you would have to write yourself. For example, if you're using the std::string class from the standardization committee, your code might look something like this: 


 #include <string>           // Let the compiler see std::string
 
 void userCode(const std::string& s1, const std::string& s2)
 {
   std::string copy = s1;    // make a copy of s1
   ...insert code here that fiddles with copy...
   copy += s2;               // append s2 onto the end of copy
   ...insert code here that fiddles with copy again...
 } 
The char* version requires you to write around three times more code than you would have to write with the std::string version. Most of the savings came from std::string's automatic memory management: in the std::string version, we didn't need to write any code... 

to reallocate memory when we grow the string. 
to delete[] anything at the end of the function. 
to catch and re-throw any exceptions. 

--------------------------------------------------------------------
101.What is "const correctness"?

A good thing. It means using the keyword const to prevent const objects from getting mutated. 

For example, if you wanted to create a function f() that accepted a std::string, plus you want to promise callers not to change the caller's std::string that gets passed to f(), you can have f() receive its std::string parameter... 

void f1(const std::string& s);      // Pass by reference-to-const 
void f2(const std::string* sptr);   // Pass by pointer-to-const 
void f3(std::string s);             // Pass by value 
In the pass by reference-to-const and pass by pointer-to-const cases, any attempts to change to the caller's std::string within the f() functions would be flagged by the compiler as an error at compile-time. This check is done entirely at compile-time: there is no run-time space or speed cost for the const. In the pass by value case (f3()), the called function gets a copy of the caller's std::string. This means that f3() can change its local copy, but the copy is destroyed when f3() returns. In particular f3() cannot change the caller's std::string object. 

As an opposite example, if you wanted to create a function g() that accepted a std::string, but you want to let callers know that g() might change the caller's std::string object. In this case you can have g() receive its std::string parameter... 

void g1(std::string& s);      // Pass by reference-to-non-const 
void g2(std::string* sptr);   // Pass by pointer-to-non-const 
The lack of const in these functions tells the compiler that they are allowed to (but are not required to) change the caller's std::string object. Thus they can pass their std::string to any of the f() functions, but only f3() (the one that receives its parameter "by value") can pass its std::string to g1() or g2(). If f1() or f2() need to call either g() function, a local copy of the std::string object must be passed to the g() function; the parameter to f1() or f2() cannot be directly passed to either g() function. E.g., 


 void g1(std::string& s);
 
 void f1(const std::string& s)
 {
   g1(s);          // Compile-time Error since s is const
 
   std::string localCopy = s;
   g1(localCopy);  // OK since localCopy is not const
 } 
Naturally in the above case, any changes that g1() makes are made to the localCopy object that is local to f1(). In particular, no changes will be made to the const parameter that was passed by reference to f1(). 
--------------------------------------------------------------------

102. How is "const correctness" related to ordinary type safety?
Declaring the const-ness of a parameter is just another form of type safety. It is almost as if a const std::string, for example, is a different class than an ordinary std::string, since the const variant is missing the various mutative operations in the non-const variant (e.g., you can imagine that a const std::string simply doesn't have an assignment operator). 

If you find ordinary type safety helps you get systems correct (it does; especially in large systems), you'll find const correctness helps also. 

--------------------------------------------------------------------
103. Should I try to get things const correct "sooner" or "later"?

At the very, very, very beginning. 

Back-patching const correctness results in a snowball effect: every const you add "over here" requires four more to be added "over there." 
--------------------------------------------------------------------

104. What does "const Fred* p" mean?

It means p points to an object of class Fred, but p can't be used to change that Fred object (naturally p could also be NULL). 

For example, if class Fred has a const member function called inspect(), saying p->inspect() is OK. But if class Fred has a non-const member function called mutate(), saying p->mutate() is an error (the error is caught by the compiler; no run-time tests are done, which means const doesn't slow your program down). 
--------------------------------------------------------------------
105. What's the difference between "const Fred* p", "Fred* const p" and "const Fred* const p"?

You have to read pointer declarations right-to-left. 

const Fred* p means "p points to a Fred that is const" — that is, the Fred object can't be changed via p. 
Fred* const p means "p is a const pointer to a Fred" — that is, you can change the Fred object via p, but you can't change the pointer p itself. 
const Fred* const p means "p is a const pointer to a const Fred" — that is, you can't change the pointer p itself, nor can you change the Fred object via p. 
--------------------------------------------------------------------
106. What does "const Fred& x" mean?

It means x aliases a Fred object, but x can't be used to change that Fred object. 

For example, if class Fred has a const member function called inspect(), saying x.inspect() is OK. But if class Fred has a non-const member function called mutate(), saying x.mutate() is an error (the error is caught by the compiler; no run-time tests are done, which means const doesn't slow your program down). 
--------------------------------------------------------------------
107. Does "Fred& const x" make any sense?

No, it is nonsense. 

To find out what the above declaration means, you have to read it right-to-left. Thus "Fred& const x" means "x is a const reference to a Fred". But that is redundant, since references are always const. You can't reseat a reference. Never. With or without the const. 

In other words, "Fred& const x" is functionally equivalent to "Fred& x". Since you're gaining nothing by adding the const after the &, you shouldn't add it since it will confuse people. I.e., the const will make some people think that the Fred is const, as if you had said "const Fred& x". 
--------------------------------------------------------------------
108. What does "Fred const& x" mean?  Updated! 

[Recently rewrote to make it even clearer that this is a business decision, and that the outcome will be different in different organizations (in 3/03). Click here to go to the next FAQ in the "chain" of recent changes.] 
Fred const& x is functionally equivalent to const Fred& x. However, the real question is which should be used. 

Answer: absolutely no one should pretend they can make decisions for your organization until they know something about your organization. One size does not fit all; there is no "right" answer for all organizations, so do not allow anyone to make a knee-jerk decision in either direction. "Think" is not a four-letter word. 

For example, some organizations value consistency and have tons of code using const Fred&; for those, Fred const& would be a bad decision independent of its merits. There are lots of other business scenarios, some of which produce a preference for Fred const&, others a preference for const Fred&. 

Use a style that is appropriate for your organization's average maintenance programmer. Not the gurus, not the morons, but the average maintenance programmer. Unless you're willing to fire them and hire new ones, make sure that they understand your code. Make a business decision based on your realities, not based on someone else's assumptions. 

You'll need to overcome a little inertia to go with Fred const&. Most current C++ books use const Fred&, most programmers learned C++ with that syntax, and most programmers still use that syntax. That doesn't mean const Fred& is necessarily better for your organization, but it does mean you may get some confusion and mistakes during the transition and/or when you integrate new people. Some organizations are convinced the benefits of Fred const& outweigh the costs; others, apparently, are not. 

Another caveat: if you decide to use Fred const& x, do something to make sure your people don't mis-type it as the nonsensical "Fred &const x". 
--------------------------------------------------------------------
109. What does "Fred const* x" mean?  Updated! 

[Recently rewrote to make it even clearer that this is a business decision, and that the outcome will be different in different organizations (in 3/03). Click here to go to the next FAQ in the "chain" of recent changes.] 
Fred const* x is functionally equivalent to const Fred* x. However, the real question is which should be used. 

Answer: absolutely no one should pretend they can make decisions for your organization until they know something about your organization. One size does not fit all; there is no "right" answer for all organizations, so do not allow anyone to make a knee-jerk decision in either direction. "Think" is not a four-letter word. 

For example, some organizations value consistency and have tons of code using const Fred*; for those, Fred const* would be a bad decision independent of its merits. There are lots of other business scenarios, some of which produce a preference for Fred const*, others a preference for const Fred*. 

Use a style that is appropriate for your organization's average maintenance programmer. Not the gurus, not the morons, but the average maintenance programmer. Unless you're willing to fire them and hire new ones, make sure that they understand your code. Make a business decision based on your realities, not based on someone else's assumptions. 

You'll need to overcome a little inertia to go with Fred const*. Most current C++ books use const Fred*, most programmers learned C++ with that syntax, and most programmers still use that syntax. That doesn't mean const Fred* is necessarily better for your organization, but it does mean you may get some confusion and mistakes during the transition and/or when you integrate new people. Some organizations are convinced the benefits of Fred const* outweigh the costs; others, apparently, are not. 
--------------------------------------------------------------------

110. What is a "const member function"?

A member function that inspects (rather than mutates) its object. 

A const member function is indicated by a const suffix just after the member function's parameter list. Member functions with a const suffix are called "const member functions" or "inspectors." Member functions without a const suffix are called "non-const member functions" or "mutators." 


 class Fred {
 public:
   void inspect() const;   // This member promises NOT to change *this
   void mutate();          // This member function might change *this
 };
 
 void userCode(Fred& changeable, const Fred& unchangeable)
 {
   changeable.inspect();   // OK: doesn't change a changeable object
   changeable.mutate();    // OK: changes a changeable object
 
   unchangeable.inspect(); // OK: doesn't change an unchangeable object
   unchangeable.mutate();  // ERROR: attempt to change unchangeable object
 } 
The error in unchangeable.mutate() is caught at compile time. There is no runtime space or speed penalty for const. 

The trailing const on inspect() member function means that the abstract (client-visible) state of the object isn't going to change. This is slightly different from promising that the "raw bits" of the object's struct aren't going to change. C++ compilers aren't allowed to take the "bitwise" interpretation unless they can solve the aliasing problem, which normally can't be solved (i.e., a non-const alias could exist which could modify the state of the object). Another (important) insight from this aliasing issue: pointing at an object with a pointer-to-const doesn't guarantee that the object won't change; it promises only that the object won't change via that pointer. 
--------------------------------------------------------------------
111. What do I do if I want a const member function to make an "invisible" change to a data member?

Use mutable (or, as a last resort, use const_cast). 

A small percentage of inspectors need to make innocuous changes to data members (e.g., a Set object might want to cache its last lookup in hopes of improving the performance of its next lookup). By saying the changes are "innocuous," I mean that the changes wouldn't be visible from outside the object's interface (otherwise the member function would be a mutator rather than an inspector). 

When this happens, the data member which will be modified should be marked as mutable (put the mutable keyword just before the data member's declaration; i.e., in the same place where you could put const). This tells the compiler that the data member is allowed to change during a const member function. If your compiler doesn't support the mutable keyword, you can cast away the const'ness of this via the const_cast keyword (but see the NOTE below before doing this). E.g., in Set::lookup() const, you might say, 


 Set* self = const_cast<Set*>(this);
   // See the NOTE below before doing this! 
After this line, self will have the same bits as this (e.g., self == this), but self is a Set* rather than a const Set* (technically a const Set* const, but the right-most const is irrelevant to this discussion). Therefore you can use self to modify the object pointed to by this. 

NOTE: there is an extremely unlikely error that can occur with const_cast. It only happens when three very rare things are combined at the same time: a data member that ought to be mutable (such as is discussed above), a compiler that doesn't support the mutable keyword, and an object that was originally defined to be const (as opposed to a normal, non-const object that is pointed to by a pointer-to-const). Although this combination is so rare that it may never happen to you, if it ever did happen the code may not work (the Standard says the behavior is undefined). 

If you ever want to use const_cast, use mutable instead. In other words, if you ever need to change a member of an object, and that object is pointed to by a pointer-to-const, the safest and simplest thing to do is add mutable to the member's declaration. You can use const_cast if you are sure that the actual object isn't const (e.g., if you are sure the object is declared something like this: Set s;), but if the object itself might be const (e.g., if it might be declared like: const Set s;), use mutable rather than const_cast. 

Please don't write and tell me that version X of compiler Y on machine Z allows you to change a non-mutable member of a const object. I don't care — it is illegal according to the language and your code will probably fail on a different compiler or even a different version (an upgrade) of the same compiler. Just say no. Use mutable instead. 
--------------------------------------------------------------------
112. Does const_cast mean lost optimization opportunities?

In theory, yes; in practice, no. 

Even if the language outlawed const_cast, the only way to avoid flushing the register cache across a const member function call would be to solve the aliasing problem (i.e., to prove that there are no non-const pointers that point to the object). This can happen only in rare cases (when the object is constructed in the scope of the const member function invocation, and when all the non-const member function invocations between the object's construction and the const member function invocation are statically bound, and when every one of these invocations is also inlined, and when the constructor itself is inlined, and when any member functions the constructor calls are inline). 

--------------------------------------------------------------------

113. Why does the compiler allow me to change an int after I've pointed at it with a const int*?

Because "const int* p" means "p promises not to change the *p," not "*p promises not to change." 

Causing a const int* to point to an int doesn't const-ify the int. The int can't be changed via the const int*, but if someone else has an int* (note: no const) that points to ("aliases") the same int, then that int* can be used to change the int. For example: 


 void f(const int* p1, int* p2)
 {
   int i = *p1;         // Get the (original) value of *p1
   *p2 = 7;             // If p1 == p2, this will also change *p1
   int j = *p1;         // Get the (possibly new) value of *p1
   if (i != j) {
     std::cout << "*p1 changed, but it didn't change via pointer p1!\n";
     assert(p1 == p2);  // This is the only way *p1 could be different
   }
 }
 
 int main()
 {
   int x;
   f(&x, &x);           // This is perfectly legal (and even moral!)
   ...
 } 
Note that main() and f(const int*,int*) could be in different compilation units that are compiled on different days of the week. In that case there is no way the compiler can possibly detect the aliasing at compile time. Therefore there is no way we could make a language rule that prohibits this sort of thing. In fact, we wouldn't even want to make such a rule, since in general it's considered a feature that you can have many pointers pointing to the same thing. The fact that one of those pointers promises not to change the underlying "thing" is just a promise made by the pointer; it's not a promise made by the "thing". 

--------------------------------------------------------------------
114. Does "const Fred* p" mean that *p can't change?

No! (This is related to the FAQ about aliasing of int pointers.) 

"const Fred* p" means that the Fred can't be changed via pointer p, but there might be other ways to get at the object without going through a const (such as an aliased non-const pointer such as a Fred*). For example, if you have two pointers "const Fred* p" and "Fred* q" that point to the same Fred object (aliasing), pointer q can be used to change the Fred object but pointer p cannot. 


 class Fred {
 public:
   void inspect() const;   // A const member function
   void mutate();          // A non-const member function
 };
 
 int main()
 {
   Fred f;
   const Fred* p = &f;
         Fred* q = &f;
 
   p->inspect();    // OK: No change to *p
   p->mutate();     // Error: Can't change *p via p
 
   q->inspect();    // OK: q is allowed to inspect the object
   q->mutate();     // OK: q is allowed to mutate the object
 
   f.inspect();     // OK: f is allowed to inspect the object
   f.mutate();      // OK: f is allowed to mutate the object
 
   ...
 } 

--------------------------------------------------------------------

115. Why am I getting an error converting a Foo** → const Foo**?  Updated! 

[Recently fixed a bug in the code (*q vs. *p) thanks to Richard van Wegen (in 2/03). Click here to go to the next FAQ in the "chain" of recent changes.] 
Because converting Foo** → const Foo** would be invalid and dangerous. 

C++ allows the (safe) conversion Foo* → const Foo*, but gives an error if you try to implicitly convert Foo** → const Foo**. 

The rationale for why that error is a good thing is given below. But first, here is the most common solution: simply change const Foo** to const Foo* const*: 


 class Foo { /* ... */ };
 
 void f(const Foo** p);
 void g(const Foo* const* p);
 
 int main()
 {
   Foo** p = /*...*/;
   ...
   f(p);  // ERROR: it's illegal and immoral to convert Foo** to const Foo**
   g(p);  // OK: it's legal and moral to convert Foo** to const Foo* const*
   ...
 } 
The reason the conversion from Foo** → const Foo** is dangerous is that it would let you silently and accidentally modify a const Foo object without a cast: 


 class Foo {
 public:
   void modify();  // make some modify to the this object
 };
 
 int main()
 {
   const Foo x;
   Foo* p;
   const Foo** q = &p;  // q now points to p; this is (fortunately!) an error
   *q = &x;             // p now points to x
   p->modify();         // Ouch: modifies a const Foo!!
   ...
 } 

Reminder: please do not pointer-cast your way around this. Just Say No! 

--------------------------------------------------------------------
116.What is a "virtual constructor"?

An idiom that allows you to do something that C++ doesn't directly support. 

You can get the effect of a virtual constructor by a virtual clone() member function (for copy constructing), or a virtual create() member function (for the default constructor). 


 class Shape {
 public:
   virtual ~Shape() { }                 // A virtual destructor
   virtual void draw() = 0;             // A pure virtual function
   virtual void move() = 0;
   ...
   virtual Shape* clone()  const = 0;   // Uses the copy constructor
   virtual Shape* create() const = 0;   // Uses the default constructor
 };
 
 class Circle : public Shape {
 public:
   Circle* clone()  const;   // Covariant Return Types; see below
   Circle* create() const;   // Covariant Return Types; see below
   ...
 };
 
 Circle* Circle::clone()  const { return new Circle(*this); }
 Circle* Circle::create() const { return new Circle();      } 
In the clone() member function, the new Circle(*this) code calls Circle's copy constructor to copy the state of this into the newly created Circle object. (Note: unless Circle is known to be final (AKA a leaf), you can reduce the chance of slicing by making its copy constructor protected.) In the create() member function, the new Circle() code calls Circle's default constructor. 

Users use these as if they were "virtual constructors": 


 void userCode(Shape& s)
 {
   Shape* s2 = s.clone();
   Shape* s3 = s.create();
   ...
   delete s2;    // You need a virtual destructor here
   delete s3;
 } 
This function will work correctly regardless of whether the Shape is a Circle, Square, or some other kind-of Shape that doesn't even exist yet. 

Note: The return type of Circle's clone() member function is intentionally different from the return type of Shape's clone() member function. This is called Covariant Return Types, a feature that was not originally part of the language. If your compiler complains at the declaration of Circle* clone() const within class Circle (e.g., saying "The return type is different" or "The member function's type differs from the base class virtual function by return type alone"), you have an old compiler and you'll have to change the return type to Shape*. 

Amazingly Microsoft Visual C++ is one of those compilers that does not, as of version 6.0, handle Covariant Return Types. This means: 

MS VC++ 6.0 will give you an error message on the overrides of clone() and create(). 
Do not write me about this. The above code is correct with respect to the C++ Standard (see section 10.3p5); the problem is with MS VC++ 6.0, not with the above code. Simply put, MS VC++ 6.0 doesn't support Covariant Return Types

--------------------------------------------------------------------
117.What is an ABC?
An abstract base class. 

At the design level, an abstract base class (ABC) corresponds to an abstract concept. If you asked a mechanic if he repaired vehicles, he'd probably wonder what kind-of vehicle you had in mind. Chances are he doesn't repair space shuttles, ocean liners, bicycles, or nuclear submarines. The problem is that the term "vehicle" is an abstract concept (e.g., you can't build a "vehicle" unless you know what kind of vehicle to build). In C++, class Vehicle would be an ABC, with Bicycle, SpaceShuttle, etc, being derived classes (an OceanLiner is-a-kind-of-a Vehicle). In real-world OO, ABCs show up all over the place. 

At the programming language level, an ABC is a class that has one or more pure virtual member functions. You cannot make an object (instance) of an ABC. 

--------------------------------------------------------------------

118. What is a "pure virtual" member function?
A member function declaration that turns a normal class into an abstract class (i.e., an ABC). You normally only implement it in a derived class. 

Some member functions exist in concept; they don't have any reasonable definition. E.g., suppose I asked you to draw a Shape at location (x,y) that has size 7. You'd ask me "what kind of shape should I draw?" (circles, squares, hexagons, etc, are drawn differently). In C++, we must indicate the existence of the draw() member function (so users can call it when they have a Shape* or a Shape&), but we recognize it can (logically) be defined only in derived classes: 


 class Shape {
 public:
   virtual void draw() const = 0;  // = 0 means it is "pure virtual"
   ...
 }; 
This pure virtual function makes Shape an ABC. If you want, you can think of the "= 0;" syntax as if the code were at the NULL pointer. Thus Shape promises a service to its users, yet Shape isn't able to provide any code to fulfill that promise. This forces any actual object created from a [concrete] class derived from Shape to have the indicated member function, even though the base class doesn't have enough information to actually define it yet. 

Note that it is possible to provide a definition for a pure virtual function, but this usually confuses novices and is best avoided until later. 

--------------------------------------------------------------------

119. How do you define a copy constructor or assignment operator for a class that contains a pointer to a (abstract) base class?
If the class "owns" the object pointed to by the (abstract) base class pointer, use the Virtual Constructor Idiom in the (abstract) base class. As usual with this idiom, we declare a pure virtual clone() method in the base class: 


 class Shape {
 public:
   ...
   virtual Shape* clone() const = 0;   // The Virtual (Copy) Constructor
   ...
 }; 
Then we implement this clone() method in each derived class: 


 class Circle : public Shape {
 public:
   ...
   virtual Shape* clone() const { return new Circle(*this); }
   ...
 };
 
 class Square : public Shape {
 public:
   ...
   virtual Shape* clone() const { return new Square(*this); }
   ...
 }; 
Now suppose that each Fred object "has-a" Shape object. Naturally the Fred object doesn't know whether the Shape is Circle or a Square or ... Fred's copy constructor and assignment operator will invoke Shape's clone() method to copy the object: 


 class Fred {
 public:
   Fred(Shape* p) : p_(p) { assert(p != NULL); }   // p must not be NULL
  ~Fred() { delete p_; }
   Fred(const Fred& f) : p_(f.p_->clone()) { }
   Fred& operator= (const Fred& f)
     {
       if (this != &f) {              // Check for self-assignment
         Shape* p2 = f.p_->clone();   // Create the new one FIRST...
         delete p_;                   // ...THEN delete the old one
         p_ = p2;
       }
       return *this;
     }
   ...
 private:
   Shape* p_;
 }; 
--------------------------------------------------------------------
120.Is it okay for a non-virtual function of the base class to call a virtual function?
Yes. It's sometimes (not always!) a great idea. For example, suppose all Shape objects have a common algorithm for printing, but this algorithm depends on their area and they all have a potentially different way to compute their area. In this case Shape's area() method would necessarily have to be virtual (probably pure virtual) but Shape::print() could, if we were guaranteed no derived class wanted a different algorithm for printing, be a non-virtual defined in the base class Shape. 


 #include "Shape.hpp"
 
 void Shape::print() const
 {
     float a = this->area();  // area() is pure virtual
     ...
 } 
--------------------------------------------------------------------
121. That last FAQ confuses me. Is it a different strategy from the other ways to use virtual functions? What's going on?

Yes, it is a different strategy. Yes, there really are two different basic ways to use virtual functions: 

Suppose you have the situation described in the previous FAQ: you have a method whose overall structure is the same for each derived class, but has little pieces that are different in each derived class. So the algorithm is the same, but the primitives are different. In this case you'd write the overall algorithm in the base class as a public method (that's sometimes non-virtual), and you'd write the little pieces in the derived classes. The little pieces would be declared in the base class (they're often protected, they're often pure virtual, and they're certainly virtual), and they'd ultimately be defined in each derived class. The most critical question in this situation is whether or not the public method containing the overall algorithm should be virtual. The answer is to make it virtual if you think that some derived class might need to override it. 
Suppose you have the exact opposite situation from the previous FAQ, where you have a method whose overall structure is different in each derived class, yet it has little pieces that are the same in most (if not all) derived classes. In this case you'd put the overall algorithm in a public virtual that's ultimately defined in the derived classes, and the little pieces of common code can be written once (to avoid code duplication) and stashed somewhere (anywhere!). A common place to stash the little pieces is in the protected part of the base class, but that's not necessary and it might not even be best. Just find a place to stash them and you'll be fine. Note that if you do stash them in the base class, you should normally make them protected, since normally they do things that public users don't need/want to do. Assuming they're protected, they probably shouldn't be virtual: if the derived class doesn't like the behavior in one of them, it doesn't have to call that method. 
For emphasis, the above list is a both/and situation, not an either/or situation. In other words, you don't have to choose between these two strategies on any given class. It's perfectly normal to have method f() correspond to strategy #1 while method g() corresponds to strategy #2. In other words, it's perfectly normal to have both strategies working in the same class. 
--------------------------------------------------------------------

122. When my base class's constructor calls a virtual function on its this object, why doesn't my derived class's override of that virtual function get invoked?

Because that would be very dangerous, and C++ is protecting you from that danger. 

The rest of this FAQ gives a rationale for why C++ needs to protect you from that danger, but before we start that, be advised that you can get the effect as if dynamic binding worked on the this object even during a constructor via The Dynamic Binding During Initialization Idiom. 

First, here is an example to explain exactly what C++ actually does: 


 #include <iostream>
 #include <string>
 
 void println(const std::string& msg)
 { std::cout << msg << '\n'; }
 
 class Base {
 public:
   Base()              { println("Base::Base()");  virt(); }
   virtual void virt() { println("Base::virt()"); }
 };
 
 class Derived : public Base {
 public:
   Derived()           { println("Derived::Derived()");  virt(); }
   virtual void virt() { println("Derived::virt()"); }
 };
 
 int main()
 {
   Derived d;
   ...
 } 
The output from the above program will be: 


 Base::Base()
 Base::virt() // ← Not Derived::virt()
 Derived::Derived()
 Derived::virt() 
The rest of this FAQ describes why C++ does the above. If you're happy merely knowing what C++ does without knowing why, feel free to skip this stuff. 

The explanation for this behavior comes from combining two facts: 

When you create a Derived object, it first calls Base's constructor. That's why it prints Base::Base() before Derived::Derived(). 
While executing Base::Base(), the this object is not yet of type Derived; its type is still merely Base. That's why the call to virtual function virt() within Base::Base() binds to Base::virt() even though an override exists in Derived. 
Now some of you are still curious, saying to yourself, "Hmmmm, but I still wonder why the this object is merely of type Base during Base::Base()." If that's you, the answer is that C++ is protecting you from serious and subtle bugs. In particular, if the above rule were different, you could easily use objects before they were initialized, and that would cause no end of grief and havoc. 

Here's how: imagine for the moment that calling this->virt() within Base::Base() ended up invoking the override Derived::virt(). Overrides can (and often do!) access non-static data members declared in the Derived class. But since the non-static data members declared in Derived are not initialized during the call to virt(), any use of them within Derived::virt() would be a "use before initialized" error. Bang, you're dead. 

So fortunately the C++ language doesn't let this happen: it makes sure any call to this->virt() that occurs while control is flowing through Base's constructor will end up invoking Base::virt(), not the override Derived::virt(). 
--------------------------------------------------------------------

123. Okay, but is there a way to simulate that behavior as if dynamic binding worked on the this object within my base class's constructor?
Yes. 

To clarify, we're talking about this situation: 


 class Base {
 public:
   Base();
   ...
   virtual void foo(int n) const; // often pure virtual
   virtual double bar() const;    // often pure virtual
   // if you don't want outsiders calling these, make them protected
 };
 
 Base::Base()
 {
   ... foo(42) ... bar() ...
   // these will not use dynamic binding
   // goal: simulate dynamic binding in those calls
 }
 
 class Derived : public Base {
 public:
   ...
   virtual void foo(int n) const;
   virtual double bar() const;
 }; 
This FAQ shows some ways to simulate dynamic binding as if the calls made in Base's constructor dynamically bound to the this object's derived class. The ways we'll show have tradeoffs, so choose the one that best fits your needs, or make up another. 

The first approach is a two-phase initialization. In Phase I, someone calls the actual constructor; in Phase II, someone calls an "init" method on the object. Dynamic binding on the this object works fine during Phase II, and Phase II is conceptually part of construction, so we simply move some code from the original Base::Base() into Base::init(). 


 class Base {
 public:
   void init();  // may or may not be virtual
   ...
   virtual void foo(int n) const; // often pure virtual
   virtual double bar() const;    // often pure virtual
 };
 
 void Base::init()
 {
   ... foo(42) ... bar() ...
   // most of this is copied from the original Base::Base()
 }
 
 class Derived : public Base {
 public:
   ...
   virtual void foo(int n) const;
   virtual double bar() const;
 }; 
The only remaining issues are determining where to call Phase I and where to call Phase II. There are many variations on where these calls can live; we will consider two. 

The first variation is simplest initially, though the code that actually wants to create objects requires a tiny bit of programmer self-discipline, which in practice means you're doomed. Seriously, if there are only one or two places that actually create objects of this hierarchy, the programmer self-discipline is quite localized and shouldn't cause problems. 

In this variation, the code that is creating the object explicitly executes both phases. When executing Phase I, the code creating the object either knows the object's exact class (e.g., new Derived() or perhaps a local Derived object), or doesn't know the object's exact class (e.g., the virtual constructor idiom or some other factory). The "doesn't know" case is strongly preferred when you want to make it easy to plug-in new derived classes. 

Note: Phase I often, but not always, allocates the object from the heap. When it does, you should store the pointer in some sort of managed pointer, such as a std::auto_ptr, a reference counted pointer, or some other object whose destructor deletes the allocation. This is the best way to prevent memory leaks when Phase II might throw exceptions. The following example assumes Phase I allocates the object from the heap. 


 #include <memory>
 
 void joe_user()
 {
   std::auto_ptr<Base> p(/*...somehow create a Derived object via new...*/);
   p->init();
   ...
 } 
The second variation is to combine the first two lines of the joe_user function into some create function. That's almost always the right thing to do when there are lots of joe_user-like functions. For example, if you're using some kind of factory, such as a registry and the virtual constructor idiom, you could move those two lines into a static method called Base::create(): 


 #include <memory>
 
 class Base {
 public:
   ...
   typedef std::auto_ptr<Base> Ptr;  // typedefs simplify the code
   static Ptr create();
   ...
 };
 
 Base::Ptr Base::create()
 {
   Ptr p(/*...use a factory to create a Derived object via new...*/);
   p->init();
   return p;
 } 
This simplifies all the joe_user-like functions (a little), but more importantly, it reduces the chance that any of them will create a Derived object without also calling init() on it. 


 void joe_user()
 {
   Base::Ptr p = Base::create();
   ...
 } 
If you're sufficiently clever and motivated, you can even eliminate the chance that someone could create a Derived object without also calling init() on it. An important step in achieving that goal is to make Derived's constructors, including its copy constructor, protected or private.. 

The next approach does not rely on a two-phase initialization, instead using a second hierarchy whose only job is to house methods foo() and bar(). This approach doesn't always work, and in particular it doesn't work in cases when foo() and bar() need to access the instance data declared in Derived, but it is conceptually quite simple and clean and is commonly used. 

Let's call the base class of this second hierarchy Helper, and its derived classes Helper1, Helper2, etc. The first step is to move foo() and bar() into this second hierarchy: 


 class Helper {
 public:
   virtual void foo(int n) const = 0;
   virtual double bar() const = 0;
 };
 
 class Helper1 : public Helper {
 public:
   virtual void foo(int n) const;
   virtual double bar() const;
 };
 
 class Helper2 : public Helper {
 public:
   virtual void foo(int n) const;
   virtual double bar() const;
 }; 
Next, remove init() from Base (since we're no longer using the two-phase approach), remove foo() and bar() from Base and Derived (foo() and bar() are now in the Helper hierarchy), and change the signature of Base's constructor so it takes a Helper by reference: 


 class Base {
 public:
   Base(const Helper& h);
   ...   // remove init() since not using two-phase this time
   ...   // remove foo() and bar() since they're in Helper
 };
 
 class Derived : public Base {
 public:
   ...   // remove foo() and bar() since they're in Helper
 }; 
We then define Base::Base(const Helper&) so it calls h.foo(42) and h.bar() in exactly those places that init() used to call this->foo(42) and this->bar(): 


 Base::Base(const Helper& h)
 {
   ... h.foo(42) ... h.bar() ...
   // almost identical to the original Base::Base()
   // but with h. in calls to h.foo() and h.bar()
 } 
Finally we change Derived's constructor to pass a (perhaps temporary) object of an appropriate Helper derived class to Base's constructor (using the init list syntax). For example, Derived would pass an instance of Helper2 if it happened to contain the behaviors that Derived wanted for methods foo() and bar(): 


 Derived::Derived()
 : Base(Helper2())   // ←the magic happens here
 {
   ...
 } 
Note that Derived can pass values into the Helper derived class's constructor, but it must not pass any data members that actually live inside the this object. While we're at it, let's explicitly say that Helper::foo() and Helper::bar() must not access data members of the this object, particularly data members declared in Derived. (Think about when those data members are initialized and you'll see why.) 

Of course the choice of which Helper derived class could be made out in the joe_user-like function, in which case it would be passed into the Derived ctor and then up to the Base ctor: 


 Derived::Derived(const Helper& h)
 : Base(h)
 {
   ...
 } 
If the Helper objects don't need to hold any data, that is, if each is merely a collection of its methods, then you can simply pass static member functions instead. This might be simpler since it entirely eliminates the Helper hierarchy. 


 class Base {
 public:
   typedef void (*FooFn)(int);  // typedefs simplify
   typedef double (*BarFn)();   //    the rest of the code
   Base(FooFn foo, BarFn bar);
   ...
 };
 
 Base::Base(FooFn foo, BarFn bar)
 {
   ... foo(42) ... bar() ...
   // almost identical to the original Base::Base()
   // except calls are made via function pointers.
 } 
The Derived class is also easy to implement: 


 class Derived : public Base {
 public:
   Derived();
   static void foo(int n); // the static is important!
   static double bar();    // the static is important!
   ...
 };
 
 Derived::Derived()
 : Base(foo, bar)  // ←pass the function-ptrs into Base's ctor
 {
   ...
 } 
As before, the functionality for foo() and/or bar() can be passed in from the joe_user-like functions. In that case, Derived's ctor just accepts them and passes them up into Base's ctor: 


 Derived::Derived(FooFn foo, BarFn bar)
 : Base(foo, bar)
 {
   ...
 } 
A final approach is to use templates to "pass" the functionality into the derived classes. This is similar to the case where the joe_user-like functions choose the initializer-function or the Helper derived class, but instead of using function pointers or dynamic binding, it wires the code into the classes via templates. 
--------------------------------------------------------------------
124. Should a derived class redefine ("override") a member function that is non-virtual in a base class?

It's legal, but it ain't moral. 

Experienced C++ programmers will sometimes redefine a non-virtual function for efficiency (e.g., if the derived class implementation can make better use of the derived class's resources) or to get around the hiding rule. However the client-visible effects must be identical, since non-virtual functions are dispatched based on the static type of the pointer/reference rather than the dynamic type of the pointed-to/referenced object. 

--------------------------------------------------------------------
125. What's the meaning of, Warning: Derived::f(float) hides Base::f(int)?  Updated! 
[Recently added the last paragraph thanks to Carl Daniel (in 2/03). Click here to go to the next FAQ in the "chain" of recent changes.] 
It means you're going to die. 

Here's the mess you're in: if Base declares a member function f(int), and Derived declares a member function f(float) (same name but different parameter types and/or constness), then the Base f(int) is "hidden" rather than "overloaded" or "overridden" (even if the Base f(int) is virtual). 

Here's how you get out of the mess: Derived must have a using declaration of the hidden member function. For example, 


 class Base {
 public:
   void f(int);
 };
 
 class Derived : public Base {
 public:
   using Base::f;    // This un-hides Base::f(int)
   void f(float);
 }; 
If the using syntax isn't supported by your compiler, redefine the hidden Base member function(s), even if they are non-virtual. Normally this re-definition merely calls the hidden Base member function using the :: syntax. E.g., 


 class Derived : public Base {
 public:
   void f(float);
   void f(int i) { Base::f(i); }  // The redefinition merely calls Base::f(int)
 }; 
Note: the hiding problem also occurs if class Base declares a method f(float). 

--------------------------------------------------------------------
126. What does it mean that the "virtual table" is an unresolved external?

If you get a link error of the form "Error: Unresolved or undefined symbols detected: virtual table for class Fred," you probably have an undefined virtual member function in class Fred. 

The compiler typically creates a magical data structure called the "virtual table" for classes that have virtual functions (this is how it handles dynamic binding). Normally you don't have to know about it at all. But if you forget to define a virtual function for class Fred, you will sometimes get this linker error. 

Here's the nitty gritty: Many compilers put this magical "virtual table" in the compilation unit that defines the first non-inline virtual function in the class. Thus if the first non-inline virtual function in Fred is wilma(), the compiler will put Fred's virtual table in the same compilation unit where it sees Fred::wilma(). Unfortunately if you accidentally forget to define Fred::wilma(), rather than getting a Fred::wilma() is undefined, you may get a "Fred's virtual table is undefined". Sad but true. 

--------------------------------------------------------------------
127. How can I set up my class so it won't be inherited from?  Updated! 
[Recently added the virtual base class technique thanks to Carl Daniel (in 2/03). Click here to go to the next FAQ in the "chain" of recent changes.] 
This is known as making the class "final" or "a leaf." There are two ways to do it: an easy technical approach and an even easier non-technical approach. 

The (easy) technical approach is to make the class's constructors private and to use the Named Constructor Idiom to create the objects. No one can create objects of a derived class since the base class's constructor will be inaccessible. The "named constructors" themselves could return by pointer if you want your objects allocated by new or they could return by value if you want the objects created on the stack. 
The (even easier) non-technical approach is to put a big fat ugly comment next to the class definition. The comment could say, for example, // We'll fire you if you inherit from this class or even just /*final*/ class Whatever {...};. Some programmers balk at this because it is enforced by people rather than by technology, but don't knock it on face value: it is quite effective in practice. 
A slightly trickier technical solution approach is to exploit virtual inheritance. Since the most derived class's ctor needs to directly call the virtual base class's ctor, the following guarantees that no concrete class can inherit from class Leaf: 

 class Leaf;
 
 class LeafBase {
 private:
   friend Leaf;
   LeafBase() { }
 };
 
 class Leaf : private virtual LeafBase {
 public:
   ...
 }; 
Class Leaf can access LeafBase's ctor, since Leaf is a friend of LeafBase, but no class derived from Leaf can access LeafBase's ctor, and therefore no one can create a concrete class derived from Leaf. 
--------------------------------------------------------------------

128. How can I set up my member function so it won't be overridden in a derived class?
This is known as making the method "final" or "a leaf." Here's an easy-to-use solution to this that gives you 90+% of what you want: simply add a comment next to the method and rely on code reviews or random maintenance activities to find violators. The comment could say, for example, // We'll fire you if you override this method or perhaps more likely, /*final*/ void theMethod();. 

The advantages to this technique are (a) it is extremely easy/fast/inexpensive to use, and (b) it is quite effective in practice. In other words, you get 90+% of the benefit with almost no cost — lots of bang per buck. 

(I'm not aware of a "100% solution" to this problem so this may be the best you can get. If you know of something better, please feel free to email me. But please do not email me objecting to this solution because it's low-tech or because it doesn't "prevent" people from doing the wrong thing. Who cares whether it's low-tech or high-tech as long as it's effective?!? And nothing in C++ "prevents" people from doing the wrong thing. Using pointer casts and pointer arithmetic, people can do just about anything they want. C++ makes it easy to do the right thing, but it doesn't prevent espionage. Besides, the original question (see above) asked for something so people won't do the wrong thing, not so they can't do the wrong thing.) 

In any case, this solution should give you most of the potential benefit at almost no cost. 






# Author

---

* [Rohtash Lakra](https://github.com/rslakra)
