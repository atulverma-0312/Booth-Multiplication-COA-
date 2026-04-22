clc;
clear;

// INPUT
m = input("Enter multiplicand (decimal): ");
q = input("Enter multiplier (decimal): ");
n = input("Enter number of bits: ");

// FUNCTION: Decimal to Binary (2's Complement)
function bin = dec_to_bin(num, bits)
    if num >= 0 then
        bin = zeros(1, bits);
        temp = num;
        for i = bits:-1:1
            bin(i) = modulo(temp, 2);
            temp = floor(temp / 2);
        end
    else
        num = 2^bits + num;
        bin = dec_to_bin(num, bits);
    end
endfunction

// FUNCTION: Binary Addition
function res = bin_add(a, b)
    carry = 0;
    res = zeros(1, length(a));
    for i = length(a):-1:1
        sum = a(i) + b(i) + carry;
        res(i) = modulo(sum, 2);
        carry = floor(sum / 2);
    end
endfunction

// FUNCTION: 2's Complement
function res = twos_comp(a)
    res = 1 - a; // 1's complement
    one = zeros(1, length(a));
    one($) = 1;
    res = bin_add(res, one);
endfunction

// INITIALIZATION
M = dec_to_bin(m, n);
Q = dec_to_bin(q, n);
A = zeros(1, n);
Q1 = 0;
count = n;

//BOOTH ALGORITHM 
while count > 0
    
    if (Q($) == 1 & Q1 == 0) then
        A = bin_add(A, twos_comp(M)); // A = A - M
    elseif (Q($) == 0 & Q1 == 1) then
        A = bin_add(A, M); // A = A + M
    end
    
// Arithmetic Right Shift
    temp = [A Q Q1];
    sign = temp(1);
    
    temp = [sign temp(1:$-1)];
    
// Update registers
    A = temp(1:n);
    Q = temp(n+1:2*n);
    Q1 = temp($);
    
    count = count - 1;
end

// RESULT
result = [A Q];

// Convert binary to decimal
function dec = bin_to_dec(arr)
    if arr(1) == 0 then
        dec = 0;
        for i = 1:length(arr)
            dec = dec + arr(i)*2^(length(arr)-i);
        end
    else
        arr = twos_comp(arr);
        dec = 0;
        for i = 1:length(arr)
            dec = dec + arr(i)*2^(length(arr)-i);
        end
        dec = -dec;
    end
endfunction

decimal_result = bin_to_dec(result);

//OUTPUT
disp("Binary Result:");
disp(result);

disp("Decimal Result:");
disp(decimal_result);
