Initial performance:
Single processor, no network:

Difficulty: 7 zero hex digits
20,445,043,024 clocks = 3 min 25 sec
Nonce = 18deaa4 = 26,077,860
2 hashes/nonce
Total hashes = 26,077,860*2 = 52,155,720
Hash rate = 52,155,720/205 sec = 0.254 Mhash/s
Less than 5% FPGA area utilization
Total on-chip power = 0.157W

Optimize timing:
Increase clock frequency by 90MHz
15,359,860,129 clocks / 190MHz = 80.84 sec
Hash rate = 52,155,720/80.84 sec = 0.645 Mhash/s
Total on-chip power = 0.285W

Minimize States:
10,352,910,817 clocks / 170MHz = 60.9 sec
Hash rate = 52,155,720/60.9 sec = 0.856 Mhash/s
Total on-chip power = 0.27W

8 Processing elements using NOC:
1,294,114,060 clocks / 100MHz = 12.94 sec
Hash rate = 52,155,720/12.94 sec = 4.03 Mhash/s
Total on-chip power = 0.705W
