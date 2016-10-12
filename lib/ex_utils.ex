defmodule ExUtils do
  def is_struct?(%{__struct__: _}), do: true
  def is_struct?(_),                do: false

  def is_pure_map?(term) do
    is_map(term) && !is_struct?(term)
  end
end
