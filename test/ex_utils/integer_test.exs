defmodule ExUtil.Tests.Integer do
  use ExUnit.Case

  test "#to_filesize formats integers as simple file size" do
    import ExUtils.Integer

    assert to_filesize(123)                 == "123 Bytes"
    assert to_filesize(1234)                == "1.21 KB"
    assert to_filesize(12345)               == "12.06 KB"
    assert to_filesize(1234567)             == "1.18 MB"
    assert to_filesize(1234567890)          == "1.15 GB"
    assert to_filesize(1234567890123)       == "1.12 TB"
    assert to_filesize(1234567890123456)    == "1.1 PB"
    assert to_filesize(1234567890123456789) == "1.07 EB"
  end
end
