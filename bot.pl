#!/usr/bin/perl
########################################################################
##hobobot - a simple, personal IRC bot.                                #
##                                                                     #
##Copyright (C) 2013 Lance Clark                                       #
##                                                                     #
##This program is free software: you can redistribute it and/or modify #
##it under the terms of the GNU General Public License as published by #
##the Free Software Foundation, either version 3 of the License, or    #
##(at your option) any later version.                                  #
##                                                                     #
##This program is distributed in the hope that it will be useful,      #
##but WITHOUT ANY WARRANTY; without even the implied warranty of       #
##MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        #
##GNU General Public License for more details.                         #
##                                                                     #
##You should have received a copy of the GNU General Public License    #
##along with this program.  If not, see <http://www.gnu.org/licenses/>.#
##                                                                     # 
########################################################################

package HoboBot;

use base qw(Bot::BasicBot);

use DateTime;
use Yahoo::Weather;

use encoding 'utf8';
use strict;

#Configuration - Begin  ####################

# Connection Information
my $server = "irc.freenode.net";
my $port = "6667";

#Bot Configuration
my $bot_nick = "hobobot";
my @channels = ["#korea"];
my @op_list = ("armlesshobo", "ggoogi", "iGG", "xGG");
my @bot_alt_nicks = ["ahobobot", "h0bobot"];
my $bot_name = "hobobot";
my $bot_username = "hobobot";
my @ignore_list = [qw( dddddd toocool armfulhobo )];

#Configuration - End #######################

#Global defs ##################

my %seen_list; #contains user info for !seen command

#End Global defs #############


sub isOp($) #checks to see if sender is Op
{
  my $sender = $_[0];

  foreach( @op_list )
  {
    print("Comparing: $_ with $sender\n");
    if ( $_ eq $sender )
    {
      print("$sender is an Op\n");  
      return 1;
    }
  }
  print("$sender is not an Op\n");
  return 0;
}


sub said(\%)
{
   my ($self, $msg) = @_;

   #pull out the sender and msg
   my $txt = $msg->{body}; 
   my $sndr = $msg->{who};

   #update the !seen table
   my $date = DateTime->now();
   my $date = $date->ymd('/') . " " . $date->hms;

   my @seen_tuple = ($date, $txt);
   $seen_list{$sndr} = \@seen_tuple;
   #end !seen table update

   #print("On $date, $sndr said '$txt'\n");

   #process input
   if ($txt =~ m/^!info$/) #standard info about the bot
   {
      return "I'm $bot_name. I'm a robotic vagrant.";
   }
   elsif ( $txt =~ m/^!poke $bot_name$/ )
   {
      return "$sndr: don't touch me, pervert...";
   }
   elsif ( $txt =~ m/^!shutdown$/ or  #to cleanly shutdown the bot
           $txt =~ m/^!die$/ )
   {
      if ( isOp($sndr) ){
         $self->shutdown();
      }
   }
   elsif ( $txt =~ m/^!weather/ ) #weather query
   {
        my @tokens = split( ' ', $txt );
        shift(@tokens);
        my $location = join(' ', @tokens);

        if ( $location eq "" ){
           return "$sndr: Please use the format '!weather <location>'";
	}
        else{
	   my $yw = Yahoo::Weather->new();

           my $wres = $yw->getWeatherByLocation($location);
           if ( $wres <= 0 ){
	      return "$sndr: Invalid location specified" if ( $wres == -2 );
              return "$sndr: Forecast for that area not available" if ( $wres == -3 );
              return "$sndr: Unknown error ($wres)";
           }
	   else{
             my %res = %{$wres};
	     my %co = %{$res{CurrentObservation}};
             
             return "$sndr: $res{Title}: $co{text}, Temperature of $co{temp}C. Last updated on $co{date}. ";
           } 
        }
   }
   elsif ( $txt =~ m/^!seen/ ) #outputs when a person was last seen
   {
      my @tokens = split(' ', $txt);
      shift( @tokens );

      print("$sndr is looking for $tokens[0]\n");

      if ( defined( $tokens[0] ) )
      {
         my @tuple = $seen_list{$tokens[0]};
         if ( @tuple and $tuple[0][0] and $tuple[0][1] ){
            return "Last saw $tokens[0] on $tuple[0][0]. Their last message was: <$tokens[0]> $tuple[0][1]";
         }
         else{
	    return "$tokens[0] hasn't been seen recently.";
         }
      }
   }
   elsif ( $txt =~ m/^!google/ ) #generates a google search URL
   {
      my @tokens = split(' ', $txt );

      shift( @tokens );
      my $query = join('+', @tokens);

      if ( defined( $query ) ){
          return "https://www.google.com/search?q=$query&ie=UTF-8";
      }
      else{
          return "Please use '!google QUERY' format.";
      }
   }
}


# with all known options
HoboBot->new(

    server => $server,
    port   => $port,
    channels => @channels,

    nick      => $bot_nick,
    alt_nicks => @bot_alt_nicks,
    username  => $bot_username,
    name      => $bot_name,

    ignore_list => @ignore_list,

  )->run();
