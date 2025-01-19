#!/usr/bin/perl 
use strict;
use warnings;
use FileHandle;
use CGI;
#version1.0
###############################################################
###############################################################
##calendar script for perl5.6.1                    ############
##written by paco "witchazel@witchazel.com"        ############
###############################################################
###############################################################

       ##############################
      ###define/ initiate variables###
       ##############################

   
  ###     #############################     ###
 ## ##   ###define subroutines      ####   ## ##
  ###     #############################     ###
   
################################################################
#####getcurrentdate subroutine / begin         #################
#####usage: getcurrentdate()                   #################
#####returns todays date in form of            #################
#####@array($month, $day, $year)               #################
################################################################
    #######                          #######
      ###                              ###
       #                                #
sub getcurrentdate
  { 
my($sec,$min,$hour,$day,$month,$year,$day2) = (localtime(time))[0,1,2,3,4,5,6];
$year += 1900;
$month +=1;
return my @date=($month, $day, $year);
  } 
      #                                #
     ###                              ###
   #######                          #######
###############################################################
##getcurrentdate subroutine / end               ###############
###############################################################
 
############################################
##leapyear subroutine / begin           ####
##usage: leapyear(YYYY)                 ####
##returns 0 if not a leap year          ####
##returns 1 if is a leap year           ####
############################################
   #######           #######
     ###               ###
      #                 #
sub leapyear
{my ($year)=@_;
($year =~ m/^\d{4}$/) || die "data not in the form of YYYY at leap year sub\n"; 
my $leap=0;
($leap=leapcheck("$year")) if ($year % 4==0);
sub leapcheck
 {my ($c)=@_;
  if ($c % 400==0)
   {return (1);}
  elsif 
   ($c % 100==0)
   {return(0);}
  else
{return(1);}
}
if($leap==1) {return(1);}
else {return(0);}
} 
      #               #
     ###             ###
   #######         #######
###########################################
##leapyear subroutine / end           #####
###########################################


##############################################
##daycount subroutine / begin           ######
##usage: daycount(MM, boolean)          ######
##returns number of days in given month ######
##must give boolean value for leap year ######
##############################################
    #######         #######
      ###             ###
       #               # 
sub daycount
{my ($month, $leapyear)= @_;
($month =~ m/^\d{1,2}$/) || die "data not in form of MM in daycount sub\n";
($month<13) || die "month is represented by too high a number in daycount sub\n";
($leapyear =~ m/^\d$/) || die "leapyear data not a boolean value\n";
(return(31)) if ($month == "01");
(return(28)) if ($month== "02" && $leapyear==0);
(return(29)) if ($month== "02" && $leapyear==1);
(return(31)) if ($month== "03");
(return(30)) if ($month== "04");
(return(31)) if ($month== "05");
(return(30)) if ($month== "06");
(return(31)) if ($month== "07");
(return(31)) if ($month== "08");
(return(30)) if ($month== "09");
(return(31)) if ($month== "10");
(return(30)) if ($month== "11");
(return(31)) if ($month== "12");
(die "data could not be verified as a month\n");
}
      #              #        
     ###            ###
   #######        #######   
############################################
##daycount subroutine / end         ########
############################################

############################################
##getfirst subroutine / begin       ########
##usage: getfirst(MM, YYYY)         ########
##returns first day of given month  ########
##in the form of single digit       ########
##where 0=sunday, 1=monday,etc...   ########
############################################
    #######     ########
      ###         ###
       #           #
sub getfirst
{my ($month, $year)=@_;
($month =~ m/^\d{1,2}$/) || die "data not in form of MM at getfirst sub\n";
($month<13) || die "month is represented by too high a number in getfirst sub\n";
($year =~ m/^\d{4}$/) || die "data not in the form of YYYY at getfirst sub\n"; 
my $a=1;
($a=0) if ($month>2);
my $y=($year-$a);
my $m=$month+(12*$a)-2;
my $c1=int($y/4);
my $c2=int($y/100);
my $c3=int($y/400);
my $c4=int((31*$m)/12);
my $dgreg=((1+$y+$c1-$c2+$c3+$c4) % 7) ;
return($dgreg);
}
          #                #  
         ###              ###
       #######          #######
############################################
##getfirst subroutine / end      ###########
############################################

############################################
##translateday subroutine / begin    #######
##usage: translateday(0-6)           #######
##translates digits to days          #######
##returns ($day or @days) in lower case#####
############################################
    #######               #######
      ###                   ###
       #                     #
