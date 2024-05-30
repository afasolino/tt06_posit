# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: MIT

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period
    clock = Clock(dut.clk, 40, units="ns")
    cocotb.start_soon(clock.start())

    # Reset
    dut._log.info("Reset")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1

    dut._log.info("Test project behavior")
    
#########################################
#    write in the input buffer
########################################
    # Set 7:0 bits to 20
    dut.ui_in.value = 20
    # check alu ready == 1
    assert dut.uio_out.value == 2
    # set data valid = 1
    dut.uio_in.value = 1

    await ClockCycles(dut.clk, 4)
    # check alu ready == 0
    assert dut.uio_out.value == 0
    # set data valid = 0
    dut.uio_in.value = 0
    
    await ClockCycles(dut.clk, 4)
    # Set 15:8 bits to 0
    dut.ui_in.value = 0
    # check alu ready == 1
    assert dut.uio_out.value == 2
    # set data valid = 0
    dut.uio_in.value = 1
    
    await ClockCycles(dut.clk, 4)
    # check alu ready == 0
    assert dut.uio_out.value == 0
    # set data valid = 0
    dut.uio_in.value = 0
    
    await ClockCycles(dut.clk, 4)
    # Set 23:15 bits to 30
    dut.ui_in.value = 30
    # check alu ready == 1
    assert dut.uio_out.value == 2
    # set data valid = 1
    dut.uio_in.value = 1

    await ClockCycles(dut.clk, 4)
    # check alu ready == 0
    assert dut.uio_out.value == 0
    # set data valid = 0
    dut.uio_in.value = 0
    
    await ClockCycles(dut.clk, 4)
    # Set 31:24 bits to 0
    dut.ui_in.value = 0
    # check alu ready == 1
    assert dut.uio_out.value == 2
    # set data valid = 0
    dut.uio_in.value = 1
    
    await ClockCycles(dut.clk, 4)
    # finish of the operands storing, check read data ready== 1 
    assert dut.uio_out.value == 8
    # set data valid = 0
    dut.uio_in.value = 0
    
#########################################
#    read output buffer with input values
########################################

    # check if the input data is correctly written in the input buffer and if it can be read from the output buffer
    await ClockCycles(dut.clk, 8)

    assert dut.uio_out.value == 8
    assert dut.uo_out.value == 20
    dut.uio_in.value = 4
    await ClockCycles(dut.clk, 4)
    
    assert dut.uio_out.value == 0
    dut.uio_in.value = 0
    await ClockCycles(dut.clk, 8)

    assert dut.uio_out.value == 8
    #dut._log.info("The result is: %d" % dut.uo_out.value)
    assert dut.uo_out.value == 0

    dut.uio_in.value = 4
    await ClockCycles(dut.clk, 4)

    dut.uio_in.value = 0
    await ClockCycles(dut.clk, 8)
    
    #dut._log.info("The result is: %d" % dut.uo_out.value)
    assert dut.uo_out.value == 30

    dut.uio_in.value = 4
    await ClockCycles(dut.clk, 4)

    dut.uio_in.value = 0
    await ClockCycles(dut.clk, 8)
    #dut._log.info("The result is: %d" % dut.uo_out.value)

    assert dut.uo_out.value == 0

##############################################################################################################
#    read the concatenation of sign, regime decimal value and exponent for the converted data, namely ap and bp, on 8 bit each one
##############################################################################################################

    await ClockCycles(dut.clk, 8)

    assert dut.uio_out.value == 8
    assert dut.uo_out.value == 21
    dut.uio_in.value = 4
    await ClockCycles(dut.clk, 4)
    assert dut.uio_out.value == 0
    dut.uio_in.value = 0
    await ClockCycles(dut.clk, 8)

    assert dut.uio_out.value == 8
    assert dut.uo_out.value == 21
    dut.uio_in.value = 4
    await ClockCycles(dut.clk, 4)
    assert dut.uio_out.value == 0
    dut.uio_in.value = 0
    await ClockCycles(dut.clk, 8)

##############################################################################################################
#    read the mantissas of ap and bp, on 16 bit each one
##############################################################################################################

# mantissa ap part 1
    assert dut.uio_out.value == 8
    assert dut.uo_out.value == 0
    dut.uio_in.value = 4
    await ClockCycles(dut.clk, 4)
    assert dut.uio_out.value == 0
    dut.uio_in.value = 0
    await ClockCycles(dut.clk, 8)

# mantissa ap part 2
    assert dut.uio_out.value == 8
    assert dut.uo_out.value == 4
    dut.uio_in.value = 4
    await ClockCycles(dut.clk, 4)
    assert dut.uio_out.value == 0
    dut.uio_in.value = 0
    await ClockCycles(dut.clk, 8)

# mantissa bp part 1
    assert dut.uio_out.value == 8
    assert dut.uo_out.value == 0
    dut.uio_in.value = 4
    await ClockCycles(dut.clk, 4)
    assert dut.uio_out.value == 0
    dut.uio_in.value = 0
    await ClockCycles(dut.clk, 8)

# mantissa bp part 2
    assert dut.uio_out.value == 8
    assert dut.uo_out.value == 14
    dut.uio_in.value = 4
    await ClockCycles(dut.clk, 4)
    assert dut.uio_out.value == 0
    dut.uio_in.value = 0
    await ClockCycles(dut.clk, 8)

##############################################################################################################
#    read the result of the posit addition, on 16 bits
##############################################################################################################

# result part 1
    assert dut.uio_out.value == 8
    assert dut.uo_out.value == 144
    dut.uio_in.value = 4
    await ClockCycles(dut.clk, 4)
    assert dut.uio_out.value == 0
    dut.uio_in.value = 0
    await ClockCycles(dut.clk, 8)

# result part 1
    assert dut.uio_out.value == 8
    assert dut.uo_out.value == 2
    dut.uio_in.value = 4
    await ClockCycles(dut.clk, 4)
    assert dut.uio_out.value == 0
    dut.uio_in.value = 0
    await ClockCycles(dut.clk, 8)
