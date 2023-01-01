#!/usr/bin/perl
 
use FetchGenome;

($alignStrings, $LDfile) = @ARGV;

$alignHashRef = FetchGenome::getAlign($alignStrings);

%alignHash = %$alignHashRef;

@keys = keys %alignHash;

print "@keys\n";


open(LD, "gunzip -c $LDfile |") || die "Can't open gzipped file $LDfile\n";

while($L = <LD>) {

  chomp($L);

  ($CHR, $POS1, $POS2, $N_CHR, $R2, $D, $Dprime) = split(/\t/, $L);

   $CHR = 'Chr'.$CHR;

  if(substr($alignHash{$CHR}, $POS1-1, 1) == 2 || substr($alignHash{$CHR}, $POS2-1, 1) == 2) {

    $Align1 = substr($alignHash{$CHR}, $POS1-1, 1);

    $Align2 = substr($alignHash{$CHR}, $POS2-1, 1);

#    print "$CHR, $POS1: $Align1; $POS2: $Align2\n"; 

    $IllegalCount++;

  }

  else {

    $Align1 = substr($alignHash{$CHR}, $POS1-1, 1);

    $Align2 = substr($alignHash{$CHR}, $POS2-1, 1);

#    print "$CHR, $POS1: $Align1; $POS2: $Align2\n";

    $LegalCount++ 

  }

}

close LD;

print "Legals = $LegalCount; Illegals = $IllegalCount\n";
