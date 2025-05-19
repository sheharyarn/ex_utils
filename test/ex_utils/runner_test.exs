defmodule ExUtils.Tests.Runner do
  use ExUnit.Case, async: false
  import ExUtils.Runner

  setup do
    Application.put_env(:ex_utils, :otp_app, :ex_utils)
    Application.put_env(:ex_utils, :testing?, false)

    start_supervised!(ExUtils.Runner)

    :ok
  end

  describe "background/2" do
    test "runs a function in a supervised background task" do
      test_process = self()

      assert {:ok, pid} = background(fn -> send(test_process, :done) end)

      assert is_pid(pid)
      assert_receive :done
    end

    test "delays execution by the configured number of milliseconds" do
      test_process = self()

      assert {:ok, _pid} = background([delay: 25], fn -> send(test_process, :done) end)

      refute_receive :done, 10
      assert_receive :done, 100
    end

    test "runs synchronously and returns a nil pid when testing is enabled" do
      Application.put_env(:ex_utils, :testing?, true)
      test_process = self()

      assert background(fn -> send(test_process, {:done, self()}) end) == {:ok, nil}

      assert_received {:done, ^test_process}
    end
  end

  describe "parallel/3" do
    test "returns tagged results in input order" do
      assert parallel([1, 2, 3], fn number -> number * 2 end) == [ok: 2, ok: 4, ok: 6]
    end

    @tag :capture_log
    test "returns an exit result when a task times out" do
      opts = [timeout: 1, on_timeout: :kill_task]
      fun = fn _task -> Process.sleep(25) end

      assert parallel([:task], opts, fun) == [exit: :timeout]
    end
  end

  describe "parallel!/3" do
    test "returns unwrapped results in input order" do
      assert parallel!([1, 2, 3], &(&1 * 2)) == [2, 4, 6]
    end

    @tag :capture_log
    test "raises when a task does not return an ok result" do
      opts = [timeout: 1, on_timeout: :kill_task]
      fun = fn _task -> Process.sleep(25) end

      assert_raise(RuntimeError, ~r/non-ok response received/, fn ->
        parallel!([:task], opts, fun)
      end)
    end
  end

  describe "group_results/1" do
    test "groups ok and error values" do
      result = [ok: 1, error: :unavailable, ok: 2]
      assert group_results(result) == %{ok: [1, 2], error: [:unavailable]}
    end

    test "includes empty groups" do
      assert group_results([]) == %{ok: [], error: []}
      assert group_results(ok: 1) == %{ok: [1], error: []}
      assert group_results(error: :unavailable) == %{ok: [], error: [:unavailable]}
    end
  end
end
