top ?= mips_control
time ?= 1000

all:
	ghdl --clean
	ghdl --remove
	rm -rf work *.o $(top)
	mkdir work
	ghdl -i --ieee=synopsys --workdir=work *.vhd
	ghdl -m --ieee=synopsys --workdir=work $(top)
	ghdl -r --ieee=synopsys --workdir=work $(top) --assert-level=error --vcd=$(top).vcd  --stop-time=$(time)ns
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
