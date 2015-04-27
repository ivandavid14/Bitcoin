Initial performance:
Single processor, no network:

Difficulty: 7 zero hex digits
20,445,043,024 clocks = 3 min 25 sec
Nonce = 18deaa4 = 26,077,860
3 hashes/nonce
Total hashes = 26,077,860*3 = 78,233,580
Hash rate = 78233580/205 sec = 0.381627 Mhash/s
Less than 5% FPGA area utilization
Total on-chip power = 0.157W

Optimize timing:
Increase clock frequency by 90MHz
15,359,860,129 clocks / 190MHz = 80.84 sec
Hash rate = 78233580/80.84 sec = 0.967758 Mhash/s
Total on-chip power = 0.285W