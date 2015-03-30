#!/usr/local/ActivePerl-5.6/bin/perl -w

use strict;
use warnings;

# sha256 of ascii variable
use Digest::SHA qw(sha256_hex);
my $data = "x";
my $digest = sha256_hex($data);
print $digest, "\n\n";

# sha256 of bits
my $bits = "0111";  # x = 0111 1 000
my $sha = Digest::SHA->new("sha256");
$sha->add_bits($bits);
$sha->add_bits("1");
$sha->add_bits("000");
print $sha->getstate, "\n\n";
print $sha->hexdigest, "\n**\n";

if ($#ARGV >= 0) {
    while (@ARGV) {
        if ($ARGV[0] eq "-file") {
			# sha256 of input file
			my $file = $ARGV[1];
			unless(-e $file){
				die("File does not exist: $file");
			}
			$sha->addfile($file);
			print $sha->getstate, "\n\n";
			print $sha->hexdigest, "\n*\n";
			shift(@ARGV);
		} elsif ($ARGV[0] eq "-fileh") {
			# file contains hex values as ascii
			my $file = $ARGV[1];
			unless(-e $file){
				die("File does not exist: $file");
			}
			open(my $fh, '<:encoding(UTF-8)', $file)
			or die "Could not open file '$file' $!";
			my $row = <$fh>;
			chomp $row;
			print "$row\n\n";
			print hex2bin($row), "\n\n";
			close($fh);
			
			$sha->reset("sha256");
			$sha->add_bits(hex2bin($row));
			print $sha->hexdigest, "\n**\n";
			shift(@ARGV);
		} else {
			# sha256 of input argument
			my $data1 = $ARGV[0];
			my $digest1 = sha256_hex($data1);
			print $digest1, "\n\n";
		}
        shift(@ARGV);
    }
}

sub hex2bin {
        my $h = shift;
        my $hlen = length($h);
        my $blen = $hlen * 4;
        return unpack("B$blen", pack("H$hlen", $h));
}
