ExUnit.start()

# Mock Struct for Testing

defmodule Person do
  defstruct [:name, :age]

  def old?(person, threshold \\ 60) do
    person.age > threshold
  end
end

