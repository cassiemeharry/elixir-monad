defmodule ErrorM do
  def bind({:ok, a}, f) do
    f.(a)
  end
  def bind({:error, reason}, _f) do
    {:error, reason}
  end

  def return(a) do
    {:ok, a}
  end

  def fail(reason) do
    {:error, reason}
  end
end
