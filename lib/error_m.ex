defmodule ErrorM do
  @moduledoc """
  The error monad.

  All actions are expected to return either `{:ok, value}` or `{:error, reason}`.
  If an error value (`{:error, reason}`) is passed to bind it will be returned
  immediately, the function passed will not be executed (in other words as soon
  as an error is detected further computation is aborted).

  Error tuples can be of arbitrary length as long as they start with `:error`.

  Return puts the value inside an `{:ok, value}` tuple.

  ## Examples

      iex> require Monad
      iex> monad ErrorM do
      ...>   a <- { :ok, 2 }
      ...>   b <- { :ok, 3 }
      ...>   return a * b
      ...> end
      { :ok, 6 }

      iex> monad ErrorM do
      ...>   a <- { :error, "boom" }
      ...>   b <- { :ok, 3 }
      ...>   return a * b
      ...> end
      { :error, "boom" }

      iex> monad ErrorM do
      ...>   a <- { :ok, 2 }
      ...>   b <- { :error, "boom" }
      ...>   return a * b
      ...> end
      { :error, "boom" }

      iex> monad ErrorM do
      ...>   a <- { :ok, 2 }
      ...>   b <- { :error, "boom" }
      ...>   return a * b
      ...> end
      { :error, "boom" }

      iex> monad ErrorM do
      ...>   a <- { :ok, 2 }
      ...>   b <- { :error, "boom", "bang" }
      ...>   return a * b
      ...> end
      { :error, "boom", "bang" }

  """

  def bind(x, f)
  def bind({:ok, a}, f) do
    f.(a)
  end
  def bind({:error, reason}, _f) do
    {:error, reason}
  end
  def bind(error_tuple, _f) when is_tuple(error_tuple) and elem(error_tuple, 0) == :error do
    error_tuple
  end

  def return(a) do
    {:ok, a}
  end

  def fail(reason) do
    {:error, reason}
  end
end
