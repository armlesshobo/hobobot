hobobot
=======

a simple, personal IRC bot

Required Modules
================
- Bot::BasicBot
- Yahoo::Weather
- DateTime

Use 'cpan' to get these modules.


Configuration
=============

At the top of bot.pl, there is a Configuration section where you can configure the
bot.

Note: If the bot is already running, you must restart the bot by killing the bot
using !shutdown or !die, and then rerunning the script.


Running
=======

$ chmod a+x bot.pl
$ ./bot.pl

or, simply:

$ perl bot.pl


Available Commands
==================

- !info     - outputs a description about the bot.
- !die      - cleanly stops the bot.
- !shutdown - same as !die.
- !weather <location> - gets weather information from any part of the world. 
                      <location> can only be a city. For more specific results,
                      you should try adding a state, province, or country after the city.
- !seen <nick>    - gets the last time the bot saw <nick> and what their last message was.
- !google <query> - will generate a URL for a Google search for <query>.
- !ndic <query>   - will generate a URL for a Naver search for <query>.


Known bugs
==========

- None.


Contact
=======

Author: Lance Clark (haYnguy@gmail.com)

