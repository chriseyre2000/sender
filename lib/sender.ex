defmodule Sender do
  @moduledoc """
  Documentation for `Sender`.
  """

  def send_email(email) do
    Process.sleep(3_000)
    IO.puts("Email to #{email} sent.")
    {:ok, "email_sent"}
  end

  def notify_all_slow(emails) do
    Enum.each(emails, &send_email/1)
  end

  def notify_all_fire_and_forget(emails) do
    Enum.each(emails, fn email ->
      Task.start(fn ->
        send_email(email)
      end)
    end)
  end

  def notify_all_await(emails) do
    emails
    |> Enum.map(fn email ->
      Task.async(fn ->
        send_email(email)
      end)
    end)
    |> Enum.map(&Task.await/1)
  end
end
