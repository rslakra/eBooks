# Python

---


## map
```python
num_map = map(lambda num : num * 2, nums)
print(list(num_map))
```

---

## filter
```python
num_filter = filter(lambda num : num % 2 == 0, nums)
print(list(num_filter))
```

---

## reduce
```python
from functools import reduce
sum = reduce(lambda first, second: first + second, nums)
print(sum)
```

---

## Recursion
```python
def fact(n):
    return 1 if n == 1 else n * fact(n - 1)

print(fact(5))
```

---

## Log Execution Time
```python
import time

def logtime(func):
    
    def wrapper(*args, **kwargs):
        print("Before")
        date_format = '%Y/%m/%d %T %Z'
        start_time = time.time()  # Start time
        print(f'{func.__name__}() started at={time.strftime(date_format)}')
        result = func(*args, **kwargs)  # Execute the function
        print("After")
        
        end_time = time.time()  # End time
        execution_time = round(end_time - start_time, 2)  # Calculate execution time
        print(f'{func.__name__}() ended at={time.strftime(date_format)} and took = {execution_time} seconds')

        return result

    return wrapper

@logtime
def hello():
    print("Hello, Function")
    time.sleep(5)
    
hello() 
```

---

## Argument Parser
````python
import argparse
parser = argparse.ArgumentParser(description="this is an arg")
parser.add_argument("-c", "--color", metavar="color", required=True, choices={"red", "green"}, help="enter color to search for")
args = parser.parse_args()
print(args)
print(args.color)
````

## Python Commands
```shell
cd /usercode/flaskapplication && export FLASK_APP=app.py && export FLASK_ENV=development && flask run --host=0.0.0.0

flask run --host=0.0.0.0
```

## Tools

- MySQL Connector
- Gonicorn
```shell
workers = (cpu * 2) + 1
```
- Pinpoint Notification
- HotSpot (SCM)
- HubSpot
- QuickSight
- Iterable
- Statsig
-


# Reference

---

https://github.com/dpetzold/aws-log-parser/blob/master/examples/count-hosts.py
https://engineering.forethought.ai/blog/2023/02/14/migrating-from-flask-to-fastapi-part-2/


