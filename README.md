

## Integer to posit converter and posit adder


Posit arithmetic [1] is an alternative numeric representation that tries to overcome some of the problems of floatin-point arithmetic. A posit number (p) is composed of a sign value (s), a regime value (k), an exponent value (e) and a mantissa value (m), as described in the equation below:
$$p = (-1)^s \times (2^{2^{es^k}}) \times 2^e \times (1+m)$$
This numeric format has been proved to be very effective in applications like Artificial Intelligence and Digital Signal Processing, thanks to the the possibility to represent a wider range of values with respect to a floatin-point number having the same bit-width.

The aim of this project are:
  -  convert the integer input data represented in 2's complement signed fixed-point to a standard posit number in (16,1) format;
  -  sum the two operands using the addition stated in the posit arithmetic.


## Architecture overview

The module (Fig. 1) is fed by two fixed-point numbers, namely af and bf, coverts them into the posit arithmetic format (ap and bp) and sums them to produce a posit output (sp).

![fixed2posit-module drawio](https://github.com/afasolino/tt06_posit/assets/151364130/2e2fa7f1-4080-490b-bbb9-8ac1b462cae2)

It is made of two units: 
1) 16-bit 2's complement fixed-point 0.15 coded to 16-bit standard posit (16,1) converter, namely fixed to posit converter,
2) posit adder, that executes the addition of posit numbers according to the posit standard.


1.
The conversion is operated as described in [1], leveraging a leading zero counter [2] and some glue logic.


2.
The addition leverages the architecture presented in [3].

References

[1] J. Gustafson. "Posit arithmetic." Mathematica Notebook describing the posit number system, 2017.

[2] Milenković, Nebojša & Stankovic, Vladimir & Milić, Miljana. (2015). Modular Design Of Fast Leading Zeros Counting Circuit. Journal of Electrical Engineering. 66. 329-333. 10.2478/jee-2015-0054. 

[3] R. Murillo, A. A. Del Barrio and G. Botella, "Customized Posit Adders and Multipliers using the FloPoCo Core Generator," 2020 IEEE International Symposium on Circuits and Systems (ISCAS), 2020, pp. 1-5, doi: 10.1109/ISCAS45731.2020.9180771.

## How to test

Given the comunication protocol implemented, to test the design it is needed to provide the two operands in 8-bit little endian strings.
The steps to write two two 16-bit operands a and b are as follows:
  1)  give the a[7:0] and assert data valid;
  2)  wait for 4 clock cycles and deassert data valid;
  3)  wait for 4 clock cycles;
  4)  repeat with a[15:8], b[7:0] and b[15:8]

The steps to read the data are as follows:
  1) assert read data valid and read the first operand LSBs, a[7:0];
  2) wait for 4 clock cycles and deassert read data valid;
  3) wait for 8 clock cycles;
  4) repeat to read a[15:8], b[7:0], b[15:8], {s,k,e} of a converted to posit (ap), {s,k,e} of b converted to posit (bp), m [15:8] of ap, m [7:0] of ap, m [15:8] of bp, m [7:0] of bp, sp[7:0] and sp[15:0].

## Contact info

Companies: (a) University of Salerno, Fisciano (SA), Italy; 
            (b) STMicroelectronics, Napoli, Italy.
            
Engineer: Andrea Fasolino (a), Gian Domenico Licciardo (a), Aldo Torino (b), Francesco Del Prete (b), Claudio Parrella (b).

Emails: afasolino@unisa.it, gdlicciardo@unisa.it, aldo.torino@st.com, francesco.delprete@st.com, claudio.parrella@st.com
