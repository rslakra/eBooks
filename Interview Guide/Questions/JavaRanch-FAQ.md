# JavaRanch Interview Questions

---

Q1. How many object references will be referring to the object created at line 7, after the execution of line 11 in the following program:
```java

public class GC {
    public static void main(String[] args) {
        Object x = new Integer(10);
        Object x = new Long(220);
        Object x = new sTRING("gGARBAGE");// line 7
        Object obj  = null;
        x=z;
        z=y;
        y=x;// line 11
    }
}
```

**Ans:**
```text
a) 0	
b) 1	
c) 2	
d) 3
```


# Author

---

* [Rohtash Lakra](https://github.com/rslakra)
