#! /usr/bin/perl -w

# This script parses the template for the given window manager.
#
# GPL'ed by Mikhael Goikhman.

# If a sum of sizes for an icon set is not greater than this limit,
# it is considered as mini (say 25x22), otherwise as norm (say 23x26).
$MINI_SIZE_LIMIT = 48;
$ICONS_DIR = '../../icons';

# chdir to the script's directory
$0 =~ m!^(.*)/[^/]+$!; chdir($1) if defined $1;

my $wm = shift;
unless (defined $wm) {
	print("Usage: $0 fvwm1|fvwm2|fvwm95|scvm\n");
	exit(-1);
}

my $confName = shift || "wm-icons";
my $wmTemplateFile = "../template/${wm}rc-$confName";
unless (-f $wmTemplateFile) {
	print("No $wm template $wmTemplateFile\n");
	exit(-2);
}

my $styleIconsFile = "../conf/style-icons.cfg";
unless (-f $styleIconsFile) {
	print("No style icons configuration $styleIconsFile\n");
	exit(-3);
}

my $outputFile = "../../etc/${wm}rc-$confName.in"; my $OUT;
unless (open(OUT, ">$outputFile")) {
	print("Can't write to $outputFile\n");
	exit(-4);
}

# must be rewritten not to use backquotes
my $wmTemplate = `cat $wmTemplateFile`;
my $styleIcons = `cat $styleIconsFile`;

# remove non-strict (devel) comments
$styleIcons =~ s/^(#[^ ]|\t).*?\n//mg;

my $defineAllIcons  = "";

my @allNames = ();
foreach (`ls $ICONS_DIR/01x01-template`) {
	/.*\.xpm$/ && push @allNames, $_;
	/_symlinks.lst$/ &&
		push @allNames, `cut -d" " -f2 $ICONS_DIR/01x01-template/$_`;
}
my @allIcons = map {
	chomp; ("menu/$_", "mini/$_", "norm/$_");
} sort @allNames;

my $maxIconLen = 0; map { /([^\/]+)\.xpm$/; $maxIconLen = length($1) if length($1) > $maxIconLen; } @allIcons;
my $adjustIcon = sub ($) { " " x ($maxIconLen - length(shift())) };

if ($wm eq 'fvwm1' || $wm eq 'fvwm2' || $wm eq 'fvwm95') {
	my $miniIconCommand = $wm eq 'fvwm95'? 'TitleIcon': 'MiniIcon';
	my $miniIconPart = sub { $wm eq 'fvwm1'? '':
		", " . &$adjustIcon($_[0]) . "$miniIconCommand mini/$_[0].xpm";
	};
	$styleIcons =~ s{(".*?")( +)([\w\-]+)$}
		{Style $1$2Icon norm\/$3.xpm${\&$miniIconPart($3)}}mg;
} elsif ($wm eq 'scwm') {
	$styleIcons =~ s{(".*?")( +)([\w\-]+)$}
		{(window-style $1$2#:icon wmi-norm-$3 #:mini-icon wmi-mini-$3)}mg;
	$styleIcons =~ s/^#/;;/mg;
	$defineAllIcons = join("", map {
		$_ =~ m|^(\w+)/(.*)\.xpm$|;
		qq{(define wmi-$1-$2 ${\&$adjustIcon($2)}(make-image "$_"))\n};
	} @allIcons);
}

my @allIconSets = `ls $ICONS_DIR | grep 'x.*-'`; chomp(@allIconSets);
shift @allIconSets if $allIconSets[0] =~ /^01x01-/;
my @miniIconSets = grep(/^(\d+)x(\d+)/ && $1 + $2 <= $MINI_SIZE_LIMIT, @allIconSets);
my @normIconSets = grep(/^(\d+)x(\d+)/ && $1 + $2 >  $MINI_SIZE_LIMIT, @allIconSets);

my $maxIconSetLen = 0; map { $maxIconSetLen = length($_) if length($_) > $maxIconSetLen; } @allIconSets;
my $substitudeIconSet = sub ($$) { my ($str, $set) = @_; $str =~ s/\@ICON_SET\@/$set/sg; $str =~ s/\@ADJUST\@/" " x ($maxIconSetLen - length($set))/seg; $str };

$wmTemplate =~ s/{{STYLE_ICONS}}\n/$styleIcons/s;
$wmTemplate =~ s/{{DEFINE_ALL_ICONS}}\n/$defineAllIcons/s;
$wmTemplate =~ s/{{ICON_SET_ITERATOR\("\n?(.*?)"\)}}\n/     join('', map { &$substitudeIconSet($1, $_) } @allIconSets)/sge;
$wmTemplate =~ s/{{MINI_ICON_SET_ITERATOR\("\n?(.*?)"\)}}\n/join('', map { &$substitudeIconSet($1, $_) } @miniIconSets)/sge;
$wmTemplate =~ s/{{NORM_ICON_SET_ITERATOR\("\n?(.*?)"\)}}\n/join('', map { &$substitudeIconSet($1, $_) } @normIconSets)/sge;
$wmTemplate =~ s/{{SIZE_ICON_SET_ITERATOR\("(\d+x\d+)", "\n?(.*?)"\)}}\n/join('', map { &$substitudeIconSet($2, $_) } grep(m:^$1:, @allIconSets))/sge;

print(OUT $wmTemplate);
close(OUT);

exit(0);
