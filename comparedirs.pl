#!/usr/bin/perl
#
# ikorolev
# korolev-ia [at] yandex.ru
# http://unixpin.com
#
# v 1.0 2009.02.27
# 
# Script will compare first directory and second directory and show files which not existed in second directory, 
# differences in files with same filenames or print differences in modification date and filesizes.
# If you have the old and the new Sun Explorer from any server, 
# this script will be useful to search for differences
#


use Getopt::Long;
use Text::Diff;
use File::Find;
use File::Spec;

my $dir2compare='.'; # dir which start to compare
my $help=0;
my $dir1='';
my $dir2='';
my $content=0;
my $wsize=0;
my $verbose=0;

GetOptions ( 'help|?' => \$help, 'd1|dir1=s' => \$dir1, 'd2|dir2=s' => \$dir2, 
			 '-size|s' => \$wsize, "verbose|v" => \$verbose, "content|c" => \$content );


if( $help ) { ShowHelp(); exit(0); }

unless( $dir1 || $dir2 ) {
	printf STDERR "Incorrect usage! Tru $0 -help\n";
	exit(-1);
}



if( $content ) {
	unless( chdir($dir1)) { 
		print STDERR "Cannot change directory to $dir1 : $!\n"; exit(-2); 
	}
	find(\&CompareContext,'.');
	exit(0);
}

if( $wsize ) {
	unless( chdir($dir1)) { 
		print STDERR "Cannot change directory to $dir1 : $!\n"; exit(-2); 
	}
	find(\&CompareTreesWithFileSize,'.');
	exit(0);
}

	unless( chdir($dir1)) { 
		print STDERR "Cannot change directory to $dir1 : $!\n"; exit(-2); 
	}
	find(\&CompareTrees,'.');

exit(0);

	
    sub CompareContext {
		my $file1=File::Spec->canonpath( "$dir1/$File::Find::name" );
		my $file2=File::Spec->canonpath( "$dir2/$File::Find::name" );
		my $diff;
		my $output='';
		if( -e $file1 ) {
			if( -e $file2) {
				print STDERR "File $file1 and $file2 exist \n" if( $verbose );
			} 
			else {
				print STDERR "File $file2 do not exist! \n";
				return 0;
			}
		}
		if( -f $file1 && -f $file2) {
			$diff = diff $file1, $file2 , { STYLE => "Context" ,OUTPUT   => \$output };
			if( 0!=$diff ) { # if any differences in context of files
				print STDERR "Files $file1 and $file2 have different content\n";
				print $output;
			} else {
				print STDERR "Files $file1 and $file2 have the same content\n" if( $verbose );
			}
			$output='';
		}
    }
	
	sub CompareTrees {		
		my $file1=File::Spec->canonpath( "$dir1/$File::Find::name" );
		my $file2=File::Spec->canonpath( "$dir2/$File::Find::name" );
		if( -e $file1 ) {
			if( -e $file2) {
				print STDERR "File $file1 and $file2 exist \n" if( $verbose );
				return 1;
			} 
			else {
				print STDERR "File $file2 do not exist! \n";
				return 0;
			}
		}	
	}

	sub CompareTreesWithFileSize {		
		my $file1=File::Spec->canonpath( "$dir1/$File::Find::name" );
		my $file2=File::Spec->canonpath( "$dir2/$File::Find::name" );
		my $diff=0;
		if( -e $file1) {
			if( -e $file2) {
				$output="File $file1 and $file2 exist";
				@stats1= stat($file1);
				@stats2= stat($file2);	
				if( -f $file1 && -f $file2) {
				#($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blocks) = 
					if($stats1[7] == $stats2[7] ) {
						$output.=" and have same size";
					}
					else {
						$output.=" but have different size  ($stats1[7] and $stats2[7]) ";
						$diff++;
					}
					if($stats1[9] == $stats2[9] ) {
						$output.=" and same date";
					}
					else {
						$output.=" and different modification date (".GetDate( $stats1[9] )." and ".GetDate($stats2[9]).")";
						$diff++;
					}
				}
				else {
				}
				print STDERR "$output\n" if( $diff || $verbose);				
			} 
			else {
				print STDERR "File $file2 do not exist! \n";
			}
		}	
	}

sub GetDate {
	my $time=shift || time();
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime($time);
	return sprintf "%.4i-%.2i-%.2i %.2i:%.2i:%.2i", $year+1900, $mon, $mday, $hour, $min, $sec ;
}


	
sub ShowHelp {
	print STDERR 
"Script will compare first directory and second directory and show files which not existed 
in second directory, differences in files with same filenames or print differences in 
modification date and filesizes. 
If you have the old and the new Sun Explorer from any server, this script will be useful to 
search for differences
-------------------------------------------------------------------------------------------
Usage:$0 [-help|?] | [-dir1|d1=directory1 -dir2|d2=directory2 [-size|s]|[-content|c]][-verbose|v]
-help     this help
-dir2     first directory
-dir2     second directory
-content  compare content of files with same names in dir1 and dir2
-size     compare only modification date and size of files with same names in dir1 and dir2
-size     verbose output
-------------------------------------------------------------------------------------------
Example: 
$0 -content -d1=c:/explorer.8eeeeee.e25k-2008.05.28.17.56 -d2=c:/explorer.8eeeeee.e25k-2009.01.20.11.24 > c:/tmp/diff.log 2> c:/tmp/messages.log
";
}