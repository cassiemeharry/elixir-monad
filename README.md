# Elixir Monads

This provides a monadic system for [Elixir][elixir], a Ruby-flavored
language for the [Erlang VM][erlang].

[elixir]: http://elixir-lang.org/
[erlang]: http://www.erlang.org/

When dealing with Erlang libraries, several common patterns emerge:

    case Library.might_fail() do
        {:ok, value} ->
            case Library.also_might_fail(value) do
                {:ok, something} ->
                    some_pid <- {:ok, something}
                {:error, reason} ->
                    some_pid <- {:error, reason}
            end
        {:error, reason} ->
            some_pid <- {:error, reason}
    end

By stealing the marvelous idea of Monads from the more mainstream
functional languages, you can abstract out that tree like this:

    import Monad
    import ErrorM

    some_pid = (monad ErrorM do
        value <- Library.might_fail()
        Library.also_might_fail(value)
    end)

Wasn't that easy?
