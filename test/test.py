# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: MIT

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


@cocotb.test()
async def test_project(dut):
    dut._log.info("Start")

    # Set the clock period to 10 us (100 KHz)
    clock = Clock(dut.clk, 10, units="us")
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
    # Set 7:0 bits to 20
    dut.ui_in.value = 20
    # check alu ready == 1
    assert dut.uio_out.value == 2
    # set data valid = 1
    dut.uio_in.value = 1

    await ClockCycles(dut.clk, 3)
    # check alu ready == 0
    assert dut.uio_out.value == 0
    # set data valid = 0
    dut.uio_in.value = 0
    
    await ClockCycles(dut.clk, 3)
    # Set 15:8 bits to 0
    dut.ui_in.value = 0
    # check alu ready == 1
    assert dut.uio_out.value == 2
    # set data valid = 0
    dut.uio_in.value = 1
    
    await ClockCycles(dut.clk, 3)
    # check alu ready == 0
    assert dut.uio_out.value == 0
    # set data valid = 0
    dut.uio_in.value = 0
    
    await ClockCycles(dut.clk, 3)

    #########################################
    # Set 23:15 bits to 30
    dut.ui_in.value = 30
    # check alu ready == 1
    assert dut.uio_out.value == 2
    # set data valid = 1
    dut.uio_in.value = 1

    await ClockCycles(dut.clk, 3)
    # check alu ready == 0
    assert dut.uio_out.value == 0
    # set data valid = 0
    dut.uio_in.value = 0
    
    await ClockCycles(dut.clk, 3)
    # Set 31:24 bits to 0
    dut.ui_in.value = 0
    # check alu ready == 1
    assert dut.uio_out.value == 2
    # set data valid = 0
    dut.uio_in.value = 1
    
    await ClockCycles(dut.clk, 3)
    # check alu ready == 0
    assert dut.uio_out.value == 0
    # set data valid = 0
    dut.uio_in.value = 0
    
    await ClockCycles(dut.clk, 3)
########################################
    
    # check read data ready== 1
    assert dut.uio_out.value == 8

    # check if the input data is correctly written in the input buffer and if it can be read from the output buffer
    assert dut.uo_out.value == 20
    
    await ClockCycles(dut.clk, 3)


