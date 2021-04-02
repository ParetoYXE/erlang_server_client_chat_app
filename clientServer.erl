%LIAM IVERSON

-module(clientServer).
-include_lib("eunit/include/eunit.hrl").
-import(string,[concat/2]).
-export([new_chat/0]).

new_chat() ->
    spawn(fun() -> chat() end).

chat() ->
    chat([]).

chat(Posts) ->
    receive
        {Sender, request, all} ->
            Sender ! {reply, Posts},
            NewPosts = Posts;
        {Sender, request, NewPost} ->
            Sender ! {reply, ok},
            NewPosts = lists:append([NewPost], Posts)
    end,
    chat(NewPosts).

head([]) -> 'No messages yet.';
head([Head|_Tail]) -> Head.

new_post(Server, Text) ->
    call(Server, Text).

all_posts(Server) ->
    call(Server, all).

call(Server, Request) ->
    Server ! {self(), request, Request},
    receive
        {reply, Reply} -> Reply
    end.

client_server_test() ->
    Server = new_chat(),
    ok = new_post(Server, "Welcome to the chat room"),
    io:format("Hello and welcome to the ParetoYXE Erlang Chatroom\n"),
    Name = io:get_line("Enter your name please: "),
    io:format("Welcome to the chat ~p\n",[Name]),
    Post = all_posts(Server),
    io:format("~p\n",Post),
    loop(Server,Name),
    io:format("---------------------------\n").

loop(Server,Name) ->
        Post = all_posts(Server),
        io:format("~p~n",[Post]),
        Msg = io:get_line("Enter a Message: "),
        ok = new_post(Server,Msg),
        loop(Server,Name).
~
