# https://www.youtube.com/watch?v=rLyYb7BFgQI&t=1s

class Microwave:
    def __init__(self, brand: str, power_rating: str) -> None:
        self.brand = brand
        self.power_rating = power_rating
        self.turned_on: bool = False

    def turn_on(self) -> None:
        if self.turned_on:
            print(f'uwave {self.brand} is already turned on')
        else:
            self.turned_on = True
            print(f'uwave {self.brand} is turned on')

    def turn_off(self) -> None:
        if self.turned_on:
            self.turned_on = False
            print(f'uwave {self.brand} is now turned off')
        else:
            print(f'uwave {self.brand} is already turned off')

    def run(self, seconds: int) -> None:
        if self.turned_on:
            print(f'uwave {self.brand} is running for {seconds} seconds')
        else:
            print(f'turn on your uwave')
        
    def __add__(self, other):
        # return f{self.brand} + {other.brand}''
        print(f'{self.brand} + {other.brand}')

    def __mul__(self, other):
        # return f{self.brand} + {other.brand}''
        print(f'{self.brand} * {other.brand}')

    def __str__(self) -> str:
        return f'{self.brand} (Rating {self.power_rating})'
    
    def __repr__(self) -> str:
        return f'Microwave(brand="{self.brand}", power_rating="{self.power_rating}")'

smeg = Microwave(brand='Smeg', power_rating='B')
print(smeg)
print("REPR:")
print(repr(smeg))
# print(smeg.brand)
# print(smeg.power_rating)
smeg.turn_on()

smeg.run(400)
smeg.turn_off()

bosch = Microwave(brand='Bosch', power_rating='A')
# print(bosch.brand)
# print(bosch.power_rating)
print(bosch)
print("REPR:")
print(repr(bosch))

'''
uwave Smeg is turned on
uwave Smeg is running for 400 seconds
uwave Smeg is now turned off

'''

print(smeg + bosch)
print(smeg * bosch)