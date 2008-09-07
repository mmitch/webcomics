#!/bin/bash

ls *.jpeg *.dwf 2>/dev/null | perl -e '
my @lines;
while (my $line = <>) {
    chomp $line;
    if ($line =~ /^((\d{4})(\d\d)(\d\d))c(\d\d)(.*)\./) {
        push @lines, {
            "FILENAME" => $line,
            "DATE_SORT" => "$1",
            "DATE_DE" => "$4.$3.$2",
            "CHAPTER" => $5,
            "TITLE" => $6 
        };        
    } else {
        warn $line;
    }
}
my @sorted = sort {
     $a->{CHAPTER} <=> $b->{CHAPTER}
  || $a->{DATE_SORT} <=> $b->{DATE_SORT}
  || $a->{TITLE} cmp $b->{TITLE}
} @lines;
foreach my $line (@sorted) {
    printf "%s\t%s - Chapter %02d - %s\n",
        $line->{FILENAME},
        $line->{DATE_DE},
        $line->{CHAPTER},
        $line->{TITLE};
}
' > index
