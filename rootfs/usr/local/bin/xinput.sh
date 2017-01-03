#!/bin/sh
xinput test-xi2 --root | perl -lne '
  BEGIN{$"=",";
    open X, "-|", "xmodmap -pke";
    while (<X>) {$k{$1}=$2 if /^keycode\s+(\d+) = (\w+)/}
    open X, "-|", "xmodmap -pm"; <X>;<X>;
    while (<X>) {if (/^(\w+)\s+(\w*)/){($k=$2)=~s/_[LR]$//;$m[$i++]=$k||$1}}
    close X;
  }
  if (/^EVENT type.*\((.*)\)/) {$e = $1}
  elsif (/detail: (\d+)/) {$d=$1}
  elsif (/modifiers:.*effective: (.*)/) {
    $m=$1;
    if ($e =~ /^Key/){
      my @mods;
      for (0..$#m) {push @mods, $m[$_] if (hex($m) & (1<<$_))}
      print "$e $d [$k{$d}] $m [@mods]"
    }
  }'

#xinput list | grep -Po 'id=\K\d+(?=.*slave\s*keyboard)' | xargs -P0 -n1 stdbuf -oL xinput test >> output.log & 
#awk 'BEGIN{while (("xmodmap -pke" | getline) > 0) k[$2]=$4}; {print $0 "[" k[$NF] "]"}' 
