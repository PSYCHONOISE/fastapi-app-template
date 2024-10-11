def null_decorator(func):
    q = func()
    return q + '2'

@null_decorator
def greet():
    return 'Hello!'

print(greet)
