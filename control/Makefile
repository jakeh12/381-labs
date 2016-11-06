top ?= control
time ?= 1000

all:
	ghdl --clean
	ghdl --remove
	rm -rf work *.o $(top)
	mkdir work
	ghdl -i --workdir=work *.vhd
	ghdl -m --workdir=work $(top)
	ghdl -r --workdir=work $(top) --stop-time=$(time)ns --vcd=$(top).vcd
	ghdl --clean
	ghdl --remove
	rm -rf work *.o $(top)

clean:
	ghdl --clean
	ghdl --remove
	rm -rf work
	rm -f *.o

note:
	ghdl --clean
	ghdl --remove
	rm -rf work *.o $(top)
	mkdir work
	ghdl -i --workdir=work *.vhd
	ghdl -m --workdir=work $(top)
	ghdl -r --workdir=work $(top) --assert-level=note --vcd=$(top).vcd
	ghdl --clean
	ghdl --remove
	rm -rf work *.o $(top)
