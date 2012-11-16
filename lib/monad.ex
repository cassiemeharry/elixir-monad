defmodule Monad do
  def line(mod_name, [ {:<-, _, [left, right]} | [] ]) do
    quoted = quote do
      f = fn (unquote(left)) ->
        unquote(left)
      end
      evaluated = unquote(right)
      unquote(mod_name).bind(evaluated, f)
      evaluated
    end
    quoted
  end

  def line(mod_name, [ {:<-, _, [left, right]} | rest ]) do
    quoted = quote do
      f = fn unquote(left) ->
        unquote(line(mod_name, rest))
      end
      unquote(mod_name).bind(unquote(right), f)
    end
    quoted
  end

  def line(mod_name, [ other | [] ]) do
    fixed = case other do
      {:return, lineno, args} -> 
        {{:., lineno, [mod_name, :return]}, lineno, args}
      _ -> other
    end
    quoted = quote do
      unquote(fixed)
    end
    quoted
  end

  def line(mod_name, [ other | rest ]) do
    quoted = quote do
      f = fn (_) ->
        unquote(line(mod_name, rest))
      end
      unquote(mod_name).bind(unquote(other), f)
    end
    quoted
  end

  defmacro monad(mod_name, do: block) do
    n = Macro.expand mod_name, __CALLER__
    case block do
          {:__block__, _, unwrapped} -> line(n, unwrapped)
          _ -> line(n, [block])
    end
  end
end
