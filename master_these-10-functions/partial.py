from functools import partial

def specifications(color: str, name: str, amount: int) -> None:
    print(f'Specs: {color=}, {name=}, {amount=}.')

col_and_name: partial = partial(specifications, amount=10)


col_and_name: partial = partial(specifications,'red', 'bob')
col_and_name(0000)

col_and_name: partial = partial (specifications, 'blue', 'Alice')
col_and_name(9999)

spe_amt: partial = partial(specifications, 'Bllue', "BOB")
spe_amt(10)
spe_amt(9000)

col_and_name(9999)

spe_name: partial = partial(specifications, 'green', amount=-9999)

spe_name('Timmpa')