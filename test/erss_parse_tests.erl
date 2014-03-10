%%% @copyright (C) 2014, Imprivata
%%% @doc
%%% 
%%% @end
%%% Created :  9 Mar 2014 by Nathaniel Waisbrot <nwaisbrot@imprivata.com>
-module(erss_parse_tests).
-author('nwaisbrot@imprivata.com').

-include_lib("eunit/include/eunit.hrl").

-define(WELLFORMED_DIR, "../test/data/wellformed").
-define(BASIC_DIR, "../test/data/basic").

wellformed_test_() ->
    Dir = ?BASIC_DIR,%?WELLFORMED_DIR,
    {ok, Filenames} = file:list_dir_all(Dir),
    {"well-formed rss", rss_suites(Dir, Filenames)}.

rss_suites(Root, [Dirname|Rest]) ->
    {generator, fun () -> 
			Dir = [Root, $/, Dirname],
			{ok, Filenames} = file:list_dir_all(Dir),
			[{Dirname, rss_examples(Dir, Filenames)} 
			 | rss_suites(Root, Rest)]
		end};
rss_suites(_Root, []) ->
    {generator, fun () -> [] end}.

rss_examples(Root, [Filename|Rest]) ->
    {generator, fun () -> [{Filename, rss_example(Root, Filename)} | rss_examples(Root, Rest)] end};
rss_examples(_Root, []) ->
    {generator, fun () -> [] end}.

rss_example(Root, Filename) ->
    ?_assertEqual(ok, erss_parse:parse_file([Root, $/, Filename])).

