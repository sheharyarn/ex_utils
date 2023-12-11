defmodule ExUtils.Tests.Files do
  use ExUnit.Case
  import ExUtils.Files

  doctest ExUtils.Files

  describe "format_size/2" do
    test "formats integer byte counts as human-readable file sizes" do
      assert format_size(12) == "12 B"
      assert format_size(1234) == "1.21 KB"
      assert format_size(12_345) == "12.06 KB"
      assert format_size(1_234_567) == "1.18 MB"
      assert format_size(1_234_567_890) == "1.15 GB"
      assert format_size(1_234_567_890_123) == "1.12 TB"
      assert format_size(1_234_567_890_123_456) == "1.1 PB"
      assert format_size(1_234_567_890_123_456_789) == "1.07 EB"
    end

    test "uses the specified precision" do
      assert format_size(1_234_567_890, precision: 0) == "1.0 GB"
      assert format_size(1_234_567_890, precision: 1) == "1.1 GB"
      assert format_size(1_234_567_890, precision: 2) == "1.15 GB"
      assert format_size(1_234_567_890, precision: 3) == "1.15 GB"
      assert format_size(1_234_567_890, precision: 4) == "1.1498 GB"
      assert format_size(1_234_567_890, precision: 5) == "1.14978 GB"
    end
  end
end
