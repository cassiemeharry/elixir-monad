defmodule ListM do
  @moduledoc """
  The list monad.

  Well, technically more of the Enum monad as it will accept any Enumerable, it
  will return a list though.

  In this monad bind is simply Enum.flat_map and return puts its argument in a
  list (so it creates a list with one value).

  ## Examples
  
      iex> require Monad
      iex> monad ListM do
      ...>   a <- [1, 2, 3]
      ...>   b <- [1, 2, 3]
      ...>   return { a, b }
      ...> end
      [{1,1},{1,2},{1,3},{2,1},{2,2},{2,3},{3,1},{3,2},{3,3}]

      iex> monad ListM do
      ...>   a <- [1, 2, 3]
      ...>   b <- [1, 2, 3]
      ...>   return a * b 
      ...> end
      [1, 2, 3, 2, 4, 6, 3, 6, 9]

      iex> monad ListM do
      ...>   return 1 
      ...> end
      [1]

  """
  def bind(x, f) do
    Enum.flat_map(x, f)
  end

  def return(a) do
    [a] 
  end
end
