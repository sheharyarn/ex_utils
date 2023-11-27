defmodule ExUtils.Tests.Integers do
  use ExUnit.Case
  import ExUtils.Integers

  doctest ExUtils.Integers

  describe "to_filesize/2" do
    test "formats integers as simple file sizes" do
      assert to_filesize(12) == "12 Bytes"
      assert to_filesize(1234) == "1.21 KB"
      assert to_filesize(12345) == "12.06 KB"
      assert to_filesize(1_234_567) == "1.18 MB"
      assert to_filesize(1_234_567_890) == "1.15 GB"
      assert to_filesize(1_234_567_890_123) == "1.12 TB"
      assert to_filesize(1_234_567_890_123_456) == "1.1 PB"
      assert to_filesize(1_234_567_890_123_456_789) == "1.07 EB"
    end

    test "uses the specified precision" do
      assert to_filesize(1_234_567_890, precision: 0) == "1.0 GB"
      assert to_filesize(1_234_567_890, precision: 1) == "1.1 GB"
      assert to_filesize(1_234_567_890, precision: 2) == "1.15 GB"
      assert to_filesize(1_234_567_890, precision: 3) == "1.15 GB"
      assert to_filesize(1_234_567_890, precision: 4) == "1.1498 GB"
      assert to_filesize(1_234_567_890, precision: 5) == "1.14978 GB"
    end
  end
end
