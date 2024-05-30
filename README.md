

# Integer to posit converter and posit adder


Posit arithmetic [1] is an alternative numeric representation that tries to overcome some of the problems of floating-point arithmetic. A posit number (p) is composed of a sign value (s), a regime value (k), an exponent value (e) and a mantissa value (m), as described in the equation below:
$$p = (-1)^s \times (2^{2^{es^k}}) \times 2^e \times (1+m)$$
This numeric format has been proved to be very effective in applications like Artificial Intelligence and Digital Signal Processing, thanks to the the possibility to represent a wider range of values with respect to a floatin-point number having the same bit-width.

The aim of this project are:
  -  convert the integer input data represented in 2's complement signed fixed-point to a standard posit number in (16,1) format;
  -  sum the two operands using the addition stated in the posit arithmetic.


## 1. Architecture overview

The module (Fig. 1) is fed by two fixed-point numbers, namely $a_f$ and $b_f$, coverts them into the posit arithmetic format ($a_p$ and $b_p$) and sums them to produce a posit output ($s_p$).

![fixed2posit-module drawio](https://github.com/afasolino/tt06_posit/assets/151364130/2e2fa7f1-4080-490b-bbb9-8ac1b462cae2)

It is made of two units: 
1) 16-bit 2's complement fixed-point 0.15 coded to 16-bit standard posit (16,1) converter, namely fixed to posit converter,
2) posit adder, that executes the addition of posit numbers according to the posit standard.

### 1.
The conversion is operated as described in [1], leveraging a leading zero counter [2] and some glue logic.

### 2.
The addition leverages the architecture presented in [3].

Module inputs and outputs are stated in the next table:

| mode  | signal |
| :-------------: | :-------------: |
| input  | $a_f$  |
| input  | $b_f$  |
| output  | $a_f$  |
| output  | $b_f$  |
| output  | $a_p$  |
| output  | $b_p$  |
| output  | $s_p$  |

### References

[1] J. Gustafson. "Posit arithmetic." Mathematica Notebook describing the posit number system, 2017.

[2] Milenković, Nebojša & Stankovic, Vladimir & Milić, Miljana. (2015). Modular Design Of Fast Leading Zeros Counting Circuit. Journal of Electrical Engineering. 66. 329-333. 10.2478/jee-2015-0054. 

[3] R. Murillo, A. A. Del Barrio and G. Botella, "Customized Posit Adders and Multipliers using the FloPoCo Core Generator," 2020 IEEE International Symposium on Circuits and Systems (ISCAS), 2020, pp. 1-5, doi: 10.1109/ISCAS45731.2020.9180771.

## 2. How to test

Given the comunication protocol implemented, to test the design it is needed to provide the two operands in 8-bit little endian strings.
The steps to write two two 16-bit operands $a_f$ and $b_f$ are as follows:
  1)  give the $a_f$[7:0] and assert data valid;
  2)  wait for 4 clock cycles and deassert data valid;
  3)  wait for 4 clock cycles;
  4)  repeat with $a_f$[15:8], $b_f$[7:0] and $b_f$[15:8]

The steps to read the data are as follows:
  1) assert read data valid and read the first operand LSBs, a[7:0];
  2) wait for 4 clock cycles and deassert read data valid;
  3) wait for 8 clock cycles;
  4) repeat to read $a_f$[15:8], $b_f$[7:0], $b_f$[15:8], {s,k,e} of a converted to posit ($a_p$), {s,k,e} of b converted to posit ($b_p$), m [15:8] of $a_p$, m [7:0] of $a_p$, m [15:8] of $b_p$, m [7:0] of $b_p$, $s_p$[7:0] and $s_p$[15:0].

## 3. Contact info

Companies: (a) University of Salerno, Fisciano (SA), Italy; 
            (b) STMicroelectronics, Napoli, Italy.
            
Engineer: Andrea Fasolino (a), Gian Domenico Licciardo (a), Aldo Torino (b), Francesco Del Prete (b), Claudio Parrella (b).

Emails: afasolino@unisa.it, gdlicciardo@unisa.it, aldo.torino@st.com, francesco.delprete@st.com, claudio.parrella@st.com
