defmodule Sender do
  @moduledoc """
  Documentation for `Sender`.
  """

  @doc """
  Simulates sending an email
  """
  def send_email("konnichiwa@world.com" = email) do
    raise "Oops, could not send an email to #{email}"
  end

  def send_email(email) do
    Process.sleep(3_000)
    IO.puts("Email to #{email} sent.")
    {:ok, "email_sent"}
  end

  @doc """
  Sends a batch of emails sequentially
  """
  def notify_all_slow(emails) do
    Enum.each(emails, &send_email/1)
  end

  @doc """
  Sends a batch of emails asyncronously
  """
  def notify_all_fire_and_forget(emails) do
    Enum.each(emails, fn email ->
      Task.start(fn ->
        send_email(email)
      end)
    end)
  end

  @doc """
  Sends a batch of emails asyncronously and waits for results
  """
  def notify_all_await(emails) do
    emails
    |> Enum.map(fn email ->
      Task.async(fn ->
        send_email(email)
      end)
    end)
    |> Enum.map(&Task.await/1)
  end

  @doc """
  Sends a batch of emails asyncronously and waits for results using a stream api
  """
  def notify_all_stream(emails) do
    emails
    |> Task.async_stream(&send_email/1)
    |> Enum.to_list()
  end

  @doc """
  Sends a batch of emails asyncronously and waits for results using a stream api and a maxdop limit
  """
  def notify_all_stream_cores(emails, cores) do
    emails
    |> Task.async_stream(&send_email/1, max_concurrency: cores)
    |> Enum.to_list()
  end

  @doc """
  Sends a batch of emails asyncronously and waits for results using a stream api and not caring about orders
  """
  def notify_all_stream_unordered(emails) do
    emails
    |> Task.async_stream(&send_email/1, ordered: false)
    |> Enum.to_list()
  end

  @doc """
  Sends a batch of emails asyncronously and waits for results using a stream api and kills timed out tasks
  """
  def notify_all_stream_kill_timeout(emails) do
    emails
    |> Task.async_stream(&send_email/1, on_timeout: :kill_task)
    |> Enum.to_list()
  end

@doc """
  Sends a batch of emails asyncronously and waits for results using a stream api with a Supervisor
  """
  def notify_all_supervised(emails) do
    Sender.EmailTaskSupervisor
    |> Task.Supervisor.async_stream_nolink(emails, &send_email/1)
    |> Enum.to_list()
  end
end
