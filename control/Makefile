top ?= you_forgot_to_specify_top_module
time ?= 1000
path ?= .

all:
	ghdl --clean
	ghdl --remove
	rm -rf work $(path)/*.o $(path)/$(top)
	mkdir $(path)/work
	ghdl -i --ieee=synopsys --workdir=$(path)/work $(path)/*.vhd
	ghdl -m --ieee=synopsys --workdir=$(path)/work $(top)
	ghdl -r --ieee=synopsys --workdir=$(path)/work $(top) --assert-level=error --vcd=$(path)/$(top).vcd  --stop-time=$(time)ns
	ghdl --clean
	ghdl --remove
	rm -rf $(path)/work $(path)/*.o $(path)/$(top)
