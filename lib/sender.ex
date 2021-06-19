defmodule Sender do
  def send_email("konnichiwah@world.com") do
    :error
  end

  def send_email(email) do
    Process.sleep(3_000)
    IO.puts("Email to #{email} sent")
    {:ok, "Email Sent"}
  end

  def notify_all(emails) do
    Sender.EmailTaskSupervisor
    |> Task.Supervisor.async_stream_nolink(emails, &send_email/1)
    |> Enum.to_list()
  end
end
