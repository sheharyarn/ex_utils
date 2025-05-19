defmodule ExUtils.Tests.Configs do
  use ExUnit.Case, async: false
  import ExUtils.Configs

  @context :ex_utils_configs_test

  setup do
    Application.put_env(:ex_utils, :otp_app, :ex_utils)

    Application.put_env(:ex_utils, @context, %{
      enabled: true,
      service: [adapter: TestAdapter, retries: 3],
      nullable: nil
    })
  end

  describe "get!/3" do
    test "returns an application config context" do
      assert get!(@context).enabled == true
    end

    test "returns values at atom and nested access paths" do
      assert get!(@context, :enabled) == true
      assert get!(@context, [:service, :adapter]) == TestAdapter
    end

    test "returns the provided default for a missing value" do
      assert get!(@context, [:service, :pool_size], 10) == 10
    end

    test "raises when the context does not exist" do
      assert_raise ArgumentError, fn -> get!(:unknown_context) end
    end

    test "raises when the resulting value is nil" do
      assert_raise ArgumentError, ~r/value :nullable is nil/, fn ->
        get!(@context, :nullable)
      end
    end
  end

  describe "get/3" do
    test "returns values at the given access path" do
      assert get(@context, [:service, :retries]) == 3
    end

    test "returns the default when a value is nil or missing" do
      assert get(@context, :nullable, :default) == :default
      assert get(@context, :missing, :default) == :default
    end
  end

  describe "from_priv!/1" do
    test "builds an absolute path inside the configured application's priv directory" do
      expected_path = :ex_utils |> :code.priv_dir() |> Path.join("test.txt")

      assert from_priv!("test.txt") == expected_path
    end
  end

  describe "read_from_priv!/1" do
    test "reads files from the configured application's priv directory" do
      assert read_from_priv!("test.txt") == "test\n"
    end
  end

  describe "otp_app configuration" do
    test "raises when otp_app is not configured" do
      Application.delete_env(:ex_utils, :otp_app)

      assert_raise RuntimeError, ~r/:otp_app configuration missing/, fn ->
        get!(@context)
      end
    end
  end
end
