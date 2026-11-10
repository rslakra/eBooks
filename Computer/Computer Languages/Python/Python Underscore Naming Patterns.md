# Python Underscore Naming Patterns

| Pattern | Example | Meaning | Enforced by interpreter? |
| :--- | :---: | :--- | :---: |
| **Single Leading Underscore** | `_var` | Naming convention indicating a name is meant for internal use. It's only a hint to the programmer. | No (except in wildcard imports) |
| **Single Trailing Underscore** | `var_` | Used by convention to avoid naming conflicts with Python keywords. | No |
| **Double Leading Underscore** | `__var` | Triggers name mangling when used in a class context. | Yes |
| **Double Leading and Trailing Underscore** | `__var__` | Indicates special methods defined by the Python language. Avoid this naming scheme for your own attributes. | Reserved by Python |
| **Single Underscore** | `_` | Sometimes used as a name for temporary or insignificant variables ("don't care"). Also: the result of the last expression in a Python REPL. | No |

## Examples

```python
# Single leading underscore: internal use
_internal_counter = 0

# Single trailing underscore: avoid clashing with a keyword
class_ = "Math101"

# Double leading underscore: name mangling inside a class
class Account:
    def __init__(self):
        self.__balance = 0   # stored as _Account__balance

# Double leading and trailing underscore: special (dunder) methods
class Point:
    def __repr__(self):
        return "Point()"

# Single underscore: throwaway variable
for _ in range(3):
    print("hello")
```
