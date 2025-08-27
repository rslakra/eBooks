# Whizlab Interview Questions

---

```java
class First {
    public Object m() {
        System.out.println("Hello base");
        return new String("Base");
    }
}

class Second extends First{
    public String m(){
        System.out.println("Hello child");
        return new String("Derived");
    }
}


public class Test {
    
    public static void main(String[] args) {
        First f = new Second();
        String result = (String)f.m();// cast required to run the prog then it will printo/p fm child class
        System.out.println(result);
        
        //	Float A = 9.0f;
        //	Float B = 9.0f;
        //	float a= (float)9.0;
        //	System.out.println(A.equals(B));
        // System.out.println(B.equals(A));
        // System.out.println(a.equals(A));//float cannot be dereferenced
        // System.out.println(a<=A);
        // System.out.println(A<=a);
        
        int counter=0;
        outer: for(int i=0;i<4;++i)
            middle:for(int j=0;j<4;++j)
                inner:for(int k=0;k<4;++k){
                    System.out.println("Hello -" + ++counter);
                    if((k%4)==0){
                        break outer;
                    }
                }
        
        for(String i :args)
            for(String j: args) {
                System.out.println("i is "+ i +"j is"+ j);
            }
    }
}
```


# Author

---

* [Rohtash Lakra](https://github.com/rslakra)
