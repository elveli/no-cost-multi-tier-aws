# https://www.youtube.com/watch?v=zPfSwhofPpk


num = [0,1,2,3,4]
print(any(num)) #out:True


num2 = [0,1,2,3,4]
print(any(n > 0 for n in num2)) # out True

num3 = [0,1,2,-1000,4]
print(any(n > 0 for n in num3)) # out True


num3 = [0,1,2,-1000,4]
print(all(n > 0 for n in num3)) # out False

str = [ 'aaaa', 'bbb', 'cccc']

print(any(s == "cccc" for s in str)) # True
print(any(s == "c" for s in str)) # False

str = [ 'aaaa', 'aaaa', 'aaaa']

print(all(s == "aaaa" for s in str)) # True
print(all(s[0] == "a" for s in str)) # True

str = [ 'aaaa', 'bba', 'a']
print(any(s[0] == "a" for s in str)) # True

num3 = [2,4,8]
print(all(n % 2 == 0 for n in num3)) # out True. All are divisible by 2.

print(any(n > 7 for n in num3)) # out True. 