sub translateday
{ 
  my (@define)=@_;
  my @define1=();
  my $count=0;
foreach my $defined(@define)
 {
    ($define1[$count] = 'sunday') if  ($defined eq '0');
    ($define1[$count] = 'monday') if  ($defined eq '1');
    ($define1[$count] = 'tuesday') if ($defined eq '2');
    ($define1[$count] = 'wednesday') if ($defined eq '3');
    ($define1[$count] = 'thursday') if ($defined eq '4');
    ($define1[$count] = 'friday') if ($defined eq '5');
    ($define1[$count] = 'saturday') if ($defined eq '6');
    $count++;
}     
wantarray()? return (@define1) : return ($define1[0]);
} 
        #                   #
       ###                 ###
     #######             #######
##########################################
##translateday subroutine / end  #########
########################################## 

#############################################
##syncmonth subroutine / begin           ####
##usage: syncmonth(D, 28-31)             ####
##returns day=>date pairs for given month####
##in form of a @array                    ####
#############################################
     #######       #######
       ###          ###
        #            #
sub syncmonth
{my ($days, $count)=@_;
my @sync;
($days =~ m/^\d$/) || die "data not in form of D\n";
($count =~ m/^\d\d$/) || die "data not in form of CC\n";
foreach (1..$count)
{
push(@sync, $days);
($days=-1) if ($days==6);
 $days++;
}
return (@sync);
} 
      #               #
     ###             ###
   #######         #######
###############################################
##syncmonth subroutine / end             ######
###############################################

##########################################
##translatemonth subroutine / begin ######
##usage: translatemonth(1-12)       ######
##translates digits to months       ######
##returns month in lower case       ######
##########################################
  #######             #######
    ###                 ###
     #                   #
sub translatemonth
{
 my ($define)=@_;
  ($define =~ m/^\d{1,2}$/) || die "data not in form of MM at translatemonth sub\n";
($define<13) || die "month is represented by too high a number in translatemonth sub\n";
 my $defined;
    ($defined = 'january') if ($define eq '1');
    ($defined = 'february') if ($define eq '2');
    ($defined = 'march') if ($define eq '3');
    ($defined = 'april') if ($define eq '4');
    ($defined = 'may') if ($define eq '5');
    ($defined = 'june') if ($define eq '6');
    ($defined = 'july') if ($define eq '7');
    ($defined = 'august') if ($define eq '8');
    ($defined = 'september') if ($define eq '9');
    ($defined = 'october') if ($define eq '10');
    ($defined = 'november') if ($define eq '11');
    ($defined = 'december') if ($define eq '12');
     return $defined;
}
 
           #                  #
          ###                ###
        #######            #######
############################################
##translatemonth subroutine / end    #######
############################################

   ###                             ###
   # #                             # #
   # #     BRAIN                   # #
   # #                             # #
  #####                           #####
   ###                             ###
    #                               #
my $cgi=new CGI;
my %qstring=();
foreach my $key ($cgi->param())
{$qstring{$key}=($cgi->param($key));}

my @caldate=("$qstring{month}", 1, "$qstring{year}"); 
my @currentdate=getcurrentdate();
(exists($qstring{month})) || (@caldate=($currentdate[0], 1, $currentdate[2]));
my $leapyear=leapyear($caldate[2]);
my $daycount=daycount($caldate[0], $leapyear);
my $fdvar=getfirst($caldate[0] , $caldate[2]);
my $firstday=translateday($fdvar);
my $month=translatemonth($caldate[0]);
$month=ucfirst($month);
$firstday=ucfirst($firstday);
my @sync=syncmonth($fdvar, $daycount);
print "content-type: text/html\n\n";
print '<html><head><title>i</title></head><body>';

print "$qstring{color}\n";

print '<table border="2" cellspacing="2" cellpadding="2"><tr><td colspan=7 align="center">';
print "$month $caldate[2]",'</td align="center"></tr>';
print '<tr><td>SUN</td><td>MON</td><td>TUE</td><td>WED</td><td>THU</td><td>FRI</td><td>SAT</td></tr>';
print '<tr>';
(print '<td></td>') if ($fdvar eq 1);
(print '<td colspan="2"></td>') if ($fdvar eq 2);
(print '<td colspan="3"></td>') if ($fdvar eq 3);
(print '<td colspan="4"></td>') if ($fdvar eq 4);
(print '<td colspan="5"></td>') if ($fdvar eq 5);
(print '<td colspan="6"> </td>') if ($fdvar eq 6);
my $date=1;
foreach my $day(@sync)
 {print '<td>',"$date",'</td>';
  (print '</tr><tr>') if ($day eq 6);
   $date++;
 }
print '</tr></table></body></html>',"\n";
